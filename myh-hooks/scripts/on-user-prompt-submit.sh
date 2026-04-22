#!/bin/bash
# Hook: UserPromptSubmit event - Notify user when a prompt is submitted

set -e

# Read input JSON from stdin
input=$(cat)

# Extract cwd from input JSON
cwd=$(echo "$input" | sed -n 's/.*"cwd"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p')

# Determine notification method and send notification
if command -v terminal-notifier &>/dev/null; then
  terminal-notifier \
    -title 'GitHub Copilot' \
    -message "Prompt submitted at $(date '+%H:%M:%S')" \
    -sound 'Glass' \
    -execute "open -a 'Visual Studio Code' \"$cwd\""
else
  osascript -e "display notification \"Prompt submitted at $(date '+%H:%M:%S')\" with title \"GitHub Copilot\" sound name \"Glass\""
fi
