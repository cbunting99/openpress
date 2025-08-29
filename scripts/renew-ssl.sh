#!/bin/sh

# SSL Certificate renewal script

echo "Checking SSL certificates..."

# Check if certificates exist and are near expiry
if [ -f /etc/letsencrypt/live/$DOMAIN/fullchain.pem ]; then
    # Check certificate expiry (30 days)
    expiry_date=$(openssl x509 -in /etc/letsencrypt/live/$DOMAIN/fullchain.pem -noout -enddate | cut -d= -f2)
    expiry_timestamp=$(date -d "$expiry_date" +%s)
    current_timestamp=$(date +%s)
    days_until_expiry=$(( (expiry_timestamp - current_timestamp) / 86400 ))

    if [ $days_until_expiry -le 30 ]; then
        echo "Certificate expires in $days_until_expiry days. Renewing..."

        # Stop nginx temporarily
        nginx -s stop

        # Renew certificate
        certbot renew --webroot -w /var/www/html

        if [ $? -eq 0 ]; then
            echo "Certificate renewed successfully"
        else
            echo "Certificate renewal failed"
        fi

        # Start nginx again
        nginx
    else
        echo "Certificate is valid for $days_until_expiry more days"
    fi
else
    echo "No Let's Encrypt certificate found"
fi
