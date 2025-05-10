FROM php:8.1-fpm-alpine

# Install PHP extensions and system packages
RUN apk update \
    && apk upgrade --no-cache \
    && apk add --no-cache \
    nginx \
    supervisor \
    bash \
    curl \
    zip \
    unzip \
    && apk add --no-cache --virtual .build-deps \
    libzip-dev \
    icu-dev \
    oniguruma-dev \
    libpng-dev \
    libjpeg-turbo-dev \
    freetype-dev \
    libxml2-dev \
    postgresql-dev \
    && docker-php-ext-configure gd \
       --with-freetype=/usr/include/ \
       --with-jpeg=/usr/include/ \
    && docker-php-ext-install pdo pdo_mysql pdo_pgsql mysqli mbstring zip intl xml gd \
    && apk del .build-deps

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Create Laravel working directory
WORKDIR /var/www/html

COPY . .

RUN apk add --no-cache --virtual .build-deps git \
    && git config --global --add safe.directory /var/www/html/vendor/theseer/tokenizer \
    && composer install --no-dev --optimize-autoloader \
    && apk del .build-deps

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

# Fix Vulnerability splish-lite to monorepos
RUN rm -f vendor/laravel/framework/bin/splitsh-lite

EXPOSE 80

#USER www-data
# Start both Nginx and PHP-FPM using Supervisor
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]
