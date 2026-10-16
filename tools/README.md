# tools/

*(Español: [README.es.md](README.es.md))*

Two scripts. `compilar-nativo.cmd` configures and builds the author's UWP target with the two workarounds this project needs (CMake's compiler probe disabled, and `VCPKG_ROOT` put back after `vcvars` moves it). `pm_empaquetar.ps1` generates the tiles from your own images, packages with MSBuild and signs with your certificate.

Every path is a parameter and the certificate thumbprint is one too: there is no value in here
pointing at the machine these were written on, and no thumbprint baked in.

`-Version` has to go up on every cycle. The console will not replace an installed package with
another one carrying the same version, and the failure looks like the new build is broken.
