FROM python:3.11-slim

# Install cron
RUN apt-get update && apt-get install -y --no-install-recommends cron \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copy only necessary files first for better caching
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Now copy the rest of the app
COPY . .

# Copy and configure crontab
COPY cerberus-crontab /etc/cron.d/cerberus-crontab
RUN chmod 0644 /etc/cron.d/cerberus-crontab && crontab /etc/cron.d/cerberus-crontab

# Set permissions for the scripts
RUN chmod +x /app/cerberus-healthcheck.sh /app/entrypoint.sh

# Expose Flask port
EXPOSE 5000

# Start Flask + Cron
CMD ["./entrypoint.sh"]
