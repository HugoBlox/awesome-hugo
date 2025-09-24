<!-- markdownlint-disable MD033 -->
<p align="center">
  <h1>Awesome Hugo</h1>
  <p><strong>Tools to help you upgrade and manage your <a href="https://gohugo.io/">Hugo</a> / <a href="https://hugoblox.com/?utm_source=github&utm_medium=awesome-hugo">Hugo Blox</a> sites.</strong></p>
</p>
<!-- markdownlint-enable MD033 -->

<!-- markdownlint-disable MD033 -->
<p align="center">
  <a href="https://discord.gg/z8wNYzb">
    <img src="https://img.shields.io/discord/722225264733716590?label=Join%20Discord&style=social" alt="Discord">
  </a>
  <a href="https://github.com/HugoBlox/awesome-hugo">
    <img src="https://img.shields.io/github/stars/HugoBlox/awesome-hugo?label=Star%20this%20repo&style=social" alt="GitHub Stars">
  </a>
  <a href="https://x.com/BuildLore">
    <img src="https://img.shields.io/twitter/follow/BuildLore?label=Follow&style=social" alt="Follow on X">
  </a>
  <br/>
  <a href="./singular2plural/README.md"><b>🚀 Upgrade to Hugo Blox v0.8.0 →</b></a>
  &nbsp;•&nbsp;
  <a href="https://docs.hugoblox.com/?utm_source=github&utm_medium=awesome-hugo"><b>Docs</b></a>
  &nbsp;•&nbsp;
  <a href="https://hugoblox.com/templates?utm_source=github&utm_medium=awesome-hugo"><b>Templates</b></a>
</p>
<!-- markdownlint-enable MD033 -->

---

## Scripts

- [`singular2plural`](./singular2plural/README.md)
  - Upgrade your site to the latest content type conventions (required for Hugo Blox v0.8.0).
  - Supports `--dry-run` and adds helpful Netlify redirects.

- `refactor-pages-to-page-bundles.sh`
  - Convert page files to page bundles: `content/<section>/X.md` → `content/<section>/X/index.md`.
  - Helps migrate Academic v2.4.0 → v3.0.0.
  - Usage:

    ```bash
    bash refactor-pages-to-page-bundles.sh
    ```

- `refactor_pages_convert_TOML_to_YAML.py`
  - Convert all front matter from TOML to YAML for broader editor compatibility.
  - Setup (Poetry):

    ```bash
    # In this repo's root
    curl -sSL https://install.python-poetry.org | python3 -  # if needed
    poetry install
    ```

  - Run:

    ```bash
    # From this repo root
    poetry run python3 refactor_pages_convert_TOML_to_YAML.py
    # Or from a site directory
    poetry run python3 /path/to/awesome-hugo/refactor_pages_convert_TOML_to_YAML.py
    ```

- `refactor-widget-bundles-as-headless.sh`
  - Academic v4.1 → v4.2: add `headless: true` to homepage section bundles.
  - Usage:

    ```bash
    bash refactor-widget-bundles-as-headless.sh
    ```

- `refactor_page_bundles_to_pages.sh`
  - Convert homepage page bundles back to page files (mainly for testing/downgrades).
  - Note: no `--dry-run` flag. Manually review and comment out `mv`/`rm` lines to simulate a dry-run.
  - Usage:

    ```bash
    bash refactor_page_bundles_to_pages.sh
    ```

---

## Contribute your scripts

Have a useful script for managing or upgrading Hugo/Hugo Blox sites? We welcome contributions!

- Submit a PR adding your script in a clearly named folder (and keep it MIT-licensed)
- Include a brief `README.md` with usage, flags (prefer a `--dry-run`), and caveats
- Prefer cross-platform approaches (macOS/Linux; Windows via WSL) and non-destructive defaults
- For Python tools, use Python 3.8+ and declare deps in `pyproject.toml` (Poetry)
- For shell tools, stick to standard Unix utilities and document any assumptions

Not sure where to start? Open an issue or discuss ideas in [Discord](https://discord.gg/z8wNYzb).

---

## Requirements

- macOS/Linux. Windows users can use [Windows Subsystem for Linux](https://learn.microsoft.com/windows/wsl/).
- For Python scripts: Python 3.8+ with Poetry-managed deps (`pyyaml`, `toml`).
- For shell scripts: standard Unix tools (`bash/zsh`, `find`, `sed`).

---

## Safety Notes

> [!WARNING]
> These scripts can modify and delete files.
>
> - Make a full backup before running.
> - Review script code and adapt to your site.
> - Always run with `--dry-run` first if the script supports it.

These tools are provided under MIT as templates to assist migrations. Test locally with `hugo server` before deploying.

---

## Community & Support

- 💬 Need help? [Join the Hugo Blox Discord](https://discord.gg/z8wNYzb)
- 📚 [Docs & Guides](https://docs.hugoblox.com/?utm_source=github&utm_medium=awesome-hugo)
- ⭐ Like these tools? [Star this repo on GitHub](https://github.com/HugoBlox/awesome-hugo)

---

## License

MIT © Hugo Blox Team. See [`LICENSE.md`](./LICENSE.md).
