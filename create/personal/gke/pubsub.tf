resource "google_pubsub_topic" "cluster_upgrade" {
  name = var.topic
}

resource "google_pubsub_subscription" "cluster_upgrade" {
  name  = format("%s-subscription", google_pubsub_topic.cluster_upgrade.name)
  topic = google_pubsub_topic.cluster_upgrade.name
}
