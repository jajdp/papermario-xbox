# Dependencies

*(Español: [DEPENDENCIES.es.md](DEPENDENCIES.es.md))*

| | |
|---|---|
| The game project | [JRickey/PaperBoat](https://github.com/JRickey/PaperBoat), branch **`uwp-xbox`**, commit `2ab7705f` — what this was built from. License: CC0-1.0 |
| Base project | [HarbourMasters/PaperBoat](https://github.com/HarbourMasters/PaperBoat), version 1.0.2 ("Mulberry Charlie") |
| Your own ROM | The project extracts the assets itself, on your machine. Neither the ROM nor the archive is distributed here |
| Visual Studio 2022 | With the **C++ UWP workload**: MSBuild packages and signs |
| CMake | The one that ships with Visual Studio is fine |
| Python 3 | Any 3.8+, standard library only, for the tile generation |
| PowerShell | The **5.1** that Windows ships. PowerShell 7 is not needed; the examples carry `-ExecutionPolicy Bypass` because a stock Windows is `Restricted` |
| An Xbox Series | In **Developer Mode**, with a user signed in, and the `Microsoft.VCLibs.140.00` x64 appx installed with the package |

⚠ The branch matters more than the version here: `uwp-xbox` is the branch with the UWP target. The project also has a clang-cl toolchain that aborts CMake's own compiler probe, and a `vcvars` that repoints `VCPKG_ROOT` at Visual Studio's vcpkg — `compilar-nativo.cmd` handles both.
