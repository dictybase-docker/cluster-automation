variable "project_id" {
  description = "gcp project id"
}

variable "bucket_name" {
  description = "GCS bucket name where terraform remote state is stored. This name should be identical with the bucket name that is used in the backend config"
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
