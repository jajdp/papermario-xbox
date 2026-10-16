# Changelog

All notable changes to this recipe. Dates are `YYYY-MM-DD`.

## 1.0.1 — 2026-10-16

### Fixed

- **`LICENSE`: the explanatory block named the wrong project.** Everything after the MIT text had
  been copied from the `dkr-xbox` repository and never adapted: it said this was a derivative of
  Golden Balloon, denied granting rights in Diddy Kong Racing, quoted "the 57 lines of the upstream
  project", and listed folders this repository does not have. The MIT grant itself was correct all
  along, and `NOTICE.md` always had the right figures. The block now names JRickey/PaperBoat (CC0-1.0) and
  Paper Mario, and points at `NOTICE.md` for the measurements instead of repeating a number.

## 1.0.0 — 2026-10-14

First release. The package built this way has been on an Xbox Series since 2026-10-02.

### Included

- `patches/01-package-all-tiles.patch`: the tile list in the author's UWP CMake becomes a glob, so
  no tile stays out of the package by being missing from a hard-coded list.
- `package/Package.appxmanifest`: the manifest as it ended up, identity blanked to `CHANGE-ME`.
- `tools/`: `pm_empaquetar.ps1` and `compilar-nativo.cmd`.
- Documentation in English and Spanish, including the traps that are not in the author's README.

### Not included, on purpose

The UWP port itself, which is the author's and lives on the `uwp-xbox` branch of
[JRickey/PaperBoat](https://github.com/JRickey/PaperBoat). This repository is the packaging half; `NOTICE.md`
measures exactly what is quoted from the author's tree: six context lines.
