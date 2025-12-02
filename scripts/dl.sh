#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
PACKAGE_DIR="$REPO_ROOT/DailyLeetCode"
DEFAULT_RUNNER=DailyLeetCodeRunner
DEFAULT_SCAFFOLDER=ProblemScaffolder

if [ $# -gt 0 ]; then
  case "$1" in
    runner)
      shift
      cd "$PACKAGE_DIR"
      exec swift run "$DEFAULT_RUNNER" "$@"
      ;;
    scaffold|scaffolder)
      shift
      cd "$PACKAGE_DIR"
      exec swift run "$DEFAULT_SCAFFOLDER" "$@"
      ;;
  esac
fi

# default: runner passthrough
cd "$PACKAGE_DIR"
exec swift run "$DEFAULT_RUNNER" "$@"
