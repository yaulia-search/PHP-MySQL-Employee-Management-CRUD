# Amazon Linux Setup Guide - MariaDB Edition

Complete guide for setting up the PHP Employee Management application on Amazon Linux with MariaDB.

## 🎯 Quick Overview

This guide covers:
- Amazon Linux 2 and Amazon Linux 2023
- MariaDB installation and configuration
- Apache web server setup
- Application deployment

## 📋 Prerequisites

- Amazon Linux EC2 instance (AL2 or AL2023)
- SSH access to your instance
- Root or sudo privileges

## 🚀 Complete Setup Guide

### Step 1: Connect to Your Instance

```bash
# Connect via SSH
ssh -i your-key.pem ec2-user@your-ec2-public-ip
```

### Step 2: Update System

**For Amazon Linux 2023:**
```bash
sudo dnf update -y
```

**For Amazon Linux 2:**
```bash
sudo yum update -y
```

### Step 3: Install LAMP Stack

#### Amazon Linux 2023 (Recommended)

```bash
# Install Apache
sudo dnf install httpd -y

# Install PHP 8.x and required extensions
sudo dnf install php php-cli php-mysqlnd php-json php-mbstring php-xml -y

# Install MariaDB 10.5
sudo dnf install mariadb105-server mariadb105 -y

# Install Git (for cloning repository)
sudo dnf install git -y

# Verify installations
php -v
mysql --version
httpd -v
```

#### Amazon Linux 2

```bash
# Install Apache
sudo yum install httpd -y

# Install PHP 7.4 or higher
sudo amazon-linux-extras enable php7.4
sudo yum clean metadata
sudo yum install php php-cli php-mysqlnd php-json php-mbstring php-xml -y

# Install MariaDB
sudo yum install mariadb-server mariadb -y

# Install Git
sudo yum install git -y

# Verify installations
php -v
mysql --version
httpd -v
```

### Step 4: Start and Enable Services

```bash
# Start Apache
sudo systemctl start httpd
sudo systemctl enable httpd

# Start MariaDB
sudo systemctl start mariadb
sudo systemctl enable mariadb

# Verify services are running
sudo systemctl status httpd
sudo systemctl status mariadb
```

### Step 5: Secure MariaDB Installation

```bash
sudo mysql_secure_installation
```

**Follow the prompts:**
1. Enter current password for root (press Enter if none)
2. Set root password? **Y** (enter a strong password)
3. Remove anonymous users? **Y**
4. Disallow root login remotely? **Y**
5. Remove test database? **Y**
6. Reload privilege tables? **Y**

### Step 6: Configure MariaDB

```bash
# Login to MariaDB
sudo mysql -u root -p

# Or if no password was set
sudo mysql
```

**Create database and user:**
```sql
-- Create database
CREATE DATABASE php_employee_management;

-- Create dedicated user (recommended for security)
CREATE USER 'empuser'@'localhost' IDENTIFIED BY 'YourStrongPassword123!';

-- Grant privileges
GRANT ALL PRIVILEGES ON php_employee_management.* TO 'empuser'@'localhost';

-- Flush privileges
FLUSH PRIVILEGES;

-- Verify
SHOW DATABASES;

-- Exit
EXIT;
```

### Step 7: Deploy Application

```bash
# Navigate to web root
cd /var/www/html

# Remove default index.html
sudo rm -f index.html

# Clone your repository
sudo git clone https://github.com/yaulia-search/PHP-MySQL-Employee-Management-CRUD.git .

# Or if you already have the files, upload them via SCP:
# scp -i your-key.pem -r /local/path/* ec2-user@your-ec2-ip:/tmp/
# sudo mv /tmp/* /var/www/html/
```

### Step 8: Import Database

```bash
# Import database schema
sudo mysql -u root -p php_employee_management < /var/www/html/database/schema.sql

# Or with the dedicated user
mysql -u empuser -p php_employee_management < /var/www/html/database/schema.sql

# Verify import
sudo mysql -u root -p -e "USE php_employee_management; SHOW TABLES;"
```

### Step 9: Configure Application

```bash
# Edit config.php
sudo nano /var/www/html/config.php
```

**Update with your MariaDB credentials:**
```php
<?php
define('DB_HOST', 'localhost');
define('DB_USER', 'empuser');  // or 'root'
define('DB_PASS', 'YourStrongPassword123!');
define('DB_NAME', 'php_employee_management');

define('APP_NAME', 'Employee Management System');
define('APP_VERSION', '1.0.0');

date_default_timezone_set('Asia/Jakarta');
?>
```

Save and exit (Ctrl+X, Y, Enter)

### Step 10: Set Permissions

```bash
# Set ownership to Apache user
sudo chown -R apache:apache /var/www/html

# Set proper permissions
sudo chmod -R 755 /var/www/html

# Secure config file
sudo chmod 644 /var/www/html/config.php

# Remove test file (after testing)
sudo rm -f /var/www/html/test-connection.php
```

### Step 11: Configure Firewall (Security Groups)

In AWS Console, configure Security Groups:
- **Port 22** - SSH (Your IP only)
- **Port 80** - HTTP (0.0.0.0/0)
- **Port 443** - HTTPS (0.0.0.0/0) - for future SSL

### Step 12: Test Application

```bash
# Get your public IP
curl http://169.254.169.254/latest/meta-data/public-ipv4

# Visit in browser
http://your-ec2-public-ip/index.php
```

## 🔧 Configuration Files

### Apache Virtual Host (Optional)

```bash
# Create virtual host configuration
sudo nano /etc/httpd/conf.d/employee-management.conf
```

**Add:**
```apache
<VirtualHost *:80>
    ServerAdmin admin@yourdomain.com
    DocumentRoot /var/www/html
    ServerName yourdomain.com
    ServerAlias www.yourdomain.com

    <Directory /var/www/html>
        Options -Indexes +FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>

    ErrorLog /var/log/httpd/employee-error.log
    CustomLog /var/log/httpd/employee-access.log combined
</VirtualHost>
```

**Restart Apache:**
```bash
sudo systemctl restart httpd
```

## 🐛 Troubleshooting

### MariaDB Won't Start

```bash
# Check status
sudo systemctl status mariadb

# Check logs
sudo journalctl -u mariadb -n 50

# Restart service
sudo systemctl restart mariadb
```

### Apache Won't Start

```bash
# Check status
sudo systemctl status httpd

# Check configuration
sudo httpd -t

# Check logs
sudo tail -f /var/log/httpd/error_log
```

### Can't Connect to Database

```bash
# Test MariaDB connection
mysql -u empuser -p

# Check if database exists
mysql -u root -p -e "SHOW DATABASES;"

# Verify user privileges
mysql -u root -p -e "SHOW GRANTS FOR 'empuser'@'localhost';"
```

### Permission Denied Errors

```bash
# Fix ownership
sudo chown -R apache:apache /var/www/html

# Fix permissions
sudo chmod -R 755 /var/www/html

# Check SELinux (if enabled)
sudo getenforce

# If SELinux is enforcing, set proper context
sudo chcon -R -t httpd_sys_content_t /var/www/html
sudo chcon -R -t httpd_sys_rw_content_t /var/www/html/uploads  # if you have uploads
```

### Can't Access from Browser

```bash
# Check if Apache is running
sudo systemctl status httpd

# Check if port 80 is listening
sudo netstat -tlnp | grep :80

# Check firewall
sudo iptables -L -n

# Verify Security Groups in AWS Console
```

## 🔐 Security Hardening

### 1. Configure Firewall

```bash
# Install and configure firewalld (if not installed)
sudo dnf install firewalld -y  # AL2023
sudo yum install firewalld -y  # AL2

sudo systemctl start firewalld
sudo systemctl enable firewalld

# Allow HTTP and HTTPS
sudo firewall-cmd --permanent --add-service=http
sudo firewall-cmd --permanent --add-service=https
sudo firewall-cmd --reload
```

### 2. Secure PHP Configuration

```bash
# Edit php.ini
sudo nano /etc/php.ini
```

**Update these settings:**
```ini
display_errors = Off
log_errors = On
error_log = /var/log/php/error.log
expose_php = Off
upload_max_filesize = 2M
post_max_size = 8M
max_execution_time = 30
```

**Create log directory:**
```bash
sudo mkdir -p /var/log/php
sudo chown apache:apache /var/log/php
sudo systemctl restart httpd
```

### 3. Secure MariaDB

```bash
# Edit MariaDB configuration
sudo nano /etc/my.cnf.d/server.cnf
```

**Add under [mysqld]:**
```ini
[mysqld]
bind-address = 127.0.0.1
max_connections = 50
```

**Restart MariaDB:**
```bash
sudo systemctl restart mariadb
```

## 📊 Monitoring and Logs

### View Logs

```bash
# Apache access log
sudo tail -f /var/log/httpd/access_log

# Apache error log
sudo tail -f /var/log/httpd/error_log

# MariaDB log
sudo tail -f /var/log/mariadb/mariadb.log

# PHP errors
sudo tail -f /var/log/php/error.log

# System log
sudo journalctl -f
```

### Monitor Resources

```bash
# Check disk usage
df -h

# Check memory usage
free -m

# Check running processes
top

# Check Apache status
sudo systemctl status httpd

# Check MariaDB status
sudo systemctl status mariadb
```

## 💾 Backup Strategy

### Automated Backup Script

```bash
# Create backup script
sudo nano /usr/local/bin/backup-employee-db.sh
```

**Add:**
```bash
#!/bin/bash
BACKUP_DIR="/home/ec2-user/backups"
DATE=$(date +%Y%m%d_%H%M%S)
DB_NAME="php_employee_management"
DB_USER="empuser"
DB_PASS="YourStrongPassword123!"

# Create backup directory
mkdir -p $BACKUP_DIR

# Backup database
mysqldump -u $DB_USER -p$DB_PASS $DB_NAME > $BACKUP_DIR/db_backup_$DATE.sql

# Compress backup
gzip $BACKUP_DIR/db_backup_$DATE.sql

# Keep only last 7 days
find $BACKUP_DIR -name "db_backup_*.sql.gz" -mtime +7 -delete

echo "Backup completed: db_backup_$DATE.sql.gz"
```

**Make executable:**
```bash
sudo chmod +x /usr/local/bin/backup-employee-db.sh
```

**Schedule with cron:**
```bash
crontab -e
```

**Add daily backup at 2 AM:**
```
0 2 * * * /usr/local/bin/backup-employee-db.sh >> /var/log/backup.log 2>&1
```

## 🚀 Performance Optimization

### Enable PHP OPcache

```bash
# Edit php.ini
sudo nano /etc/php.ini
```

**Add/update:**
```ini
[opcache]
opcache.enable=1
opcache.memory_consumption=128
opcache.interned_strings_buffer=8
opcache.max_accelerated_files=4000
opcache.revalidate_freq=60
```

### Optimize MariaDB

```bash
sudo nano /etc/my.cnf.d/server.cnf
```

**Add:**
```ini
[mysqld]
innodb_buffer_pool_size = 256M
query_cache_size = 16M
query_cache_type = 1
max_connections = 50
```

**Restart services:**
```bash
sudo systemctl restart httpd
sudo systemctl restart mariadb
```

## 📝 Quick Reference Commands

```bash
# Restart services
sudo systemctl restart httpd
sudo systemctl restart mariadb

# Check service status
sudo systemctl status httpd
sudo systemctl status mariadb

# View logs
sudo tail -f /var/log/httpd/error_log
sudo tail -f /var/log/mariadb/mariadb.log

# Database backup
mysqldump -u empuser -p php_employee_management > backup.sql

# Database restore
mysql -u empuser -p php_employee_management < backup.sql

# Update application
cd /var/www/html
sudo git pull origin main
sudo systemctl restart httpd
```

## 🎉 Success!

Your application should now be running at: `http://your-ec2-public-ip/index.php`

## 📚 Next Steps

1. ✅ Set up domain name
2. ✅ Install SSL certificate (Let's Encrypt)
3. ✅ Configure automated backups
4. ✅ Set up monitoring
5. ✅ Implement security best practices

---

**For SSL setup, see: [EC2_DEPLOYMENT_GUIDE.md](EC2_DEPLOYMENT_GUIDE.md)**
