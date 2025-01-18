#!/bin/sh

# Ensure all dependencies are installed
if [ ! -d "vendor" ]; then
  echo "\nRunning composer install..."
  composer install
fi

if [ ! -d "node_modules" ]; then
  echo "\nRunning npm install..."
  npm install
fi

# Build assets if required
if [ ! -d "public/build" ]; then
  echo "\nBuilding assets..."
  npm run build
fi

# Check if the encryption key is set in the .env file
if ! grep -q "^APP_KEY=" .env || [ -z "$(grep "^APP_KEY=" .env | cut -d '=' -f 2)" ]; then
  echo "\nAPP_KEY is not set. Generating a new application encryption key..."
  php artisan key:generate
fi

# Run database migrations
echo "\nRunning database migrations..."
php artisan migrate

# Start Laravel's dev server
echo "\nStarting Laravel application..."
composer run dev
