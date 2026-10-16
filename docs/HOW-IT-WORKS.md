# How it works

*(Español: [HOW-IT-WORKS.es.md](HOW-IT-WORKS.es.md))*

## Whose work is whose

The UWP target — the WinRT entry point, the window, the backend that draws on a console — is the
author's, on the `uwp-xbox` branch of [JRickey/PaperBoat](https://github.com/JRickey/PaperBoat). Reading that
branch is how you learn how the port works, and this repository does not duplicate it.

What was missing, and what is here, is the path from that branch to a signed package sitting on a
console: the build invocation that survives this project's toolchain, the tiles actually making it
into the package, the signature with a certificate the console already trusts, and the handful of
console behaviours that look like bugs in your build and are not.

## The one code change

The author's `uwp/CMakeLists.txt` lists the tiles that go into the package by name — six of them.
Any tile you add beyond those six is not packaged, and nothing warns you: the console just shows a
default icon and no splash screen. The patch replaces that list with a glob over `Assets/`.

It is three lines. It is also the difference between a package that looks like a game and one that
looks like a broken sideload, which is why it is the one change worth publishing.

## What the console does that a desktop does not

- **It will not replace a package with another of the same version.** Every cycle needs a new
  version number, or you install and run the old build while believing you tested the new one.
- **The app's data folder does not exist until the app has run once.** Uploading before that fails
  with "cannot find the path".
- **Files uploaded inside a `.zip` are unreadable.** Unpacked by the Device Portal they end up with
  permissions the AppContainer cannot open, and the game behaves as if the data were not there.
- **With no user signed in, a package installs and then does nothing.** This one looks exactly like
  a broken package.

**The Torch submodule points at a repository that no longer exists.** Cloning the branch fails there. The URL has to be fixed in `.git/config` -- and **not** with `git submodule sync`, which copies the broken URL from `.gitmodules` back over it.

**The project's clang-cl toolchain aborts CMake's own compiler tests.** The toolchain file is fine for the game but the probe CMake runs first does not survive it. Configure once with the probe disabled, as `compilar-nativo.cmd` does.

**`vcvars` repoints VCPKG_ROOT at the Visual Studio copy of vcpkg.** After loading the build environment, `VCPKG_ROOT` no longer points at the vcpkg inside your checkout, and the build picks up the wrong packages. It is set back explicitly.

## How this was verified

The package built this way has been running on a console since 2026-10-02: it ran the intro with DirectX 11 on an Xbox Series X on 2026-10-02, with the o2r archive from the desktop build in its data folder.

What this repository publishes is the recipe and the tooling, and both were re-read and sanitised
before publication: no path from the machine they were written on, no certificate thumbprint (it is
a parameter now), and no artwork.

What is **not** re-measured here is a rebuild from a fresh clone, because the port is the author's
and its build needs the full project toolchain. The claim is narrow on purpose.
