# Useful Scripts

This repository contains a collection of useful scripts for various tasks.

## Scripts

### Bash

- **`git_add_commit.sh`**: Automates the process of adding and committing all changed files in a Git repository. It generates commit messages based on the file status (e.g., "Modify `<filename>`", "Add `<filename>`").

- **`git-remote-scanner.sh`**: Scans subdirectories for Git repositories and, if a repository's remote URL contains a specific string, it prints the `git remote add` command and the default branch for that repository.

### Python

- **`optimizer.py`**: A simple script that finds the optimal `x` that maximizes the value of a given mathematical function within a specified range.

- **`subtitle processor.py`**: Extracts dialogue from `.srt` subtitle files within a directory structure and combines them into a single text file.

- **`main.py`**: A sample Python script created by the PyCharm IDE. It serves as a placeholder and does not have any specific functionality.

## Usage

### `git_add_commit.sh`

To use this script, provide the path to the directory you want to process as an argument:

```bash
bash bash/git_add_commit.sh <directory>
```

You can also use the `-p` flag to print the actions that would be taken without actually executing them:

```bash
bash bash/git_add_commit.sh -p <directory>
```

### `git-remote-scanner.sh`

To use this script, you can optionally provide a path to a directory to scan. If no path is provided, it will scan the current directory.

```bash
bash py/git-remote-scanner.sh [path]
```

The script will output `git remote add` commands for any repositories that have a remote URL containing the hardcoded target string "fidmor89".

### `optimizer.py`

This script can be run directly.

```bash
python3 py/optimizer.py
```

You can modify the functions and the ranges within the script to find the optimal values for your own mathematical functions.

### `subtitle processor.py`

To use this script, you need to modify the `base_directory` and `output_file_path` variables within the script to match your directory structure.

```python
base_directory = '/path/to/your/lectures'
output_file_path = f'{base_directory}/lectures_transcript.txt'
```

Then, you can run the script:

```bash
python3 py/subtitle processor.py
```

## Contributions

Contributions are welcome! If you have a useful script that you'd like to share, feel free to submit a pull request.