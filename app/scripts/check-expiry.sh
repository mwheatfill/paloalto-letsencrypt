#!/bin/bash
# Check certificate expiry

DOMAIN=${1:-$DOMAIN}
CERT_FILE="/app/certs/config/live/$DOMAIN/cert.pem"

if [ ! -f "$CERT_FILE" ]; then
    echo "Certificate not found: $CERT_FILE"
    exit 1
fi

# Check expiry date
EXPIRY_DATE=$(openssl x509 -enddate -noout -in "$CERT_FILE" | cut -d= -f2)
EXPIRY_EPOCH=$(date -d "$EXPIRY_DATE" +%s)
CURRENT_EPOCH=$(date +%s)
DAYS_LEFT=$(( ($EXPIRY_EPOCH - $CURRENT_EPOCH) / 86400 ))

echo "Certificate expires: $EXPIRY_DATE"
echo "Days until expiry: $DAYS_LEFT"

if [ $DAYS_LEFT -lt 30 ]; then
    echo "WARNING: Certificate expires in less than 30 days!"
    exit 1
fi
