# aur-codeql-builder

Helper scripts to keep the [`codeql`](https://aur.archlinux.org/packages/codeql) AUR package metadata up to date.

It checks for the latest release of the CodeQL CLI and updates the version and checksum in the AUR `PKGBUILD`.

## What it does

- Fetches release metadata from [github/codeql-cli-binaries](https://github.com/github/codeql-cli-binaries)
- Extracts version and checksum (but does **not** download the archive)
- Updates the AUR `PKGBUILD` accordingly
- Commits and pushes changes to the AUR repository
