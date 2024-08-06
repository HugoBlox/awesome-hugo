# Awesome Hugo

**A collection of scripts to help you easily manage your Markdown content.**

- easily apply batch edits to all your Markdown content
- integrates with [Hugo](https://gohugo.io/) and the [Hugo Website Builder](https://wowchemy.com/)

👉 Questions? Join the community on [Discord](https://discord.gg/z8wNYzb).

💡 Have you developed a useful script? Consider contributing it in a Pull Request so the community can benefit!

## Scripts

- `refactor-pages-to-page-bundles`
  - Refactor all **Markdown page files to page bundles** (each page gets a portable, self contained folder with its assets)
- `refactor_page_bundles_to_pages.sh`
   - Convert page bundles (e.g. `content/home/hero/index.md`) to page files (e.g. `content/home/hero.md`)
- `refactor_pages_convert_TOML_to_YAML.py`
  - Python script to **convert front matter of all pages from TOML to YAML** for compatibility with a wider range of Markdown editors
  - Prerequisite: `pip install pipenv` and `pipenv install`
  - To use `cd YOUR_SITE_FOLDER` and `python3 refactor_pages_convert_TOML_to_YAML.py`
- `refactor-widget-bundles-as-headless.sh`
  - Refactor Hugo widgets to add `headless: true` to front matter (assumes YAML front matter, such as by running above Python script to convert all front matter from TOML to YAML)
- [wp2hugo](https://github.com/ashishb/wp2hugo)
  - The best WordPress to Hugo migrator

## Notes

Please make a full backup of your site and Markdown content prior to running any scripts.

These scripts are provided by the community in the hope that they might aid updating and managing large collections of Markdown content. Before running a script, you should review its code and adapt it as necessary for your content.

Windows users may need to install the [Windows Linux Subsystem](https://docs.microsoft.com/en-us/windows/wsl/install-win10) in order to run Bash scripts.
