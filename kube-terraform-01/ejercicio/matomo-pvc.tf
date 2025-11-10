resource "kubernetes_persistent_volume_claim" "matomo_pvc" {
  metadata { name = "matomo-pvc" }
  spec {
    access_modes = ["ReadWriteOnce"]
    resources { requests = { storage = "512Mi" } }
    storage_class_name = "standard"
  }
}
