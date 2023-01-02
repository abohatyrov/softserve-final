resource "google_compute_instance" "default" {
  provider     = google-beta
  name         = "debian-instance-1"
  machine_type = "e2-medium"
  tags         = ["http", "ssh",]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-10"
    }
  }

  metadata_startup_script = file("scripts/debian-startup.sh")

  network_interface {
    network    = google_compute_network.vpc_network.id
    subnetwork = google_compute_subnetwork.petclinic-eu-west1.id
    
    access_config {
      
    }
  }

  service_account {
    email  = jsondecode(file("tf_auth.json")).client_email
    scopes = ["cloud-platform"]
  }

  desired_status = "TERMINATED"
}

resource "google_compute_image" "image" {
  name        = "petclinic-image-v2"
  source_disk = google_compute_instance.default.self_link
}

resource "google_compute_instance_template" "default" {
  name         = "petclinic-instance-template-v1"
  machine_type = "e2-medium"
  tags         = ["http",]

  disk {
    source_image = google_compute_image.image.id
  }

  metadata_startup_script = file("scripts/startup.sh")

  network_interface {
    network    = google_compute_network.vpc_network.id
    subnetwork = google_compute_subnetwork.petclinic-eu-west1.id
  }

  service_account {
    email  = jsondecode(file("tf_auth.json")).client_email
    scopes = ["cloud-platform"]
  }
}

resource "google_compute_health_check" "autohealing" {
  name                = "petclinic-health-check"
  check_interval_sec  = 5
  timeout_sec         = 5
  healthy_threshold   = 2
  unhealthy_threshold = 10 

  http_health_check {
    request_path = "/"
    port         = "8080"
  }
}

resource "google_compute_autoscaler" "default" {
  provider = google-beta

  name   = "petclinic-autoscaler"
  zone   = var.zone
  target = google_compute_instance_group_manager.default.id

  autoscaling_policy {
    max_replicas    = 3
    min_replicas    = 1
    cooldown_period = 60
  }
}

resource "google_compute_instance_group_manager" "default" {
  provider = google-beta

  name               = "petclinic-mig"
  zone               = var.zone
  base_instance_name = "petclinic"

  version {
    instance_template  = google_compute_instance_template.default.id
  }


  named_port {
    name = "http"
    port = 8080
  }

  auto_healing_policies {
    health_check      = google_compute_health_check.autohealing.id
    initial_delay_sec = 90
  }
}

resource "google_compute_global_forwarding_rule" "default" {
  name                  = "petclinic-forwarding-rule"
  ip_protocol           = "TCP"
  load_balancing_scheme = "EXTERNAL"
  port_range            = "80"
  target                = google_compute_target_http_proxy.default.id
  ip_address            = google_compute_global_address.default.id
}

resource "google_compute_target_http_proxy" "default" {
  name     = "petclinic-target-http-proxy"
  url_map  = google_compute_url_map.default.id
}

resource "google_compute_url_map" "default" {
  name            = "petclinic-url-map"
  default_service = google_compute_backend_service.default.id
}

resource "google_compute_backend_service" "default" {
  name                    = "petclinic-backend-service"
  provider                = google-beta
  protocol                = "HTTP"
  port_name               = "http"
  load_balancing_scheme   = "EXTERNAL"
  health_checks           = [ google_compute_health_check.autohealing.id ]
  
  backend {
    group = google_compute_instance_group_manager.default.instance_group
  }
}

