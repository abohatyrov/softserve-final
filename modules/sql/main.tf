resource "random_id" "db_name_suffix" {
  byte_length = 2
}

resource "google_sql_database_instance" "mysql" {
  project          = var.project
  name             = "petclinic-db-tf-${random_id.db_name_suffix.hex}"
  region           = var.region
  database_version = var.ver
  depends_on       = [var.connections]

  settings {
    tier              = "db-f1-micro"
    availability_type = "ZONAL"

    ip_configuration {
      ipv4_enabled    = "false"
      private_network = "projects/${var.project}/global/networks/${var.network}"
    }
  }

  deletion_protection = false 
}

resource "google_sql_database" "database" {
  project  = var.project
  name     = var.database
  instance = google_sql_database_instance.mysql.name
}

resource "google_sql_user" "petclinic" {
  project  = var.project
  name     = var.user
  instance = google_sql_database_instance.mysql.name
  password = var.password
}