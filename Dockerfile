FROM php:7.4-apache

# Instalar extensiones de PHP necesarias
RUN apt-get update && apt-get install -y \
    libcurl4-gnutls-dev \
    libpng-dev \
    zlib1g-dev \
    git \
    zip \
    unzip \
    && rm -rf /var/lib/apt/lists/* \
    && docker-php-ext-install mysqli pdo_mysql curl gd pcntl \
    && php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
    && php composer-setup.php --install-dir=/usr/local/bin --filename=composer \
    && php -r "unlink('composer-setup.php');"

# Copiar la configuración de Apache
COPY apache-config.conf /etc/apache2/sites-available/000-default.conf

# Habilitar módulos de Apache
RUN a2enmod rewrite

# Reiniciar el servicio de Apache
RUN service apache2 restart
