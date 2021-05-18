data "google_client_config" "default" {}


resource "local_file" "kubeconfig" {
  content = templatefile(
    var.kubeconfig_template_file,
    {
      cluster_ca_cert  = var.cluster_ca_cert,
      cluster_endpoint = var.cluster_endpoint,
      context          = var.cluster_name,
      token            = data.google_client_config.default.access_token
  })
  filename = var.kubeconfig_output_file
}
