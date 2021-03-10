terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "3.58.0"
    }
  }
  backend "gcs" {}
  required_version = "~> 0.14"
}

