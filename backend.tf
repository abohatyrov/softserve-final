terraform {
  backend "gcs" {
    bucket = "terraform-state-bohatyrov"
    prefix = "terraform/state"
  }
}