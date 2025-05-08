FROM php:8.1-fpm-alpine

# Install PHP extensions and system packages
RUN apk add --no-cache \
    nginx \
    supervisor \
    bash \
    curl \
    libzip-dev \
    zip \
    unzip \
    icu-dev \
    oniguruma-dev \
    libpng-dev \
    libjpeg-turbo-dev \
    freetype-dev \
    libxml2-dev \
    postgresql-dev \
    git \
    && docker-php-ext-install pdo pdo_pgsql mbstring zip intl xml gd

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Create Laravel working directory
WORKDIR /var/www/html

COPY . .

RUN git config --global --add safe.directory /var/www/html/vendor/theseer/tokenizer \
    && composer install --no-dev --optimize-autoloader

RUN composer install --no-dev --optimize-autoloader

# Set correct permissions
RUN mkdir -p storage/logs bootstrap/cache \
    && chown -R www-data:www-data /var/www/html \
    && chmod -R 775 storage bootstrap/cache

# Copy Nginx config
COPY docker/nginx.conf /etc/nginx/nginx.conf
COPY docker/default.conf /etc/nginx/conf.d/default.conf

# Copy Supervisor config
COPY docker/supervisord.conf /etc/supervisord.conf

# Copy Custom PHP config
COPY docker/php/conf.d/ /usr/local/etc/php/conf.d/

EXPOSE 80

#USER www-data
# Start both Nginx and PHP-FPM using Supervisor
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]
