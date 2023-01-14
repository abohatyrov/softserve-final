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
  default = "network-vpc"
}

variable "connections" {
}

variable "database" {
  type    = string
  default = "database"
}

variable "user" {
  type    = string
  default = "user"
}

variable "password" {
  type    = string
  default = "password"
}

variable "ver" {
  type    = string
  default = "MYSQL_5_7"
}
