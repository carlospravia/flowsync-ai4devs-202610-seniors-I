#!/usr/bin/env bash
# PostToolUse hook: run Prettier on files the agent edits under frontend/src/.
file=$(jq -r '.tool_input.file_path // empty')
[[ -z "$file" ]] && exit 0
case "$file" in
  "$CLAUDE_PROJECT_DIR"/frontend/src/*) ;;
  *) exit 0 ;;
esac
[[ -f "$file" ]] || exit 0
cd "$CLAUDE_PROJECT_DIR/frontend" || exit 0
npx --no-install prettier --write --log-level warn "$file" >&2 || exit 0
