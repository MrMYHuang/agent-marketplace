#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage:
  run_sqlcl.sh --connection <saved-connection-name> --sql-file <path.sql>

Runs a SQLcl script through a saved named connection:
  sql -name "<saved-connection-name>" @<path.sql>
EOF
}

connection=""
sql_file=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --connection)
      connection="${2:-}"
      shift 2
      ;;
    --sql-file)
      sql_file="${2:-}"
      shift 2
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown argument: $1" >&2
      usage >&2
      exit 1
      ;;
  esac
done

if [[ -z "$connection" || -z "$sql_file" ]]; then
  usage >&2
  exit 1
fi

if [[ ! -f "$sql_file" ]]; then
  echo "SQL file not found: $sql_file" >&2
  exit 1
fi

exec sql -name "$connection" @"$sql_file"
