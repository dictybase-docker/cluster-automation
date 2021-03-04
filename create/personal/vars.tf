variable "project_id" {
  description = "gcp project id"
}

variable "service_account" {
  description = "service account to be used by node vm"
}

variable "gke_num_nodes" {
  default     = 2
  description = "number of gke nodes"
}

variable "service_account_file" {
  default     = "credentials.json"
  description = "path to service account key file"
}

variable "region" {
  default     = "us-central1"
  description = "gcp region"
}

variable "zone" {
  default     = "us-central1-c"
  description = "gcp zone name within a region"
}

variable "version_prefix" {
  default     = "1.15"
  description = "version prefix for determining kubernetes version"
}

variable "disk_size_gb" {
  default     = 50
  description = "disk size in gb for every kubernetes node"
}

variable "disk_type" {
  default = "pd-ssd"
}

variable "machine_type" {
  default = "n1-standard-1"
}

variable "minimum_cpu_resource" {
  default = 2
}

variable "minimum_memory_resource" {
  default = 8
}

variable "resource_multiplier" {
  default = 2
}

variable "image_type" {
  default = "cos_containerd"
}

variable "subnet_ipv4_cidr_range" {
  default     = "10.10.10.10/16"
  description = "The IP range in cidr notation for vpc subnet"
}

locals {
  gke_name_tag             = format("%s-%s", var.project_id, "personal-cluster")
  master_ipv4_cidr_block   = cidrsubnet(var.subnet_ipv4_cidr_range, 12, 1)
  cluster_ipv4_cidr_block  = cidrsubnet(var.subnet_ipv4_cidr_range, 1, 0)
  services_ipv4_cidr_block = cidrsubnet(var.subnet_ipv4_cidr_range, 1, 1)
}

