#!/bin/bash

# Deploy Employee Management System to AWS Lightsail (Amazon Linux 2023)
# Instance IP: 52.91.83.238

INSTANCE_IP="52.91.83.238"
SSH_KEY="./LightsailDefaultKey-us-east-1.pem"
APP_DIR="/var/www/html"

echo "🚀 Deploying Employee Management System to Lightsail (Amazon Linux 2023)..."

# Test SSH connection
echo "📡 Testing SSH connection..."
ssh -i $SSH_KEY -o ConnectTimeout=10 ec2-user@$INSTANCE_IP "echo 'SSH connection successful!'"

if [ $? -ne 0 ]; then
    echo "❌ SSH connection failed. Please check:"
    echo "   - Instance is running"
    echo "   - Security groups allow SSH (port 22)"
    echo "   - SSH key permissions: chmod 400 $SSH_KEY"
    exit 1
fi

# Upload application files
echo "📁 Uploading application files..."
scp -i $SSH_KEY -r *.php database/ ec2-user@$INSTANCE_IP:/tmp/

# Configure the server
echo "⚙️ Configuring server..."
ssh -i $SSH_KEY ec2-user@$INSTANCE_IP << 'EOF'
# Update system
sudo dnf update -y

# Install Apache, PHP, MySQL
sudo dnf install -y httpd php php-mysqli php-json php-mbstring mariadb105-server

# Start and enable services
sudo systemctl start httpd mariadb
sudo systemctl enable httpd mariadb

# Secure MySQL installation
sudo mysql_secure_installation

# Create database and user
sudo mysql -e "CREATE DATABASE IF NOT EXISTS php_employee_management;"
sudo mysql -e "CREATE USER IF NOT EXISTS 'empuser'@'localhost' IDENTIFIED BY 'SecurePass123!';"
sudo mysql -e "GRANT ALL PRIVILEGES ON php_employee_management.* TO 'empuser'@'localhost';"
sudo mysql -e "FLUSH PRIVILEGES;"

# Import database schema
sudo mysql php_employee_management < /tmp/database/schema.sql

# Copy application files
sudo cp /tmp/*.php /var/www/html/
sudo cp -r /tmp/database /var/www/html/
sudo chown -R apache:apache /var/www/html/
sudo chmod -R 755 /var/www/html/

# Update config for production
sudo cp /var/www/html/config-production.php /var/www/html/config.php

# Update database credentials in config.php
sudo sed -i "s/define('DB_USER', 'root');/define('DB_USER', 'empuser');/" /var/www/html/config.php
sudo sed -i "s/define('DB_PASS', '');/define('DB_PASS', 'SecurePass123!');/" /var/www/html/config.php

# Configure Apache
sudo tee /etc/httpd/conf.d/employee-management.conf > /dev/null << 'APACHE_CONF'
<VirtualHost *:80>
    DocumentRoot /var/www/html
    DirectoryIndex index.php index.html
    
    <Directory /var/www/html>
        AllowOverride All
        Require all granted
    </Directory>
    
    <FilesMatch \.php$>
        SetHandler "proxy:unix:/run/php-fpm/www.sock|fcgi://localhost"
    </FilesMatch>
</VirtualHost>
APACHE_CONF

# Start PHP-FPM
sudo systemctl start php-fpm
sudo systemctl enable php-fpm

# Restart Apache
sudo systemctl restart httpd

echo "✅ Deployment completed!"
echo "🌐 Your application is available at: http://52.91.83.238"
EOF

echo ""
echo "🎉 Deployment completed successfully!"
echo ""
echo "📋 Next steps:"
echo "   1. Visit: http://52.91.83.238"
echo "   2. Test database: http://52.91.83.238/test-connection.php"
echo "   3. Remove test file after verification"
echo ""
echo "🔧 SSH access:"
echo "   ssh -i $SSH_KEY ec2-user@52.91.83.238"
echo ""
echo "💰 Monthly cost: ~$7 (Micro instance)"
