output "client_public_ip" {
  value       = yandex_compute_instance.client.network_interface[0].nat_ip_address
  description = "Public IP address used by Ansible to connect to the benchmark client VM."
}

output "client_private_ip" {
  value       = yandex_compute_instance.client.network_interface[0].ip_address
  description = "Private IP address of the benchmark client VM."
}

output "postgres_host" {
  value       = yandex_mdb_postgresql_cluster.benchmark.host[0].fqdn
  description = "Managed PostgreSQL endpoint reachable from the benchmark client VM."
}

output "postgres_port" {
  value       = var.postgres.port
  description = "Managed PostgreSQL port."
}

output "postgres_user" {
  value       = var.postgres.user
  description = "Benchmark database user."
}

output "postgres_password" {
  value       = var.postgres.password_default
  sensitive   = true
  description = "Benchmark database password."
}

output "postgres_database" {
  value       = var.postgres.database
  description = "Benchmark database name."
}

output "ssh_user" {
  value       = var.ssh_user
  description = "SSH user for Ansible."
}
