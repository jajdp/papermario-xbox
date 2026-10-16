<#
.SYNOPSIS
  Construye y firma el paquete UWP de Paper Mario (PaperBoat, rama uwp-xbox de JRickey) para la Xbox Series.

.DESCRIPTION
  Segunda mitad del build-uwp.yml de JRickey/PaperBoat: con la DLL nativa ya compilada (compilar-nativo.cmd, clang-cl de
  LLVM 19.1.7), se configura el envoltorio WinRT de uwp\ y se empaqueta con MSBuild.

  Cambios respecto al flujo original, los mismos que en los demás ports propios del proyecto:
   - identidad propia (Decompilaciones-PaperMario) y editor CN=Decompilaciones, el certificado del proyecto que ya está en
     Cert:\CurrentUser\My, en vez del autofirmado CN=JRickey que genera el CI;
   - nombre visible «Paper Mario Decomp» (RN-12, identidad-visual.xlsx);
   - desde la 1.0.2.1 (2026-10-02), el arte del usuario: pantalla de carga declarada en el manifiesto, el CMake de uwp\
     empaqueta todos los PNG de Assets\ (el original tenía una lista fija de seis) y identidad-visual.py --aplicar-a pinta
     los mosaicos con las imagenes que le pases (el cuadrado y la pantalla de carga).
  Idempotente: el manifiesto y el CMakeLists.txt de uwp\ se reescriben enteros desde el original de la rama cada vez.

.PARAMETER Version
  Sube en cada ciclo: la consola no reemplaza un paquete por otro de la MISMA versión.
#>
[CmdletBinding()]
param(
  [string]$Version = "1.0.2.0",
  [string]$Arbol = "<tree>",
  [string]$Huella = $null   # CN=Decompilaciones
)

$ErrorActionPreference = 'Stop'
$cmake = "C:\Program Files\Microsoft Visual Studio\2022\Community\Common7\IDE\CommonExtensions\Microsoft\CMake\CMake\bin\cmake.exe"
$msbuild = "C:\Program Files\Microsoft Visual Studio\2022\Community\MSBuild\Current\Bin\MSBuild.exe"

$dll = Join-Path $Arbol "build-windows-uwp\PaperBoat.dll"
if (-not (Test-Path -LiteralPath $dll)) { throw "falta la DLL del juego: $dll (correr antes compilar-nativo.cmd)" }
Write-Host ("  DLL: {0:N1} MB" -f ((Get-Item -LiteralPath $dll).Length / 1MB))

# 1. Manifiesto: identidad y nombres del proyecto, partiendo SIEMPRE del original de la rama (git show HEAD:...)
$manifiesto = Join-Path $Arbol "uwp\Package.appxmanifest"
$original = & git -C $Arbol show "HEAD:uwp/Package.appxmanifest"
if ($LASTEXITCODE -ne 0) { throw "no pude leer el manifiesto original de la rama" }
$texto = ($original -join "`n")
$cambios = @(
  @('Name="PaperBoat.UWP" Publisher="CN=JRickey"', 'Name="Decompilaciones-PaperMario" Publisher="CN=Decompilaciones"'),
  @('PhoneProductId="5e5df209-60fc-45ba-b5c9-39d1ed8380d9"', 'PhoneProductId="8a3f2c61-7d4e-4b9a-9c25-6e1f0d7b3a48"'),
  @('<DisplayName>Paper Boat</DisplayName>', '<DisplayName>Paper Mario Decomp</DisplayName>'),
  @('<PublisherDisplayName>Paper Boat Community UWP</PublisherDisplayName>', '<PublisherDisplayName>Decompilaciones</PublisherDisplayName>'),
  @('DisplayName="Paper Boat"', 'DisplayName="Paper Mario Decomp"'),
  @('Description="Paper Mario 64 native port for Xbox developer mode"', 'Description="Paper Mario (PaperBoat 1.0.2) - port propio para la Xbox en modo desarrollador"'),
  # La pantalla de carga al abrir el juego (el original no la declara): sin ella no se ve el arte xbox-ss.
  @('<uap:DefaultTile Wide310x150Logo="Assets\Wide310x150Logo.png" />', ('<uap:DefaultTile Wide310x150Logo="Assets\Wide310x150Logo.png" />' + "`n        " + '<uap:SplashScreen Image="Assets\SplashScreen.png" />'))
)
foreach ($c in $cambios) {
  if (-not $texto.Contains($c[0])) { throw "el manifiesto original cambió: no encuentro «$($c[0])»" }
  $texto = $texto.Replace($c[0], $c[1])
}
[IO.File]::WriteAllText($manifiesto, $texto + "`n", (New-Object Text.UTF8Encoding $false))
Write-Host "  manifiesto: Decompilaciones-PaperMario, CN=Decompilaciones, «Paper Mario Decomp», con pantalla de carga"

# 1b. CMakeLists.txt de uwp\: todos los PNG de Assets\ al paquete, en vez de la lista fija de seis del original
$cmakeUwp = Join-Path $Arbol "uwp\CMakeLists.txt"
$cmakeOriginal = (& git -C $Arbol show "HEAD:uwp/CMakeLists.txt") -join "`n"
if ($LASTEXITCODE -ne 0) { throw "no pude leer el CMakeLists.txt original de la rama" }
$glob = '# Decompilaciones (2026-10-02): todos los PNG de Assets\, también los mosaicos del usuario con su versión base y la' + "`n" +
        '# pantalla de carga (identidad-visual.py --aplicar-a, desde pm_empaquetar.ps1).' + "`n" +
        'file(GLOB PKG_ASSETS RELATIVE "${CMAKE_CURRENT_SOURCE_DIR}" "${CMAKE_CURRENT_SOURCE_DIR}/Assets/*.png")'
$cmakeNuevo = [regex]::Replace($cmakeOriginal, 'set\(PKG_ASSETS[^)]*\)', [System.Text.RegularExpressions.MatchEvaluator] { param($m) $glob })
if ($cmakeNuevo -eq $cmakeOriginal) { throw "el CMakeLists.txt original cambió: no encuentro set(PKG_ASSETS ...)" }
[IO.File]::WriteAllText($cmakeUwp, $cmakeNuevo + "`n", (New-Object Text.UTF8Encoding $false))
Write-Host "  CMakeLists.txt de uwp\: Assets\*.png al paquete"

# 1c. El arte del usuario en los mosaicos (Display Images del subproyecto), como en los demás ports propios
$identidad = [IO.Path]::GetFullPath((Join-Path $PSScriptRoot "..\..\..\..\herramientas\identidad-visual.py"))
& py -3.13 -X utf8 $identidad --aplicar-a "Paper Mario" $manifiesto
if ($LASTEXITCODE -ne 0) { throw "falló identidad-visual.py --aplicar-a" }

Write-Host "=== 2. configurar el envoltorio WinRT (version $Version) ==="
& $cmake -S (Join-Path $Arbol "uwp") -B (Join-Path $Arbol "build-uwp") -G "Visual Studio 17 2022" -A x64 `
  "-DPAPERBOAT_BUILD_DIR=$Arbol/build-windows-uwp" "-DPAPERBOAT_PACKAGE_VERSION=$Version"
if ($LASTEXITCODE -ne 0) { throw "falló el configure del envoltorio" }

Write-Host "=== 3. empaquetar y firmar ==="
$salida = "<tree>$Version"
# AppxPackageValidationEnabled=false: la validación del paquete de MSBuild (target _ValidateAppxPackage) exige imágenes de
# 200 KB como máximo (APPX3207, regla de la Tienda) y el arte del usuario a 1240x600 pesa más de 1 MB. Ni
# AppxValidateAppxManifest=false ni SkipAppxManifestValidation=true la apagan: es otro target. La consola en modo
# desarrollador no tiene ese límite: Melee, empaquetado con makeappx, lleva una pantalla de carga de 1,27 MB y se ve
# (2026-10-01).
& $msbuild (Join-Path $Arbol "build-uwp\PaperBoat-UWP.vcxproj") `
  /p:Configuration=Release /p:Platform=x64 `
  /p:AppxBundle=Always /p:AppxBundlePlatforms=x64 `
  /p:UapAppxPackageBuildMode=SideloadOnly `
  /p:AppxPackageValidationEnabled=false `
  /p:AppxPackageSigningEnabled=true `
  /p:PackageCertificateThumbprint=$Huella `
  /p:AppxPackageDir="$salida\\" `
  /verbosity:minimal
if ($LASTEXITCODE -ne 0) { throw "falló el empaquetado" }

Write-Host "=== 4. resultado ==="
Get-ChildItem -LiteralPath $salida -Recurse -File -Include *.msixbundle, *.appxbundle, *.msix, *.appx, *.cer |
  ForEach-Object { "  {0,8:N1} MB  {1}" -f ($_.Length / 1MB), $_.FullName }
