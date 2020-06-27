FROM node:10-alpine AS build
ENV DOCKER_BUILD=1
COPY dockvine_toolbar  /var/www/dockvine/dockvine_toolbar
WORKDIR /var/www/dockvine/dockvine_toolbar
RUN sh build.sh
COPY wix  /var/www/dockvine/wix
WORKDIR /var/www/dockvine/wix
RUN sh build.sh

FROM php:5-apache-jessie
RUN curl -sS https://getcomposer.org/installer | \
	php -- --install-dir=/usr/local/bin --filename=composer \
	&& apt-get update \
	&& apt-get install -y git zip libmcrypt-dev zlib1g-dev\
	&& docker-php-ext-install -j$(nproc) iconv mcrypt zip \
	&& a2enmod ssl rewrite\
	&& apt-get clean autoclean \
	&& apt-get autoremove --yes \
	&& rm -rf /var/lib/{apt,dpkg,cache,log}/
COPY --from=build /var/www/dockvine /var/www/dockvine
COPY dockvine_corp /var/www/dockvine/dockvine_corp
WORKDIR /var/www/dockvine/dockvine_corp
RUN sh build.sh \
	&& rm -rf /root/.composer/cache
COPY dockvine_api/composer.lock dockvine_api/composer.json \
	dockvine_api/build.sh \
	/var/www/dockvine/dockvine_api/
WORKDIR /var/www/dockvine/dockvine_api
RUN sh build.sh \
	&& rm -rf /root/.composer/cache \
	# remove cashier binaries
	&& rm  -f /var/www/dockvine/dockvine_api/vendor/laravel/cashier/src/Laravel/Cashier/bin/linux-i686/phantomjs \
	&& rm  -f /var/www/dockvine/dockvine_api/vendor/laravel/cashier/src/Laravel/Cashier/bin/windows/phantomjs.exe \
	&& rm  -f /var/www/dockvine/dockvine_api/vendor/laravel/cashier/src/Laravel/Cashier/bin/macosx/phantomjs
COPY dockvine_api/ /var/www/dockvine/dockvine_api
COPY sites-enabled /etc/apache2/sites-enabled
