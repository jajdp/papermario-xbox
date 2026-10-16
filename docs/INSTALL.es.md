# Instalación — de la rama del autor al juego en la consola

*(English: [INSTALL.md](INSTALL.md))*

## 0. Dónde se escriben estas órdenes

**PowerShell** para los scripts y el Device Portal; una ventana de **`cmd` con el entorno de
compilación** para CMake. Ningún paso necesita «ejecutar como administrador», y usarlo rompe el
paso de la firma, porque el certificado vive en el almacén de quien ejecuta la orden. El
`-ExecutionPolicy Bypass` de los ejemplos es porque un Windows de fábrica no ejecuta un `.ps1`.

## 1. Clonar la rama del autor

```powershell
git clone --branch uwp-xbox https://github.com/JRickey/PaperBoat.git C:\game
cd C:\game
git submodule update --init --recursive
```

⚠ **El submódulo de Torch apunta a un repositorio que ya no existe**, así que este paso falla. Arregla la URL en `.git/config` — y **no** uses `git submodule sync`, que vuelve a copiar encima la URL rota del `.gitmodules`.

Haz que compile **primero para escritorio**, con tu propia ROM. El proyecto extrae los datos a un
archivo en tu máquina; si eso no funciona, nada de lo que venga después lo hará.

## 2. Aplicar nuestro único cambio y poner tus mosaicos

```powershell
git apply <este repo>\patches\01-package-all-tiles.patch
```

El parche convierte la lista fija de seis nombres de `uwp/CMakeLists.txt` en un glob de `Assets/`.
Sin él, cualquier mosaico cuyo nombre no esté en esa lista simplemente no entra en el paquete, y la
consola enseña la app con un icono por defecto y sin pantalla de carga, sin un error en ninguna
parte.

Tus trece mosaicos van en `uwp/Assets/` ([`ASSETS.es.md`](ASSETS.es.md) tiene las medidas). Este
repositorio no trae ninguno: los de la consola se hicieron con el arte del juego.

## 3. Compilar, empaquetar y firmar

La rama del autor compila el objetivo UWP ella sola; lo que añade nuestro script es el empaquetado
y la firma con **tu** certificado en vez de uno de usar y tirar, para que la consola no tenga que
confiar en un publicador nuevo en cada compilación.

```powershell
powershell -ExecutionPolicy Bypass -File <este repo>\tools\pm_empaquetar.ps1 -Version 0.1.0.0
```

El certificado se crea una vez, en una ventana de PowerShell **normal**:

```powershell
New-SelfSignedCertificate -Type Custom -Subject "CN=<tu nombre>" -KeyUsage DigitalSignature `
  -FriendlyName "<tu nombre> UWP dev" -CertStoreLocation "Cert:\CurrentUser\My" `
  -TextExtension @("2.5.29.37={text}1.3.6.1.5.5.7.3.3", "2.5.29.19={text}")
```

El `Publisher` de `uwp/Package.appxmanifest` tiene que ser **exactamente** ese `-Subject`, con el
`CN=`: la consola compara las dos cadenas literalmente.

⚠ **La versión del paquete tiene que subir en cada ciclo.** La consola no reemplaza un paquete
instalado por otro con la misma versión, y el fallo parece que tu compilación nueva está rota.

## 4. Instalarlo y darle sus datos

Device Portal (`https://<ip de la consola>:11443`, con el usuario y la contraseña de Dev Home):
**Add** → el paquete → con el appx de `Microsoft.VCLibs.140.00` para x64 como dependencia. La
consola necesita **un usuario conectado**, o el paquete se instala y al abrirlo no pasa nada.

Después sube el archivo que produjo la versión de escritorio a `LocalState\boat`, en la carpeta de
datos de la app.

⚠ Dos cosas que cuestan una tarde cada una: la carpeta de datos **no existe hasta que la app ha
corrido una vez**, y los archivos subidos **dentro de un `.zip`** quedan con permisos que el
AppContainer no puede leer. Láncala una vez, ciérrala y sube los archivos de uno en uno.

## 5. Cuando algo sale mal

| Lo que ves | Qué es |
|---|---|
| El clon falla en un submódulo | La URL del submódulo de Torch está muerta; arréglala en `.git/config` |
| La app sale con un icono por defecto y sin pantalla de carga | El parche de los mosaicos no está aplicado (apartado 2) |
| La consola rechaza el paquete | El `Publisher` y el sujeto del certificado no son la misma cadena |
| Instalar «funciona» pero el juego es el viejo | No subió la versión del paquete |
| El juego arranca y no encuentra sus datos | El archivo no está en la carpeta de la app, o se subió dentro de un zip |
