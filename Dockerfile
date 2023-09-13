FROM php:8.1.6-apache


# Cài đặt các extensions cần thiết
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libzip-dev \
    zip \
    unzip \

    software-properties-common \
    gnupg \
   
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd pdo pdo_mysql \
    && docker-php-ext-install zip \
     
    && curl -fsSL https://deb.nodesource.com/setup_14.x | bash - \
    && apt-get install -y nodejs

# Cấu hình Apache
RUN a2enmod rewrite
WORKDIR /var/www/html

# Sao chép ứng dụng vào image
COPY . .
# COPY package*.json ./
# Cài đặt Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer


# Cài đặt Node.js
RUN npm install

# Chạy lệnh php artisan storage:link
RUN php artisan storage:link

RUN chown -R www-data:www-data /var/www/html/storage
RUN chown -R www-data:www-data /var/www/html/bootstrap/cache


# Expose port và khởi động Apache
EXPOSE 8000
# CMD php artisan serve --host=0.0.0.0 --port=8000
# CMD ["-D", "FOREGROUND"]
# CMD ["apache2-foreground"]



