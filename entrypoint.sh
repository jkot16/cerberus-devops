#!/bin/bash

# Start the Flask server in the background
python app.py &

# Start cron in the foreground
cron -f