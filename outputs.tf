output "Petclinic_External_IPAddr" {
  value = module.petclinic_network.ip_address
}

output "Cloud_SQL_connection_name" {
  value = module.petclinic_sql.connection_name
}