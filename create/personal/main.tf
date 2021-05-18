module "gke-cluster" {
  source                  = "./gke"
  project_id              = var.project_id
  service_account         = var.service_account
  bucket_name             = var.bucket_name
  gke_num_nodes           = var.gke_num_nodes
  service_account_file    = var.service_account_file
  zone                    = var.zone
  version_prefix          = var.version_prefix
  disk_size_gb            = var.disk_size_gb
  disk_type               = var.disk_type
  machine_type            = var.machine_type
  minimum_cpu_resource    = var.minimum_cpu_resource
  minimum_memory_resource = var.minimum_memory_resource
  resource_multiplier     = var.resource_multiplier
  image_type              = var.image_type
}

module "kubernetes-config" {
  source           = "./kubernetes"
  cluster_name     = module.gke-cluster.cluster_name
  cluster_id       = module.gke-cluster.cluster_id # creates dependency on cluster creation
  cluster_endpoint = module.gke-cluster.cluster_endpoint
  cluster_ca_cert  = module.gke-cluster.cluster_ca_cert
}
