FROM composer:2 AS composer

# Alpine-based PHP-FPM to keep image size small.
FROM php:8.3-fpm-alpine

LABEL org.opencontainers.image.title="lemp-laravel app image" \
    org.opencontainers.image.description="Lightweight PHP-FPM image for Laravel in LEMP stack" \
    org.opencontainers.image.authors="Pashinoh" \
    maintainer="Pashinoh"

RUN apk add --no-cache \
    icu-dev \
    libzip-dev \
    oniguruma-dev \
    $PHPIZE_DEPS \
    && docker-php-ext-install -j$(nproc) pdo_mysql bcmath opcache zip \
    && apk del $PHPIZE_DEPS

COPY --from=composer /usr/bin/composer /usr/local/bin/composer

WORKDIR /var/www/html

CMD ["php-fpm"]
