output "network_id" {
  value = google_compute_network.petclinic-vpc-tf.id
}

output "network_name" {
  value = google_compute_network.petclinic-vpc-tf.name
}

output "subnet" {
  value = google_compute_subnetwork.petclinic-subnet-tf-eu-west1.id
}

output "ip_address" {
  value = google_compute_global_address.static.address
}

output "connections" {
  value = google_service_networking_connection.private_vpc_connection
}