# module "petclinic_instance" {
#   source = "./modules/compute_instance"

#   project         = var.project
#   instance_name   = "petclinic-app-tf"
#   network         = module.petclinic_network.network_id
#   subnetwork      = module.petclinic_network.subnet
#   ip_addr         = module.petclinic_network.ip_address
#   connection_name = module.petclinic_sql.connection_name
#   tags            = ["web", "ssh",]
# }

module "petclinic_network" {
  source = "./modules/compute_network"

  region  = var.region
  project = jsondecode(file("pllug-2022-bohatyriov-a84927fb580e.json")).project_id
  ip_name = "petclinic-public-ip-tf"
  network = "petclinic-vpc-tf"

  subnetwork = {
    name     = "petclinic-subnet-tf-eu-west1"
    ip_range = "10.24.5.0/24"
  }

  firewall = {
    ssh = {
      name   = "petclinic-allow-ssh-tf"
      tags   = ["ssh"]
      ranges = ["0.0.0.0/0"]
      ports  = ["22"]
    },
    http = {
      name   = "petclinic-allow-http-tf"
      tags   = ["web"]
      ranges = ["0.0.0.0/0"]
      ports  = ["8080"]
    }
  }
}

module "petclinic_sql" {
  source = "./modules/sql"

  project     = jsondecode(file("pllug-2022-bohatyriov-a84927fb580e.json")).project_id
  region      = var.region
  ver         = "MYSQL_5_7"
  network     = module.petclinic_network.network_name
  connections = module.petclinic_network.connections
  database    = "petclinic"
  user        = "petclinic"
  password    = "petclinic"
}

module "petclinic_load_balancer" {
  source = "./modules/load_balancing"

  project         = jsondecode(file("pllug-2022-bohatyriov-a84927fb580e.json")).project_id
  sa-email        = jsondecode(file("pllug-2022-bohatyriov-a84927fb580e.json")).client_email
  template_name   = "petclinic-instance-template-v2"
  connection_name = module.petclinic_sql.connection_name
  network         = module.petclinic_network.network_id
  subnetwork      = module.petclinic_network.subnet
  ip_addr         = module.petclinic_network.ip_address
  tags            = ["web",]
}
