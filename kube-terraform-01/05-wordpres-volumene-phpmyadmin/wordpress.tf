resource "kubernetes_deployment" "wordpress" {
  metadata {
    name = "wordpress"
    labels = {
      app = "wordpress"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "wordpress"
      }
    }

    template {
      metadata {
        labels = {
          app = "wordpress"
        }
      }

      spec {
        container {
          name  = "wordpress"
          image = "bitnami/wordpress:latest"

          port {
            container_port = 8080
          }

          env {
            name  = "ALLOW_EMPTY_PASSWORD"
            value = "yes"
          }
          env {
            name  = "WORDPRESS_DATABASE_USER"
            value = "bn_wordpress"
          }
          env {
            name  = "WORDPRESS_DATABASE_NAME"
            value = "bitnami_wordpress"
          }
          env {
            name  = "WORDPRESS_DATABASE_HOST"
            value = "service-mariadb"
          }

          volume_mount {
            name       = "wordpress-storage"
            mount_path = "/bitnami/wordpress"
          }
        }

        volume {
          name = "wordpress-storage"
          persistent_volume_claim {
            claim_name = "wp-pvc"
          }
        }
      }
    }
  }
}


resource "kubernetes_service" "service_wp" {
  metadata {
    name = "service-wp"
    labels = {
      app = "wordpress"
    }
  }

  spec {
    selector = {
      app = "wordpress"
    }

    type = "NodePort"

    port {
      name        = "http"
      port        = 8080
      target_port = 8080
      node_port   = 30001
    }
  }
}