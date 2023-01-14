variable "template_name" {
    type    = string
    default = "name"
}

variable "hc_name" {
    type    = string
    default = "petclinic-health-check"
}

variable "autoscaler_name" {
    type    = string
    default = "petclinic-autoscaler"
}

variable "mig_name" {
    type    = string
    default = "petclinic-mig"
}

variable "forwarding_name" {
    type    = string
    default = "petclinic-forwarding-rule"
}

variable "target_proxy_name" {
    type    = string
    default = "petclinic-target-http-proxy"
}

variable "url_map_name" {
    type    = string
    default = "petclinic-url-map"
}

variable "backend_name" {
    type    = string
    default = "petclinic-backend-service"
}

variable "inner_port" {
    type    = number
    default = 8080
}

variable "tags" {
    type    = list(string)
    default = []
}

variable "project" {
    type    = string
    default = "project"
}

variable "region" {
    type    = string
    default = "europe-west1"
}

variable "zone" {
    type    = string
    default = "europe-west1-b"
}

variable "network" {
    type    = string
    default = "europe-west1-b"
}

variable "subnetwork" {
    type    = string
    default = "europe-west1-b"
}

variable "ip_addr" {
    type    = string
    default = "europe-west1-b"
}

variable "connection_name" {
    type    = string
    default = "connection name"
}

variable "sa-email" {
    type    = string
    default = "email@mail.com"
}