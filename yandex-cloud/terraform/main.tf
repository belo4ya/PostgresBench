data "yandex_compute_image" "ubuntu" {
  family = var.client.image_family
}

data "terraform_remote_state" "shared" {
  backend = "local"

  config = {
    path = var.cloud.shared_state_path
  }
}

resource "yandex_compute_instance" "client" {
  folder_id          = var.cloud.folder_id
  name               = local.client_name
  hostname           = local.client_name
  description        = "PostgresBench client VM for ${var.scenario}"
  zone               = var.cloud.zone
  platform_id        = var.client.platform_id
  service_account_id = var.cloud.service_account_id
  labels             = local.labels

  resources {
    cores         = var.client.vcpus
    memory        = var.client.ram_gb
    core_fraction = 100
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.id
      size     = var.client.disk_gb
      type     = var.client.disk_type
    }
  }

  network_interface {
    subnet_id          = data.terraform_remote_state.shared.outputs.subnet_id
    nat                = true
    security_group_ids = [data.terraform_remote_state.shared.outputs.client_security_group_id]
  }

  metadata = {
    ssh-keys  = "${var.ssh_user}:${local.ssh_public_key}"
    user-data = local.cloud_init_user_data
  }
}

resource "yandex_mdb_postgresql_cluster" "benchmark" {
  folder_id          = var.cloud.folder_id
  name               = local.postgres_name
  description        = "PostgresBench Managed PostgreSQL for ${var.scenario}"
  environment        = "PRODUCTION"
  network_id         = data.terraform_remote_state.shared.outputs.network_id
  security_group_ids = [data.terraform_remote_state.shared.outputs.postgres_security_group_id]
  labels             = local.labels

  config {
    version = var.postgres.version

    resources {
      resource_preset_id = var.postgres.resource_preset
      disk_type_id       = var.postgres.storage.type
      disk_size          = var.postgres.storage.size_gb
    }

    postgresql_config = {
      max_connections = tostring(var.postgres.max_connections)
    }
  }

  host {
    zone             = var.cloud.zone
    subnet_id        = data.terraform_remote_state.shared.outputs.subnet_id
    assign_public_ip = false
  }
}

resource "yandex_mdb_postgresql_user" "benchmark" {
  cluster_id  = yandex_mdb_postgresql_cluster.benchmark.id
  name        = var.postgres.user
  password    = var.postgres.password_default
  conn_limit  = var.postgres.user_conn_limit
  login       = true
  auth_method = "AUTH_METHOD_PASSWORD"
}

resource "yandex_mdb_postgresql_database" "benchmark" {
  cluster_id = yandex_mdb_postgresql_cluster.benchmark.id
  name       = var.postgres.database
  owner      = yandex_mdb_postgresql_user.benchmark.name
}
