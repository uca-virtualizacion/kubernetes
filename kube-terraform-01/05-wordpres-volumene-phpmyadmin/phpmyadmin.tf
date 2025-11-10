resource "kubernetes_pod_v1" "phpmyadmin" {
  metadata {
    name = "phpmyadmin-pod"
    labels = { app = "phpmyadmin" }
  }
  spec {
    container {
      name  = "phpmyadmin"
      image = "phpmyadmin:5-apache"
      port { container_port = 80 }
      env { 
        name = "PMA_HOST"
        value = "service-mariadb" 
      }
      env {
        name = "PMA_PORT"
        value = "3306"
      }
      env {
        name = "PMA_USER"
        value = "bn_wordpress"
      }
    }
  }
}

resource "kubernetes_service" "phpmyadmin" {
  metadata { name = "service-phpmyadmin" }
  spec {
    selector = { app = "phpmyadmin" }
    type     = "NodePort"
    port {
      name        = "http"
      port        = 80
      target_port = 80
      node_port   = 30002
    }
  }
}