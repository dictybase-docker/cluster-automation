data "google_container_engine_versions" "central1c" {
  provider       = google
  location       = var.zone
  version_prefix = var.version_prefix
}


# GKE cluster
resource "google_container_cluster" "primary" {
  provider = google
  name     = local.gke_name_tag
  location = var.zone

  remove_default_node_pool = true
  initial_node_count       = 1

  network    = google_compute_network.vpc.name
  subnetwork = google_compute_subnetwork.subnet.name

  min_master_version = data.google_container_engine_versions.central1c.release_channel_default_version.STABLE

  master_auth {
    client_certificate_config {
      issue_client_certificate = false
    }
  }

  addons_config {
    horizontal_pod_autoscaling {
      disabled = true
    }
  }
  maintenance_policy {
    recurring_window {
      start_time = timestamp()
      end_time   = timeadd(timestamp(), "6h")
      recurrence = "FREQ=WEEKLY;BYDAY=SU,SA;WKST=SU"
    }
  }
  release_channel {
    channel = "STABLE"
  }
  cluster_autoscaling {
    enabled = true
    resource_limits {
      resource_type = "cpu"
      minimum       = var.minimum_cpu_resource
      maximum       = var.minimum_cpu_resource * var.resource_multiplier
    }
    resource_limits {
      resource_type = "memory"
      minimum       = var.minimum_memory_resource
      maximum       = var.minimum_memory_resource * var.resource_multiplier
    }
  }
}

# Separately Managed Node Pool
resource "google_container_node_pool" "primary_nodes" {
  name       = "primary-node-pool"
  location   = var.zone
  cluster    = google_container_cluster.primary.name 
  node_count = var.gke_num_nodes
  version    = data.google_container_engine_versions.central1c.release_channel_default_version.STABLE
  management {
    auto_repair = true
	auto_upgrade = true
  }
  autoscaling {
    min_node_count = var.gke_num_nodes
    max_node_count = var.gke_num_nodes + var.resource_multiplier
  }
  node_config {
    disk_size_gb = var.disk_size_gb
    disk_type    = var.disk_type
    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
    labels = {
      env = var.project_id
    }
    # preemptible  = true
    machine_type = var.machine_type
    tags         = ["gke-node", local.gke_name_tag]
    metadata = {
      disable-legacy-endpoints = "true"
    }
    service_account = var.service_account
  }
}


# # Kubernetes provider
# # The Terraform Kubernetes Provider configuration below is used as a learning reference only. 
# # It references the variables and resources provisioned in this file. 
# # We recommend you put this in another file -- so you can have a more modular configuration.
# # https://learn.hashicorp.com/terraform/kubernetes/provision-gke-cluster#optional-configure-terraform-kubernetes-provider
# # To learn how to schedule deployments and services using the provider, go here: https://learn.hashicorp.com/tutorials/terraform/kubernetes-provider.

# provider "kubernetes" {
#   load_config_file = "false"

#   host     = google_container_cluster.primary.endpoint
#   username = var.gke_username
#   password = var.gke_password

#   client_certificate     = google_container_cluster.primary.master_auth.0.client_certificate
#   client_key             = google_container_cluster.primary.master_auth.0.client_key
#   cluster_ca_certificate = google_container_cluster.primary.master_auth.0.cluster_ca_certificate
# }

