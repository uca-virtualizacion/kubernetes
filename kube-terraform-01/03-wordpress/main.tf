terraform {
  required_providers {
    kubernetes = {
      source = "hashicorp/kubernetes"
    }
  }
}

provider "kubernetes" {
  config_context = "kind-kind"
  config_path    = "~/.kube/config"
}