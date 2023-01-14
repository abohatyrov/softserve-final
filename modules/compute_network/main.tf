resource "google_compute_global_address" "static" {
  project = var.project
  name    = var.ip_name
}

resource "google_compute_network" "petclinic-vpc-tf" {
  project                 = var.project
  name                    = var.network
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "petclinic-subnet-tf-eu-west1" {
  project                  = var.project
  name                     = var.subnetwork.name
  ip_cidr_range            = var.subnetwork.ip_range
  region                   = var.region
  network                  = google_compute_network.petclinic-vpc-tf.id
  private_ip_google_access = true
}

resource "google_compute_global_address" "private_ip" {
  project                 = var.project
  name         = "petclinic-vpc-tf-ip"
  purpose      = "VPC_PEERING"
  address_type = "INTERNAL"
  ip_version   = "IPV4"
  prefix_length = 20
  network       = google_compute_network.petclinic-vpc-tf.self_link
}

resource "google_service_networking_connection" "private_vpc_connection" {
  network                 = google_compute_network.petclinic-vpc-tf.self_link
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_ip.name]
}

resource "google_compute_firewall" "petclinic-firewall-rule" {
  project  = var.project
  for_each = var.firewall


  name          = each.value.name
  network       = google_compute_network.petclinic-vpc-tf.id
  target_tags   = each.value.tags
  source_ranges = each.value.ranges

  allow {
    protocol = "tcp"
    ports    = each.value.ports
  }
}

resource "google_compute_router" "router" {
  project = var.project
  name    = "petclinic-router"
  region  = var.region
  network = google_compute_network.petclinic-vpc-tf.id
}

resource "google_compute_router_nat" "nat" {
  project                            = var.project
  name                               = "petclinic-router-nat"
  router                             = google_compute_router.router.name
  region                             = var.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
}