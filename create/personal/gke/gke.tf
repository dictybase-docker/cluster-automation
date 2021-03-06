data "google_container_engine_versions" "central1c" {
  provider       = google
  location       = var.zone
  version_prefix = var.version_prefix
}


# GKE cluster
resource "google_container_cluster" "primary" {
  depends_on = [
    google_compute_network.vpc,
    google_pubsub_subscription.cluster_upgrade,
  ]
  provider = google
  name     = local.gke_name_tag
  location = var.zone

  remove_default_node_pool = true
  initial_node_count       = 1

  network    = google_compute_network.vpc.name
  subnetwork = google_compute_subnetwork.subnet.name

  min_master_version = data.google_container_engine_versions.central1c.release_channel_default_version.STABLE

  enable_shielded_nodes = true

  default_max_pods_per_node = var.max_pods_per_node

  master_auth {
    client_certificate_config {
      issue_client_certificate = false
    }
  }
  maintenance_policy {
    recurring_window {
      start_time = var.start_time
      end_time   = timeadd(var.start_time, "6h")
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
    enable_private_endpoint = false
    master_ipv4_cidr_block  = var.master_ipv4_cidr_range
    master_global_access_config {
      enabled = true
    }
  }
  ip_allocation_policy {
    cluster_ipv4_cidr_block  = var.cluster_ipv4_cidr_range
    services_ipv4_cidr_block = var.services_ipv4_cidr_range
  }
  # notification_config {
  #   pubsub {
  #     enabled = true
  #     topic   = format("projects/%s/topics/%s", var.project_id, google_pubsub_topic.cluster_upgrade.name)
  #   }
  # }
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
