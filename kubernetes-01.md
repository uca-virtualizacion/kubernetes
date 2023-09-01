---
marp: true
title: Prácticas de Kubernetes
description: Asignatura de Virtualización de Sistemas
---

<!-- size: 16:9 -->
<!-- theme: default -->

<!-- paginate: skip -->
<!-- headingDivider: 1 -->

<style>
h1 {
  text-align: center;
  color: #005877;
}
h2 {
  color: #E87B00;
}
h3 {
  color: #005877;
}

img[alt~="center"] {
  display: block;
  margin: 0 auto;
}
</style>

# KUBERNETES

![width:480 center](img/Kubernetes_logo.svg)

---

<!-- paginate: true -->

## ¿Qué es Kubernetes?

### Algunas definiciones:

1. **k8s**
2. **Orquestador de contenedores**
3. **Pod**
4. **Servicio (Service)**

---

### 1. k8s

Plataforma código abierto, conocida como k8s, para automatizar la implementación, el escalado y la administración de aplicaciones en contenedores.

### 2. Orquestador de contenedores

Kubernetes agrupa los contenedores que conforman una aplicación en unidades lógicas para una fácil administración y descubrimiento.

---

### 3. Pod

Un pod es la unidad más pequeña y básica en Kubernetes.

Representa un único proceso o conjunto de procesos que comparten el mismo espacio de red y almacenamiento.

Los pods son a menudo utilizados para agrupar contenedores relacionados y se ejecutan en el mismo nodo.

---

### 4. Servicio (Service)

Un servicio en Kubernetes es una abstracción que define una política de acceso a un conjunto de pods.

Proporciona una forma constante de acceder a una aplicación, independientemente de los cambios en la ubicación o el escalado de los pods.

Los servicios pueden ser expuestos internamente en el cluster o de manera externa, permitiendo la comunicación entre diferentes componentes de la aplicación.

---

## Introducción de kind

![width:480 center](img/kind_logo.png)

kind (Kubernetes in Docker) es una herramienta que nos permite crear clusters de Kubernetes utilizando contenedores Docker para cada nodo.

---

## Instalación de kind

[Guía de instalación](https://kind.sigs.k8s.io/docs/user/quick-start/#installation)

Hay varias formas de instalar kind en cada Sistema Operativo, a continuación mostraremos un ejemplo en MacOs y Windows.

---

### Instalación de kind (MacOS)

1. Instala Homebrew (si aún no lo has hecho):

   ```bash
   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
   ```

2. Instala kind:

   ```bash
   brew install kind
   ```

3. Verifica que kind se haya instalado correctamente:

   ```bash
   kind version
   ```

---

### Instalación de kind (Windows)

1. Abre PowerShell como administrador.

2. Instala Chocolatey (si aún no lo has hecho):

   ```powershell
   Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
   ```

3. Instala kind:

   ```powershell
   choco install kind
   ```

4. Verifica que kind se haya instalado correctamente:

   ```powershell
   kind version
   ```

---

## Creación de un cluster

```
kind create cluster
```

Esto creará un cluster llamado kind. Podemos personalizar el nombre usando el flag --name:

```
kind create cluster --name kind-2
```

---

## Exploración del cluster

Mediante un listado de contenedores podemos observar que el servidor de kubernetes se ha desplegado dentro de un contenedor de docker:

   ```bash
   docker ps
   ```

1. Verifica que el cluster está en funcionamiento:

   ```bash
   kubectl cluster-info
   ```

   ```bash
   kubectl cluster-info kind-kind2
   ```

2. Lista los nodos del cluster:

   ```bash
   kubectl get nodes
   ```

---
## Contextos de Kubernetes

En caso de tener varios clusteres:

1. Ver los contextos disponibles en tu configuración de Kubernetes:

   ```bash
    kubectl config get-contexts
   ```

2. Cambiar al contexto del cluster que deseas inspeccionar:

   ```bash
    kubectl config use-context <nombre-del-contexto>
   ```

3. Listar nodos del cluster seleccionado:

   ```bash
   kubectl get nodes
   ```
---

## Borrado del cluster

   ```bash
   kind delete cluster
   ```

   ```bash
   kind delete cluster --name=kind2
   ```

Comprobamos que ya no existen los contenedores:

   ```bash
   docker ps
   ```

---

## Roles de los Nodos

En un cluster de kind, los nodos pueden tener diferentes roles:

1. **Control-plane**: Este nodo actúa como el "cerebro" del cluster. Se encarga de administrar la orquestación y la comunicación en el cluster.

2. **Worker**: Estos nodos ejecutan las cargas de trabajo de las aplicaciones. Son responsables de alojar y ejecutar los contenedores que componen las aplicaciones.

Esta separación de responsabilidades permite una administración más eficiente del cluster de Kubernetes.

---

## Creación de un cluster mediante archivo de configuración (I)

Crea un archivo `cluster-config.yaml` con el siguiente contenido:

```yaml
kind: cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
- role: control-plane
  extraPortMappings:
  - containerPort: 30080
    hostPort: 30070
    protocol: TCP
- role: worker
```
---

## Creación de un cluster mediante archivo de configuración (II)

```yaml
kind: cluster
apiVersion: kind.x-k8s.io/v1alpha4
```

* Tipo de archivo de configuración (Cluster)
* Versión de la API de Kubernetes a utilizar

---

## Creación de un cluster mediante archivo de configuración (III)

```yaml
nodes:
- role: control-plane
  extraPortMappings:
  - containerPort: 30080
    hostPort: 30070
    protocol: TCP
- role: worker
```

* Se indican los nodos que contiene el cluster
* Mapeamos el puerto de dentro del cluster (30080) al puerto 30070 de nuestro host.

---

## Creación de un cluster mediante archivo de configuración (IV)

Ejecuta el siguiente comando para crear un cluster. Reemplaza `[ruta-al-archivo]` con la ruta real al archivo `cluster-config.yaml`:

```bash
kind create cluster --config [ruta-al-archivo]/cluster-config.yaml
```

```bash
kubectl get nodes
```
A diferencia de antes, ahora visualizamos 2 nodos (1 control-plane y 1 worker)

---

## Despliegue de una aplicación

Vamos a desplegar una aplicación en nuestro cluster de Kubernetes.

Para ello, vamos a utilizar un archivo yaml que contendrá la información necesaria para que Kubernetes sepa qué queremos desplegar.

---

### Archivo de despliegue (I)

1. Crea un archivo `nginx.yaml` con un deployment de nginx:

   ```yaml
   apiVersion: apps/v1
   kind: Deployment
   metadata:
     name: nginx-deployment
   spec:
     replicas: 1
     selector:
       matchLabels:
         app: nginx
     template:
       metadata:
         labels:
           app: nginx
       spec:
         containers:
         - name: nginx
           image: nginx:mainline-alpine
            ports:
              - containerPort: 30080
   ```
---

### Archivo de despliegue (II)

```yaml
   apiVersion: apps/v1
   kind: Deployment
   metadata:
     name: nginx-deployment
   ```

* El tipo de recurso (Deployment)
* La versión de este tipo de recurso (apps/v1)
* El nombre de este recurso específico (knote)

---

### Archivo de despliegue (III)

```yaml
   spec:
     replicas: 1
   ```

Una única réplica: lógico, ya que cuando creamos el cluster sólo un node de rol worker, le estamos diciendo que sólo tendrá un Pod y por tanto está preparado para desplegar una única réplica.

---

### Archivo de despliegue (IV)

```yaml
   spec:
     selector:
       matchLabels:
         app: nginx
     template:
       metadata:
         labels:
           app: nginx
```

* El template.metadata.labels define una etiqueta (app:nginx) para los Pods que envuelven tu contenedor
* El campo selector.matchLabels selecciona aquellos Pods con una etiqueta (app:nginx) para que pertenezcan a este Deployment

---

### Archivo de despliegue (V)

```yaml
     template:
       spec:
         containers:
         - name: nginx
            image: nginx:mainline-alpine
            ports:
              - containerPort: 30080
   ```

* Un nombre para el contenedor (nginx)
* El nombre de la imagen Docker a usar (nginx:mainline-alpine)
* Puerto en el que exponemos el contenedor (30080)

---

### Comando para desplegar

Despliega la aplicación en el cluster:

   ```bash
   kubectl apply -f [ruta-al-archivo]/nginx-deployment.yaml
   ```

   ```bash
   kubectl get pods
   ```

---

## Crear Servicio para un despliegue

Un Despliegue (Deployment) define cómo ejecutar una aplicación en el cluster pero no la pone a disposición de otras aplicaciones.

Para exponer tu aplicación, necesitas un Servicio (Service).

Vamos a añadir una definición de recurso al archivo yaml que hemos creado para el despliegue.

---

### Añadir Servicio (I)

Añade un servicio como el siguiente al principio del archivo `nginx.yaml`.

```yaml
apiVersion: v1
kind: Service
metadata:
  name: web-nginx
spec:
  type: NodePort
  ports:
    - name: http
      port: 80
      nodePort: 30080
  selector:
    app: web-nginx
--- # Separa el servicio y el depliegue con ---
```

---

### Añadir Servicio (II)

```yaml
spec:
  selector:
    app: web-nginx
```

El Servicio (Service) selecciona los Pods que se expondrán en función de sus etiquetas, que deben coincidir con las especificadas para los Pods en el recurso de Despliegue.

Esto se indicó anteriomente en el campo template.metadata.labels del deployment.

---

### Añadir Servicio (III)

```yaml
spec:
  type: NodePort
  ports:
    - name: http
      port: 80
      nodePort: 30080
```

En este caso, el Servicio (Service) escucha las solicitudes en el puerto 80 y las reenvía al puerto 30080 de los Pods de destino

---

### Comando para desplegar

Recarga la configuración en el cluster:

```bash
  kubectl apply -f [ruta-al-archivo]/nginx-deployment.yaml
 ```

Prueba a acceder a la aplicación mediante los puertos indicados anteriormente: [127.0.0.1:30070](127.0.0.1:30070)

---

## Escalado de la aplicación

1. Escala el deployment para tener 2 réplicas:

   ```bash
   kubectl scale deployment web-nginx --replicas=2
   ```

---

2. Verifica que se haya creado el nuevo pod:

   ```bash
   kubectl get pods
   ```

   ```bash
   docker ps
   ```

   Sin embargo, sólo uno será accesible ya que no hemos expuesto los puertos para el segundo Pod.

---

## Tarea Adicional

1. Crea un nuevo archivo llamado `wordpress-deployment.yaml` que defina un deployment de WordPress en Kubernetes. Asegúrate de incluir configuraciones como volúmenes persistentes y variables de entorno necesarias para que la aplicación funcione correctamente.

2. Despliega el archivo `wordpress-deployment.yaml` en el cluster de kind que has creado previamente.

3. Configura un servicio para el deployment de WordPress de manera que puedas acceder a la aplicación desde tu navegador.

4. Realiza pruebas para asegurarte de que la aplicación de WordPress se ejecuta correctamente en el cluster local.
