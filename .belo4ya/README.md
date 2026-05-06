# PostgresBench automation workspace

This directory contains the local automation layer for reproducible benchmark
runs. The current bootstrap is scoped to Yandex Cloud `network-ssd` scenarios.

## Stack

- Terraform creates and destroys cloud infrastructure.
- cloud-init performs only the first VM bootstrap needed for Ansible access.
- Ansible prepares the client VM, runs smoke checks, starts the benchmark as a
  durable systemd unit, checks status, and fetches artifacts.
- Make exposes stable local commands.
- Bash is used for small glue scripts and for the existing repository `run.sh`.

## Commands

Run from the repository root:

```sh
make -f .belo4ya/Makefile list
make -f .belo4ya/Makefile shared-plan PROVIDER=yandex-cloud
make -f .belo4ya/Makefile shared-apply PROVIDER=yandex-cloud
make -f .belo4ya/Makefile render PROVIDER=yandex-cloud SCENARIO=yc_4cpu_16gb_6849_network_ssd
make -f .belo4ya/Makefile inventory PROVIDER=yandex-cloud SCENARIO=yc_4cpu_16gb_6849_network_ssd
make -f .belo4ya/Makefile setup PROVIDER=yandex-cloud SCENARIO=yc_4cpu_16gb_6849_network_ssd
make -f .belo4ya/Makefile smoke PROVIDER=yandex-cloud SCENARIO=yc_4cpu_16gb_6849_network_ssd
make -f .belo4ya/Makefile start PROVIDER=yandex-cloud SCENARIO=yc_4cpu_16gb_6849_network_ssd
make -f .belo4ya/Makefile status PROVIDER=yandex-cloud SCENARIO=yc_4cpu_16gb_6849_network_ssd
make -f .belo4ya/Makefile fetch PROVIDER=yandex-cloud SCENARIO=yc_4cpu_16gb_6849_network_ssd
```

Generated runtime files live under `.belo4ya/.runs/` and are intentionally
ignored by git.

The Yandex Cloud automation is split into two Terraform layers:

- `yandex-cloud/shared/terraform` manages reusable provider-level networking:
  VPC, subnet, client security group, and PostgreSQL security group.
- `yandex-cloud/terraform` manages scenario resources: benchmark client VM,
  Managed PostgreSQL cluster, benchmark user, and database. It reads shared
  networking IDs from the shared layer Terraform state.

## Current scope

The current Yandex Cloud bootstrap assumes the `postgresbench` folder and
service account already exist. Provider-level network resources are declarative
and reproducible through the shared Terraform layer.

Service account keys and other local secrets live under `.belo4ya/secrets/`.
That directory is ignored by git.
