#!/bin/bash
# Automated renewal and deployment script

echo "$(date): Starting certificate renewal process..."

# Renew certificates
certbot renew \
  --config-dir /app/certs/config \
  --work-dir /app/certs/work \
  --logs-dir /app/logs \
  --quiet

if [ $? -eq 0 ]; then
    echo "$(date): Certificate renewal successful"
    
    # Prepare certificates for Palo Alto
    /app/scripts/prepare-palo-certs.sh "$DOMAIN"
    
    # Upload to Palo Alto (uncomment when ready)
    # python3 /app/scripts/upload-to-palo.py
    
    echo "$(date): Certificate deployment completed"
else
    echo "$(date): Certificate renewal failed"
fi
