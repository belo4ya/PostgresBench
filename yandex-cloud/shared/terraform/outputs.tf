output "network_id" {
  value       = yandex_vpc_network.benchmark.id
  description = "Shared VPC network id used by benchmark scenarios."
}

output "subnet_id" {
  value       = yandex_vpc_subnet.benchmark.id
  description = "Shared subnet id used by benchmark clients and Managed PostgreSQL hosts."
}

output "client_security_group_id" {
  value       = yandex_vpc_security_group.client.id
  description = "Security group id attached to benchmark client VMs."
}

output "postgres_security_group_id" {
  value       = yandex_vpc_security_group.postgres.id
  description = "Security group id attached to Managed PostgreSQL clusters."
}
