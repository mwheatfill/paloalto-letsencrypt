#!/bin/bash
# Health check script for monitoring

DOMAIN=${DOMAIN}
CERT_FILE="/app/certs/config/live/$DOMAIN/cert.pem"

if [ ! -f "$CERT_FILE" ]; then
    echo "CRITICAL: Certificate file not found"
    exit 2
fi

# Check expiry
EXPIRY_DATE=$(openssl x509 -enddate -noout -in "$CERT_FILE" | cut -d= -f2)
EXPIRY_EPOCH=$(date -d "$EXPIRY_DATE" +%s)
CURRENT_EPOCH=$(date +%s)
DAYS_LEFT=$(( ($EXPIRY_EPOCH - $CURRENT_EPOCH) / 86400 ))

if [ $DAYS_LEFT -lt 7 ]; then
    echo "CRITICAL: Certificate expires in $DAYS_LEFT days"
    exit 2
elif [ $DAYS_LEFT -lt 30 ]; then
    echo "WARNING: Certificate expires in $DAYS_LEFT days"
    exit 1
else
    echo "OK: Certificate expires in $DAYS_LEFT days"
    exit 0
fi