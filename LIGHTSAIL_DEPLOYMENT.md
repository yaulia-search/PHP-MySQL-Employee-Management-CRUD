# AWS Lightsail Deployment Guide - Amazon Linux 2023

## Quick Start

Your Lightsail instance is ready:
- **Instance:** employee-management-app  
- **IP:** 52.91.83.238
- **OS:** Amazon Linux 2023
- **Web Server:** Apache
- **Cost:** $7/month

## Deploy in 3 Steps

### 1. Run Deployment Script
```bash
./deploy-to-lightsail.sh
```

### 2. Access Application
- **URL:** http://52.91.83.238
- **Test:** http://52.91.83.238/test-connection.php

### 3. SSH Access (if needed)
```bash
ssh -i LightsailDefaultKey-us-east-1.pem ec2-user@52.91.83.238
```

## What the Script Does

1. Updates Amazon Linux 2023
2. Installs Apache, PHP 8, MariaDB
3. Uploads your PHP files to `/var/www/html/`
4. Creates database and imports sample data
5. Configures Apache virtual host
6. Sets proper file permissions

## Manual Installation (Alternative)

If you prefer manual setup:

```bash
# Connect to instance
ssh -i LightsailDefaultKey-us-east-1.pem ec2-user@52.91.83.238

# Install LAMP stack
sudo dnf update -y
sudo dnf install -y httpd php php-mysqli php-json php-mbstring mariadb105-server

# Start services
sudo systemctl start httpd mariadb
sudo systemctl enable httpd mariadb

# Upload files (from local machine)
scp -i LightsailDefaultKey-us-east-1.pem -r *.php database/ ec2-user@52.91.83.238:/tmp/
```

## Troubleshooting

**Apache not starting:**
```bash
sudo systemctl status httpd
sudo systemctl restart httpd
```

**Database connection failed:**
```bash
sudo mysql -u root -p
CREATE DATABASE php_employee_management;
```

**Permission denied:**
```bash
sudo chown -R apache:apache /var/www/html/
sudo chmod -R 755 /var/www/html/
```

## Security

After deployment:
```bash
sudo rm /var/www/html/test-connection.php
```

## File Locations

- **Web files:** `/var/www/html/`
- **Apache config:** `/etc/httpd/conf.d/`
- **PHP config:** `/etc/php.ini`
- **Logs:** `/var/log/httpd/`

That's it! Your Employee Management System is live on AWS Lightsail with Apache.
