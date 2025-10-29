# AWS Lightsail Deployment Guide - Employee Management System

## Overview
This guide will help you deploy the PHP Employee Management System on AWS Lightsail with Nginx web server.

## Prerequisites
- AWS Account with Lightsail access
- SSH client (Terminal on macOS/Linux, PuTTY on Windows)

## Step 1: Instance Setup

Your Lightsail instance has been created with:
- **Instance Name:** employee-management-app
- **Bundle:** Micro ($7/month) - 1GB RAM, 40GB SSD
- **Blueprint:** LAMP (PHP 8) - Pre-configured with Apache, MySQL, PHP
- **Region:** us-east-1a

## Step 2: Connect to Your Instance

1. Get your instance's public IP:
```bash
aws lightsail get-instances --region us-east-1 --query 'instances[?name==`employee-management-app`].publicIpAddress' --output text
```

2. Download the SSH key:
```bash
aws lightsail download-default-key-pair --region us-east-1
```

3. Connect via SSH:
```bash
chmod 400 LightsailDefaultKey-us-east-1.pem
ssh -i LightsailDefaultKey-us-east-1.pem bitnami@YOUR_INSTANCE_IP
```

## Step 3: Switch from Apache to Nginx

Since the LAMP blueprint comes with Apache, we'll switch to Nginx:

```bash
# Stop and disable Apache
sudo systemctl stop apache2
sudo systemctl disable apache2

# Install Nginx
sudo apt update
sudo apt install -y nginx

# Start and enable Nginx
sudo systemctl start nginx
sudo systemctl enable nginx
```

## Step 4: Configure Nginx

Create Nginx configuration:

```bash
sudo tee /etc/nginx/sites-available/employee-management > /dev/null <<EOF
server {
    listen 80;
    server_name _;
    root /opt/bitnami/apache/htdocs;
    index index.php index.html index.htm;

    location / {
        try_files \$uri \$uri/ =404;
    }

    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/opt/bitnami/php/var/run/www.sock;
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
```

## Step 5: Upload Application Files

1. **Using SCP (from your local machine):**
```bash
scp -i LightsailDefaultKey-us-east-1.pem -r /Users/admin/ysa-edu.website/PHP-MySQL-Employee-Management-CRUD/* bitnami@YOUR_INSTANCE_IP:/tmp/
```

2. **Move files to web directory:**
```bash
sudo cp -r /tmp/* /opt/bitnami/apache/htdocs/
sudo chown -R bitnami:daemon /opt/bitnami/apache/htdocs/
sudo chmod -R 755 /opt/bitnami/apache/htdocs/
```

## Step 6: Configure Database

1. **Access MySQL:**
```bash
mysql -u root -p
```

2. **Create database and import schema:**
```sql
CREATE DATABASE IF NOT EXISTS php_employee_management;
USE php_employee_management;
SOURCE /opt/bitnami/apache/htdocs/database/schema.sql;
EXIT;
```

## Step 7: Update Configuration

1. **Copy production config:**
```bash
sudo cp /opt/bitnami/apache/htdocs/config-production.php /opt/bitnami/apache/htdocs/config.php
```

2. **Update database credentials in config.php:**
```php
define('DB_HOST', 'localhost');
define('DB_USER', 'root');
define('DB_PASS', 'YOUR_MYSQL_ROOT_PASSWORD');
define('DB_NAME', 'php_employee_management');
```

## Step 8: Configure Firewall

Open HTTP port in Lightsail:

```bash
aws lightsail put-instance-public-ports --region us-east-1 --instance-name employee-management-app --port-infos fromPort=80,toPort=80,protocol=TCP,cidrs=0.0.0.0/0
```

## Step 9: Test Application

1. **Visit your application:**
   - Open browser: `http://YOUR_INSTANCE_IP`
   - Test database connection: `http://YOUR_INSTANCE_IP/test-connection.php`

2. **Check logs if issues:**
```bash
sudo tail -f /var/log/nginx/error.log
sudo tail -f /opt/bitnami/php/var/log/php-fpm.log
```

## Step 10: Security Hardening

1. **Remove test files:**
```bash
sudo rm /opt/bitnami/apache/htdocs/test-connection.php
```

2. **Update PHP settings:**
```bash
sudo nano /opt/bitnami/php/etc/php.ini
# Set: display_errors = Off
# Set: expose_php = Off
```

3. **Restart services:**
```bash
sudo systemctl restart nginx
sudo /opt/bitnami/ctlscript.sh restart php-fpm
```

## Optional: SSL Certificate

Install Let's Encrypt SSL:

```bash
sudo apt install -y certbot python3-certbot-nginx
sudo certbot --nginx -d your-domain.com
```

## Monitoring and Maintenance

1. **Check service status:**
```bash
sudo systemctl status nginx mysql
sudo /opt/bitnami/ctlscript.sh status
```

2. **View application logs:**
```bash
sudo tail -f /var/log/nginx/access.log
sudo tail -f /var/log/nginx/error.log
```

3. **Backup database:**
```bash
mysqldump -u root -p php_employee_management > backup_$(date +%Y%m%d).sql
```

## Troubleshooting

### Common Issues:

1. **502 Bad Gateway:**
   - Check PHP-FPM: `sudo /opt/bitnami/ctlscript.sh status php-fpm`
   - Restart: `sudo /opt/bitnami/ctlscript.sh restart php-fpm`

2. **Database Connection Failed:**
   - Verify MySQL: `sudo systemctl status mysql`
   - Check credentials in config.php

3. **Permission Denied:**
   - Fix permissions: `sudo chown -R bitnami:daemon /opt/bitnami/apache/htdocs/`

## Cost Optimization

- **Micro instance:** $7/month (1GB RAM, 40GB SSD)
- **Data transfer:** 2TB included
- **Static IP:** $3.50/month (optional)
- **Snapshots:** $0.05/GB/month

## Next Steps

1. Configure domain name
2. Set up SSL certificate
3. Implement backup strategy
4. Monitor performance
5. Scale if needed

Your Employee Management System is now running on AWS Lightsail with Nginx!
