locals {
  repo_root                = abspath("${path.module}/../../..")
  service_account_key_file = startswith(var.cloud.service_account_key_file, "~") ? pathexpand(var.cloud.service_account_key_file) : abspath("${local.repo_root}/${var.cloud.service_account_key_file}")

  labels = {
    project  = "postgresbench"
    provider = var.provider_id
    scope    = "shared"
  }

  network_name     = "${var.name}-network"
  subnet_name      = "${var.name}-subnet"
  client_sg_name   = "${var.name}-client-sg"
  postgres_sg_name = "${var.name}-postgres-sg"
}
