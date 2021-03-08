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

  enable_shielded_nodes = true

  master_auth {
    client_certificate_config {
      issue_client_certificate = false
    }
  }
  addons_config {
    horizontal_pod_autoscaling {
      enabled = true
    }
  }
  vertical_pod_autoscaling {
    disabled = true
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
  private_cluster_config {
    enable_private_nodes    = true
    enable_private_endpoint = true
    master_ipv4_cidr_block  = var.master_ipv4_cidr_range
    master_global_access_config {
      enabled = false
    }
  }
  ip_allocation_policy {
    cluster_ipv4_cidr_block  = var.cluster_ipv4_cidr_range
    services_ipv4_cidr_block = var.services_ipv4_cidr_range
  }
  master_authorized_networks_config {
    cidr_blocks {
      cidr_block = var.master_ipv4_cidr_range
    }
  }

  #workload_identity_config {
  #  identity_namespace = data.google_project.project.project_id
  #}
}

# Separately Managed Node Pool
resource "google_container_node_pool" "primary_nodes" {
  name              = "primary-node-pool"
  location          = var.zone
  cluster           = google_container_cluster.primary.name
  node_count        = var.gke_num_nodes
  version           = data.google_container_engine_versions.central1c.release_channel_default_version.STABLE
  max_pods_per_node = var.max_pods_per_node
  management {
    auto_repair  = true
    auto_upgrade = true
  }
  autoscaling {
    min_node_count = var.gke_num_nodes
    max_node_count = var.gke_num_nodes + var.resource_multiplier
  }
  node_config {
    disk_size_gb    = var.disk_size_gb
    disk_type       = var.disk_type
    service_account = var.service_account
    image_type      = var.image_type
    machine_type    = var.machine_type
    tags            = ["gke-node", local.gke_name_tag]
    labels = {
      env = var.project_id
    }
    metadata = {
      disable-legacy-endpoints = "true"
    }
  }
}
