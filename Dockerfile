# this is based on https://hub.docker.com/r/alucardlevash/phpback
# see the git clone command for the version of phpback running

FROM php:5.6-apache

ENV DEBIAN_FRONTEND noninteractive
ENV SHELL /bin/bash

RUN apt-get update && \
    apt-get -y install \
      default-mysql-client \
      git \
      libfreetype6-dev \
      libjpeg62-turbo-dev \
      libpng-dev

RUN docker-php-ext-configure gd --with-freetype-dir=/usr/include --with-jpeg-dir=/usr/include && \
    docker-php-ext-install -j$(nproc) gd pdo_mysql mysqli json opcache

# Enable apache mods
RUN a2enmod php7; a2enmod rewrite

WORKDIR /
# RUN rm -rf /var/www; git clone --branch v1.3.2 https://github.com/ivandiazwm/phpback.git /var/www
RUN rm -rf /var/www; git clone https://github.com/ivandiazwm/phpback.git /var/www

# this is needed in PHP 5.6
RUN echo 'date.timezone = GMT' >> /usr/local/etc/php/php.ini

COPY scripts/run.sh /run.sh
RUN chmod +x /run.sh

EXPOSE 80

COPY scripts/phpback.conf /etc/apache2/sites-available/phpback.conf
RUN a2dissite 000-default && a2ensite phpback

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENTRYPOINT ["/run.sh"]
