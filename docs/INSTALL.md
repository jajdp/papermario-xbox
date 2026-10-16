# Install — from the author's branch to the game on the console

*(Español: [INSTALL.es.md](INSTALL.es.md))*

## 0. Where you type these commands

**PowerShell** for the scripts and the Device Portal; a **`cmd` window with the build environment**
for CMake. No step needs "run as administrator", and using it breaks the signing step, because the
certificate lives in the store of whoever runs the command. The `-ExecutionPolicy Bypass` in the
examples is because a stock Windows will not run a `.ps1` at all.

## 1. Clone the author's branch

```powershell
git clone --branch uwp-xbox https://github.com/JRickey/PaperBoat.git C:\game
cd C:\game
git submodule update --init --recursive
```

⚠ **The Torch submodule points at a repository that no longer exists**, so this step fails. Fix the URL in `.git/config` — and do **not** use `git submodule sync`, which copies the broken URL from `.gitmodules` right back over it.

Get it building **for the desktop first**, with your own ROM. The project extracts the assets into
an archive on your machine; if that does not work, nothing after it will.

## 2. Apply our one change, and put your tiles in

```powershell
python <this repo>\tools\...   # see tools/README.md
git apply <this repo>\patches\01-package-all-tiles.patch
```

The patch turns the fixed six-name tile list in `uwp/CMakeLists.txt` into a glob over `Assets/`.
Without it, any tile whose name is not in that list is simply not in the package, and the console
shows the app with a default icon and no splash screen — with no error anywhere.

Your own thirteen tiles go in `uwp/Assets/` ([`ASSETS.md`](ASSETS.md) has the sizes). This
repository ships none: the ones used on the console were made from the game's art.

## 3. Build, package and sign

The author's branch builds the UWP target itself; what our script adds is the packaging and the
signature with **your** certificate instead of a throwaway one, so the console does not have to
trust a new publisher for every build.

```powershell
powershell -ExecutionPolicy Bypass -File <this repo>\tools\pm_empaquetar.ps1 -Version 0.1.0.0
```

Create the certificate once, in an **ordinary** PowerShell window:

```powershell
New-SelfSignedCertificate -Type Custom -Subject "CN=<your name>" -KeyUsage DigitalSignature `
  -FriendlyName "<your name> UWP dev" -CertStoreLocation "Cert:\CurrentUser\My" `
  -TextExtension @("2.5.29.37={text}1.3.6.1.5.5.7.3.3", "2.5.29.19={text}")
```

`Publisher` in `uwp/Package.appxmanifest` must be **exactly** that `-Subject`, `CN=` included: the
console compares the two strings literally.

⚠ **The package version has to go up on every cycle.** The console will not replace an installed
package with another one carrying the same version, and the failure looks like your new build is
broken.

## 4. Install it and feed it its data

Device Portal (`https://<console ip>:11443`, with your Dev Home username and password): **Add** →
the package → with the `Microsoft.VCLibs.140.00` x64 appx as a dependency. The console needs
**a user signed in**, or the package installs and then does nothing when opened.

Then upload the archive the desktop build produced to `LocalState\boat` in the app's data folder.

⚠ Two things that cost an afternoon each: the data folder **does not exist until the app has run
once**, and files uploaded **inside a `.zip`** come out with permissions the AppContainer cannot
read. Launch it once, close it, then upload one file at a time.

## 5. When something goes wrong

| What you see | What it is |
|---|---|
| The clone fails on a submodule | The Torch submodule URL is dead; fix it in `.git/config` |
| The app shows a default icon and no splash | The tile patch is not applied (section 2) |
| The console rejects the package | `Publisher` and the certificate subject are not the same string |
| Installing "works" but the game is the old build | The package version did not go up |
| The game starts and cannot find its data | The archive is not in the app folder, or it was uploaded inside a zip |
