#!/usr/bin/env python3
"""
Hugo Blox Content Type Migration Script

This script helps users migrate their Hugo Blox Builder site from the old
singular content type structure (post, publication, project, event, teaching)
to the new standardized structure (blog, publications, projects, events, courses).

Usage:
    python migrate-content-types.py /path/to/your/site

Author: Hugo Blox Team
License: MIT
"""

import os
import sys
import re
import shutil
from pathlib import Path
import yaml
import argparse


# Define content type migrations
CONTENT_MIGRATIONS = {
    'post': 'blog',
    'publication': 'publications', 
    'project': 'projects',
    'event': 'events',
    'teaching': 'courses'
}

# Define page type migrations in front matter
PAGE_TYPE_MIGRATIONS = {
    'post': 'blog',
    'publication': 'publications',
    'project': 'projects',
    'event': 'events',
    'teaching': 'courses'
}


def migrate_content_directories(site_path):
    """Rename content directories according to the migration mapping."""
    content_path = os.path.join(site_path, 'content')
    
    if not os.path.exists(content_path):
        print(f"⚠️ Content directory not found at {content_path}")
        return
    
    print("📂 Migrating content directories...")
    
    for old_type, new_type in CONTENT_MIGRATIONS.items():
        old_dir = os.path.join(content_path, old_type)
        if os.path.exists(old_dir) and os.path.isdir(old_dir):
            new_dir = os.path.join(content_path, new_type)
            
            # Create new directory if it doesn't exist
            if not os.path.exists(new_dir):
                os.makedirs(new_dir)
                print(f"  ✅ Created {new_type} directory")
            
            # Move files from old to new directory
            for item in os.listdir(old_dir):
                old_item_path = os.path.join(old_dir, item)
                new_item_path = os.path.join(new_dir, item)
                
                if os.path.exists(new_item_path):
                    print(f"  ⚠️ {item} already exists in {new_type}/, skipping...")
                    continue
                    
                shutil.move(old_item_path, new_item_path)
                print(f"  ✅ Moved {old_type}/{item} to {new_type}/{item}")
            
            # Remove old directory if empty
            if not os.listdir(old_dir):
                os.rmdir(old_dir)
                print(f"  ✅ Removed empty {old_type}/ directory")


def update_folder_references(site_path):
    """Update folder references in content files and configs."""
    content_path = os.path.join(site_path, 'content')
    
    print("\n📄 Updating folder references in content files...")
    
    # Get list of markdown files
    md_files = []
    for root, _, files in os.walk(site_path):
        for file in files:
            if file.endswith(('.md', '.markdown')):
                md_files.append(os.path.join(root, file))
    
    # Update folder references in markdown files
    for md_file in md_files:
        update_needed = False
        with open(md_file, 'r', encoding='utf-8') as f:
            content = f.read()
        
        # Look for folder references in filters
        for old_type, new_type in CONTENT_MIGRATIONS.items():
            # Match folders: - old_type pattern with proper YAML indentation
            pattern = re.compile(r'([ \t]*folders:[ \t]*\n[ \t]*-[ \t]*){0}([ \t]*\n)'.format(old_type))
            if pattern.search(content):
                content = pattern.sub(r'\1{0}\2'.format(new_type), content)
                update_needed = True
                print(f"  ✅ Updated folder reference in {os.path.relpath(md_file, site_path)}")
        
        # Look for page_type references
        for old_type, new_type in PAGE_TYPE_MIGRATIONS.items():
            # Match page_type: old_type pattern
            pattern = re.compile(r'([ \t]*page_type:[ \t]*){0}([ \t]*\n)'.format(old_type))
            if pattern.search(content):
                content = pattern.sub(r'\1{0}\2'.format(new_type), content)
                update_needed = True
                print(f"  ✅ Updated page_type reference in {os.path.relpath(md_file, site_path)}")
        
        # Write back if changes were made
        if update_needed:
            with open(md_file, 'w', encoding='utf-8') as f:
                f.write(content)


def update_config_files(site_path):
    """Update Hugo configuration files to remove permalink overrides."""
    print("\n⚙️ Updating configuration files...")
    
    # Find all hugo.yaml or config.yaml files
    config_files = []
    for root, _, files in os.walk(site_path):
        for file in files:
            if file in ('hugo.yaml', 'config.yaml', 'config.toml', 'hugo.toml'):
                config_files.append(os.path.join(root, file))
    
    for config_file in config_files:
        file_ext = os.path.splitext(config_file)[1]
        
        if file_ext in ('.yaml', '.yml'):
            try:
                with open(config_file, 'r', encoding='utf-8') as f:
                    config = yaml.safe_load(f)
                
                # Check for permalinks section
                if config and 'permalinks' in config:
                    # Remove singular path overrides
                    updated = False
                    for key in list(config['permalinks'].keys()):
                        if key == 'authors' and config['permalinks'][key] == '/author/:slug/':
                            del config['permalinks'][key]
                            updated = True
                        elif key in ('tags', 'categories') and config['permalinks'][key].startswith('/'):
                            del config['permalinks'][key]
                            updated = True
                    
                    # Remove empty permalinks section
                    if not config['permalinks']:
                        del config['permalinks']
                        updated = True
                    
                    if updated:
                        # Write updated config
                        with open(config_file, 'w', encoding='utf-8') as f:
                            yaml.dump(config, f, default_flow_style=False, sort_keys=False)
                        print(f"  ✅ Removed permalink overrides from {os.path.relpath(config_file, site_path)}")
                
            except Exception as e:
                print(f"  ⚠️ Error updating {config_file}: {e}")
        
        # TODO: Add support for TOML config files if needed


def create_netlify_redirects(site_path):
    """Create Netlify redirects for backward compatibility."""
    print("\n🔄 Creating Netlify redirects for backward compatibility...")
    
    netlify_file = os.path.join(site_path, 'netlify.toml')
    redirects_to_add = []
    
    for old_type, new_type in CONTENT_MIGRATIONS.items():
        redirects_to_add.append(f"""
[[redirects]]
  from = "/{old_type}/*"
  to = "/{new_type}/:splat"
  status = 301
  force = true""")
    
    if os.path.exists(netlify_file):
        # Append to existing file
        with open(netlify_file, 'a', encoding='utf-8') as f:
            f.write("\n# Redirects for content type migration\n")
            for redirect in redirects_to_add:
                f.write(redirect + "\n")
        print(f"  ✅ Added redirects to {netlify_file}")
    else:
        # Create new file
        with open(netlify_file, 'w', encoding='utf-8') as f:
            f.write("# Hugo Blox Builder - Netlify Configuration\n")
            f.write("# See https://docs.hugoblox.com/getting-started/hugo-blox-to-netlify/\n\n")
            f.write("# Redirects for content type migration\n")
            for redirect in redirects_to_add:
                f.write(redirect + "\n")
        print(f"  ✅ Created {netlify_file} with redirects")


def main():
    parser = argparse.ArgumentParser(description="Migrate Hugo Blox site to standardized content types")
    parser.add_argument("site_path", help="Path to your Hugo Blox site")
    parser.add_argument("--dry-run", action="store_true", help="Print actions without executing them")
    
    args = parser.parse_args()
    site_path = os.path.abspath(args.site_path)
    
    if not os.path.exists(site_path):
        print(f"Error: Site path {site_path} does not exist")
        sys.exit(1)
    
    print(f"\n🚀 Migrating Hugo Blox site at {site_path} to standardized content types\n")
    
    if not args.dry_run:
        migrate_content_directories(site_path)
        update_folder_references(site_path)
        update_config_files(site_path)
        create_netlify_redirects(site_path)
        
        print("\n✨ Migration completed successfully!")
        print("\nRecommendations:")
        print("1. Run 'hugo server' to test your site locally")
        print("2. Review your site to make sure everything works as expected")
        print("3. Commit the changes to your Git repository")
    else:
        print("Dry run completed. No changes were made.")
    
    print("\nFor more details on the content type standardization, see: https://github.com/HugoBlox/awesome-hugo/blob/main/singular2plural/CONTENT-TYPES.md")


if __name__ == "__main__":
    try:
        main()
    except KeyboardInterrupt:
        print("\n⚠️ Migration interrupted by user")
        sys.exit(1)
    except Exception as e:
        print(f"\n❌ Error during migration: {e}")
        sys.exit(1)
