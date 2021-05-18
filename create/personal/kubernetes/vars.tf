variable "cluster_name" {}

variable "cluster_id" {}

variable "cluster_endpoint" {}

variable "cluster_ca_cert" {}

variable "kubeconfig_template_file" {
  default     = "kubernetes/template/kubeconfig-template.yaml.tpl"
  description = "kubeconfig template file"
}

variable "kubeconfig_output_file" {
  default     = "kubeconfig.yaml"
  description = "name of kubeconfig file to access cluster"
}

variable "namespace" {}
