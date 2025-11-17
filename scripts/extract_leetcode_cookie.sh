#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET_DIR="$SCRIPT_DIR/../DailyLeetCode"
ENV_FILE="$TARGET_DIR/.leetcode.env"
COOKIE_INPUT=""

if [ -p /dev/stdin ]; then
  COOKIE_INPUT="$(cat)"
elif [ $# -gt 0 ]; then
  COOKIE_INPUT="$1"
else
  read -r -p "粘贴整段 Cookie: " COOKIE_INPUT
fi

if [ -z "$COOKIE_INPUT" ]; then
  echo "未提供 Cookie 字符串" >&2
  exit 1
fi

extract_value() {
  local key="$1"
  COOKIE_KEY="$key" python3 - <<'PY'
import os
import re

cookie = os.environ.get('COOKIE_SRC', '')
key = os.environ.get('COOKIE_KEY', '')
if not key:
    print('')
else:
    pattern = re.compile(rf'{re.escape(key)}=([^;]+)')
    match = pattern.search(cookie)
    print(match.group(1) if match else '')
PY
}

export COOKIE_SRC="$COOKIE_INPUT"
CSRFTOKEN="$(extract_value "csrftoken")"
SESSION="$(extract_value "LEETCODE_SESSION")"

if [ -z "$CSRFTOKEN" ] || [ -z "$SESSION" ]; then
  echo "解析失败：未找到 csrftoken 或 LEETCODE_SESSION" >&2
  exit 1
fi

cat > "$ENV_FILE" <<ENV
LEETCODE_SESSION=$SESSION
LEETCODE_CSRF=$CSRFTOKEN
LEETCODE_ENDPOINT=https://leetcode.cn/graphql/
ENV

echo "Wrote credentials to $ENV_FILE"
