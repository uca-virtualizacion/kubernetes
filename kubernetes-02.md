---
marp: true
title: Prácticas de Kubernetes 02
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

# KUBERNETES - Parte 2

![width:480 center](img/Kubernetes_logo.svg)

---

<!-- paginate: true -->

## Recordatorio...

![width:800 center](img/kubernetes-cluster-architecture.svg)

---

## Recordatorio...

`kind create cluster` Crear cluster local

`kubectl cluster-info` Información del cluster

`kubectl get nodes` Lista los nodos del cluster

`kind delete cluster` Borrado del cluster

Crear un despliegue de nginx en un cluster: 
`kubectl create deployment web-nginx --image=nginx:alpine`

Listado de despliegues:
`kubectl get deployments`

---

## Recordatorio...

Obtener el nombre del Pod que ejecuta la aplicación:
`kubectl get pods`

Crear proxy para acceder a la aplicación (ejecutar en otra terminal):
`kubectl proxy`

Acceder a la aplicación:
  * Crear proxy para acceder a la aplicación con `kubectl proxy`:
    * [http://localhost:8001/api/v1/namespaces/default/pods/<nombre-del-pod>/proxy/](http://localhost:8001/api/v1/namespaces/default/pods/<nombre-del-pod/proxy/>)
  * Redirigiendo un puerto en la máquina local a un puerto del Pod con `kubectl port-forward <nombre-del-pod> 8080:80`:
    * [http://localhost:8080](http://localhost:8080)

---

## Recordatorio...

Un servicio proporciona una forma constante de acceder a una aplicación.

Crear servicio para despliegue de nginx:
`kubectl expose deployment web-nginx --type=NodePort --port=80`

Podemos ver el puerto asignado al servicio en el campo NodePort mediante:
  * `kubectl describe services/web-nginx` (Información del servicio)
  * `kubectl get services` (Listado de servicios del cluster)

Para asignar puerto específico, usar archivo de configuración.

---

## Recordatorio...

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

`kubectl apply -f [ruta-al-archivo]/[nombre-archivo].yaml`

---

## Recordatorio...

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

`kind create cluster --config [ruta-al-archivo]/cluster-config.yaml`

---

## Recordatorio...

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

---

## Despliegue de una aplicación con IaC

Anteriormente hemos visto cómo crear clusters y servicios usando archivos de configuración `yaml`.

Podemos hacer lo mismo con los despliegues de aplicaciones. Ventajas:

* Definir el estado de la aplicación y facilidad de reproducibilidad
* Versionado y almacenado en un repositorio
* Uso compartido entre usuarios y equipos
* Automatización de la creación de aplicaciones
* Escalabilidad más flexible mediante lenguaje declarativo

---

## Archivo de despliegue (I)

   ```yaml
   apiVersion: apps/v1
   kind: Deployment
   metadata:
     name: web-nginx
   spec:
     selector:
       matchLabels:
         app: web-nginx
     template:
       metadata:
         labels:
           app: web-nginx
       spec:
         containers:
         - name: web-nginx
           image: nginx:mainline-alpine
            ports:
              - containerPort: 80
   ```
---

## Archivo de despliegue (II)

```yaml
   apiVersion: apps/v1
   kind: Deployment
   metadata:
     name: web-nginx
   ```

* El tipo de recurso (Deployment)
* La versión de este tipo de recurso (apps/v1)
* El nombre de este recurso específico (web-nginx)

---

## Archivo de despliegue (III)

```yaml
   spec:
     selector:
       matchLabels:
         app: web-nginx
     template:
       metadata:
         labels:
           app: web-nginx
```

* El campo selector.matchLabels selecciona aquellos Pods con una etiqueta (app:web-nginx) para que pertenezcan a este Deployment
* El template.metadata.labels define una etiqueta (app:web-nginx) para los Pods que envuelven tu contenedor

---

## Archivo de despliegue (IV)

```yaml
     template:
       spec:
         containers:
         - name: web-nginx
            image: nginx:mainline-alpine
            ports:
              - containerPort: 80
   ```

* Un nombre para el contenedor (web-nginx)
* El nombre de la imagen Docker a usar (nginx:mainline-alpine)
* Puerto en el que exponemos el contenedor (80)

---

## Archivo de despliegue (V)

Despliega la aplicación en el cluster:

```bash
kubectl apply -f [ruta-al-archivo]/nginx.yaml
```

```bash
kubectl get pods
```

---

## Archivo de despliegue (VI)

Vamos a modificar el archivo de despliegue para añadir un servicio que exponga la aplicación.

Basta con añadir el símbolo `---` entre el despliegue y el servicio:

   ```yaml
   kind: Deployment
   ...
   ---
   kind: Service
   ...
   ```

```bash
kubectl apply -f [ruta-al-archivo]/nginx.yaml
kubectl get kubectl get deploy,svc,pod
```
[http://localhost:8080](http://localhost:8080)

---

## Escalado de la aplicación (I)

Escalar un Despliegue garantizará que se creen nuevos Pods y se programen en Nodos con recursos disponibles.
La escalabilidad se logra cambiando el número de réplicas en un Despliegue.

![width:420 center](img/kubernetes_escalado_01.png)

---

## Escalado de la aplicación (II)

Comprobamos el número de pods y despliegues:

```bash
kubectl get deploy,svc,pod
```

Escala el deployment para tener 2 réplicas:

```bash
kubectl scale deployment web-nginx --replicas=2
```

Si volvemos a comprobar el número de pods y despliegues, veremos que ahora tenemos dos en vez de uno.

---

## Escalado de la aplicación (III)

Al igual que hemos hecho anteriormente, podemos escalar un deployment usando un archivo de configuración:

```yaml
   apiVersion: apps/v1
   kind: Deployment
   metadata:
     name: web-nginx
   spec:
     replicas: 4
     ...
```
  
```bash
  kubectl apply -f [ruta-al-archivo]/nginx.yaml
```

Si probamos a borrar manualmente uno de los pods, inmediatamente se creará otro para mantener el número de réplicas.

En un entorno de producción, esto proporcionará una alta disponibilidad de la aplicación.

---

## Varias aplicaciones

Hasta ahora, sólo hemos desplegado una aplicación en el cluster.

Lo más probable es que en un sistema real necesitemos desplegar varias aplicaciones: backend, base de datos, etc.

A continuación vamos a crear tres archivos de configuración: la configuración del cluster, Wordpress y MariaDB.

```yaml
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
- role: control-plane
  extraPortMappings:
  - containerPort: 30001
    hostPort: 8081
    protocol: TCP
```

---

## Varias aplicaciones (Despliegue de Wordpress I)

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: wordpress
spec:
  selector:
    matchLabels:
      app: wordpress
  template:
    metadata:
      labels:
        app: wordpress
    spec:
      containers:
        - name: wordpress
          image: bitnami/wordpress:latest
          ports:
            - containerPort: 8080
```

---

## Varias aplicaciones (Despliegue de Wordpress II)

```yaml
    spec:
      containers:
        ...
          env:
            - name: ALLOW_EMPTY_PASSWORD
              value: 'yes'
            - name: WORDPRESS_DATABASE_USER
              value: 'bn_wordpress'
            - name: WORDPRESS_DATABASE_NAME
              value: 'bitnami_wordpress'
            - name: WORDPRESS_DATABASE_HOST
              value: 'service-mariadb' # Nombre del servicio de MariaDB
```

* El campo env define las variables de entorno que se usarán en el contenedor.
* Estas variables están definidas en la imagen de Docker que vamos a usar: [https://hub.docker.com/r/bitnami/wordpress](https://hub.docker.com/r/bitnami/wordpress)

---

## Varias aplicaciones (Servicio de WordPress)

```yaml
apiVersion: v1
kind: Service
metadata:
  name: service-wp
spec:
  type: NodePort
  selector:
    app: wordpress
  ports:
    - name: http
      port: 8080 # Puerto por defecto de Wordpress
      nodePort: 30001
```
---

## Varias aplicaciones (Despliegue de MariaDB I)

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: mariadb
spec:
  selector:
    matchLabels:
      app: mariadb
  template:
    metadata:
      labels:
        app: mariadb
    spec:
      containers:
        - name: mariadb
          image: bitnami/mariadb:latest
          ports:
            - containerPort: 3306
```
---

## Varias aplicaciones (Despliegue de MariaDB II)

```yaml
    spec:
      containers:
        ...
          env:
            - name: ALLOW_EMPTY_PASSWORD
              value: 'yes'
            - name: MARIADB_USER
              value: 'bn_wordpress'
            - name: MARIADB_DATABASE
              value: 'bitnami_wordpress'
```

* Estas variables están definidas en la imagen de Docker que vamos a usar: [https://hub.docker.com/r/bitnami/mariadb](https://hub.docker.com/r/bitnami/mariadb)

---

## Varias aplicaciones (Servicio de MariaDB)

```yaml
apiVersion: v1
kind: Service
metadata:
  name: service-mariadb
spec:
  type: ClusterIP
  selector:
    app: mariadb
  ports:
    - name: http
      port: 3306
      targetPort: 3306
```

* El tipo de servicio ClusterIP sólo es accesible desde dentro del clúster, utilizando esta dirección IP virtual y el puerto especificado
* Este enfoque es adecuado si no necesitas exponer el servicio públicamente

---

## Varias aplicaciones

```bash
kind create cluster --config [ruta-al-archivo]/cluster-config-wp.yaml
kubectl apply -f [ruta-al-archivo]/wordpress.yaml
kubectl apply -f [ruta-al-archivo]/mariadb.yaml
```

Veamos nuestros servicios, despliegues y pods:
```bash
kubectl get svc,deploy,pod
```

Si accedemos a la ruta [http://localhost:8081](http://localhost:8081) veremos que tenemos Wordpress funcionando.

---

## Volúmenes persistentes

Si queremos desplegar una aplicación que requiera almacenamiento persistente, necesitaremos usar volúmenes persistentes:
  * Los volúmenes son directorios que se montan en los contenedores de los Pods
  * Los volúmenes se pueden usar para almacenar datos que deben sobrevivir a la vida del Pod

Si probamos a borrar el Pod de MariaDB, veremos que se crea uno nuevo, pero la aplicación no funciona o se habrá perdido la información:

```bash
kubectl delete pod mariadb-<id-pod>
```

---

## Volúmenes persistentes (Crear volumen persistente)

```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: mariadb-pvc-claim
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 256Mi
```
* PersistentVolumeClaim indica que es un recurso de tipo volumen persistente
* El campo metadata.name define el nombre del volumen persistente
* El campo spec.accessModes define los modos de acceso al volumen
* El campo spec.resources.requests.storage define el tamaño del volumen

---

## Volúmenes persistentes (Modificación de MariaDB)

```yaml
...
spec:
...
    spec:
      containers:
        ...
          volumeMounts:
            - name: mariadb-persistent-storage
              mountPath: /bitnami/mariadb
```
* spec.containers.volumeMounts.name define el nombre del volumen
* spec.containers.volumeMounts.mountPath especifica que este volumen se montará en el directorio /bitnami/mariadb dentro del contenedor

---

## Volúmenes persistentes (Modificación de MariaDB)

```yaml
...
    spec:
      containers:
        ...
          volumeMounts:
            ...
      volumes:
        - name: mariadb-persistent-storage
          persistentVolumeClaim:
            claimName: mariadb-pvc-claim
```
* spec.volumes.name define el nombre del volumen
* spec.volumes.persistentVolumeClaim.claimName define el nombre que se utilizará para solicitar un volumen persistente del cluster de Kubernetes

Ahora podemos hacer la prueba de borrar el pod de MariaDB y ver que la aplicación sigue funcionando (previamente borrar el pod de Wordpress).