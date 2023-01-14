variable "region" {
  type    = string
  default = "europe-west1"
}

variable "project" {
  type    = string
  default = "project"
}

variable "zone" {
  type    = string
  default = "europe-west1-b"
}

variable "network" {
  type    = string
  default = "network-vpc"
}

variable "subnetwork" {
  type    = object({
    name     = string
    ip_range = string
  })
}

variable "ip_name" {
  type    = string
  default = "ip_name"
}

variable "firewall" {
  type  = map(object({
    name   = string
    tags   = list(string)
    ranges = list(string)
    ports  = list(string)
  }))
}