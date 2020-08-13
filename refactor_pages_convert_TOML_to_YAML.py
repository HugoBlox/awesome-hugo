# -*- coding: utf-8 -*-

import os
import glob
import toml
import yaml

VERBOSE = False
# VERBOSE = True

for file_path in glob.glob("content/**/*.md", recursive=True):
    if VERBOSE: print('Handling file :', file_path)
    # loads file
    with open(file_path, 'r', encoding='utf-8') as source_file:
        page = source_file.read() + '\n'
        # extracts and parses metadata
        parts = page.split('+++')
    # closes file

    if len(parts) == 3 :
        pre, metadata, post = parts
        if VERBOSE: print('Handling file :', file_path, 'pre =', pre)
        if VERBOSE: print('Handling file :', file_path, 'post =', post)

        parsed_metadata = toml.loads(metadata)
        if VERBOSE: print('Handling file :', file_path, '\nparsed_toml =', parsed_metadata)

        # saves
        metadata = yaml.dump(parsed_metadata, encoding=('utf-8'), allow_unicode=True)
        if VERBOSE: print('Handling file :', file_path, '\nYAML =', metadata)
        metadata = metadata.decode('utf-8')
        if VERBOSE: print('Handling file :', file_path, '\nYAML =', metadata)

        # Save Markdown file.
        try:
            if VERBOSE: print(f"Saving Markdown to '{file_path}'")
            page = '---\n' + metadata + '---\n' + post.strip('\n')
            with open(file_path, 'w', encoding='utf-8') as f:
                f.write(page + '\n')
        except IOError:
            print('ERROR: could not save file ', file_path)
    else:
        print('Handling file :', file_path, 'Warn:  len(metadata) =', len(parts), '... ignoring file')
