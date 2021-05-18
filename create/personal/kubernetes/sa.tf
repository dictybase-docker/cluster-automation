resource "kubernetes_service_account" "admin" {
  metadata {
    name      = "admin"
    namespace = var.namespace
  }
}

resource "kubernetes_cluster_role_binding" "admin" {
  metadata {
    name = "admin"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cluster-admin"
  }

  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.admin.metadata.0.name
    namespace = kubernetes_service_account.admin.metadata.0.namespace
  }
}
