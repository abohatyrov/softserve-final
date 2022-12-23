provider "google" {
  credentials = file("tf_auth.json")
  project     = "sofserve-final"
  region      = "us-west1"
  zone        = "us-west1-a"
}