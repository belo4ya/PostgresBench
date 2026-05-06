#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
PB="$ROOT_DIR/.belo4ya/scripts/pb"
TMP_DIR=$(mktemp -d)
trap 'rm -rf "$TMP_DIR"' EXIT

fail() {
  echo "FAIL: $*" >&2
  exit 1
}

assert_file() {
  [[ -f "$1" ]] || fail "expected file: $1"
}

assert_contains() {
  local needle=$1
  local haystack=$2
  grep -Fq "$needle" "$haystack" || fail "expected '$needle' in $haystack"
}

assert_jq() {
  local file=$1
  local filter=$2
  jq -e "$filter" "$file" >/dev/null || fail "jq assertion failed for $file: $filter"
}

LIST_OUT="$TMP_DIR/list.out"
"$PB" list >"$LIST_OUT"
assert_contains "yandex-cloud yc_4cpu_16gb_6849_network_ssd" "$LIST_OUT"
assert_contains "yandex-cloud yc_16cpu_64gb_6849_network_ssd" "$LIST_OUT"
assert_contains "yandex-cloud yc_16cpu_64gb_34247_network_ssd" "$LIST_OUT"

SHARED_RUN_DIR="$TMP_DIR/shared"
"$PB" shared-render yandex-cloud --run-dir "$SHARED_RUN_DIR"
assert_file "$SHARED_RUN_DIR/terraform.auto.tfvars.json"
assert_file "$SHARED_RUN_DIR/terraform.tfstate.path"
assert_file "$SHARED_RUN_DIR/backend.hcl"
assert_jq "$SHARED_RUN_DIR/terraform.auto.tfvars.json" '.provider_id == "yandex-cloud"'
assert_jq "$SHARED_RUN_DIR/terraform.auto.tfvars.json" '.name == "postgresbench-yc-shared"'
assert_jq "$SHARED_RUN_DIR/terraform.auto.tfvars.json" '.cloud.cloud_id == "b1g4kfp4qu27rpl3hvrf"'
assert_jq "$SHARED_RUN_DIR/terraform.auto.tfvars.json" '.cloud.folder_id == "b1gfie3oennae9j1bvn7"'
assert_jq "$SHARED_RUN_DIR/terraform.auto.tfvars.json" '.cloud.subnet_cidr_blocks == ["10.10.0.0/24"]'
assert_jq "$SHARED_RUN_DIR/terraform.auto.tfvars.json" '.cloud.ssh_cidr_blocks == ["0.0.0.0/0"]'
assert_jq "$SHARED_RUN_DIR/terraform.auto.tfvars.json" '.cloud.postgres_port == 6432'
assert_contains "$SHARED_RUN_DIR/terraform.tfstate" "$SHARED_RUN_DIR/terraform.tfstate.path"
assert_contains "path = \"$SHARED_RUN_DIR/terraform.tfstate\"" "$SHARED_RUN_DIR/backend.hcl"

RUN_DIR="$TMP_DIR/run"
"$PB" render yandex-cloud yc_4cpu_16gb_6849_network_ssd --run-dir "$RUN_DIR"
assert_file "$RUN_DIR/terraform.auto.tfvars.json"
assert_file "$RUN_DIR/ansible-vars.json"
assert_file "$RUN_DIR/terraform.tfstate.path"
assert_file "$RUN_DIR/backend.hcl"

assert_jq "$RUN_DIR/terraform.auto.tfvars.json" '.provider_id == "yandex-cloud"'
assert_jq "$RUN_DIR/terraform.auto.tfvars.json" '.scenario == "yc_4cpu_16gb_6849_network_ssd"'
assert_jq "$RUN_DIR/terraform.auto.tfvars.json" '.ssh_user == "postgresbench"'
assert_jq "$RUN_DIR/terraform.auto.tfvars.json" '.cloud.cloud_id == "b1g4kfp4qu27rpl3hvrf"'
assert_jq "$RUN_DIR/terraform.auto.tfvars.json" '.cloud.folder_id == "b1gfie3oennae9j1bvn7"'
assert_jq "$RUN_DIR/terraform.auto.tfvars.json" '.cloud.shared_state_path | endswith("/.belo4ya/.runs/yandex-cloud/shared/terraform.tfstate")'
assert_jq "$RUN_DIR/terraform.auto.tfvars.json" '(.cloud.network_id? // null) == null'
assert_jq "$RUN_DIR/terraform.auto.tfvars.json" '(.cloud.subnet_id? // null) == null'
assert_jq "$RUN_DIR/terraform.auto.tfvars.json" '(.cloud.client_security_group_id? // null) == null'
assert_jq "$RUN_DIR/terraform.auto.tfvars.json" '(.cloud.postgres_security_group_id? // null) == null'
assert_jq "$RUN_DIR/terraform.auto.tfvars.json" '.cloud.service_account_id == "ajeietrbobnc9c16fv9s"'
assert_jq "$RUN_DIR/terraform.auto.tfvars.json" '.cloud.service_account_key_file == ".belo4ya/secrets/yandex-cloud/sa/postgresbench/postgresbench-sa-key.json"'
assert_jq "$RUN_DIR/terraform.auto.tfvars.json" '.cloud.ssh_public_key_path == "~/.ssh/postgresbench.pub"'
assert_jq "$RUN_DIR/ansible-vars.json" '.ssh_private_key_path == "~/.ssh/postgresbench"'
assert_jq "$RUN_DIR/terraform.auto.tfvars.json" '.postgres.vcpus == 4'
assert_jq "$RUN_DIR/terraform.auto.tfvars.json" '.postgres.ram_gb == 16'
assert_jq "$RUN_DIR/terraform.auto.tfvars.json" '.postgres.storage.type == "network-ssd"'
assert_jq "$RUN_DIR/terraform.auto.tfvars.json" '.postgres.max_connections == 315'
assert_jq "$RUN_DIR/terraform.auto.tfvars.json" '.postgres.user_conn_limit == 300'
assert_jq "$RUN_DIR/terraform.auto.tfvars.json" '.benchmark.scale_factor == 6849'
assert_jq "$RUN_DIR/terraform.auto.tfvars.json" '.client.vcpus == 8'
assert_jq "$RUN_DIR/terraform.auto.tfvars.json" '.client.ram_gb == 16'

assert_jq "$RUN_DIR/ansible-vars.json" '.pgdatabase == "postgresbench"'
assert_jq "$RUN_DIR/ansible-vars.json" '.min_postgres_connections == 315'
assert_jq "$RUN_DIR/ansible-vars.json" '.required_pgbench_connections == 300'
assert_jq "$RUN_DIR/ansible-vars.json" '.benchmark.out_json == "yandex-cloud/results/yc_4cpu_16gb_6849_network_ssd.json"'
assert_contains "$RUN_DIR/terraform.tfstate" "$RUN_DIR/terraform.tfstate.path"
assert_contains "path = \"$RUN_DIR/terraform.tfstate\"" "$RUN_DIR/backend.hcl"

TF_OUT="$TMP_DIR/tf-output.json"
cat >"$TF_OUT" <<'JSON'
{
  "client_public_ip": {"value": "203.0.113.10"},
  "client_private_ip": {"value": "10.0.0.10"},
  "postgres_host": {"value": "postgresbench.example.internal"},
  "postgres_port": {"value": 6432},
  "postgres_user": {"value": "postgresbench"},
  "postgres_password": {"value": "Qwerty123!"},
  "postgres_database": {"value": "postgresbench"},
  "ssh_user": {"value": "postgresbench"}
}
JSON

"$PB" inventory yandex-cloud yc_4cpu_16gb_6849_network_ssd --run-dir "$RUN_DIR" --terraform-output "$TF_OUT"
assert_file "$RUN_DIR/inventory.ini"
assert_contains "postgresbench-client ansible_host=203.0.113.10 ansible_user=postgresbench ansible_ssh_private_key_file=~/.ssh/postgresbench" "$RUN_DIR/inventory.ini"
assert_contains "postgres_host=postgresbench.example.internal" "$RUN_DIR/inventory.ini"
assert_contains "postgres_port=6432" "$RUN_DIR/inventory.ini"

echo "ok"
