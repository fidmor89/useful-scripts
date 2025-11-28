import os


def extract_dialog_from_srt(file_path):
    """Extracts dialog from an SRT file, ignoring sequence numbers and timecodes."""
    dialogues = []
    with open(file_path, 'r', encoding='utf-8') as file:
        content = file.readlines()

    # Keep track of whether the next lines should be treated as dialog
    is_dialogue = False
    for line in content:
        if is_dialogue:
            if line.strip():
                dialogues.append(line.strip())
            else:
                is_dialogue = False
        elif '-->' in line:
            is_dialogue = True

    return dialogues


def process_subtitle_directories(directory, output_file):
    with open(output_file, 'w', encoding='utf-8') as output:

        for root, dirs, files in os.walk(directory):
            if root.endswith("_subtitles"):
                module_name = root.replace("_subtitles", "").replace(directory, "").strip("/")
                output.write(f"\n\n# Module: {module_name.replace('_', ' ')}\n")

                for file in files:
                    if file.endswith(".srt"):
                        file_path = os.path.join(root, file)
                        dialogues = extract_dialog_from_srt(file_path)
                        output.write("\n".join(dialogues) + "\n")


base_directory = '/Users/fides/Documents/MSCS/CS7641-ML/Lectures'
output_file_path = f'{base_directory}/lectures_transcript.txt'

# Call the function with the path to the base directory where subtitle directories are located
process_subtitle_directories(base_directory, output_file_path)
