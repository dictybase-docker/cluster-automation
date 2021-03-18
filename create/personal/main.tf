module "gke-cluster" {
  source       = "./gke-cluster"
}

module "kubernetes-config" {
  source           = "./kubernetes-config"
  cluster_name     = module.gke-cluster.cluster_name
  cluster_id       = module.gke-cluster.cluster_id # creates dependency on cluster creation
  cluster_endpoint = module.gke-cluster.cluster_endpoint
  cluster_ca_cert  = module.gke-cluster.cluster_ca_cert
}
