resource "google_compute_network" "vpc_network" {
  name                    = var.network
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "petclinic-eu-west1" {
  name                     = var.subnetwork
  ip_cidr_range            = "10.24.5.0/24"
  region                   = var.region
  network                  = google_compute_network.vpc_network.id
  private_ip_google_access = true
}

resource "google_compute_global_address" "default" {
  name     = "petclinic-static-ip"
}

resource "google_compute_router" "router" {
  name    = "petclinic-router"
  region  = var.region
  network = google_compute_network.vpc_network.id
}

resource "google_compute_router_nat" "nat" {
  name                               = "petclinic-router-nat"
  router                             = google_compute_router.router.name
  region                             = var.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
}