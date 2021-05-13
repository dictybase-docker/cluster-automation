resource "local_file" "k8sconfig" {
  content = templatefile(
    var.k8s_template_file,
    {
      cluster_id       = google_container_cluster.primary.id,
      cluster_name     = google_container_cluster.primary.name,
      cluster_endpoint = google_container_cluster.primary.endpoint,
      cluster_ca_cert  = google_container_cluster.primary.master_auth.0.cluster_ca_certificate
  })
  filename = var.k8s_output_file
}
