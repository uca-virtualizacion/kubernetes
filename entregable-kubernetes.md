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

# Kubernetes - Entregable

![width:480 center](img/Kubernetes_logo.svg)

---

## Ejercicio

1. Utiliza un Vagrantfile para crear una máquina virtual donde puedas crear el cluster de kind con los archivos anteriormente creados:
- El Vagrantfile debe aprovisionar la instalación de docker
- Las de kind y kubectl pueden realizarse manualmente

2. Crea un cluster de kind con un mapeo de puertos que apunte al puerto 8085 de tu máquina local

---

3. Despliega una aplicación de Drupal dentro del cluster:
- Usa la [imagen oficial](https://hub.docker.com/_/drupal) más reciente
- Usa una base de datos MySQL desplegada en el cluster (usa la imagen oficial)
- Usa volúmenes persistentes para almacenar los datos de MySQL y Drupal
  - En la documentación de la imagen de Drupal se indica los directorios donde se almacenan los datos
  - Para el directorio /var/www/html/sites de Drupal, necesitarás usar initContainers para copiar los archivos de configuración

4. Elimina todos los pods y demuestra que los datos persisten

---

## Instrucciones: Despliegue de aplicaciones en Kubernetes

El entregable consiste en crear un cluster de Kubernetes y desplegar en él una aplicación de Drupal con MySQL. Deben utilizarse archivos de configuración `yaml` para crear los recursos necesarios en Kubernetes.

Deben subirse a la tarea habilitada en el campus virtual los siguientes ficheros:
- Todos los ficheros de configuración usados en la creación y despliegue del cluster
- El archivo Vagrantfile usado para crear la máquina virtual
- Un documento Markdown con una breve explicación de las configuraciones realizadas
- Un video explicativo de entre 6 y 8 minutos en calidad media (720p) donde se explique el funcionamiento del ejercicio. El video debe incluir la explicación de las configuraciones realizadas en cada fichero y mostrar el correcto funcionamiento del cluster
