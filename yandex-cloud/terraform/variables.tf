variable "provider_id" {
  type        = string
  description = "Benchmark provider id from .belo4ya/benchmarks.json."
}

variable "scenario" {
  type        = string
  description = "Benchmark scenario id from .belo4ya/benchmarks.json."
}

variable "name" {
  type        = string
  description = "Stable resource name prefix generated from provider and scenario."
}

variable "ssh_user" {
  type        = string
  description = "Linux user for the benchmark client VM."
}

variable "cloud_init_template" {
  type        = string
  description = "Repository-relative cloud-init template path."
}

variable "cloud" {
  type = object({
    cloud_id                 = string
    folder_id                = string
    zone                     = string
    service_account_id       = string
    service_account_key_file = string
    ssh_public_key_path      = string
    ssh_private_key_path     = string
    shared_state_path        = string
  })
  description = "Yandex Cloud identifiers and bootstrap inputs."
}

variable "client" {
  type = object({
    vcpus        = number
    ram_gb       = number
    disk_gb      = number
    disk_type    = string
    platform_id  = string
    image_family = string
  })
  description = "Benchmark client VM shape."
}

variable "postgres" {
  type = object({
    database         = string
    user             = string
    password_env     = string
    password_default = string
    port             = number
    sslmode          = string
    version          = string
    max_connections  = number
    user_conn_limit  = number
    resource_preset  = string
    vcpus            = number
    ram_gb           = number
    storage = object({
      type        = string
      size_gb     = number
      description = string
    })
  })
  description = "Managed PostgreSQL target shape and benchmark database settings."
}

variable "benchmark" {
  type = object({
    clients          = number
    threads          = number
    duration         = number
    query_mode       = string
    progress_seconds = number
    cluster_size     = number
    tuned            = string
    comment          = string
    system_name      = string
    instance_type    = string
    vcpus            = number
    ram_gb           = number
    instance_storage = string
    primary_storage  = string
    scale_factor     = number
    out_json         = string
  })
  description = "pgbench and result metadata."
}
