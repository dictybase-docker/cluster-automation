terraform {
  required_providers {
    google = {
      source  = "hashicorp/google-beta"
      version = "3.67.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.1.0"
    }
  }
  backend "gcs" {}
  required_version = "~> 0.14"
}

