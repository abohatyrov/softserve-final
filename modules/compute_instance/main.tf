data "google_compute_image" "petclinic-instance-image-v2" {
  name    = "petclinic-instance-image-v2"
  project = var.project
}

data "google_service_account" "petclinic-sa" {
  account_id = "petclinic-sa"
}

resource "google_compute_instance" "default" {
  name         = var.instance_name
  machine_type = "e2-medium"
  zone         = var.zone
  tags         = var.tags

  boot_disk {
    initialize_params {
      image = data.google_compute_image.petclinic-instance-image-v2.self_link
    }
  }

  service_account {
    email = data.google_service_account.petclinic-sa.email
    scopes = ["cloud-platform"]
  }

  network_interface {
    network    = var.network
    subnetwork = var.subnetwork

    access_config {
      nat_ip = var.ip_addr
    }
  }
}