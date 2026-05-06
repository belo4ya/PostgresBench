ROOT_DIR := $(abspath $(dir $(lastword $(MAKEFILE_LIST)))/..)
PB := $(ROOT_DIR)/.belo4ya/scripts/pb

PROVIDER ?= yandex-cloud
SCENARIO ?= yc_4cpu_16gb_6849_network_ssd

.PHONY: help list shared-render shared-init shared-plan shared-apply shared-destroy shared-output render inventory init plan apply destroy setup smoke start status fetch test

help:
	@printf '%s\n' \
		'Usage: make -f .belo4ya/Makefile <target> PROVIDER=yandex-cloud SCENARIO=yc_4cpu_16gb_6849_network_ssd' \
		'' \
		'Targets:' \
		'  list       List benchmark scenarios' \
		'  shared-render  Render shared provider Terraform vars into .belo4ya/.runs' \
		'  shared-init    Run terraform init for shared provider infrastructure' \
		'  shared-plan    Run terraform plan for shared provider infrastructure' \
		'  shared-apply   Run terraform apply for shared provider infrastructure' \
		'  shared-destroy Run terraform destroy for shared provider infrastructure' \
		'  shared-output  Show shared provider Terraform outputs' \
		'  render     Render local tfvars and Ansible vars into .belo4ya/.runs' \
		'  inventory  Build Ansible inventory from terraform output -json' \
		'  init       Run terraform init for the scenario provider' \
		'  plan       Run terraform plan for the scenario' \
		'  apply      Run terraform apply and refresh inventory' \
		'  destroy    Run terraform destroy' \
		'  setup      Prepare the benchmark client VM with Ansible' \
		'  smoke      Run cheap connectivity/readiness checks' \
		'  start      Start the full benchmark as a remote systemd unit' \
		'  status     Show remote benchmark unit/result status' \
		'  fetch      Fetch result JSON and logs from the benchmark client' \
		'  test       Run local layout/CLI tests'

list:
	@$(PB) list

shared-render:
	@$(PB) shared-render $(PROVIDER)

shared-init:
	@$(PB) shared-terraform-init $(PROVIDER)

shared-plan:
	@$(PB) shared-terraform-plan $(PROVIDER)

shared-apply:
	@$(PB) shared-terraform-apply $(PROVIDER)

shared-destroy:
	@$(PB) shared-terraform-destroy $(PROVIDER)

shared-output:
	@$(PB) shared-terraform-output $(PROVIDER)

render:
	@$(PB) render $(PROVIDER) $(SCENARIO)

inventory:
	@$(PB) inventory $(PROVIDER) $(SCENARIO)

init:
	@$(PB) terraform-init $(PROVIDER) $(SCENARIO)

plan:
	@$(PB) terraform-plan $(PROVIDER) $(SCENARIO)

apply:
	@$(PB) terraform-apply $(PROVIDER) $(SCENARIO)

destroy:
	@$(PB) terraform-destroy $(PROVIDER) $(SCENARIO)

setup:
	@$(PB) ansible-setup $(PROVIDER) $(SCENARIO)

smoke:
	@$(PB) ansible-smoke $(PROVIDER) $(SCENARIO)

start:
	@$(PB) ansible-start $(PROVIDER) $(SCENARIO)

status:
	@$(PB) ansible-status $(PROVIDER) $(SCENARIO)

fetch:
	@$(PB) ansible-fetch $(PROVIDER) $(SCENARIO)

test:
	@bash $(ROOT_DIR)/.belo4ya/tests/test_pb.sh
	@bash $(ROOT_DIR)/.belo4ya/tests/test_yandex_terraform_resources.sh
	@bash $(ROOT_DIR)/.belo4ya/tests/test_ansible_benchmark_unit.sh
