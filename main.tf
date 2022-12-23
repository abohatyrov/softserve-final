resource "random_id" "instance_id" {
  byte_length = 8
}


resource "google_compute_instance" "default" {
  name         = "apache-vm-${random_id.instance_id.hex}"
  machine_type = "f1-micro"
  zone         = "us-west1-a"
  tags         = ["http-server", "https-server",]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  metadata_startup_script = file("scripts/startup")

  network_interface {
    network = "default"

    access_config {}
  }
}
