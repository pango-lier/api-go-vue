FROM php:8.0.8-fpm-alpine

LABEL maintainer="Binh Trong"

# ARG WWWGROUP

WORKDIR /var/www/html

RUN apk update && apk add --no-cache \
    git \
    npm \
    yarn \
    curl \
    build-base shadow supervisor \
    php8-pear \
    php8-common \
    php8-pdo \
    php8-pdo_mysql \
    php8-mysqli \
    php7-mcrypt \
    php8-mbstring \
    php8-xml \
    php8-openssl \
    php8-json \
    php8-phar \
    php8-zip \
    php8-gd \
    php8-dom \
    php8-session \
    php8-zlib \
    autoconf pcre-dev \
    freetype-dev libjpeg-turbo-dev libpng-dev \
    libzip-dev \
    curl-dev
# ZIP extension
RUN docker-php-ext-install zip

# RUN yarn global add @vue/cli
# RUN yarn global add @vue/cli @vue/cli-service-global

# Add and Enable PHP-PDO Extenstions for PHP connect Mysql
RUN docker-php-ext-install pdo pdo_mysql
RUN docker-php-ext-enable pdo_mysql

# Get latest Composer
RUN wget https://getcomposer.org/composer-stable.phar -O /usr/local/bin/composer && chmod +x /usr/local/bin/composer

# COPY --chown=www:www . /var/www/

COPY docker/supervisord.conf /etc/supervisord.conf
COPY docker/supervisor.d /etc/supervisor.d

# Remove Cache
RUN rm -rf /var/cache/apk/*

# Use the default production configuration ($PHP_INI_DIR variable already set by the default image)
RUN cp -f "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"

ENV ENABLE_CRONTAB 1
ENV ENABLE_HORIZON 1
ENV ENABLE_WORKER 1

# RUN addgroup -g 1000 -S www && \
#     adduser -u 1000 -S www -G www
# # Copy existing application directory
# COPY . .

# # Chang app directory permission
RUN chown -R www-data:www-data .

EXPOSE 9000
# Setup document root
# RUN mkdir -p /var/www/html
# ENTRYPOINT ["sh", "/var/www/html/docker/start-container.sh"]
# CMD supervisord -n -c /etc/supervisord.conf
