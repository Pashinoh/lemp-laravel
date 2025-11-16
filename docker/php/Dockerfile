FROM php:8.4-fpm-alpine

RUN apk update && apk add --no-cache \
    git \
    zip \
    unzip \
    oniguruma-dev \
    freetype-dev \
    libjpeg-turbo-dev \
    libpng-dev \
    icu-dev \
    libzip-dev \
    $PHPIZE_DEPS

RUN docker-php-ext-configure gd \
        --with-freetype \
        --with-jpeg \
    && docker-php-ext-install \
        pdo_mysql \
        bcmath \
        gd \
        intl \
        zip \
        exif \
        pcntl \
        opcache

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

WORKDIR /var/www/html

RUN mkdir -p /var/www/html/storage /var/www/html/bootstrap/cache \
    && chown -R www-data:www-data /var/www/html

USER www-data

CMD ["php-fpm"]
