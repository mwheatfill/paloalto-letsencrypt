FROM ubuntu:22.04

# Metadata labels
LABEL maintainer="michael@wheatfill.com"
LABEL version="1.0.0"
LABEL description="Automated Let's Encrypt certificate generation and deployment for Palo Alto Networks firewalls"
LABEL org.opencontainers.image.title="Palo Alto Let's Encrypt Certificate Manager"
LABEL org.opencontainers.image.description="Automates Let's Encrypt certificate generation using Cloudflare DNS challenges and deploys them to Palo Alto Networks firewalls via API"
LABEL org.opencontainers.image.version="1.0.0"
LABEL org.opencontainers.image.authors="Michael Wheatfill <michael@wheatfill.com>"
LABEL org.opencontainers.image.url="https://github.com/mwheatfill/paloalto-letsencrypt"
LABEL org.opencontainers.image.documentation="https://github.com/mwheatfill/paloalto-letsencrypt/blob/main/README.md"
LABEL org.opencontainers.image.source="https://github.com/mwheatfill/paloalto-letsencrypt"
LABEL org.opencontainers.image.licenses="MIT"

ENV DEBIAN_FRONTEND=noninteractive

# Update and install packages
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

# Install Python packages
RUN pip3 install pan-python certbot-dns-cloudflare

WORKDIR /app
RUN mkdir -p /app/certs /app/scripts /app/config /app/logs

# Copy automation scripts into the container
COPY scripts/ /app/scripts/

# Make scripts executable
RUN chmod +x /app/scripts/*.sh

# Set up cron for automatic renewal
RUN echo "0 3 * * * /app/scripts/renew-and-deploy.sh >> /app/logs/renewal.log 2>&1" | crontab -

# Create log rotation config
RUN echo "/app/logs/*.log {\n    daily\n    rotate 30\n    compress\n    delaycompress\n    missingok\n    create 644 root root\n}" > /etc/logrotate.d/certbot-automation

# Environment variables (non-sensitive only)
ENV DOMAIN="" \
    EMAIL="" \
    PALO_HOST="" \
    PALO_USER="" \
    CLOUDFLARE_EMAIL=""

# Health check
HEALTHCHECK --interval=24h --timeout=30s --start-period=5m --retries=3 \
  CMD /app/scripts/cert-health-check.sh || exit 1

# Use JSON format for CMD to handle signals properly
CMD ["sh", "-c", "cron && tail -f /dev/null"]
