# syntax=docker/dockerfile:1

FROM composer:2 AS composer-bin

FROM php:8.4-fpm-alpine AS runtime

LABEL org.opencontainers.image.title="lemp-laravel app image" \
    org.opencontainers.image.description="Lightweight PHP-FPM image for Laravel in LEMP stack" \
    org.opencontainers.image.authors="Pashinoh" \
    maintainer="Pashinoh"

RUN apk add --no-cache \
        icu-libs \
        libzip \
        oniguruma \
    && apk add --no-cache --virtual .build-deps \
        icu-dev \
        libzip-dev \
        $PHPIZE_DEPS \
    && docker-php-ext-install -j$(nproc) \
        pdo_mysql \
        bcmath \
        opcache \
        zip \
        intl \
    && apk del .build-deps \
    && rm -rf /tmp/* /var/cache/apk/* \
    && chown -R www-data:www-data /var/www/html

COPY --from=composer-bin /usr/bin/composer /usr/local/bin/composer

COPY docker/opcache.ini /usr/local/etc/php/conf.d/opcache.ini

USER www-data

WORKDIR /var/www/html

EXPOSE 9000

CMD ["php-fpm"]
