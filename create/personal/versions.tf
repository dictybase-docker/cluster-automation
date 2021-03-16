terraform {
  required_providers {
    google = {
      source  = "hashicorp/google-beta"
      version = "3.58.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "2.1.0"
    }
  }
  backend "gcs" {}
  required_version = "~> 0.14"
}

