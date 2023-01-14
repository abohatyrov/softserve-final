variable "instance_name" {
    type    = string
    default = "instance name"
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