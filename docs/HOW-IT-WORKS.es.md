# Cómo funciona

*(English: [HOW-IT-WORKS.md](HOW-IT-WORKS.md))*

## De quién es cada parte

El objetivo UWP —el punto de entrada de WinRT, la ventana, el backend que dibuja en una consola— es
del autor, en la rama `uwp-xbox` de [JRickey/PaperBoat](https://github.com/JRickey/PaperBoat). Leer esa rama es
cómo se aprende cómo funciona el port, y este repositorio no lo duplica.

Lo que faltaba, y lo que hay aquí, es el camino de esa rama a un paquete firmado en una consola: la
invocación de compilación que sobrevive al toolchain de este proyecto, que los mosaicos entren de
verdad en el paquete, la firma con un certificado en el que la consola ya confía, y el puñado de
comportamientos de la consola que parecen fallos de tu compilación y no lo son.

## El único cambio de código

El `uwp/CMakeLists.txt` del autor lista por nombre los mosaicos que entran en el paquete: seis.
Cualquier mosaico que añadas más allá de esos seis no se empaqueta, y nada te avisa: la consola
enseña un icono por defecto y ninguna pantalla de carga. El parche sustituye esa lista por un glob
de `Assets/`.

Son tres líneas. También son la diferencia entre un paquete que parece un juego y uno que parece
una carga lateral rota, que es por lo que es el cambio que merece publicarse.

## Lo que hace la consola y no hace un escritorio

- **No reemplaza un paquete por otro de la misma versión.** Cada ciclo necesita un número de
  versión nuevo, o instalas y ejecutas la compilación vieja creyendo que has probado la nueva.
- **La carpeta de datos de la app no existe hasta que la app ha corrido una vez.** Subir algo antes
  falla con «cannot find the path».
- **Los archivos subidos dentro de un `.zip` no se pueden leer.** Extraídos por el Device Portal
  quedan con permisos que el AppContainer no abre, y el juego se comporta como si los datos no
  estuvieran.
- **Sin usuario conectado, un paquete se instala y luego no hace nada.** Este se parece exactamente
  a un paquete roto.

**El submódulo de Torch apunta a un repositorio que ya no existe.** Clonar la rama falla ahí. La URL hay que arreglarla en `.git/config` — y **no** con `git submodule sync`, que vuelve a copiar encima la URL rota del `.gitmodules`.

**El toolchain de clang-cl del proyecto aborta las pruebas de compilador de CMake.** El archivo de toolchain va bien para el juego, pero la prueba que CMake hace antes no lo sobrevive. Se configura una vez con esa prueba desactivada, que es lo que hace `compilar-nativo.cmd`.

**`vcvars` reapunta VCPKG_ROOT al vcpkg de Visual Studio.** Después de cargar el entorno de compilación, `VCPKG_ROOT` ya no apunta al vcpkg de tu copia y la compilación coge los paquetes equivocados. Se vuelve a poner a mano.

## Cómo se verificó esto

El paquete construido así lleva corriendo en una consola desde el 2026-10-02: corrió la intro con DirectX 11 en una Xbox Series X el 2026-10-02, con el archivo o2r de la versión de escritorio en su carpeta de datos.

Lo que publica este repositorio es la receta y las herramientas, y las dos se releyeron y sanearon
antes de publicarlas: ninguna ruta de la máquina donde se escribieron, ninguna huella de
certificado (ahora es un parámetro) y ningún arte.

Lo que **no** se vuelve a medir aquí es una reconstrucción desde un clon limpio, porque el port es
del autor y su compilación necesita el toolchain completo del proyecto. La afirmación es estrecha a
propósito.
