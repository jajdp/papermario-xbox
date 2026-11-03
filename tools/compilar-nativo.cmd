@echo off
rem Compila la DLL nativa de PaperBoat para UWP (rama uwp-xbox de JRickey) con el clang-cl de LLVM 19.1.7 portátil
rem (el Visual Studio que trae el componente de clang no siempre esta, y la rama lo pide) y el entorno x64 de VS 2022.
rem Equivale al paso «Build Paper Boat native DLL» de su .github\workflows\build-uwp.yml. Uso: compilar-nativo.cmd [configurar]
rem No se pasa cmake\toolchains\windows-clang-cl.cmake: CMake lo vuelve a incluir en sus pruebas de compilación, donde
rem busca clang-cl DENTRO de Visual Studio y aborta. Basta con darle los compiladores (lo único que hace ese archivo).
setlocal
rem Las tres rutas de abajo son lo unico que hay que ajustar. Se pueden fijar aqui o dejarlas
rem puestas en el entorno antes de llamar al script (PM_ARBOL, PM_LLVM).
if not defined PM_ARBOL set "PM_ARBOL=C:\papermario"
if not defined PM_LLVM  set "PM_LLVM=C:\llvm-19.1.7\bin"
set "VS=C:\Program Files\Microsoft Visual Studio\2022\Community"
set "CMAKE=%VS%\Common7\IDE\CommonExtensions\Microsoft\CMake\CMake\bin\cmake.exe"
set "NINJA=%VS%\Common7\IDE\CommonExtensions\Microsoft\CMake\Ninja\ninja.exe"
set "LLVM=%PM_LLVM%"
call "%VS%\VC\Auxiliary\Build\vcvars64.bat" >nul || exit /b 1
rem vcvars apunta VCPKG_ROOT al vcpkg de Visual Studio, que no es un clon de git y la automatización lo rechaza:
rem como en el CI, vcpkg propio dentro del árbol.
set "VCPKG_ROOT=%PM_ARBOL%\vcpkg"
set "PATH=%LLVM%;%PATH%"
cd /d "%PM_ARBOL%" || exit /b 1
if /i "%~1"=="configurar" (
  "%CMAKE%" -S . -B build-windows-uwp -G Ninja ^
    "-DCMAKE_MAKE_PROGRAM=%NINJA%" ^
    "-DCMAKE_C_COMPILER=%LLVM%\clang-cl.exe" ^
    "-DCMAKE_CXX_COMPILER=%LLVM%\clang-cl.exe" ^
    -DPAPERBOAT_UWP=ON ^
    "-DVCPKG_ROOT=%PM_ARBOL%/vcpkg" ^
    -DCMAKE_BUILD_TYPE=Release || exit /b 1
)
"%CMAKE%" --build build-windows-uwp --parallel 16 || exit /b 1
echo COMPILADO
