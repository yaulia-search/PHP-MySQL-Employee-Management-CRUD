#!/bin/bash

# AWS Lightsail Deployment Script for Employee Management System
# This script configures Nginx, PHP, and MySQL on Ubuntu

set -e

echo "🚀 Starting Employee Management System deployment on AWS Lightsail..."

# Update system
sudo apt update && sudo apt upgrade -y

# Install Nginx, PHP, MySQL
sudo apt install -y nginx mysql-server php8.3-fpm php8.3-mysql php8.3-cli php8.3-curl php8.3-json php8.3-mbstring php8.3-xml php8.3-zip unzip

# Start and enable services
sudo systemctl start nginx mysql php8.3-fpm
sudo systemctl enable nginx mysql php8.3-fpm

# Configure MySQL
sudo mysql_secure_installation

# Create database and user
sudo mysql -e "CREATE DATABASE IF NOT EXISTS php_employee_management;"
sudo mysql -e "CREATE USER IF NOT EXISTS 'empuser'@'localhost' IDENTIFIED BY 'SecurePass123!';"
sudo mysql -e "GRANT ALL PRIVILEGES ON php_employee_management.* TO 'empuser'@'localhost';"
sudo mysql -e "FLUSH PRIVILEGES;"

# Create web directory
sudo mkdir -p /var/www/employee-management
sudo chown -R www-data:www-data /var/www/employee-management
sudo chmod -R 755 /var/www/employee-management

# Configure Nginx
sudo tee /etc/nginx/sites-available/employee-management > /dev/null <<EOF
server {
    listen 80;
    server_name _;
    root /var/www/employee-management;
    index index.php index.html index.htm;

    location / {
        try_files \$uri \$uri/ =404;
    }

    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/var/run/php/php8.3-fpm.sock;
        fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
        include fastcgi_params;
    }

    location ~ /\.ht {
        deny all;
    }
}
EOF

# Enable site and remove default
sudo ln -sf /etc/nginx/sites-available/employee-management /etc/nginx/sites-enabled/
sudo rm -f /etc/nginx/sites-enabled/default

# Test and reload Nginx
sudo nginx -t
sudo systemctl reload nginx

# Configure PHP
sudo sed -i 's/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/' /etc/php/8.3/fpm/php.ini

# Restart PHP-FPM
sudo systemctl restart php8.3-fpm

echo "✅ Server configuration completed!"
echo "📁 Upload your files to: /var/www/employee-management"
echo "🔧 Update config.php with database credentials:"
echo "   DB_HOST: localhost"
echo "   DB_USER: empuser"
echo "   DB_PASS: SecurePass123!"
echo "   DB_NAME: php_employee_management"
