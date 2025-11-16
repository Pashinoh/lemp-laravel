FROM php:8.4-fpm-alpine

RUN apk update && apk add \
    git \
    zip \
    unzip \
    
    && docker-php-ext-install pdo_mysql opcache bcmath exif pcntl

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

WORKDIR /var/www/html
RUN chown -R www-data:www-data /var/www/html
USER www-data

CMD ["php-fpm"]