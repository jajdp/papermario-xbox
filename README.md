# Paper Mario on Xbox — packaging the UWP port

**The UWP port of this game is the author's, not ours.** [JRickey/PaperBoat](https://github.com/JRickey/PaperBoat)
carries it on its `uwp-xbox` branch, and it works. What was missing was everything between that
branch and a package installed on a console: how to build it, how to get the tiles in, how to sign
it, and what the console does that a desktop never does.

That is what this repository is. It is the same decision as in `retro-rewind-xbox`: publish the
half that is ours, and say plainly that the other half is not.

*(Español: [README.es.md](README.es.md))*

It is not a theory: it ran the intro with DirectX 11 on an Xbox Series X on 2026-10-02, with the o2r archive from the desktop build in its data folder.

## What is here

| | |
|---|---|
| `patches/01-package-all-tiles.patch` | Our one change to the author's CMake: the tile list was a fixed set of six filenames, and it becomes a glob over the whole `Assets/` folder, so no tile can silently stay out of the package |
| `package/Package.appxmanifest` | The manifest as it ended up, with the identity blanked to `CHANGE-ME` |
| `tools/` | `pm_empaquetar.ps1` and `compilar-nativo.cmd`: build, package, sign, and generate the tiles from your own images |
| `docs/` | The step-by-step, in English and Spanish, including the console-side traps |

## What is **not** here

No ROM, no `.o2r` archive, no built binary, no package, and **no code of the author's** beyond the
six context lines the patch needs. No artwork: the tiles on the real console were made from the
game's own art. No signing certificate.

## What you need first

| | |
|---|---|
| The game project | [JRickey/PaperBoat](https://github.com/JRickey/PaperBoat), branch `uwp-xbox` (commit `2ab7705f` is what this was built from), **building and running on your PC first** |
| Your own ROM | The project extracts its assets itself, on your machine |
| Visual Studio | 2022 with the C++ UWP workload |
| Python 3 | For the tile generation. Standard library only |
| An Xbox in Developer Mode | And a certificate to sign with ([`docs/INSTALL.md`](docs/INSTALL.md)) |

## What it had to solve

These are the things that cost time, and none of them is in the author's README:

| | Symptom | Fix |
|---|---|---|
| 1 | The Torch submodule points at a repository that no longer exists | Cloning the branch fails there. The URL has to be fixed in `.git/config` -- and **not** with `git submodule sync`, which copies the broken URL from `.gitmodules` back over it. |
| 2 | The project's clang-cl toolchain aborts CMake's own compiler tests | The toolchain file is fine for the game but the probe CMake runs first does not survive it. Configure once with the probe disabled, as `compilar-nativo.cmd` does. |
| 3 | `vcvars` repoints VCPKG_ROOT at the Visual Studio copy of vcpkg | After loading the build environment, `VCPKG_ROOT` no longer points at the vcpkg inside your checkout, and the build picks up the wrong packages. It is set back explicitly. |

## Credits and license

The port is **JRickey/PaperBoat**'s, under CC0-1.0. The packaging recipe, the tooling and this
documentation are by **Recompilaciones**, under the [MIT License](LICENSE).

*Paper Mario* is © Nintendo. This project is not affiliated with them, with Microsoft or with the
author of the port, and it distributes nothing that belongs to them — see
[`NOTICE.md`](NOTICE.md). Rights holders can write to **jajdpmail@gmail.com**.
