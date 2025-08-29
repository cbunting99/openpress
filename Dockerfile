FROM openresty/openresty:alpine

# Install dependencies
RUN apk add --no-cache \
    curl \
    wget \
    git \
    build-base \
    openssl-dev \
    pcre-dev \
    zlib-dev \
    lua-dev \
    libxml2-dev \
    libxslt-dev \
    gd-dev \
    geoip-dev \
    libmaxminddb-dev \
    yajl-dev \
    ssdeep-dev \
    lua-resty-core \
    lua-resty-lrucache \
    php82 \
    php82-fpm \
    php82-mysqli \
    php82-json \
    php82-curl \
    php82-gd \
    php82-mbstring \
    php82-xml \
    php82-zip \
    php82-opcache \
    certbot \
    fail2ban \
    && mkdir -p /var/log/nginx /var/cache/nginx /tmp/nginx

# Install ModSecurity
RUN git clone --depth 1 -b v3/master https://github.com/SpiderLabs/ModSecurity.git /tmp/modsecurity \
    && cd /tmp/modsecurity \
    && git submodule init \
    && git submodule update \
    && ./build.sh \
    && ./configure \
    && make \
    && make install \
    && cd / \
    && rm -rf /tmp/modsecurity

# Install ModSecurity-nginx connector
RUN git clone --depth 1 https://github.com/SpiderLabs/ModSecurity-nginx.git /tmp/modsecurity-nginx \
    && wget http://nginx.org/download/nginx-1.21.6.tar.gz \
    && tar -zxvf nginx-1.21.6.tar.gz \
    && cd nginx-1.21.6 \
    && ./configure --with-compat --add-dynamic-module=/tmp/modsecurity-nginx \
    && make modules \
    && cp objs/ngx_http_modsecurity_module.so /usr/local/openresty/nginx/modules/ \
    && cd / \
    && rm -rf /tmp/modsecurity-nginx nginx-1.21.6.tar.gz

# Copy configurations
COPY nginx/nginx.conf /usr/local/openresty/nginx/conf/nginx.conf
COPY nginx/conf.d/ /usr/local/openresty/nginx/conf/conf.d/
COPY nginx/sites-available/ /usr/local/openresty/nginx/conf/sites-available/
COPY nginx/sites-enabled/ /usr/local/openresty/nginx/conf/sites-enabled/
COPY modsecurity/ /etc/modsecurity/
COPY scripts/ /scripts/

# Create necessary directories
RUN mkdir -p /var/www/html /var/log/php82 /run/php /ssl /letsencrypt

# Set permissions
RUN chown -R www-data:www-data /var/www/html /var/log/php82 /ssl /letsencrypt

# Expose ports
EXPOSE 80 443

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD curl -f http://localhost/health || exit 1

# Start services
CMD ["/scripts/start.sh"]
