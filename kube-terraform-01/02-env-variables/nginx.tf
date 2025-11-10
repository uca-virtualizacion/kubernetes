resource "kubernetes_deployment" "nginx" {
  metadata {
    name   = "web-nginx"
    labels = { app = "web" }
  }
  spec {
    replicas = 2
    selector { match_labels = { app = "web" } }
    template {
      metadata { labels = { app = "web" } }
      spec {
        container {
          name  = "nginx"
          image = "nginx:stable"
          port { container_port = 80 }
        }
      }
    }
  }
}

resource "kubernetes_service" "nginx" {
  metadata {
    name   = "web-nginx"
    labels = { app = "web" }
  }
  spec {
    selector = { app = "web" }
    port {
      node_port = 30201
      port        = 80
      target_port = 80
    }
    type = "NodePort"
  }
}
