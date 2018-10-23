# PHP
#
# VERSION 7.1+

FROM php:7.1-fpm

ENV MAX_CHILDREN 50
ENV START_SERVERS 5
ENV MIN_SPARE_SERVERS 5
ENV MAX_SPARE_SERVERS 35

#opcache
ENV OPCACHE_MAX_ACCELERATED_FILES 4000
ENV OPCACHE_REVALIDATE_FREQ 60
ENV OPCACHE_MEMORY_CONSUMPTION 128
ENV OPCAHCE_INTERNED_STRINGS_BUFFER 8
ENV OPCAHCE_FAST_SHUTDOWN 1
ENV OPCACHE_SAVE_COMMENTS 0

RUN apt-get update && apt-get install -y \
        libpng-dev \
        pkg-config \
        libssl-dev \
        libsasl2-dev \
        libxml2-dev \
        gettext \
        libmcrypt-dev \
        libxslt-dev \
        libmemcached-dev \
  && docker-php-ext-install gd pdo pdo_mysql mysqli shmop sockets sysvsem xsl iconv zip  bcmath xmlrpc soap intl gettext pcntl \
  && docker-php-ext-install opcache


RUN pecl install redis \
  && pecl install mongodb \
  && pecl install memcached \
  && pecl install swoole \
  && docker-php-ext-enable redis mongodb  memcached swoole



RUN sed -i 's/pm.max_children = 5/pm.max_children = ${MAX_CHILDREN}/g' /usr/local/etc/php-fpm.d/www.conf  \
  && sed -i 's/pm.start_servers = 2/pm.start_servers = ${START_SERVERS}/g' /usr/local/etc/php-fpm.d/www.conf \
  && sed -i 's/pm.min_spare_servers = 1/pm.min_spare_servers = ${MIN_SPARE_SERVERS}/g' /usr/local/etc/php-fpm.d/www.conf \
  && sed -i 's/pm.max_spare_servers = 3/pm.max_spare_servers = ${MAX_SPARE_SERVERS}/g' /usr/local/etc/php-fpm.d/www.conf \
  && echo "opcache.enable=1" >> /usr/local/etc/php/conf.d/docker-php-ext-opcache.ini \
  && echo "opcache.enable_cli=1" >> /usr/local/etc/php/conf.d/docker-php-ext-opcache.ini \
  && echo "opcache.revalidate_freq=${OPCACHE_REVALIDATE_FREQ}" >> /usr/local/etc/php/conf.d/docker-php-ext-opcache.ini \
  && echo "opcache.memory_consumption=${OPCACHE_MEMORY_CONSUMPTION}" >> /usr/local/etc/php/conf.d/docker-php-ext-opcache.ini \
  && echo "opcache.max_accelerated_files=${OPCACHE_MAX_ACCELERATED_FILES}" >> /usr/local/etc/php/conf.d/docker-php-ext-opcache.ini \
  && echo "opcache.interned_strings_buffer=${OPCAHCE_INTERNED_STRINGS_BUFFER}" >> /usr/local/etc/php/conf.d/docker-php-ext-opcache.ini \
  && echo "opcache.fast_shutdown=${OPCAHCE_FAST_SHUTDOWN}" >> /usr/local/etc/php/conf.d/docker-php-ext-opcache.ini \
  && echo "opcache.save_comments=${OPCACHE_SAVE_COMMENTS}" >> /usr/local/etc/php/conf.d/docker-php-ext-opcache.ini 
