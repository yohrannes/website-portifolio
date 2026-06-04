resource "kubernetes_namespace_v1" "cert_manager" {
  metadata {
    name = var.kubernetes_namespace_cert_manager
  }
}

resource "kubernetes_namespace_v1" "nginx_gateway" {
  metadata {
    name = var.kubernetes_namespace_nginx_gateway
  }
}

resource "kubernetes_manifest" "gateway_api_crds" {
  for_each = fileset("${path.module}/manifests", "gateway-api-*.yaml")
  manifest = yamldecode(file("${path.module}/manifests/${each.value}"))
}
