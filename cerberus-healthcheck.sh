#!/bin/bash

# cerberus-healthcheck.sh – Health Check and Monitoring for Cerberus

LOG_FILE="/app/cerberus.log"

# Check if the webhook URL is set
if [ -z "$CERBERUS_WEBHOOK_URL" ]; then
    echo "Webhook URL is not set. Aborting."
    exit 1
fi

RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" http://localhost/ping)
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

# Determine status and embed color
if [ "$RESPONSE" == "200" ]; then
    COLOR=3066993
    STATUS_TEXT="Cerberus is guarding the gates – all clear 🟢"
else
    COLOR=15158332
    STATUS_TEXT="Cerberus is missing from his post! ❌ Status: $RESPONSE"
fi

# Log to file
echo "[$TIMESTAMP] $STATUS_TEXT" >> "$LOG_FILE"

# Build Discord embed JSON
JSON=$(cat <<EOF
{
  "embeds": [{
    "title": "Cerberus Watchdog Status",
    "description": "$STATUS_TEXT",
    "color": $COLOR,
    "footer": {
      "text": "Cerberus Monitoring • $TIMESTAMP"
    },
    "thumbnail": {
      "url": "https://raw.githubusercontent.com/jkot16/cerberus-devops/main/static/cerberus-logo.png"
    }
  }]
}
EOF
)

# Send the payload to Discord
curl -s -H "Content-Type: application/json" \
     -X POST \
     --data "$JSON" \
     "$CERBERUS_WEBHOOK_URL"
