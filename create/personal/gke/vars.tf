variable "project_id" {
  description = "gcp project id"
}

variable "service_account" {
  description = "service account to be used by node vm"
}


variable "bucket_name" {
  description = "GCS bucket name where terraform remote state is stored. This name should be identical with the bucket name that is used in the backend config"
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

variable "max_pods_per_node" {
  default = 50
}

variable "subnet_ipv4_cidr_range" {
  default     = "10.8.0.0/21"
  description = "The IP range in cidr notation for vpc subnet that will be assigned to nodes"
}

variable "cluster_ipv4_cidr_range" {
  default     = "10.6.0.0/16"
  description = "The IP range in cidr notation for pods in the cluster"
}

variable "services_ipv4_cidr_range" {
  default     = "10.5.0.0/20"
  description = "The IP range in cidr notation for services in the cluster"
}

variable "master_ipv4_cidr_range" {
  default     = "10.4.0.0/28"
  description = "The IP range in cidr notation for master in the cluster"
}

variable "start_time" {
  default     = "2021-03-12T00:13:33+00:00"
  description = "recurring start time for maintenance window"
}

variable "topic" {
  default     = "gke-cluster-upgrade-notify"
  description = "topic name for google pub sub"
}

variable "kubeconfig_template_file" {
  default     = "template/kubeconfig-template.yaml.tpl"
  description = "kubeconfig template file"
}

variable "kubeconfig_output_file" {
  default     = "kubeconfig.yaml"
  description = "name of kubeconfig file to access cluster"
}


locals {
  gke_name_tag = format("%s-%s", var.project_id, "personal-cluster")
}

variable "service_account_iam_role" {
  default = "roles/editor"
}
