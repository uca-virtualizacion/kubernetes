---
marp: true
title: Prácticas de Kubernetes 01
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

# KUBERNETES - Parte 1

![width:480 center](img/Kubernetes_logo.svg)

---

<!-- paginate: true -->

## ¿Qué es Kubernetes?

### Algunas definiciones:

1. **k8s**
2. **Pod**

---

### 1. k8s

Kubernetes es una plataforma de código abierto, conocida como k8s, para automatizar la implementación, el escalado y la administración de aplicaciones en contenedores.

### 2. Pod

Un pod es la unidad más pequeña y básica en Kubernetes.

Representa un único proceso o conjunto de procesos que comparten el mismo espacio de red y almacenamiento.

Los pods son a menudo utilizados para agrupar contenedores relacionados y se ejecutan en el mismo nodo.

---

## Introducción de kind

![width:480 center](img/kind_logo.png)

kind (Kubernetes in Docker) es una herramienta que nos permite crear clusters de Kubernetes utilizando contenedores Docker para cada nodo.

---

## Instalación de kind

[Guía de instalación](https://kind.sigs.k8s.io/docs/user/quick-start/#installation)

Hay varias formas de instalar kind en cada Sistema Operativo, a continuación mostraremos un ejemplo en Linux, MacOs y Windows.

---

### Instalación de kind (Linux)

```bash
# For AMD64 / x86_64
[ $(uname -m) = x86_64 ] && curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.20.0/kind-linux-amd64
# For ARM64
[ $(uname -m) = aarch64 ] && curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.20.0/kind-linux-arm64
chmod +x ./kind
sudo mv ./kind /usr/local/bin/kind
```

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
   Set-ExecutionPolicy Bypass `
     -Scope Process `
     -Force `
   [System.Net.ServicePointManager]::SecurityProtocol = `
     [System.Net.ServicePointManager]::SecurityProtocol `
     -bor 3072 `
   iex ((New-Object `
     System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
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

## Exploración del cluster (I)

Mediante un listado de contenedores podemos observar que el servidor de kubernetes se ha desplegado dentro de un contenedor de docker:

   ```bash
   docker ps
   ```

kubectl es la interfaz de línea de comandos de Kubernetes.

Utiliza la API de Kubernetes para interactuar con el clúster.

---

## Exploración del cluster (II)

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

## Despliegue (I)

Una vez tenemos un cluster de Kubernetes en funcionamiento, podemos desplegar aplicaciones en él [https://kubernetes.io/docs/](https://kubernetes.io/docs/)

![width:600 center](img/kubernetes_nodes_01.png)

---

## Despliegue (II)

Crear un Despliegue (Deployment) en Kubernetes permite programar la ejecución de aplicaciones contenerizadas en el clúster.

```bash
kubectl create deployment
```
Necesitamos proporcionar el nombre del despliegue y la imagen de la aplicación.

```bash
kubectl create deployment web-nginx --image=nginx:alpine
```
---

## Despliegue (III)

¿Qué ha hecho el comando anterior?:

1. Buscar un nodo donde ejecutar una instancia de la aplicación (actualmente sólo tenemos 1 nodo disponible)
2. Programar la ejecución de la aplicación en ese nodo
3. Configurar el cluster para reprogramar la instancia en un nuevo nodo cuando fuera necesario

Verificar despliegue:

   ```bash
   kubectl get deployments
   ```

---

## Visualización de la aplicación (I)

Los Pods que se ejecutan dentro de Kubernetes funcionan en una red privada y aislada.

Por defecto, son visibles desde otros Pods y servicios dentro del mismo cluster de Kubernetes, pero no fuera de esa red.

Cuando usamos kubectl, estamos interactuando a través de un acceso de la API para comunicarnos con nuestra aplicación.

Para acceder a la aplicación, necesitamos exponerla fuera de la red privada del cluster:

   ```bash
   kubectl proxy
   ```

El proxy reenviará las comunicaciones a la red privada del cluster. Debe abrirse en otra terminal y puede detenerse presionando control-C.

---

## Visualización de la aplicación (II)

El servidor de API crea un punto de acceso para cada pod basado en su nombre, accesible mediante el proxy.

Obtener el nombre del Pod que ejecuta la aplicación:

   ```bash
   kubectl get pods
   ```

Puedes acceder al Pod a través de la API proxy accediendo a la siguiente URL:

[http://localhost:8001/api/v1/namespaces/default/pods/<nombre-del-pod>](http://localhost:8001/api/v1/namespaces/default/pods/<nombre-del-pod>)

[http://localhost:8001/api/v1/namespaces/default/pods/<nombre-del-pod>/proxy/](http://localhost:8001/api/v1/namespaces/default/pods/<nombre-del-pod/proxy/>)

---

## Visualización de la aplicación (III)

También podemos acceder a la aplicación redirigiendo un puerto en la máquina local a un puerto del Pod:

```bash
   kubectl port-forward <nombre-del-pod> 8080:80
   ```

---

## Servicios (Services) (I)

Un servicio en Kubernetes es una abstracción que define una política de acceso a un conjunto de pods.

Proporciona una forma constante de acceder a una aplicación, independientemente de los cambios en la ubicación o el escalado de los pods.

Los servicios pueden ser expuestos internamente en el cluster o de manera externa, permitiendo la comunicación entre diferentes componentes de la aplicación.

---

## Servicios (Services) (II)

Listar servicios actuales:

   ```bash
   kubectl get services
   ```

Por defecto se crea un servicio llamado kubernetes que permite acceder a la API del cluster.

---

## Servicios (Services) (III)

Para crear un nuevo servicio y exponerlo al tráfico externo, utilizaremos el comando "expose" con "NodePort" como parámetro.

```bash
   kubectl expose deployment web-nginx --type=NodePort --port=80
```

Podemos ver el puerto asignado al servicio en el campo NodePort mediante el comando:
```bash
   kubectl describe services/web-nginx
```

```bash
   kubectl get services
```

---

## Servicios (Services) (IV)

Por defecto, Kubernetes asigna un puerto aleatorio entre 30000 y 32767 para cada servicio.

Si quieremos asignar un NodePort específico, tendremos que hacerlo mediante un archivo de configuración:

```yaml
apiVersion: v1
kind: Service
metadata:
  name: service-nginx
spec:
  type: NodePort
  ports:
    - name: http
      port: 80
      nodePort: 30080
  selector:
    app: web-nginx
```

---

## Servicios (Services) (V)

```yaml
spec:
  selector:
    app: web-nginx
```

* El Servicio (Service) selecciona los Pods que se expondrán en función de sus etiquetas.
* Deben coincidir con las especificadas para los Pods en el recurso de Despliegue (en nuestro caso web-nginx).

---

## Servicios (Services) (VI)

```yaml
spec:
  type: NodePort
  ports:
    - name: http
      port: 80
      nodePort: 30080
```

En este caso, el Servicio (Service) escucha las solicitudes en el puerto 80 y las reenvía al puerto 30080 de los Pods de destino.

---

### Comando para aplicar la configuración del servicio:

Recarga la configuración en el cluster:

```bash
kubectl apply -f [ruta-al-archivo]/[nombre-archivo].yaml
 ```

```bash
kubectl get services
```
---

## Mapeo de puertos del cluster (I)

El mapeo de puertos de un cluster permite acceder a los servicios de un Pod desde fuera del cluster.

Usando un archivo de configuración, podemos crear un cluster con un mapeo de puertos personalizado:

```yaml
kind: cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
- role: control-plane
  extraPortMappings:
  - containerPort: 30080
    hostPort: 8080
    protocol: TCP
```

---

## Mapeo de puertos (II)

```yaml
kind: cluster
apiVersion: kind.x-k8s.io/v1alpha4
```

* Tipo de archivo de configuración (Cluster)
* Versión de la API de Kubernetes a utilizar

---

## Mapeo de puertos (III)

```yaml
nodes:
- role: control-plane
  extraPortMappings:
  - containerPort: 30080
    hostPort: 8080
    protocol: TCP
```

* Se indican los nodos que contiene el cluster
* Mapeamos el puerto de dentro del cluster (30080) al puerto 8080 de nuestro host.

---

## Mapeo de puertos (IV)

Podremos crear el nuevo cluster aplicando la configuración anterior mediante el comando:

```bash
kind create cluster --config [ruta-al-archivo]/[nombre-archivo.yaml]
```

Repetimos los pasos anteriores para desplegar la aplicación y crear el servicio.

```bash
kubectl create deployment web-nginx --image=nginx:alpine
```

```bash
kubectl apply -f [ruta-al-archivo]/[nombre-archivo].yaml
```

Prueba a acceder a la aplicación mediante los puertos indicados anteriormente: [127.0.0.1:8080](127.0.0.1:8080)

---

## Tarea Adicional

1. Crea un cluster de kind con un mapeo de puertos personalizado que apunte al puerto 80 de tu máquina local.

2. Crea un despliegue en el cluster para ejecutar la aplicación de Apache.

3. Configura un servicio para el deployment de Apache de manera que puedas acceder a la aplicación desde tu navegador a través del puerto 80.

4. Realiza pruebas para asegurarte de que se abre la página de Apache.
