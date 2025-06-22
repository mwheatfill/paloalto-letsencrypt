#!/bin/bash
# Prepare certificates for Palo Alto

DOMAIN=${1:-$DOMAIN}
CERT_DIR="/app/certs/config/live/$DOMAIN"
OUTPUT_DIR="/app/certs/palo-ready"

if [ ! -d "$CERT_DIR" ]; then
    echo "Certificate directory not found: $CERT_DIR"
    exit 1
fi

mkdir -p "$OUTPUT_DIR"

# Copy files with Palo Alto friendly names
cp "$CERT_DIR/fullchain.pem" "$OUTPUT_DIR/certificate.pem"
cp "$CERT_DIR/privkey.pem" "$OUTPUT_DIR/private-key.pem"
cp "$CERT_DIR/chain.pem" "$OUTPUT_DIR/certificate-chain.pem"

# Create combined file (cert + key) for some Palo Alto configurations
cat "$CERT_DIR/cert.pem" "$CERT_DIR/privkey.pem" > "$OUTPUT_DIR/combined.pem"

echo "Palo Alto ready certificates created in $OUTPUT_DIR"
ls -la "$OUTPUT_DIR"

# Verify certificates
echo "Certificate verification:"
openssl x509 -in "$OUTPUT_DIR/certificate.pem" -text -noout | grep -E "(Subject:|Not After|DNS:)"
