#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
ANSIBLE_DIR="$ROOT_DIR/.belo4ya/ansible"
START_PLAYBOOK="$ANSIBLE_DIR/playbooks/start-benchmark.yml"
STATUS_PLAYBOOK="$ANSIBLE_DIR/playbooks/status.yml"
SERVICE_TEMPLATE="$ANSIBLE_DIR/templates/postgresbench.service.j2"

fail() {
  echo "FAIL: $*" >&2
  exit 1
}

assert_file() {
  [[ -f "$1" ]] || fail "expected file: $1"
}

assert_rg() {
  local pattern=$1
  local path=$2
  rg -q -- "$pattern" "$path" || fail "expected pattern '$pattern' in $path"
}

assert_not_rg() {
  local pattern=$1
  local path=$2
  if rg -q -- "$pattern" "$path"; then
    fail "unexpected pattern '$pattern' in $path"
  fi
}

assert_file "$SERVICE_TEMPLATE"

assert_rg 'path:\s+"\{\{ remote\.env_dir \}\}"' "$START_PLAYBOOK"
assert_rg 'group:\s+"\{\{ ansible_user \}\}"' "$START_PLAYBOOK"
assert_rg 'mode:\s+"0750"' "$START_PLAYBOOK"
assert_rg 'dest:\s+"\{\{ remote\.env_file \}\}"' "$START_PLAYBOOK"
assert_rg 'mode:\s+"0640"' "$START_PLAYBOOK"

assert_rg 'postgresbench\.service\.j2' "$START_PLAYBOOK"
assert_rg 'ansible\.builtin\.systemd_service:' "$START_PLAYBOOK"
assert_not_rg 'systemd-run' "$START_PLAYBOOK"
assert_not_rg '--collect' "$START_PLAYBOOK"

assert_rg '^User=\{\{ ansible_user \}\}$' "$SERVICE_TEMPLATE"
assert_rg '^Group=\{\{ ansible_user \}\}$' "$SERVICE_TEMPLATE"
assert_rg '^WorkingDirectory=\{\{ remote\.repo_dir \}\}$' "$SERVICE_TEMPLATE"
assert_rg '^ExecStart=\{\{ remote\.runner_path \}\} \{\{ remote\.env_file \}\}$' "$SERVICE_TEMPLATE"

assert_rg 'LoadState' "$STATUS_PLAYBOOK"

echo "ok"
