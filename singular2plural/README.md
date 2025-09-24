# Content Type Migration Guide

This guide helps users migrate their existing Hugo Blox site to the new standardized content types.

> [!TIP]
> Prefer the automatic scripts below. Always run with `--dry-run` first.

## What's Changing in v0.8.0

Hugo Blox has standardized content types to be more intuitive and consistent:

| Old Content Type | New Content Type |
|-----------------|------------------|
| `post`          | `blog`           |
| `publication`   | `publications`   |
| `project`       | `projects`       |
| `event`         | `events`         |
| `teaching`      | `courses`        |

These changes make URLs more intuitive and consistent, following standard practices where collection types use plural names (with `blog` being the exception as standard practice).

## Migration Options

### Option 1: Automatic Migration Script

We've provided two migration scripts (choose your preferred one):

1. **Python Script** (recommended): `migrate-content-types.py`
2. **Zsh Script**: `migrate-content-types.sh`

Requirements:

- Python 3.8+ with `pyyaml` installed (for Python script):

  ```bash
  pip3 install pyyaml
  ```
- macOS/Linux shell (or Windows via WSL) for the Zsh script

> [!WARNING]
> These scripts perform file/folder writing and deletion operations.
> They are provided as a template only, under the MIT license of the repo.
> Ensure you perform a full backup of your computer and review/tailor the script code to your site before running.
> Always run the script with `--dry-run` first to review what actions the script will attempt to perform.

#### Using the Python Script


```bash
# Run the migration script
python migrate-content-types.py /path/to/your/site --dry-run

# Apply changes after reviewing dry-run output
python migrate-content-types.py /path/to/your/site
```

#### Using the Zsh Script


```bash
# Make the script executable (first time only)
chmod +x migrate-content-types.sh

# Preview without making changes
./migrate-content-types.sh /path/to/your/site --dry-run

# Apply changes after reviewing dry-run output
./migrate-content-types.sh /path/to/your/site
```

### Option 2: Manual Migration

If you prefer to migrate manually, follow these steps:

1. **Rename content directories**:
   ```bash
   # For each content type
   mkdir -p content/blog
   mv content/post/* content/blog/
   rmdir content/post
   
   # Repeat for other types
   mkdir -p content/publications
   mv content/publication/* content/publications/
   rmdir content/publication
   
   # And so on...
   ```

2. **Update folder references** in your content files:
   - Look for `folders:` sections in markdown files
   - Update references like `- post` to `- blog`
   - Update references like `- publication` to `- publications`
   - Update references like `- project` to `- projects`
   - Update references like `- event` to `- events`
   - Update references like `- teaching` to `- courses`

3. **Update page_type references** in your content files:
   - Look for `page_type:` in markdown files
   - Update `page_type: post` to `page_type: blog`
   - And so on for other content types

4. **Remove permalink overrides** in your Hugo configuration:
   - Edit your `hugo.yaml`, `config.yaml`, or `config.toml`
   - Remove or update any `permalinks:` sections

5. **Add redirects** to your `netlify.toml` for backward compatibility:

   ```toml
   [[redirects]]
     from = "/post/*"
     to = "/blog/:splat"
     status = 301
     force = true
   
   [[redirects]]
     from = "/publication/*"
     to = "/publications/:splat"
     status = 301
     force = true
   
   # And so on for other content types
   ```

## After Migration

1. Run your site locally with `hugo server` to test the changes
2. Review all pages to ensure they display correctly
3. Try searching your site folder in VSCode for terms like `folders` or `type` or `layout` or the old page types (e.g. `post`) to confirm you have no filters looking for content in the old structure.
4. Check that links and images work properly
5. Commit the changes to your repository

## Need Help?

If you encounter any issues during migration:

- 💬 Ask in Discord: https://discord.gg/z8wNYzb
- 📚 Read the docs: https://docs.hugoblox.com/
- 🐛 File an issue: https://github.com/HugoBlox/awesome-hugo/issues

> [!WARNING]
> These scripts can modify and delete files. Back up your site and test with `--dry-run` first.
