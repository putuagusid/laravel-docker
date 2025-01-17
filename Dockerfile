# Base image for PHP
FROM php:8.4-fpm

# Set working directory
WORKDIR /var/www

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    unzip \
    curl \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    nodejs \
    npm \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd

# Install Composer
COPY --from=composer:2.8 /usr/bin/composer /usr/bin/composer

# Copy existing application directory
COPY . .

# Install dependencies
RUN composer install \
    && npm install \
    && npm run build

# Expose Laravel's default port (8000)
EXPOSE 8000

# Expose Vite's development server port (5173)
EXPOSE 5173

# Command to run Laravel development server with all necessary services
CMD ["composer", "run", "dev"]
