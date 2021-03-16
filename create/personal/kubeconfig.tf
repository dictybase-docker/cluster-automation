data "google_client_config" "client" {}


resource "local_file" "kubeconfig" {
  depends_on = [
    google_container_cluster.primary
  ]
  content = templatefile(
    var.kubeconfig_template_file,
    {
      cluster_ca_certificate = google_container_cluster.primary.master_auth.0.cluster_ca_certificate,
      endpoint               = google_container_cluster.primary.endpoint,
      context                = google_container_cluster.primary.name,
      token                  = data.google_client_config.client.access_token
  })
  filename = var.kubeconfig_output_file
}
