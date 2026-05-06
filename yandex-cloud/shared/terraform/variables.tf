variable "provider_id" {
  type        = string
  description = "Benchmark provider id from .belo4ya/benchmarks.json."
}

variable "name" {
  type        = string
  description = "Stable shared resource name prefix generated for the provider."
}

variable "cloud" {
  type = object({
    cloud_id                 = string
    folder_id                = string
    zone                     = string
    subnet_cidr_blocks       = list(string)
    ssh_cidr_blocks          = list(string)
    service_account_key_file = string
    postgres_port            = number
  })
  description = "Yandex Cloud shared network settings and provider bootstrap inputs."
}
