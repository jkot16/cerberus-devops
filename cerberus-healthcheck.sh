#!/bin/bash

# cerberus-healthcheck.sh – Health Check and Monitoring for Cerberus

LOG_FILE="/app/cerberus.log"
WEBHOOK_URL="$CERBERUS_WEBHOOK_URL"

# Check if the webhook URL is set
if [ -z "$WEBHOOK_URL" ]; then
    echo "Webhook URL is not set. Aborting."
    exit 1
fi

# Ping the application with a timeout
RESPONSE=$(curl --max-time 5 -s -o /dev/null -w "%{http_code}" http://localhost:5000/ping)

# Get Warsaw time
TIMESTAMP=$(TZ="Europe/Warsaw" date '+%Y-%m-%d %H:%M:%S')

# Determine status and embed color
if [ "$RESPONSE" == "200" ]; then
    STATUS_TEXT="Cerberus is guarding the gates – all clear 🟢"
    COLOR=3066993
else
    STATUS_TEXT="Cerberus is missing from his post! ❌ Status: $RESPONSE"
    COLOR=15158332
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
     "$WEBHOOK_URL"
