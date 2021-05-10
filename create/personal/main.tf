module "gke-cluster" {
  source       = "./gke"
}

module "kubernetes-config" {
  source           = "./kubernetes"
  cluster_name     = module.gke-cluster.cluster_name
  cluster_id       = module.gke-cluster.cluster_id # creates dependency on cluster creation
  cluster_endpoint = module.gke-cluster.cluster_endpoint
  cluster_ca_cert  = module.gke-cluster.cluster_ca_cert
}
