FROM php:8.3-cli

WORKDIR /app

RUN apt-get update && apt-get install -y git unzip libpq-dev && docker-php-ext-install pdo pdo_pgsql
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

COPY . .
RUN composer install --no-interaction

EXPOSE 8000
CMD php artisan migrate --seed && php artisan serve --host=0.0.0.0 --port=8000

