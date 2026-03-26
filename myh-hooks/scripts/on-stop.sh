#!/bin/bash
# Hook: Stop event - Notify user when agent response is complete

set -e

# Read input JSON from stdin
input=$(cat)

# Extract cwd from input JSON
cwd=$(echo "$input" | sed -n 's/.*"cwd"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p')

# Determine notification method and send notification
if command -v terminal-notifier &>/dev/null; then
  # macOS: Use terminal-notifier for better integration
  terminal-notifier \
    -title 'GitHub Copilot' \
    -message 'Response complete' \
    -sound 'Glass' \
    -execute "open -a 'Visual Studio Code' \"$cwd\""
else
  # Fallback: Use osascript for native macOS notification
  osascript -e 'display notification "Response complete" with title "GitHub Copilot" sound name "Glass"'
fi
