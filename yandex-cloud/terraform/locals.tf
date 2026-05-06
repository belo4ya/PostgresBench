locals {
  repo_root = abspath("${path.module}/../..")

  service_account_key_file = startswith(var.cloud.service_account_key_file, "~") ? pathexpand(var.cloud.service_account_key_file) : abspath("${local.repo_root}/${var.cloud.service_account_key_file}")
  ssh_public_key_path      = startswith(var.cloud.ssh_public_key_path, "~") ? pathexpand(var.cloud.ssh_public_key_path) : abspath("${local.repo_root}/${var.cloud.ssh_public_key_path}")
  ssh_public_key           = trimspace(file(local.ssh_public_key_path))
  cloud_init_user_data = templatefile("${local.repo_root}/${var.cloud_init_template}", {
    provider       = var.provider_id
    scenario       = var.scenario
    ssh_public_key = local.ssh_public_key
    ssh_user       = var.ssh_user
  })

  labels = {
    project  = "postgresbench"
    provider = var.provider_id
    scenario = var.scenario
  }

  client_name   = "${var.name}-client"
  postgres_name = "${var.name}-postgres"
}
