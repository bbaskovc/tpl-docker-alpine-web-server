
# Set the base image name and tag as build arguments
ARG IMAGE_NAME=alpine
ARG IMAGE_TAG=latest

# Use Alpine as the base image
FROM ${IMAGE_NAME}:${IMAGE_TAG}

# Set environment variables for consistent locale settings
ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8

# Install dependencies: Git, Node.js with npm, Apache, PHP 8.2, and Xdebug
RUN apk update && apk add --no-cache \
    curl \
    git \
    nodejs \
    npm \
    apache2 \
    apache2-ssl \
    php82 \
    php82-apache2 \
    php82-mysqli \
    php82-json \
    php82-opcache \
    php82-mbstring \
    php82-session \
    php82-xml \
    php82-curl \
    php82-pdo \
    php82-pdo_mysql \
    php82-xdebug \
    mariadb \
    mariadb-client \
    phpmyadmin \
    && rm -rf /var/cache/apk/*