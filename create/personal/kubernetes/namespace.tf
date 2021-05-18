resource "kubernetes_namespace" "user" {
  metadata {
    name = var.namespace
  }
}
