provider "yandex" {
  service_account_key_file = local.service_account_key_file
  cloud_id                 = var.cloud.cloud_id
  folder_id                = var.cloud.folder_id
  zone                     = var.cloud.zone
}
