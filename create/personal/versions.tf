terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "3.58.0"
    }
  }
  backend "gcs" {
    bucket = var.bucket_name
    prefix = local.gke_name_tag
  }


  required_version = "~> 0.14"
}

