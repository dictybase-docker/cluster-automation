resource "random_id" "random" {
  prefix      = "k8s-"
  byte_length = "8"
}

resource "google_service_account" "sa" {
  account_id   = random_id.random.hex
  display_name = random_id.random.hex
  project      = var.project_id
}

resource "google_service_account_key" "sa_key" {
  service_account_id = google_service_account.sa.name
}

resource "google_project_iam_member" "project" {
  project = var.project_id
  role    = var.service_account_iam_role
  member  = "serviceAccount:${google_service_account.sa.email}"
}
