#!/bin/bash
ssl_dir=/etc/nginx/ssl/
ssl_key=$ssl_dir/nginx.key
ssl_cert=$ssl_dir/nginx.crt
if [ -f "$ssl_key" ] && [ -f "$ssl_cert" ]; then

    echo "SSL certificates already exist. Checking the certificate age..."
    cert_start_date=$(openssl x509 -in $ssl_cert -noout -startdate | cut -d'=' -f2)
    cert_start_date_epoch=$(date -d "$(echo $cert_start_date | sed 's/ GMT//')" +%s)
    current_date_epoch=$(date +%s)

    cert_age_days=$(( (current_date_epoch - cert_start_date_epoch) / 86400 ))

    if [ "$cert_age_days" -gt 364 ]; then
        echo "SSL certificate is older than 364 days. Regenerating..."

        rm -f $ssl_key $ssl_cert

        openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
            -keyout $ssl_key -out $ssl_cert -subj "/CN=localhost"

        echo "New SSL certificates have been generated and stored in $ssl_dir."
    else
        echo "SSL certificates are still valid. No need to regenerate."
    fi
else
    echo "SSL certificates do not exist. Generating new certificates..."
    
    mkdir -p $ssl_dir

    openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
        -keyout $ssl_key -out $ssl_cert -subj "/CN=localhost"

    echo "SSL certificates have been generated and stored in $ssl_dir."
fi