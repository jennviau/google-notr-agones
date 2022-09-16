resource "google_compute_firewall" "default" {
  name    = "agones-gameservers"
  project = var.project_id
  network = var.vpc_network

  allow {
    protocol = "tcp"
    ports    = ["7000-8000"]
  }

  allow {
    protocol = "udp"
    ports    = ["7000-8000"]
  }

  source_ranges = ["0.0.0.0/0"]

  target_tags = ["google-notr-agones"]
}