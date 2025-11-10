resource "kubernetes_deployment" "matomo" {
  metadata {
    name = "matomo"
    labels = { app = "matomo" }
  }

  spec {
    replicas = 1

    selector { match_labels = { app = "matomo" } }

    template {
      metadata { labels = { app = "matomo" } }

      spec {
        container {
          name  = "matomo"
          image = "matomo:apache"

          port { container_port = 80 }

          env {
            name = "MATOMO_DATABASE_HOST"
            value = "service-mariadb"
          }
          env {
            name = "MATOMO_DATABASE_ADAPTER"
            value = "mysql"
          }
          env {
            name = "MATOMO_DATABASE_TABLES_PREFIX"
            value = "mtm_"
          }
          env {
            name = "MATOMO_DATABASE_USERNAME"
            value = "matomo"
          }
          env {
            name = "MATOMO_DATABASE_PASSWORD"
            value = "matomo123"
          }
          env {
            name = "MATOMO_DATABASE_DBNAME"
            value = "matomo"
          }

          volume_mount {
            name       = "matomo-storage"
            mount_path = "/var/www/html"
          }
        }

        volume {
          name = "matomo-storage"
          persistent_volume_claim {
            claim_name = "matomo-pvc"
          }
        }
      }
    }
  }
}
