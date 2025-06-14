#!/bin/bash
# Setup script for initial configuration

echo "Setting up Palo Alto Certificate Automation..."

# Create CloudFlare credentials
if [ ! -f /app/config/cloudflare.ini ]; then
    echo "Creating CloudFlare credentials file..."
    cat > /app/config/cloudflare.ini << EOF
dns_cloudflare_email = ${CLOUDFLARE_EMAIL}
dns_cloudflare_api_key = ${CLOUDFLARE_API_KEY}
EOF
    chmod 600 /app/config/cloudflare.ini
    echo "CloudFlare credentials created."
fi

# Create Palo Alto config
if [ ! -f /app/config/palo-config.json ]; then
    echo "Creating Palo Alto configuration..."
    cat > /app/config/palo-config.json << EOF
{
    "hostname": "${PALO_HOST}",
    "username": "${PALO_USER}",
    "password": "${PALO_PASS}",
    "cert_name": "letsencrypt-$(date +%Y%m%d)"
}
EOF
    chmod 600 /app/config/palo-config.json
    echo "Palo Alto configuration created."
fi

echo "Setup complete!"
