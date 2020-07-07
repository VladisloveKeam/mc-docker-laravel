FROM php:7.3-alpine

# Install dev dependencies
RUN apk add --no-cache --virtual .build-deps \
    $PHPIZE_DEPS \
    curl-dev \
    libtool \
    libxml2-dev \
    postgresql-dev 

# Install production dependencies
RUN apk add --no-cache \
    bash \
    curl \
    g++ \
    gcc \
    git \
    libc-dev \
    libpng-dev \
    libjpeg-turbo-dev \
    libzip-dev \
#    make \
#    nodejs \
#    nodejs-npm \
#    yarn \
    openssh-client \
    postgresql-libs \
    rsync \
    zlib-dev \
    ffmpeg

# Install and enable php extensions
RUN docker-php-ext-configure zip --with-libzip

RUN docker-php-ext-configure gd \
  --with-gd \
  --with-jpeg-dir \
  --with-png-dir \
  --with-zlib-dir
  
RUN docker-php-ext-install \
    calendar \
    curl \
    exif \
    iconv \
    mbstring \
    pdo \
    pdo_pgsql \
    pcntl \
    tokenizer \
    xml \
    gd \
    zip \
    bcmath \
    sockets

# Install composer
ENV COMPOSER_HOME /composer
ENV PATH ./vendor/bin:/composer/vendor/bin:$PATH
ENV COMPOSER_ALLOW_SUPERUSER 1
RUN curl -s https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin/ --filename=composer

# Install PHP_CodeSniffer
RUN composer global require "squizlabs/php_codesniffer=*"

# Cleanup dev dependencies
RUN apk del -f .build-deps

# Setup working directory
WORKDIR /var/www
