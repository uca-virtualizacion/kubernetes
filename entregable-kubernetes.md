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

1. Crea un cluster de kind con un mapeo de puertos personalizado que apunte al puerto 8085 de tu máquina local.

2. Despliega una aplicación de Drupal dentro del cluster. 

3. La aplicación Drupal debe conectarse a una base de datos MySQL desplegada en el cluster.

4. Una vez puedas acceder a la aplicación, usa volúmenes persistentes para almacenar los datos de la base de datos y de la aplicación Drupal.

5. Modifica el despliegue de Drupal para que tenga dos réplicas.

6. Utiliza un Vagrantfile para crear una máquina virtual donde puedas crear el cluster de kind con los archivos anteriormente creados.

---

## Instrucciones: Despliegue de aplicaciones en Kubernetes

El entregable consiste en crear un cluster de Kubernetes y desplegar en él una aplicación de Drupal con MySQL. Deben utilizarse archivos de configuración `yaml` para crear los recursos necesarios en Kubernetes.

Deben subirse a la tarea habilitada en el campus virtual los siguientes ficheros:
- Todos los ficheros de configuración usados en la creación y despliegue del cluster
- El archivo Vagrantfile usado para crear la máquina virtual
- Un documento Markdown con una breve explicación de las configuraciones realizadas
- Un video explicativo de entre 6 y 8 minutos en calidad media (720p) donde se explique el funcionamiento del ejercicio. El video debe incluir la explicación de las configuraciones realizadas en cada fichero y mostrar el correcto funcionamiento del cluster
