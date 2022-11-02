FROM php:7.4-apache

RUN apt-get update \
    && apt-get install -y --no-install-recommends git zlib1g-dev libzip-dev zip unzip libpng-dev wget

RUN docker-php-ext-install pdo_mysql zip gd opcache
RUN echo 'memory_limit = 2048M' >> /usr/local/etc/php/conf.d/docker-php-memlimit.ini;

RUN a2enmod rewrite headers

RUN curl -sSk https://getcomposer.org/installer | php -- --disable-tls && \
       mv composer.phar /usr/local/bin/composer

RUN wget -O drush.phar https://github.com/drush-ops/drush-launcher/releases/latest/download/drush.phar
RUN chmod +x drush.phar && mv drush.phar /usr/local/bin/drush

COPY apache-vhost.conf /etc/apache2/sites-enabled/000-default.conf

RUN rm -rf /var/lib/apt/lists/*

RUN useradd --uid 1000 zzr
RUN chown -R zzr:www-data /var/www
USER zzr:zzr
