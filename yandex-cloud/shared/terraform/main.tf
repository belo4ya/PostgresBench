resource "yandex_vpc_network" "benchmark" {
  folder_id   = var.cloud.folder_id
  name        = local.network_name
  description = "PostgresBench shared network"
  labels      = local.labels
}

resource "yandex_vpc_subnet" "benchmark" {
  folder_id      = var.cloud.folder_id
  name           = local.subnet_name
  description    = "PostgresBench shared subnet"
  zone           = var.cloud.zone
  network_id     = yandex_vpc_network.benchmark.id
  v4_cidr_blocks = var.cloud.subnet_cidr_blocks
  labels         = local.labels
}

resource "yandex_vpc_security_group" "client" {
  folder_id   = var.cloud.folder_id
  name        = local.client_sg_name
  description = "Allow SSH into PostgresBench client VMs"
  network_id  = yandex_vpc_network.benchmark.id
  labels      = local.labels

  ingress {
    description    = "SSH for Ansible"
    protocol       = "TCP"
    port           = 22
    v4_cidr_blocks = var.cloud.ssh_cidr_blocks
  }

  egress {
    description    = "Client outbound access for apt, git, and PostgreSQL"
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "yandex_vpc_security_group" "postgres" {
  folder_id   = var.cloud.folder_id
  name        = local.postgres_sg_name
  description = "Allow PostgreSQL access from PostgresBench client VMs"
  network_id  = yandex_vpc_network.benchmark.id
  labels      = local.labels

  ingress {
    description       = "PostgreSQL from benchmark clients"
    protocol          = "TCP"
    port              = var.cloud.postgres_port
    security_group_id = yandex_vpc_security_group.client.id
  }

  egress {
    description    = "Managed PostgreSQL outbound access"
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}
