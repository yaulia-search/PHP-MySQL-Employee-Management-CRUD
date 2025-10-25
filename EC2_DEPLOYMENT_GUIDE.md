# AWS EC2 Deployment Guide

Complete guide to deploy your PHP Employee Management application on AWS EC2.

## Prerequisites

- AWS Account
- EC2 Instance (Ubuntu 20.04 or Amazon Linux 2)
- SSH Key Pair
- Domain name (optional but recommended)

## Part 1: EC2 Instance Setup

### Step 1: Launch EC2 Instance

1. **Login to AWS Console**
   - Go to EC2 Dashboard
   - Click "Launch Instance"

2. **Configure Instance**
   - **Name:** employee-management-server
   - **AMI:** Ubuntu Server 20.04 LTS (Free tier eligible)
   - **Instance Type:** t2.micro (Free tier eligible)
   - **Key Pair:** Create new or use existing
   - **Network Settings:**
     - Allow SSH (port 22) from your IP
     - Allow HTTP (port 80) from anywhere
     - Allow HTTPS (port 443) from anywhere

3. **Storage:** 8 GB (default is fine)

4. **Launch Instance**

### Step 2: Connect to EC2 Instance

```bash
# Change permission of your key file
chmod 400 your-key.pem

# Connect via SSH
ssh -i your-key.pem ubuntu@your-ec2-public-ip
```

## Part 2: Server Configuration

### Step 1: Update System

```bash
sudo apt update
sudo apt upgrade -y
```

### Step 2: Install LAMP Stack

**Install Apache:**

```bash
sudo apt install apache2 -y
sudo systemctl start apache2
sudo systemctl enable apache2
sudo systemctl status apache2
```

**Install MySQL:**

```bash
sudo apt install mysql-server -y
sudo systemctl start mysql
sudo systemctl enable mysql

# Secure MySQL installation
sudo mysql_secure_installation
```

**Install PHP:**

```bash
sudo apt install php libapache2-mod-php php-mysql php-cli php-curl php-json php-mbstring -y

# Verify installation
php -v
```

**Install Additional Tools:**

```bash
sudo apt install git unzip -y
```

### Step 3: Configure MySQL

```bash
# Login to MySQL
sudo mysql

# Create database and user
CREATE DATABASE php_employee_management;
CREATE USER 'empuser'@'localhost' IDENTIFIED BY 'YourStrongPassword123!';
GRANT ALL PRIVILEGES ON php_employee_management.* TO 'empuser'@'localhost';
FLUSH PRIVILEGES;
EXIT;
```

### Step 4: Configure Apache

**Enable mod_rewrite:**

```bash
sudo a2enmod rewrite
sudo systemctl restart apache2
```

**Set proper permissions:**

```bash
sudo chown -R www-data:www-data /var/www/html
sudo chmod -R 755 /var/www/html
```

## Part 3: Deploy Application

### Step 1: Upload Application Files

**Option A: Using Git**

```bash
cd /var/www/html
sudo rm index.html  # Remove default page
sudo git clone https://github.com/yaulia-search/PHP-MySQL-Employee-Management-CRUD.git .
```

**Option B: Using SCP (from your local machine)**

```bash
# From your local machine
scp -i your-key.pem -r /Users/admin/ysa-edu.website/PHP-MySQL-Employee-Management-CRUD/* ubuntu@your-ec2-ip:/tmp/

# On EC2 instance
sudo mv /tmp/* /var/www/html/
```

### Step 2: Configure Application

**Update config.php:**

```bash
sudo nano /var/www/html/config.php
```

Update with EC2 database credentials:

```php
define('DB_HOST', 'localhost');
define('DB_USER', 'empuser');
define('DB_PASS', 'YourStrongPassword123!');
define('DB_NAME', 'php_employee_management');
```

### Step 3: Import Database

```bash
mysql -u empuser -p php_employee_management < /var/www/html/database/schema.sql
```

### Step 4: Set Permissions

```bash
sudo chown -R www-data:www-data /var/www/html
sudo chmod -R 755 /var/www/html
sudo chmod 644 /var/www/html/config.php
```

### Step 5: Test Application

Visit: `http://your-ec2-public-ip/index.php`

## Part 4: Security Hardening

### Step 1: Configure Firewall

```bash
# Install UFW
sudo apt install ufw -y

# Configure firewall rules
sudo ufw allow OpenSSH
sudo ufw allow 'Apache Full'
sudo ufw enable
sudo ufw status
```

### Step 2: Remove Test Files

```bash
sudo rm /var/www/html/test-connection.php
```

### Step 3: Secure PHP Configuration

```bash
sudo nano /etc/php/7.4/apache2/php.ini
```

Update these settings:

```ini
display_errors = Off
log_errors = On
error_log = /var/log/php/error.log
expose_php = Off
upload_max_filesize = 2M
post_max_size = 8M
```

Create log directory:

```bash
sudo mkdir -p /var/log/php
sudo chown www-data:www-data /var/log/php
```

Restart Apache:

```bash
sudo systemctl restart apache2
```

### Step 4: Configure Apache Virtual Host

```bash
sudo nano /etc/apache2/sites-available/employee-management.conf
```

Add:

```apache
<VirtualHost *:80>
    ServerAdmin admin@yourdomain.com
    ServerName yourdomain.com
    ServerAlias www.yourdomain.com
    DocumentRoot /var/www/html
    
    <Directory /var/www/html>
        Options -Indexes +FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>
    
    ErrorLog ${APACHE_LOG_DIR}/error.log
    CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
```

Enable site:

```bash
sudo a2ensite employee-management.conf
sudo systemctl reload apache2
```

## Part 5: SSL Certificate (HTTPS)

### Install Certbot

```bash
sudo apt install certbot python3-certbot-apache -y
```

### Obtain SSL Certificate

```bash
sudo certbot --apache -d yourdomain.com -d www.yourdomain.com
```

Follow the prompts and choose to redirect HTTP to HTTPS.

### Auto-renewal

```bash
# Test renewal
sudo certbot renew --dry-run

# Certbot automatically sets up auto-renewal
```

## Part 6: Monitoring and Maintenance

### Setup Log Rotation

```bash
sudo nano /etc/logrotate.d/apache2
```

### Monitor Logs

```bash
# Apache error logs
sudo tail -f /var/log/apache2/error.log

# Apache access logs
sudo tail -f /var/log/apache2/access.log

# PHP error logs
sudo tail -f /var/log/php/error.log
```

### Database Backup Script

Create backup script:

```bash
sudo nano /usr/local/bin/backup-database.sh
```

Add:

```bash
#!/bin/bash
BACKUP_DIR="/home/ubuntu/backups"
DATE=$(date +%Y%m%d_%H%M%S)
mkdir -p $BACKUP_DIR

mysqldump -u empuser -p'YourStrongPassword123!' php_employee_management > $BACKUP_DIR/db_backup_$DATE.sql

# Keep only last 7 days of backups
find $BACKUP_DIR -name "db_backup_*.sql" -mtime +7 -delete

echo "Backup completed: db_backup_$DATE.sql"
```

Make executable:

```bash
sudo chmod +x /usr/local/bin/backup-database.sh
```

Setup cron job:

```bash
crontab -e
```

Add daily backup at 2 AM:

```
0 2 * * * /usr/local/bin/backup-database.sh >> /var/log/backup.log 2>&1
```

## Part 7: Performance Optimization

### Enable PHP OPcache

```bash
sudo nano /etc/php/7.4/apache2/php.ini
```

Add/update:

```ini
opcache.enable=1
opcache.memory_consumption=128
opcache.interned_strings_buffer=8
opcache.max_accelerated_files=4000
opcache.revalidate_freq=60
```

### Enable Apache Compression

```bash
sudo a2enmod deflate
sudo systemctl restart apache2
```

### Configure MySQL

```bash
sudo nano /etc/mysql/mysql.conf.d/mysqld.cnf
```

Add under [mysqld]:

```ini
max_connections = 50
innodb_buffer_pool_size = 128M
query_cache_size = 16M
```

Restart MySQL:

```bash
sudo systemctl restart mysql
```

## Troubleshooting

### Issue: Cannot connect to database

```bash
# Check MySQL status
sudo systemctl status mysql

# Check MySQL logs
sudo tail -f /var/log/mysql/error.log

# Test connection
mysql -u empuser -p
```

### Issue: Permission denied errors

```bash
# Fix permissions
sudo chown -R www-data:www-data /var/www/html
sudo chmod -R 755 /var/www/html
```

### Issue: 500 Internal Server Error

```bash
# Check Apache error logs
sudo tail -f /var/log/apache2/error.log

# Check PHP errors
sudo tail -f /var/log/php/error.log
```

### Issue: Page not loading

```bash
# Check Apache status
sudo systemctl status apache2

# Restart Apache
sudo systemctl restart apache2

# Check if port 80 is open
sudo netstat -tlnp | grep :80
```

## Security Checklist

- [ ] Changed default MySQL root password
- [ ] Created dedicated database user with limited privileges
- [ ] Removed test files (test-connection.php)
- [ ] Configured firewall (UFW)
- [ ] Disabled PHP error display
- [ ] Enabled error logging
- [ ] Installed SSL certificate
- [ ] Set proper file permissions
- [ ] Configured regular backups
- [ ] Updated all system packages
- [ ] Disabled directory listing
- [ ] Changed SSH port (optional)
- [ ] Setup fail2ban (optional)

## Maintenance Commands

```bash
# Update system
sudo apt update && sudo apt upgrade -y

# Restart services
sudo systemctl restart apache2
sudo systemctl restart mysql

# Check disk usage
df -h

# Check memory usage
free -m

# Monitor processes
htop
```

## Cost Estimation

**Free Tier (First 12 months):**
- t2.micro instance: Free
- 30 GB storage: Free
- Data transfer: 15 GB/month free

**After Free Tier:**
- t2.micro: ~$8-10/month
- Storage: ~$1/month
- Data transfer: Varies

**Total estimated cost:** $10-15/month

## Next Steps

1. ✅ Setup monitoring (CloudWatch)
2. ✅ Configure automatic backups
3. ✅ Setup domain name
4. ✅ Install SSL certificate
5. ✅ Implement rate limiting
6. ✅ Add authentication system
7. ✅ Setup CI/CD pipeline (optional)

## Support Resources

- [AWS EC2 Documentation](https://docs.aws.amazon.com/ec2/)
- [Apache Documentation](https://httpd.apache.org/docs/)
- [MySQL Documentation](https://dev.mysql.com/doc/)
- [Let's Encrypt](https://letsencrypt.org/)

---

**Deployment Complete! 🎉**

Your application should now be live at: `https://yourdomain.com`
