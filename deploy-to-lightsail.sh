#!/bin/bash

# Deploy Employee Management System to AWS Lightsail
# Instance IP: 52.91.83.238

INSTANCE_IP="52.91.83.238"
SSH_KEY="./LightsailDefaultKey-us-east-1.pem"
APP_DIR="/opt/bitnami/apache/htdocs"

echo "🚀 Deploying Employee Management System to Lightsail..."

# Test SSH connection
echo "📡 Testing SSH connection..."
ssh -i $SSH_KEY -o ConnectTimeout=10 bitnami@$INSTANCE_IP "echo 'SSH connection successful!'"

if [ $? -ne 0 ]; then
    echo "❌ SSH connection failed. Please check:"
    echo "   - Instance is running"
    echo "   - Security groups allow SSH (port 22)"
    echo "   - SSH key permissions: chmod 400 $SSH_KEY"
    exit 1
fi

# Upload application files
echo "📁 Uploading application files..."
scp -i $SSH_KEY -r *.php database/ bitnami@$INSTANCE_IP:/tmp/

# Configure the server
echo "⚙️ Configuring server..."
ssh -i $SSH_KEY bitnami@$INSTANCE_IP << 'EOF'
# Stop Apache (we'll use Nginx)
sudo systemctl stop apache2
sudo systemctl disable apache2

# Install and configure Nginx
sudo apt update
sudo apt install -y nginx

# Copy application files
sudo cp -r /tmp/*.php /opt/bitnami/apache/htdocs/
sudo cp -r /tmp/database /opt/bitnami/apache/htdocs/
sudo chown -R bitnami:daemon /opt/bitnami/apache/htdocs/
sudo chmod -R 755 /opt/bitnami/apache/htdocs/

# Configure Nginx
sudo tee /etc/nginx/sites-available/employee-management > /dev/null << 'NGINX_CONF'
server {
    listen 80;
    server_name _;
    root /opt/bitnami/apache/htdocs;
    index index.php index.html index.htm;

    location / {
        try_files $uri $uri/ =404;
    }

    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/opt/bitnami/php/var/run/www.sock;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        include fastcgi_params;
    }

    location ~ /\.ht {
        deny all;
    }
}
NGINX_CONF

# Enable site
sudo ln -sf /etc/nginx/sites-available/employee-management /etc/nginx/sites-enabled/
sudo rm -f /etc/nginx/sites-enabled/default

# Start Nginx
sudo systemctl start nginx
sudo systemctl enable nginx

# Setup database
mysql -u root << 'SQL_SETUP'
CREATE DATABASE IF NOT EXISTS php_employee_management;
USE php_employee_management;
SOURCE /opt/bitnami/apache/htdocs/database/schema.sql;
SQL_SETUP

# Update config for production
sudo cp /opt/bitnami/apache/htdocs/config-production.php /opt/bitnami/apache/htdocs/config.php

echo "✅ Deployment completed!"
echo "🌐 Your application is available at: http://$INSTANCE_IP"
EOF

echo ""
echo "🎉 Deployment completed successfully!"
echo ""
echo "📋 Next steps:"
echo "   1. Visit: http://$INSTANCE_IP"
echo "   2. Test database: http://$INSTANCE_IP/test-connection.php"
echo "   3. Remove test file after verification"
echo ""
echo "🔧 SSH access:"
echo "   ssh -i $SSH_KEY bitnami@$INSTANCE_IP"
echo ""
echo "💰 Monthly cost: ~$7 (Micro instance)"
