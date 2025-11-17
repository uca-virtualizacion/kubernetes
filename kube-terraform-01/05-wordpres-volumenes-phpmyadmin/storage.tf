resource "kubernetes_persistent_volume_claim" "wp_pvc" {
  metadata { name = "wp-pvc" }

  spec {
    access_modes = ["ReadWriteOnce"]
    resources {
      requests = {
        storage = "2Gi"
      }
    }
    storage_class_name = "standard"
  }
}

resource "kubernetes_persistent_volume_claim" "mariadb_pvc" {
  metadata { name = "mariadb-pvc" }

  spec {
    access_modes = ["ReadWriteOnce"]
    resources {
      requests = {
        storage = "2Gi"
      }
    }
    storage_class_name = "standard"
  }
}
