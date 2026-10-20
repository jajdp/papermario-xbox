# Paper Mario en la Xbox — empaquetar el port UWP

**El port UWP de este juego es del autor, no nuestro.** [JRickey/PaperBoat](https://github.com/JRickey/PaperBoat)
lo lleva en su rama `uwp-xbox`, y funciona. Lo que faltaba era todo lo que va entre esa rama y un
paquete instalado en una consola: cómo compilarlo, cómo meter los mosaicos, cómo firmarlo y qué
hace la consola que un escritorio no hace nunca.

Eso es este repositorio. Es la misma decisión que en `retro-rewind-xbox`: publicar la mitad que es
nuestra y decir claramente que la otra no lo es.

*(English: [README.md](README.md))*

No es una teoría: corrió la intro con DirectX 11 en una Xbox Series X el 2026-10-02, con el archivo o2r de la versión de escritorio en su carpeta de datos.

## En qué consola se probó

**En una Xbox Series X**, en modo desarrollador. Las dos consolas en las que se construyó y se probó esto
son Series X, así que es el único hardware al que se refiere cualquier cosa que se afirme aquí.

**En una Series S no se ha probado nunca, ni una vez.** Es otra máquina: menos memoria disponible para un
juego y una GPU más floja. Puede que funcione en una, puede que vaya más despacio, o puede que no
arranque; nada de aquí se ha medido en ella. Si lo ejecutas en una Series S, lo que obtengas no es lo que
dice este README, y ninguna de las cifras de aquí es una promesa sobre esa consola.

## Qué hay aquí

| | |
|---|---|
| `patches/01-package-all-tiles.patch` | Nuestro único cambio al CMake del autor: la lista de mosaicos era un conjunto fijo de seis nombres, y pasa a ser un glob de toda la carpeta `Assets/`, para que ningún mosaico se quede fuera del paquete en silencio |
| `package/Package.appxmanifest` | El manifiesto tal como quedó, con la identidad en blanco (`CHANGE-ME`) |
| `tools/` | `pm_empaquetar.ps1` y `compilar-nativo.cmd`: compilar, empaquetar, firmar y generar los mosaicos desde tus propias imágenes |
| `docs/` | El paso a paso, en inglés y español, con las trampas del lado de la consola |

## Qué **no** hay

Ninguna ROM, ningún archivo `.o2r`, ningún binario compilado, ningún paquete y **ningún código del
autor** más allá de las seis líneas de contexto que necesita el parche. Ningún arte: los mosaicos de
la consola de verdad se hicieron con el arte del propio juego. Ningún certificado de firma.

## Qué hace falta antes

| | |
|---|---|
| El proyecto del juego | [JRickey/PaperBoat](https://github.com/JRickey/PaperBoat), rama `uwp-xbox` (el commit `2ab7705f` es el que se usó aquí), **compilando y corriendo antes en tu PC** |
| Tu propia ROM | El proyecto extrae sus datos él mismo, en tu máquina |
| Visual Studio | 2022 con la carga de trabajo de C++ para UWP |
| Python 3 | Para generar los mosaicos. Solo biblioteca estándar |
| Una Xbox en modo desarrollador | Y un certificado para firmar ([`docs/INSTALL.es.md`](docs/INSTALL.es.md)) |

## Qué hubo que resolver

Estas son las cosas que costaron tiempo, y ninguna está en el README del autor:

| | Síntoma | Arreglo |
|---|---|---|
| 1 | El submódulo de Torch apunta a un repositorio que ya no existe | Clonar la rama falla ahí. La URL hay que arreglarla en `.git/config` — y **no** con `git submodule sync`, que vuelve a copiar encima la URL rota del `.gitmodules`. |
| 2 | El toolchain de clang-cl del proyecto aborta las pruebas de compilador de CMake | El archivo de toolchain va bien para el juego, pero la prueba que CMake hace antes no lo sobrevive. Se configura una vez con esa prueba desactivada, que es lo que hace `compilar-nativo.cmd`. |
| 3 | `vcvars` reapunta VCPKG_ROOT al vcpkg de Visual Studio | Después de cargar el entorno de compilación, `VCPKG_ROOT` ya no apunta al vcpkg de tu copia y la compilación coge los paquetes equivocados. Se vuelve a poner a mano. |

## Créditos y licencia

El port es de **JRickey/PaperBoat**, bajo CC0-1.0. La receta de empaquetado, las herramientas y esta
documentación son de **Recompilaciones**, bajo la [licencia MIT](LICENSE).

*Paper Mario* es © Nintendo. Este proyecto no está afiliado con ellos, ni con Microsoft, ni con el autor
del port, y no distribuye nada que les pertenezca — ver [`NOTICE.es.md`](NOTICE.es.md). Los
titulares de derechos pueden escribir a **jajdpmail@gmail.com**.
