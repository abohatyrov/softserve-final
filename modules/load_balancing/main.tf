data "google_compute_image" "petclinic-instance-image-v2" {
  name    = "petclinic-instance-image-v2"
  project = var.project
}


resource "google_compute_instance_template" "default" {
  project      = var.project
  name         = var.template_name
  machine_type = "e2-medium"
  tags         = var.tags

  disk {
    source_image = data.google_compute_image.petclinic-instance-image-v2.self_link
  }

  metadata_startup_script = "source /etc/profile.d/jdk.sh & cloud_sql_proxy -instances=${var.connection_name}=tcp:3306 & java -jar -Dspring.profiles.active=mysql /root/spring-petclinic/target/petclinic-bohatyrov-3.0.0-SNAPSHOT.jar"

  network_interface {
    network    = var.network
    subnetwork = var.subnetwork
  }

  service_account {
    email  = var.sa-email
    scopes = ["cloud-platform"]
  }
}

resource "google_compute_health_check" "autohealing" {
  project             = var.project
  name                = var.hc_name
  check_interval_sec  = 5
  timeout_sec         = 5
  healthy_threshold   = 2
  unhealthy_threshold = 10

  http_health_check {
    request_path = "/"
    port         = "${var.inner_port}"
  }
}

resource "google_compute_autoscaler" "default" {
  project = var.project
  name    = var.autoscaler_name
  zone    = var.zone
  target  = google_compute_instance_group_manager.default.id

  autoscaling_policy {
    max_replicas    = 3
    min_replicas    = 1
    cooldown_period = 60
  }
}

resource "google_compute_instance_group_manager" "default" {
  project            = var.project
  name               = var.mig_name
  zone               = var.zone
  base_instance_name = "petclinic"

  version {
    instance_template  = google_compute_instance_template.default.id
  }

  named_port {
    name = "http"
    port = var.inner_port
  }

  auto_healing_policies {
    health_check      = google_compute_health_check.autohealing.id
    initial_delay_sec = 90
  }
}

resource "google_compute_global_forwarding_rule" "default" {
  project               = var.project
  name                  = var.forwarding_name
  ip_protocol           = "TCP"
  load_balancing_scheme = "EXTERNAL"
  port_range            = "80"
  target                = google_compute_target_http_proxy.default.id
  ip_address            = var.ip_addr
}

resource "google_compute_target_http_proxy" "default" {
  project  = var.project
  name     = var.target_proxy_name
  url_map  = google_compute_url_map.default.id
}

resource "google_compute_url_map" "default" {
  project         = var.project
  name            = var.url_map_name
  default_service = google_compute_backend_service.default.id
}

resource "google_compute_backend_service" "default" {
  project                 = var.project
  name                    = var.backend_name
  protocol                = "HTTP"
  port_name               = "http"
  load_balancing_scheme   = "EXTERNAL"
  health_checks           = [ google_compute_health_check.autohealing.id ]
  
  backend {
    group = google_compute_instance_group_manager.default.instance_group
  }
}
