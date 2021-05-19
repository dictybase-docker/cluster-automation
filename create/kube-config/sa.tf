resource "kubernetes_namespace" "user" {
  metadata {
    name = var.namespace
  }
}

resource "kubernetes_service_account" "admin" {
  metadata {
    name      = "${var.namespace}-admin"
    namespace = var.namespace
  }
}

resource "kubernetes_role_binding" "admin" {
  metadata {
    name      = "${var.namespace}-admin"
    namespace = var.namespace
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = "edit"
  }

  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.admin.metadata.0.name
    namespace = var.namespace
  }
}
