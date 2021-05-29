# Awesome Hugo

**A collection of scripts to help migrate content to new versions of [Hugo](https://gohugo.io/) and [Wowchemy Website Builder](https://wowchemy.com/).**

## Scripts

- `refactor-pages-to-page-bundles`
  - Refactor all **page files to page bundles** (each page gets a portable, self contained folder with its assets)
  - Helps migrate from Academic v2.4.0 to v3.0.0
- `refactor_pages_convert_TOML_to_YAML.py`
  - Python script to **convert front matter of all pages from TOML to YAML** for compatibility with a wider range of Markdown editors
  - Prerequisite: `pip install pipenv` and `pipenv install`
  - To use `cd YOUR_SITE_FOLDER` and `python3 refactor_pages_convert_TOML_to_YAML.py`
- `refactor-widget-bundles-as-headless.sh`
  - Assists with migration from Academic v4.1 to v4.2
  - Refactor Academic widgets to add `headless: true` to front matter (assumes YAML front matter, such as by running above Python script to convert all front matter from TOML to YAML)
- `refactor_page_bundles_to_pages.sh`
   - Converts homepage page bundles to page files - mainly useful for testing or downgrading Academic

## Notes

Please make a full backup of your site prior to running any scripts.

These scripts are provided in the hope that they might aid updating and managing Hugo sites. Before running a script, you should review its code and adapt it as necessary for your site.

Windows users may need to install the [Windows Linux Subsystem](https://docs.microsoft.com/en-us/windows/wsl/install-win10) in order to run Bash scripts.
