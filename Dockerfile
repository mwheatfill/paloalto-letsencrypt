FROM ubuntu:22.04

# Avoid interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Update package list and install base packages
RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    certbot \
    openssl \
    curl \
    wget \
    jq \
    nano \
    cron \
    logrotate \
    && rm -rf /var/lib/apt/lists/*

# Create symlinks only if they don't exist
RUN [ ! -e /usr/bin/python ] && ln -s /usr/bin/python3 /usr/bin/python || true
RUN [ ! -e /usr/bin/pip ] && ln -s /usr/bin/pip3 /usr/bin/pip || true

# Install Python packages
RUN pip install pan-python certbot-dns-cloudflare

# Create working directories
WORKDIR /app
RUN mkdir -p /app/certs /app/scripts /app/config /app/logs /app/templates

# Copy automation scripts into the container
COPY scripts/ /app/scripts/
COPY templates/ /app/templates/

# Make scripts executable
RUN chmod +x /app/scripts/*.sh

# Set up cron for automatic renewal
RUN echo "0 3 * * * /app/scripts/renew-and-deploy.sh >> /app/logs/renewal.log 2>&1" | crontab -

# Create log rotation config
RUN echo "/app/logs/*.log {\n    daily\n    rotate 30\n    compress\n    delaycompress\n    missingok\n    create 644 root root\n}" > /etc/logrotate.d/certbot-automation

# Set environment variables with defaults
ENV DOMAIN=""
ENV EMAIL=""
ENV PALO_HOST=""
ENV PALO_USER=""
ENV CLOUDFLARE_EMAIL=""

# Keep container running and start cron
CMD ["sh", "-c", "cron && tail -f /dev/null"] 
