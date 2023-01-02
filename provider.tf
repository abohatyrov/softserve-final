terraform {
  required_providers {
    google = {
      version = "~> 3.83.0"
    }
    google-beta = {
      version = "~> 3.83.0"
    }
  }
}

provider "google" {
  credentials = file("tf_auth.json")
  project     = var.project_id
  region      = var.region
  zone        = var.zone
}

provider "google-beta" {
  credentials = file("tf_auth.json")
  project     = var.project_id
  region      = var.region
  zone        = var.zone
}
