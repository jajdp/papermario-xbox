# Changelog

All notable changes to this recipe. Dates are `YYYY-MM-DD`.

## 1.0.4 — 2026-11-03

### Changed

- **The opening paragraph still pointed at another repository of this catalogue.** 1.0.3 said this
  repository had stopped explaining itself that way, and line 8 of both README files was still
  doing it: it introduced the split between what is ours and what is not as "the same decision as
  in" another port of ours, named outright. The sentence now states the thing itself, which is all
  it ever carried. No other file in the tree named one.

  Why 1.0.3 claimed zero and was wrong: that sweep looked for **links** to other repositories and
  for **game names written in prose**, and this was neither — a repository name, with hyphens, in
  running text. The check that found it compares the exact name of every other repository of the
  catalogue against every text file of the tree.

## 1.0.3 — 2026-11-03

### Changed

- **This repository no longer explains itself by pointing at other repositories of this
  catalogue.** Comments and documentation introduced a decision, a trap or a default as "the same
  as in such-and-such other port of ours" — which asked anyone who came here for this game to go
  and read about a different one first. Each of those comparisons carried a fact that reads better
  stated outright, so that is what is written now.

  What is still cited is everything that is **not** ours: the upstream project, the third-party
  forks the recipe is built on, and the files taken from them under their own license.

- **Two tools work again.** An earlier automatic substitution had left the placeholder `<tree>` as
  the *value* of several variables, so they could not run at all: `pm_empaquetar.ps1` now takes
  `-Arbol` and fails early with a message if it is missing, and `compilar-nativo.cmd` takes
  `PM_ARBOL` and `PM_LLVM` — it also used `%TREE%`, a variable nothing ever defined.

## 1.0.2 — 2026-10-20

### Changed

- **The README now says which console this was tested on, and which one it was not.** Everything here
  was built and measured on an **Xbox Series X** in Developer Mode; a **Series S has never been tried**,
  so nothing here says anything about one. The wording used to say "Xbox Series", which reads as if it
  covered both, and it does not.

## 1.0.1 — 2026-10-16

### Fixed

- **`LICENSE`: the explanatory block named the wrong project.** Everything after the MIT text had
  been copied from another repository in this catalogue and never adapted: it said this was a
  derivative of a different project altogether, denied granting rights in a game that is not this
  one, quoted "the 57 lines of the upstream project", and listed folders this repository does not
  have. The MIT grant itself was correct all along, and `NOTICE.md` always had the right figures.
  The block now names JRickey/PaperBoat (CC0-1.0) and Paper Mario, and points at `NOTICE.md` for the
  measurements instead of repeating a number.

## 1.0.0 — 2026-10-14

First release. The package built this way has been on an Xbox Series X since 2026-10-02.

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
