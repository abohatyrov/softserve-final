terraform {
  required_providers {
    google = {
      version = "~> 3.83.0"
    }
  }
}

provider "google" {
  credentials = file("pllug-2022-bohatyriov-a84927fb580e.json")
  region      = var.region
}