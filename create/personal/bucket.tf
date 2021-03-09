resource "google_storage_bucket" "private-cluster" {
  name          = var.bucket_name
  force_destroy = true
  versioning {
    enabled = true
  }

}
