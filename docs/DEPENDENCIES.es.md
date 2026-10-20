# Dependencias

*(English: [DEPENDENCIES.md](DEPENDENCIES.md))*

| | |
|---|---|
| El proyecto del juego | [JRickey/PaperBoat](https://github.com/JRickey/PaperBoat), rama **`uwp-xbox`**, commit `2ab7705f` — el que se usó aquí. Licencia: CC0-1.0 |
| Proyecto base | [HarbourMasters/PaperBoat](https://github.com/HarbourMasters/PaperBoat), versión 1.0.2 ("Mulberry Charlie") |
| Tu propia ROM | El proyecto extrae los datos él mismo, en tu máquina. Aquí no se distribuye ni la ROM ni el archivo |
| Visual Studio 2022 | Con la **carga de trabajo de C++ para UWP**: MSBuild empaqueta y firma |
| CMake | El que viene con Visual Studio sirve |
| Python 3 | Cualquiera 3.8+, solo biblioteca estándar, para generar los mosaicos |
| PowerShell | La **5.1** que trae Windows. PowerShell 7 no hace falta; los ejemplos llevan `-ExecutionPolicy Bypass` porque un Windows de fábrica está en `Restricted` |
| Una Xbox Series X | En **modo desarrollador**, con un usuario conectado, y el appx de `Microsoft.VCLibs.140.00` para x64 instalado con el paquete |

⚠ Aquí la rama importa más que la versión: `uwp-xbox` es la rama que lleva el objetivo UWP. El proyecto trae además un toolchain de clang-cl que aborta la prueba de compilador de CMake, y un `vcvars` que reapunta `VCPKG_ROOT` al vcpkg de Visual Studio: `compilar-nativo.cmd` se encarga de las dos cosas.
