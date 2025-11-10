resource "kubernetes_service" "service_mariadb" {
  metadata {
    name = "service-mariadb"
    labels = { app = "mariadb" }
  }

  spec {
    selector = { app = "mariadb" }
    type     = "ClusterIP"

    port {
      name        = "mysql"
      port        = 3306
      target_port = 3306
    }
  }
}
