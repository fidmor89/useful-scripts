#!/usr/bin/env bash

# Define the string we are looking for in the remote URL
TARGET_STRING="fidmor89"

## ----------------------------------------------------
## 1. PARAMETER AND PATH HANDLING
## ----------------------------------------------------

# Check if a path argument was provided
if [ -z "$1" ]; then
  SEARCH_PATH="./"
else
  SEARCH_PATH="$1"
fi

# Check if the provided path is a directory
if [ ! -d "$SEARCH_PATH" ]; then
  echo "Error: Directory not found or path is invalid: $SEARCH_PATH" >&2
  exit 1
fi

## ----------------------------------------------------
## 2. MAIN LOOP (using find for safe path handling)
## ----------------------------------------------------

# Find all direct subdirectories.
find "$SEARCH_PATH" -maxdepth 1 -type d -print0 | while IFS= read -r -d $'\0' d; do
  
  if [ "$d" = "$SEARCH_PATH" ] || [ "$d" = "." ]; then
    continue
  fi

  # Check 1: Is it a Git repo?
  if [ ! -d "$d/.git" ]; then
    continue # Skip non-git directories silently
  fi

  # Start a subshell to work inside the directory
  (
    cd "$d" || exit 1

    # Get the directory name (which will be the new remote name in the output)
    remote_name_raw="${PWD##*/}"
    remote_name="${remote_name_raw// /-}" # Replace spaces with hyphens

    # Find the remote URL that contains the TARGET_STRING
    # - `git remote -v` lists all remotes (name, url, (fetch/push))
    # - `grep` filters for lines containing the TARGET_STRING
    # - `head -n 1` picks the first matching remote if multiple exist
    # - `awk` extracts the remote name ($1) and the URL ($2)
    remote_info=$(git remote -v 2>/dev/null | grep "${TARGET_STRING}" | head -n 1 | awk '{print $1, $2}')

    # Check 2: Was a matching remote found?
    if [ -z "$remote_info" ]; then
      echo "SKIPPED: $remote_name | Reason: No remote URL contains '${TARGET_STRING}'." >&2
      exit 0 # Exit the subshell successfully
    fi
    
    # Split remote_info into the actual remote name (e.g., 'upstream') and the URL
    ACTUAL_REMOTE_NAME=$(echo "$remote_info" | awk '{print $1}')
    remote_url=$(echo "$remote_info" | awk '{print $2}')

    # --- Determine the Default Branch ---

    # Try to read the ACTUA_REMOTE_NAME's HEAD (default branch)
    # The variable for the remote name must be used for the symbolic-ref path
    default_branch=$(git symbolic-ref --short "refs/remotes/${ACTUAL_REMOTE_NAME}/HEAD" 2>/dev/null | sed "s#^${ACTUAL_REMOTE_NAME}/##")

    if [ -z "$default_branch" ]; then
      # Fallback to local branches if remote HEAD is not set
      if git show-ref --verify --quiet refs/heads/main; then
        default_branch="main"
      elif git show-ref --verify --quiet refs/heads/master; then
        default_branch="master"
      else
        # Check 3: Could not find a default branch
        echo "SKIPPED: $remote_name | Reason: Could not determine default branch for remote '${ACTUAL_REMOTE_NAME}'." >&2
        exit 0 # Exit the subshell successfully
      fi
    fi

    ## ----------------------------------------------------
    ## 3. SUCCESS OUTPUT
    ## ----------------------------------------------------
    
    # Format: git remote add <remoteName> <remote_url>
    echo "git remote add $remote_name $remote_url"
    
    # Format: <remoteName> <defaultBranch>
    echo "$remote_name $default_branch"
    
    echo "" # Add an empty line for separation
  )
done