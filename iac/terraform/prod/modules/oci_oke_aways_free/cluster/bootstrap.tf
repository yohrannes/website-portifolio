resource "kubernetes_service_account_v1" "tfc_admin" {
  metadata {
    name      = "tfc-admin-sa"
    namespace = "kube-system"
  }
}

resource "kubernetes_secret_v1" "tfc_admin_token" {
  metadata {
    name      = "tfc-admin-token"
    namespace = "kube-system"
    annotations = {
      "kubernetes.io/service-account.name" = kubernetes_service_account_v1.tfc_admin.metadata[0].name
    }
  }
  type = "kubernetes.io/service-account-token"
}

resource "kubernetes_cluster_role_binding_v1" "tfc_admin_binding" {
  metadata {
    name = "tfc-admin-binding"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cluster-admin"
  }
  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account_v1.tfc_admin.metadata[0].name
    namespace = "kube-system"
  }
}

output "tfc_admin_token" {
  value     = kubernetes_secret_v1.tfc_admin_token.data["token"]
  sensitive = true
}
