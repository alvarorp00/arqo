# ARQUITECTURA - PRÁCTICA 4

Autores:
  - Álvaro Rodríguez Palacios
  - Javier Romera Llave


## Sobre el desarrollo de la práctica

La práctica será desarrollada en un directorio local, pero las pruebas se ejecutarán en el cluster, por lo que a continuación expondremos - como se pide en el _ejercicio 0_ - la información relativa a la arquitectura de la máquina con la que estamos trabajando.

## Ejercicio 0

Para ello, ejecutamos:

  ```
  cat /proc/cpuinfo
  ```

Y de ahí, podemos observar que el nodo del cluster en el que estamos trabajando
tiene las siguientes características:

  - Procesador AMD Opteron 6128
    - 8 cores con hyperthreading activado
    - 8 threads por defecto, 16 con hyperthreading
    - 3 niveles de Caché:
      - Caché L1:
        - 8 x 64 KB Asociativa de 2 vías INSTRUCCIONES
        - 8 x 64 KB Asociativa de 2 vías DATOS
      - Caché L2:
        - 8 x 512 KB Asociativa de 16 vías Exclusive
      - Caché L3:
        - 2 x 6 MB compartida Exclusive
    - TLB de 1024 entradas con páginas de 4KB
    - 48 bits direccionamiento físico
    - 48 bits direccionamiento virtual

## Ejercicio 1

