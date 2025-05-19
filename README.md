# Hello World PHP with Laravel

This is repository Hello World App PHP with Laravel 10.

## Pre-requisites

```sh
# Composer version 2.8.8 2025-04-04 16:56:46
# PHP version 8.1.3 (/home/user/.asdf/installs/php/8.1.3/bin/php)
# Run the "diagnose" command to get more detailed diagnostics output.
```

## Usage

```sh
cp .env.example .env
composer update
php artisan serve
# Generate APP_KEY env
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
