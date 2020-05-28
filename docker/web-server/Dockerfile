FROM nginx:stable

# Modified from repository: https://github.com/TrafeX/docker-php-nginx
LABEL Maintainer="Bill Yang <bill.yang@live.ca>" Description="Nginx stable & PHP-FPM 7.4 based on debian:buster-slim."

# set php version
# Note: need manually modify the supervisord.conf content according to php version
ENV PHP_VERSION 7.4
ENV RUN_USER www-data
ENV RUN_USER_GROUP www-data

# timezone
ENV TZ America/Vancouver
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt update -y && apt install -y curl wget supervisor
RUN wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg
RUN echo "deb https://packages.sury.org/php/ buster main" > /etc/apt/sources.list.d/php.list

RUN apt update -y && apt install --no-install-recommends --no-install-suggests -q -y \
    php${PHP_VERSION}-common \
    php${PHP_VERSION}-cli \
    php${PHP_VERSION}-fpm \
    php${PHP_VERSION}-opcache \
    php${PHP_VERSION}-json \
    php${PHP_VERSION}-curl \
    php${PHP_VERSION}-zip \
    php${PHP_VERSION}-dev \
    php${PHP_VERSION}-gd \
    php${PHP_VERSION}-mbstring \
    php${PHP_VERSION}-xml \
    php${PHP_VERSION}-xmlrpc \
    php${PHP_VERSION}-mysql \
    php-redis \
    php-xdebug

# Enable php fpm service (when the service is not able to start automatically)
#RUN systemctl enable php${PHP_VERSION}-fpm
#RUN service php${PHP_VERSION}-fpm start

RUN apt remove --purge --auto-remove -y \
    && rm -f /etc/apt/trusted.gpg.d/php.gpg /etc/apt/sources.list.d/php.list

# Configure nginx
COPY config/nginx.conf /etc/nginx/nginx.conf
COPY config/vhost.conf /etc/nginx/conf.d/vhost.conf
# Remove default server definition
RUN rm /etc/nginx/conf.d/default.conf

# Configure PHP-FPM
COPY config/fpm-pool.conf /etc/php/${PHP_VERSION}/fpm/pool.d/www.conf
COPY config/xdebug.ini /etc/php/${PHP_VERSION}/mods-available/xdebug.ini
COPY config/php.ini /etc/php/${PHP_VERSION}/fpm/conf.d/custom.ini

# Configure supervisord
COPY config/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Setup document root
RUN mkdir -p /var/www/html
RUN mkdir -p /var/www/sites

# Add application
WORKDIR /var/www/html

RUN groups ${RUN_USER_GROUP} &>/dev/null || groupadd -r ${RUN_USER_GROUP}
RUN id -u ${RUN_USER} &>/dev/null || useradd ${RUN_USER} 

# Make sure files/directories needed by processes are acceptable for the user
RUN mkdir -p /run/php
RUN chown -R ${RUN_USER}:${RUN_USER_GROUP} /var/www/html && \
    chown -R ${RUN_USER}:${RUN_USER_GROUP} /var/www/sites && \
    chown -R ${RUN_USER}:${RUN_USER_GROUP} /run && \
    chown -R ${RUN_USER}:${RUN_USER_GROUP} /var/lib && \
    chown -R ${RUN_USER}:${RUN_USER_GROUP} /var/log

# Switch to use a non-root user from here on
USER ${RUN_USER}

# Add default web pages in docker
COPY --chown=${RUN_USER}:${RUN_USER_GROUP} src/ /var/www/html/
COPY --chown=${RUN_USER}:${RUN_USER_GROUP} src/ /var/www/sites/

# Expose the port nginx is reachable on
# port 80 is a privilege port only root user can run
EXPOSE 8080 10080

# Let supervisord start nginx & php-fpm
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]

# Configure a healthcheck to validate that everything is up&running
HEALTHCHECK --timeout=10s CMD curl --silent --fail http://127.0.0.1:8080/fpm-ping

#docker run --name nginx -p 80:80 -v /etc/nginx/sites-enabled:/etc/nginx/conf.d -v /etc/nginx/certs-enabled:/etc/nginx/certs -v /var/log/nginx:/var/log/nginx nginx