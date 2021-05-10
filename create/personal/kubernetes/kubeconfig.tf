data "google_client_config" "client" {}


resource "local_file" "kubeconfig" {
  depends_on = [
    google_container_cluster.primary
  ]
  content = templatefile(
    var.kubeconfig_template_file,
    {
      cluster_ca_cert  = var.cluster_ca_cert,
      cluster_endpoint = var.cluster_endpoint,
      context          = var.cluster_name,
  })
  filename = var.kubeconfig_output_file
}
