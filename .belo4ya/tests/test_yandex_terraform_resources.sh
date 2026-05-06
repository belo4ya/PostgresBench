#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
TF_DIR="$ROOT_DIR/yandex-cloud/terraform"
SHARED_TF_DIR="$ROOT_DIR/yandex-cloud/shared/terraform"

fail() {
  echo "FAIL: $*" >&2
  exit 1
}

assert_rg() {
  local pattern=$1
  local path=$2
  rg -q "$pattern" "$path" || fail "expected pattern '$pattern' in $path"
}

assert_not_rg() {
  local pattern=$1
  local path=$2
  if rg -q "$pattern" "$path"; then
    fail "unexpected pattern '$pattern' in $path"
  fi
}

assert_not_rg 'resource "yandex_vpc_network" "benchmark"' "$TF_DIR"
assert_not_rg 'resource "yandex_vpc_subnet" "benchmark"' "$TF_DIR"
assert_not_rg 'resource "yandex_vpc_security_group" "client"' "$TF_DIR"
assert_not_rg 'resource "yandex_vpc_security_group" "postgres"' "$TF_DIR"
assert_rg 'data "terraform_remote_state" "shared"' "$TF_DIR"
assert_rg 'data "yandex_compute_image" "ubuntu"' "$TF_DIR"
assert_rg 'resource "yandex_compute_instance" "client"' "$TF_DIR"
assert_rg 'resource "yandex_mdb_postgresql_cluster" "benchmark"' "$TF_DIR"
assert_rg 'resource "yandex_mdb_postgresql_user" "benchmark"' "$TF_DIR"
assert_rg 'resource "yandex_mdb_postgresql_database" "benchmark"' "$TF_DIR"

assert_rg 'yandex_compute_instance\.client\.network_interface\[0\]\.nat_ip_address' "$TF_DIR/outputs.tf"
assert_rg 'yandex_compute_instance\.client\.network_interface\[0\]\.ip_address' "$TF_DIR/outputs.tf"
assert_rg 'yandex_mdb_postgresql_cluster\.benchmark\.host\[0\]\.fqdn' "$TF_DIR/outputs.tf"
assert_not_rg 'value\s+=\s+null' "$TF_DIR/outputs.tf"
assert_rg 'conn_limit\s+=\s+var\.postgres\.user_conn_limit' "$TF_DIR/main.tf"
assert_rg 'max_connections\s+=\s+tostring\(var\.postgres\.max_connections\)' "$TF_DIR/main.tf"
assert_rg 'network_id\s+=\s+data\.terraform_remote_state\.shared\.outputs\.network_id' "$TF_DIR/main.tf"
assert_rg 'subnet_id\s+=\s+data\.terraform_remote_state\.shared\.outputs\.subnet_id' "$TF_DIR/main.tf"
assert_rg 'security_group_ids\s+=\s+\[data\.terraform_remote_state\.shared\.outputs\.client_security_group_id\]' "$TF_DIR/main.tf"
assert_rg 'security_group_ids\s+=\s+\[data\.terraform_remote_state\.shared\.outputs\.postgres_security_group_id\]' "$TF_DIR/main.tf"

assert_rg 'resource "yandex_vpc_network" "benchmark"' "$SHARED_TF_DIR"
assert_rg 'resource "yandex_vpc_subnet" "benchmark"' "$SHARED_TF_DIR"
assert_rg 'resource "yandex_vpc_security_group" "client"' "$SHARED_TF_DIR"
assert_rg 'resource "yandex_vpc_security_group" "postgres"' "$SHARED_TF_DIR"
assert_rg 'output "network_id"' "$SHARED_TF_DIR/outputs.tf"
assert_rg 'output "subnet_id"' "$SHARED_TF_DIR/outputs.tf"
assert_rg 'output "client_security_group_id"' "$SHARED_TF_DIR/outputs.tf"
assert_rg 'output "postgres_security_group_id"' "$SHARED_TF_DIR/outputs.tf"

echo "ok"
