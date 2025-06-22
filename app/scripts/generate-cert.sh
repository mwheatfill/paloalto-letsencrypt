#!/bin/bash
# Generate new certificate

DOMAIN=${1:-$DOMAIN}
EMAIL=${2:-$EMAIL}

if [ -z "$DOMAIN" ] || [ -z "$EMAIL" ]; then
    echo "Usage: $0 <domain> <email>"
    echo "Or set DOMAIN and EMAIL environment variables"
    exit 1
fi

echo "Generating certificate for $DOMAIN..."

certbot certonly \
  --dns-cloudflare \
  --dns-cloudflare-credentials /app/config/cloudflare.ini \
  -d "*.$DOMAIN" \
  -d "$DOMAIN" \
  --preferred-challenges dns-01 \
  --email "$EMAIL" \
  --agree-tos \
  --non-interactive \
  --config-dir /app/certs/config \
  --work-dir /app/certs/work \
  --logs-dir /app/logs \
  --quiet

if [ $? -eq 0 ]; then
    echo "Certificate generated successfully!"
    /app/scripts/prepare-palo-certs.sh "$DOMAIN"
else
    echo "Certificate generation failed!"
    exit 1
fi
