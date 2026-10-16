# tools/

*(English: [README.md](README.md))*

Dos scripts. `compilar-nativo.cmd` configura y compila el objetivo UWP del autor con los dos apaños que este proyecto necesita (la prueba de compilador de CMake desactivada y `VCPKG_ROOT` repuesto después de que `vcvars` lo mueva). `pm_empaquetar.ps1` genera los mosaicos desde tus propias imágenes, empaqueta con MSBuild y firma con tu certificado.

Cada ruta es un parámetro, y la huella del certificado también: aquí no hay ningún valor que apunte
a la máquina donde se escribieron, ni ninguna huella metida dentro.

El `-Version` tiene que subir en cada ciclo. La consola no reemplaza un paquete instalado por otro
con la misma versión, y el fallo parece que la compilación nueva está rota.
