# Plan

### Providers

- [x] Cloud.ru Managed PostgreSQL
- [x] Yandex Cloud Managed Service for PostgreSQL
- [x] MWS Managed PostgreSQL
- [x] Selectel PostgreSQL
- [x] VK Cloud Managed PostgreSQL
- [ ] Timeweb Cloud Managed Service for PostgreSQL
- [ ] H3llo.Cloud PostgreSQL
- [ ] Reg.ru Cloud PostgreSQL

### Client Setup

- VM 8CPU/16Gi, 30Gi SSD - for PostgreSQL 4CPU/16Gi
- VM 16CPU/32Gi, 30Gi SSD - for PostgreSQL 16CPU/64Gi

### Presets

Principals:

- latest Postgres version
- most powerful configurations
    - but the disk size <=1536Gi
- out-of-the-box Postgres configuration (no tuning)
    - but max_connections >=300
- client VM and Postgres in same cloud, in same VPC, in same AZ
- service project `postgresbench`, service account `postgresbench`, ...
- optimizing benchmark costs

Common parameters:

- database `postgresbench`
- user `postgresbench`, password `Qwerty123!`
- `max_connections` >=300

#### Cloud.ru

- https://cloud.ru/docs/terraform-evolution/ug/index
- https://cloud.ru/docs/disks/ug/topics/concepts__disk-types

Нужно увеличить max_connections до 300.

- [x] 4CPU/16Gi, SF=6849, 1050Gi SSD NVMe (50K IOPS)
- [x] 16CPU/64Gi, SF=6849, 1050Gi SSD NVMe (50K IOPS)
- [x] 16CPU/64Gi, SF=34247, 1050Gi SSD NVMe (50K IOPS)

#### Yandex Cloud

- https://yandex.cloud/ru/docs/managed-postgresql/tf-ref

Для пользователя нужно увеличить кол-во подключений до 300.

network-ssd:

- [x] 4CPU/16Gi, SF=6849, 1250Gi network-ssd (20/40K IOPS)
- [x] 16CPU/64Gi, SF=6849, 1250Gi network-ssd (20/40K IOPS)
- [x] 16CPU/64Gi, SF=34247, 1250Gi network-ssd (20/40K IOPS)

network-ssd-io-m3:

- [x] 4CPU/16Gi, SF=6849, 837Gi network-ssd-io-m3 (75/40K IOPS)
- [x] 16CPU/64Gi, SF=6849, 837Gi network-ssd-io-m3 (75/40K IOPS)
- [x] 16CPU/64Gi, SF=34247, 837Gi network-ssd-io-m3 (75/40K IOPS)

local-ssd:

- [ ] 4CPU/16Gi, SF=6849, 368Gi local-ssd (260K/230K IOPS), 3 hosts
- [ ] 16CPU/64Gi, SF=6849, 736Gi local-ssd (260K/230K IOPS), 3 hosts
- [ ] 16CPU/64Gi, SF=34247, 736Gi local-ssd (260K/230K IOPS), 3 hosts

#### MWS

- https://mws.ru/docs/cloud-platform/terraform/general/whatis-terraform.html
- https://mws.ru/docs/cloud-platform/mpostgres/general/whatis-mpostgres.html#disks-types
- https://mws.ru/docs/cloud-platform/compute/general/disks-overview.html

NBS-PL2:

- [x] 4CPU/16Gi, SF=6849, 180Gi NBS-PL2 (10K IOPS)
- [x] 16CPU/64Gi, SF=6849, 700Gi NBS-PL2 (10K IOPS)
- [x] 16CPU/64Gi, SF=34247, 700Gi NBS-PL2 (10K IOPS)

local NVMe:

- [x] 4CPU/16Gi, SF=6849, 248Gi local NVMe
- [x] 16CPU/64Gi, SF=6849, 744Gi local NVMe
- [x] 16CPU/64Gi, SF=34247, 744Gi local NVMe

#### Selectel

- https://docs.selectel.ru/terraform/providers/
- https://docs.selectel.ru/managed-databases/postgresql/volumes/
- https://docs.selectel.ru/managed-databases/postgresql/configurations/

Flex, network SSD NVMe:

- [x] 4CPU/16Gi, SF=6849, 180Gi network SSD NVMe (25/15K IOPS)
- [x] 16CPU/64Gi, SF=6849, 760Gi network SSD NVMe (25/15K IOPS)
- [x] 16CPU/64Gi, SF=34247, 760Gi network SSD NVMe (25/15K IOPS)

Standard, local SSD NVMe:

- [x] 4CPU/32Gi, SF=6849, 256Gi local SSD NVMe (25.6/12.8K IOPS) (Memory)
- [x] 16CPU/128Gi, SF=6849, 1024Gi local SSD NVMe (60/30K IOPS) (CPU)
- [x] 16CPU/128Gi, SF=34247, 1024Gi local SSD NVMe (60/30K IOPS) (CPU)

Dedicated, Extra Small:

- [x] 14CPU/64Gi, SF=6849, 1024Gi local SSD NVMe (700/180K IOPS)
- [x] 14CPU/64Gi, SF=34247, 1024Gi local SSD NVMe (700/180K IOPS)

#### VK Cloud

- https://cloud.vk.com/docs/computing/iaas/concepts/data-storage/volume-sla

Нужно увеличить max_connections до 300.

- [x] 4CPU/16Gi, SF=6849, 1050Gi High-IOPS SSD (31.5/26.2K IOPS) + 210Gi WAL
- [x] 16CPU/64Gi, SF=6849, 1050Gi High-IOPS SSD (31.5/26.2K IOPS) + 210Gi WAL
- [x] 16CPU/64Gi, SF=34247, 1050Gi High-IOPS SSD (31.5/26.2K IOPS) + 210Gi WAL

#### Timeweb Cloud

- https://timeweb.cloud/docs/terraform

Нужно увеличить max_connections до 300.

Dedicated CPU:

- [x] 4CPU/16Gi, SF=6849, 180Gi local SSD NVMe
- [ ] 16CPU/64Gi, SF=6849, 700Gi local SSD NVMe
- [ ] 16CPU/64Gi, SF=34247, 700Gi local SSD NVMe

#### H3llo.Cloud

...

### Reg.ru Cloud

...
