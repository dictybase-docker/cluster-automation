resource "google_pubsub_lite_topic" "cluster_upgrade" {
  name   = var.topic
  region = var.region
  zone   = var.zone
}

resource "google_pubsub_lite_subscription" "cluster_upgrade" {
  name   = format("%s-subscription", google_pubsub_lite_topic.cluster_upgrade.name)
  topic  = google_pubsub_lite_topic.cluster_upgrade.name
  region = var.region
  zone   = var.zone
}
