FROM php:7.4-apache

ENV APACHE_DOCUMENT_ROOT /var/www/html/public

COPY --from=composer:latest /usr/bin/composer /usr/local/bin/composer

COPY ./ /var/www/html/

WORKDIR /var/www/html

RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf
RUN sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y git

RUN docker-php-ext-install mysqli pdo pdo_mysql \
    && docker-php-ext-enable pdo_mysql \
    && a2enmod rewrite