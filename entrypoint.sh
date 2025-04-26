#!/bin/bash

# Create /status endpoint log file
touch /app/cerberus.log

# Export webhook URL for cron to access
echo "CERBERUS_WEBHOOK_URL=${CERBERUS_WEBHOOK_URL}" >> /etc/environment


# Start the Flask server in the background
python app.py &

# Start cron in the foreground
cron -f
