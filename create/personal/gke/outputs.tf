output "cluster_id" {
  value       = google_container_cluster.primary.id
}

output "cluster_name" {
  value       = google_container_cluster.primary.name
  description = "GKE Cluster Name"
}

output "cluster_endpoint" {
  value       = google_container_cluster.primary.endpoint
  description = "GKE Cluster Host"
}

output "cluster_ca_cert" {
  value       = google_container_cluster.primary.master_auth.0.cluster_ca_certificate
}