resource "kubernetes_deployment" "mariadb" {
  metadata {
    name = "mariadb"
    labels = {
      app = "mariadb"
    }
  }

  spec {

    selector {
      match_labels = {
        app = "mariadb"
      }
    }

    template {
      metadata {
        labels = {
          app = "mariadb"
        }
      }

      spec {
        container {
          name  = "mariadb"
          image = "bitnami/mariadb:latest"

          port {
            container_port = 3306
          }

          env {
            name  = "ALLOW_EMPTY_PASSWORD"
            value = "yes"
          }
          env {
            name  = "MARIADB_USER"
            value = "bn_wordpress"
          }
          env {
            name  = "MARIADB_DATABASE"
            value = "bitnami_wordpress"
          }

          volume_mount {
            name       = "mariadb-storage"
            mount_path = "/bitnami/mariadb"
          }
        }

        volume {
          name = "mariadb-storage"
          persistent_volume_claim {
            claim_name = "mariadb-pvc"
          }
        }
      }
    }
  }
}


resource "kubernetes_service" "service_mariadb" {
  metadata {
    name = "service-mariadb"
    labels = {
      app = "mariadb"
    }
  }

  spec {
    selector = {
      app = "mariadb"
    }

    type = "ClusterIP"

    port {
      name        = "mysql"
      port        = 3306
      target_port = 3306
    }
  }
}