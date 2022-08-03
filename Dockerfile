FROM php:8.1-fpm

ENV TZ=Europe/London
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN printf '[PHP]\ndate.timezone = "Europe/London"\n' > /usr/local/etc/php/conf.d/tzone.ini

LABEL maintainer="Jae Toole <jae.toole@northernestateagencies.co.uk>"
WORKDIR /srv/app

COPY --chown=www-data:www-data . /srv/app

# COPY .docker/vhost.conf /etc/apache2/sites-available/000-default.conf
COPY .docker/php/ini/conf.d/memory_limit.ini /usr/local/etc/php/conf.d/memory_limit.ini

#ENV LOG_CHANNEL=stderr

RUN apt-get update && apt-get install -y \
    git \
    zip \
    curl \
    sudo \
    unzip \
    libicu-dev \
    libbz2-dev \
    libzip-dev \
    libpng-dev \
    libjpeg-dev \
    libmcrypt-dev \
    libreadline-dev \
    libfreetype6-dev \
    g++ \
    wget

RUN docker-php-ext-configure gd --with-freetype --with-jpeg

RUN docker-php-ext-install \
    -j$(nproc) gd \
    bz2 \
    zip \
    intl \
    pcntl \
    iconv \
    bcmath \
    opcache \
    calendar \
    pdo_mysql

RUN wget https://github.com/FriendsOfPHP/pickle/releases/latest/download/pickle.phar && chmod +x pickle.phar && mv pickle.phar /usr/bin/pickle
RUN pickle install igbinary && docker-php-ext-enable igbinary

RUN pickle install redis && docker-php-ext-enable redis

COPY --from=public.ecr.aws/composer/composer:latest /usr/bin/composer /usr/bin/composer
COPY . .
RUN echo ${NOVA_USERNAME}
#RUN mkdir -p ~/.composer
#RUN #echo "{\"http-basic\":{\"nova.laravel.com\":{\"username\":\"${NOVA_USERNAME}\",\"password\":\"${NOVA_LICENCE_KEY}\"}}}" > ~/.composer/auth.json
RUN composer config "http-basic.nova.laravel.com" "${NOVA_USERNAME}" "${NOVA_LICENCE_KEY}"
#RUN #cat ~/.composer/auth.json
#RUN cd /srv/app/tmp && compose install
# RUN cd /srv/app/tmp && composer dump-autoload
RUN composer update
RUN chmod -R 777 storage
RUN chown www-data:www-data -R /srv/app
# RUN service apache2 restart

RUN docker-php-ext-install pdo pdo_mysql
    # && a2enmod rewrite
