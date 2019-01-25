FROM php:7.3.0-fpm-alpine3.8

RUN apk upgrade --update && apk --no-cache add \
    # iconv, intl
    icu-dev \
    # xdebug
    autoconf make g++ gcc

RUN docker-php-ext-install  -j$(nproc) iconv intl mbstring pdo_mysql opcache && \
  pecl install xdebug-2.7.0beta1 && \
  docker-php-ext-enable xdebug

RUN { \
  echo 'upload_max_filesize = 100M'; \
  echo 'post_max_size = 108M'; \
  echo 'short_open_tag = On'; \
  echo 'fastcgi.logging = 1'; \
  echo 'opcache.enable=1'; \
  echo 'opcache.optimization_level=0x7FFFBBFF' ; \
  echo 'opcache.revalidate_freq=0'; \
  echo 'opcache.validate_timestamps=1'; \
  echo 'opcache.memory_consumption=128'; \
  echo 'opcache.interned_strings_buffer=8'; \
  echo 'opcache.max_accelerated_files=4000'; \
  echo 'opcache.revalidate_freq=60'; \
  echo 'opcache.fast_shutdown=1'; \
  echo 'xdebug.remote_enable=1'; \
} > /usr/local/etc/php/conf.d/overrides.ini

COPY . /var/www/html
RUN chown -R www-data:www-data /var/www
