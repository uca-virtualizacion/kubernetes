---
marp: true
title: Entregable 2 (Kubernetes)
description: Asignaturas del grado en Ingeniería Informática 
---

<!-- size: 16:9 -->
<!-- theme: default -->

<!-- paginate: false -->
<!-- headingDivider: 1 -->

<style>
h1 {
  text-align: center;
}
img[alt~="center"] {
  display: block;
  margin: 0 auto;
}
</style>

# Kubernetes + Terraform + SCV (CI) - Entregable

![width:480 center](img/Kubernetes_logo.svg)

---

## Instrucciones 

Deben subirse a la tarea habilitada en el campus virtual un comprimido zip que solo contenga:
- Un archivo con los nombres de los integrantes del grupo y el repositorio GitHub donde se encuentra el código del entregable (asegurarse de que el repositorio es público o que se ha dado acceso al profesor).
- Un video de entre 8 y 15 minutos en calidad media (720p) donde se muestre el funcionamiento de los ejercicios. El video debe incluir la explicación de las configuraciones realizadas en cada fichero y mostrar el correcto funcionamiento de los ejercicios. Pueden realizarse cortes en el video para acelerar partes que no sean relevantes (esperas, instalaciones, etc.)
- Puede aportarse información adicional en el `README.md` si se considera relevante.

---

## Instrucciones 

El repositorio GitHub solo debe contener:
- Un directorio `ejercicio-1` con los ficheros necesarios para el ejercicio 1.
- Un directorio `ejercicio-2` con los ficheros necesarios para el ejercicio 2.
- Un directorio `.github/workflows` con los ficheros necesarios para la integración continua del ejercicio 2.

---

### Ejercicio 1

Despliega una aplicación Drupal + MySQL (imágenes oficiales) en una infraestructura Kubernetes (sin Terraform).

- Usa volúmenes persistentes para almacenar los datos de MySQL y Drupal
  - Para el directorio /var/www/html/sites de Drupal, necesitarás usar initContainers para copiar los archivos de configuración
- Drupal debe ser accesible desde el puerto 8085 del host
- MySQL debe configurarse con las variables de entorno necesarias para su correcto funcionamiento

1) Explicar los ficheros a usar y el proceso completo a llevar a cabo
2) Demostrar el proceso completo de creación del cluster, despliegue de la aplicación y configuración de Drupal
3) Elimina todos los pods y demuestra que los datos persisten

---

### Ejercicio 2 (I)

Despliega una aplicación Matomo + MariaDB (imágenes oficiales) en una infraestructura Kubernetes creada con Terraform y kind.
- Matomo debe ser accesible desde el puerto 8081 del host.
- MariaDB y Matomo deben configurarse con las variables de entorno necesarias para su correcto funcionamiento. Usar variables de Terraform para definir estos valores.
- La imagen de Matomo debe ser personalizada mediante un Dockerfile con las mismas características que el entregable anterior.
  - Esta imagen debe ser construida y subida a Docker Hub automáticamente mediante GitHub Actions al hacer push en la rama `master` del repositorio.
- La persistencia de datos debe estar configurada para ambos servicios (Matomo y MariaDB) y debe mantenerse cuando se destruya la infraestructura Terraform.
- Git debe ignorar los ficheros innecesarios.

---

### Ejercicio 2 (II)

1) Explicar los ficheros a usar y el proceso completo a llevar a cabo
2) Demostrar el proceso de CI mediante GitHub Actions
3) Demostrar la creación de la infraestructura Kubernetes
4) Configurar el contenedor de Matomo:
  - Comprobar que la información del sistema es la indicada desde el Dockerfile (paso 2 de la configuración de Matomo)
  - Continuar con la configuración para comprobar que la información de la base de datos es la indicada desde las variables de entorno y es correcta (pasos 3 y 4)
  - Finalizar la configuración de Matomo
5) Borrar la infraestructura y demostrar que la información persiste.

