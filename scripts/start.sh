#!/bin/sh

# Start script for high-performance WordPress webserver

echo "Starting OpenPress WebServer..."

# Create necessary directories
mkdir -p /var/log/nginx /var/log/php82 /tmp/modsecurity /ssl /letsencrypt

# Set permissions
chown -R www-data:www-data /var/www/html /var/log/php82 /ssl /letsencrypt
chmod -R 755 /var/www/html

# Generate self-signed certificate if SSL doesn't exist
if [ ! -f /ssl/live/yourdomain.com/fullchain.pem ]; then
    echo "Generating self-signed certificate..."
    mkdir -p /ssl/live/yourdomain.com
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
        -keyout /ssl/live/yourdomain.com/privkey.pem \
        -out /ssl/live/yourdomain.com/fullchain.pem \
        -subj "/C=US/ST=State/L=City/O=Organization/CN=yourdomain.com"
fi

# Request Let's Encrypt certificate if domain is configured
if [ "$DOMAIN" != "yourdomain.com" ] && [ "$EMAIL" != "admin@yourdomain.com" ]; then
    echo "Requesting Let's Encrypt certificate for $DOMAIN..."

    # Wait for nginx to start
    sleep 5

    # Get certificate
    certbot certonly --webroot -w /var/www/html \
        -d $DOMAIN -d www.$DOMAIN \
        --email $EMAIL \
        --agree-tos \
        --non-interactive \
        --rsa-key-size 4096

    if [ $? -eq 0 ]; then
        echo "SSL certificate obtained successfully"
        # Update nginx configuration with real SSL paths
        sed -i "s|/ssl/live/yourdomain.com|/etc/letsencrypt/live/$DOMAIN|g" /usr/local/openresty/nginx/conf/sites-enabled/wordpress
    else
        echo "Failed to obtain SSL certificate, using self-signed"
    fi
fi

# Start PHP-FPM
echo "Starting PHP-FPM..."
php-fpm82 -D

# Start Nginx
echo "Starting Nginx..."
nginx -g "daemon off;"
