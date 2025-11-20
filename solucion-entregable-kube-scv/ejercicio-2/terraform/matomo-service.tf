resource "kubernetes_service" "service_matomo" {
  metadata {
    name = "service-matomo"
    labels = { app = "matomo" }
  }

  spec {
    selector = { app = "matomo" }
    type     = "NodePort"

    port {
      name        = "http"
      port        = 80
      target_port = 80
      node_port   = 30003
    }
  }
}
