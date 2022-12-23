provider "google" {
  credentials = file("tf_auth.json")
  project     = var.project_id
  region      = var.region
  zone        = var.zone
}