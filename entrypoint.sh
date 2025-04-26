#!/bin/bash

# Create /status endpoint log file
touch /app/cerberus.log

# Start the Flask server in the background
python app.py &

# Start cron in the foreground
cron -f