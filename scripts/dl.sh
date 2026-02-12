#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
PACKAGE_DIR="$REPO_ROOT/DailyLeetCode"
DEFAULT_RUNNER="DailyLeetCodeRunner"
DEFAULT_SCAFFOLDER="ProblemScaffolder"

print_help() {
  cat <<'EOF'
Usage: scripts/dl.sh <command> [options]

Commands:
  run|r         Run tasks (default: enabled only)
  fetch|f       Fetch problem metadata by URL
  scaffold|s    Generate problem scaffold
  list|ls       List tasks
  help|h        Show this help

Examples:
  scripts/dl.sh run
  scripts/dl.sh run --id LT0088
  scripts/dl.sh fetch --url https://leetcode.cn/problems/two-sum/
  scripts/dl.sh scaffold --url https://leetcode.cn/problems/merge-sorted-array/
EOF
}

cd "$PACKAGE_DIR"
if [ $# -eq 0 ]; then
  print_help
  exit 0
fi

case "$1" in
  run|r|fetch|f|list|ls|help|h)
    exec swift run "$DEFAULT_RUNNER" "$@"
    ;;
  scaffold|s)
    exec swift run "$DEFAULT_SCAFFOLDER" "$@"
    ;;
  *)
    echo "Unknown command: $1" >&2
    print_help >&2
    exit 64
    ;;
esac
