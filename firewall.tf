resource "google_compute_firewall" "petclinic-allow-ssh" {
  name          = "petclinic-allow-ssh"
  network       = google_compute_network.vpc_network.id
  target_tags   = ["ssh"]
  source_ranges = ["0.0.0.0/0"]

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
}

resource "google_compute_firewall" "petclinic-allow-http" {
  name          = "petclinic-allow-http"
  network       = google_compute_network.vpc_network.id
  target_tags   = ["http"]
  source_ranges = ["0.0.0.0/0"]

  allow {
    protocol = "tcp"
    ports    = ["8080"]
  }
}

resource "google_compute_firewall" "petclinic-allow-health_check" {
  name          = "petclinic-allow-hc"
  network       = google_compute_network.vpc_network.id
  target_tags   = ["allow-health-check"]
  source_ranges = ["130.211.0.0/22", "35.191.0.0/16"]

  allow {
    protocol = "tcp"
    ports    = ["8080", "80", "443"]
  }
}
