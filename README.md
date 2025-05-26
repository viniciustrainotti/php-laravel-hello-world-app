# PHP with Laravel and Dynatrace Setup

This is repository Hello World App PHP with Laravel 10.

## Pre-requisites

### Install Debian Dependencies and asdf php version

```bash
sudo apt install -y autoconf bison re2c libxml2-dev libssl-dev libcurl4-openssl-dev \
    libjpeg-dev libpng-dev libonig-dev libsqlite3-dev libreadline-dev libzip-dev pkg-config \
    locate build-essential libgd-dev libpq-dev
asdf install php 8.1.3
asdf set php 8.1.3
composer --version
# Composer version 2.8.8 2025-04-04 16:56:46
# PHP version 8.1.3 (/home/user/.asdf/installs/php/8.1.3/bin/php)
# Run the "diagnose" command to get more detailed diagnostics output.
```

## Usage

```sh
cp .env.example .env
composer update
php artisan serve
# Generate APP_KEY env or set directly into .env
```

## Docker

```sh
docker build -t laravel-single .
docker run -it --rm -p 8080:80 laravel-single
```

## Add Dynatrace

```sh
docker login <DT_TENANT>.live.dynatrace.com -u <DT_TENANT>
# Password: PaaS Token
docker build --build-arg DT_ENV_ID=<DT_TENANT> -t laravel-hello-world:dynatrace-base -f dockerfile.dynatrace.base .
docker build -t laravel-single:latest \
    -f dockerfile.dynatrace.deploy .
```
