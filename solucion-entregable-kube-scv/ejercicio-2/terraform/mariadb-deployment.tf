resource "kubernetes_deployment" "mariadb" {
  metadata {
    name = "mariadb"
    labels = { app = "mariadb" }
  }

  spec {
    selector { match_labels = { app = "mariadb" } }

    template {
      metadata { labels = { app = "mariadb" } }

      spec {
        container {
          name  = "mariadb"
          image = "mariadb:latest"

          port { container_port = 3306 }

          env {
            name = "MARIADB_ROOT_PASSWORD"
            value = "${var.mariadb_root_password}"
          }
          env {
            name = "MARIADB_USER"
            value = "${var.mariadb_user}"
          }
          env {
            name = "MARIADB_PASSWORD"
            value = "${var.mariadb_password}"
          }
          env {
            name = "MARIADB_DATABASE"
            value = "${var.mariadb_database}"
          }
          volume_mount {
            name       = "mariadb-storage"
            mount_path = "/var/lib/mysql"
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
