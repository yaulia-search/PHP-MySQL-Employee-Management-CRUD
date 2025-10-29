# Employee Management System - Setup Guide

Complete guide to set up and run the PHP Employee Management application on your local machine.

## Prerequisites

Before you begin, ensure you have the following installed:

- **PHP 7.4 or higher** - [Download PHP](https://www.php.net/downloads)
- **MySQL 5.7+ or MariaDB 10.3+** - [Download MySQL](https://dev.mysql.com/downloads/)
- **Web Server** (Apache/Nginx) or use PHP's built-in server
- **phpMyAdmin** (optional, for easier database management)

### Check Your PHP Version

```bash
php -v
```

### Check MySQL/MariaDB Installation

```bash
# For MySQL
mysql --version

# For MariaDB
mariadb --version
# or
mysql --version  # MariaDB also responds to mysql command
```

## Installation Steps

### Step 1: Clone or Download the Project

If you haven't already:

```bash
cd /Users/admin/ysa-edu.website
git clone https://github.com/yaulia-search/PHP-MySQL-Employee-Management-CRUD.git
cd PHP-MySQL-Employee-Management-CRUD
```

### Step 2: Start MySQL/MariaDB Server

**On macOS:**

```bash
# If using Homebrew (MySQL)
brew services start mysql

# If using Homebrew (MariaDB)
brew services start mariadb

# Or manually
mysql.server start
```

**On Windows:**
- Start MySQL from XAMPP/WAMP control panel
- Or start from Services

**On Amazon Linux 2 / Amazon Linux 2023:**

```bash
# Start MariaDB
sudo systemctl start mariadb

# Enable MariaDB to start on boot
sudo systemctl enable mariadb

# Check status
sudo systemctl status mariadb
```

**On Ubuntu/Debian Linux:**

```bash
# For MySQL
sudo systemctl start mysql

# For MariaDB
sudo systemctl start mariadb
```

**On CentOS/RHEL:**

```bash
# For MariaDB
sudo systemctl start mariadb

# For MySQL
sudo systemctl start mysqld
```

### Step 3: Create Database

**Option A: Using Command Line**

```bash
# Login to MySQL/MariaDB
mysql -u root -p

# For MariaDB on Amazon Linux (if no password set initially)
sudo mysql

# Create database (copy and paste from schema.sql)
source database/schema.sql

# Or manually:
CREATE DATABASE php_employee_management;
USE php_employee_management;
```

**Option B: Using phpMyAdmin**

1. Open phpMyAdmin (usually at `http://localhost/phpmyadmin`)
2. Click "Import" tab
3. Choose `database/schema.sql` file
4. Click "Go"

**Option C: Quick Command**

```bash
# Standard method
mysql -u root -p < database/schema.sql

# For MariaDB on Amazon Linux (if using sudo)
sudo mysql < database/schema.sql

# Or if you have a password
mysql -u root -p php_employee_management < database/schema.sql
```

### Step 4: Configure Database Connection

The application uses `config.php` for database settings. Update if needed:

```php
// config.php
define('DB_HOST', 'localhost');
define('DB_USER', 'root');  // or your MariaDB user
define('DB_PASS', '');  // Your MySQL/MariaDB password
define('DB_NAME', 'php_employee_management');
```

**For Amazon Linux with MariaDB:**

If you created a dedicated database user:

```php
define('DB_HOST', 'localhost');
define('DB_USER', 'empuser');  // your database user
define('DB_PASS', 'your_password');  // your database password
define('DB_NAME', 'php_employee_management');
```

### Step 5: Start the Application

**Option A: PHP Built-in Server (Recommended for Development)**

```bash
# From the project root directory
php -S localhost:8000
```

Then open your browser and visit: `http://localhost:8000`

**Option B: Using XAMPP/WAMP**

1. Copy project folder to `htdocs` (XAMPP) or `www` (WAMP)
2. Start Apache and MySQL from control panel
3. Visit: `http://localhost/PHP-MySQL-Employee-Management-CRUD/`

**Option C: Using MAMP (macOS)**

1. Copy project to MAMP's `htdocs` folder
2. Start MAMP servers
3. Visit: `http://localhost:8888/PHP-MySQL-Employee-Management-CRUD/`

## Verification

### Test Database Connection

Create a test file `test-connection.php`:

```php
<?php
require_once 'config.php';

$connection = getDatabaseConnection();

if ($connection) {
    echo "✅ Database connection successful!<br>";
    echo "Database: " . DB_NAME . "<br>";
    
    // Test query
    $result = $connection->query("SELECT COUNT(*) as count FROM employee");
    $row = $result->fetch_assoc();
    echo "Total employees in database: " . $row['count'];
    
    closeDatabaseConnection($connection);
} else {
    echo "❌ Database connection failed!";
}
?>
```

Visit: `http://localhost:8000/test-connection.php`

## Common Issues and Solutions

### Issue 1: "Connection failed" Error

**Solution:**

**On macOS:**
```bash
# Check MySQL status
mysql.server status

# Or for Homebrew
brew services list | grep mysql
```

**On Amazon Linux:**
```bash
# Check MariaDB status
sudo systemctl status mariadb

# Start if not running
sudo systemctl start mariadb
```

**On any system:**
- Verify database credentials in `config.php`
- Ensure database exists: `SHOW DATABASES;`
- Test connection: `mysql -u root -p` or `sudo mysql`

### Issue 2: "Table doesn't exist" Error

**Solution:**
- Import the database schema: `mysql -u root -p php_employee_management < database/schema.sql`
- Or create tables manually using phpMyAdmin

### Issue 3: Port 8000 Already in Use

**Solution:**
```bash
# Use a different port
php -S localhost:8080
```

### Issue 4: Permission Denied

**Solution:**
```bash
# Fix permissions (macOS/Linux)
chmod -R 755 /path/to/project
```

### Issue 5: MySQL/MariaDB Access Denied

**Solution for MySQL:**
```bash
# Reset MySQL root password
mysql -u root
ALTER USER 'root'@'localhost' IDENTIFIED BY 'your_new_password';
FLUSH PRIVILEGES;
```

**Solution for MariaDB on Amazon Linux:**
```bash
# Access MariaDB as root
sudo mysql

# Set password for root user
ALTER USER 'root'@'localhost' IDENTIFIED BY 'your_new_password';
FLUSH PRIVILEGES;
EXIT;

# Or create a new user
CREATE USER 'empuser'@'localhost' IDENTIFIED BY 'your_password';
GRANT ALL PRIVILEGES ON php_employee_management.* TO 'empuser'@'localhost';
FLUSH PRIVILEGES;
EXIT;
```

## Application Features

### 1. View Employees
- Navigate to home page
- See list of all employees with their details

### 2. Add New Employee
- Click "New Employee" button
- Fill in the form (all fields required)
- Submit to add employee

### 3. Edit Employee
- Click "Edit" button next to any employee
- Update information
- Submit to save changes

### 4. Delete Employee
- Click "Delete" button next to any employee
- Employee will be removed from database

## Project Structure

```
PHP-MySQL-Employee-Management-CRUD/
├── config.php                  # Database configuration
├── index.php                   # Home page - List employees
├── create-new-employee.php     # Add new employee
├── edit-employee.php           # Edit employee details
├── delete-employee.php         # Delete employee
├── database/
│   └── schema.sql             # Database schema and sample data
├── README.md                   # Original README
├── SETUP_GUIDE.md             # This file
└── .gitignore                 # Git ignore rules
```

## Development Tips

### Enable Error Reporting

Add to the top of your PHP files during development:

```php
<?php
error_reporting(E_ALL);
ini_set('display_errors', 1);
?>
```

### Check PHP Logs

```bash
# macOS/Linux
tail -f /var/log/apache2/error.log

# Or PHP built-in server shows errors in terminal
```

### Database Backup

```bash
# Backup database (MySQL/MariaDB)
mysqldump -u root -p php_employee_management > backup.sql

# For MariaDB on Amazon Linux (with sudo)
sudo mysqldump php_employee_management > backup.sql

# Restore database
mysql -u root -p php_employee_management < backup.sql

# Or with sudo
sudo mysql php_employee_management < backup.sql
```

## Next Steps: Preparing for EC2 Deployment

### 1. Security Improvements Needed

- [ ] Use prepared statements (prevent SQL injection)
- [ ] Add input validation and sanitization
- [ ] Implement CSRF protection
- [ ] Add authentication system
- [ ] Use HTTPS in production

### 2. Configuration for Production

- [ ] Create separate `config.production.php`
- [ ] Use environment variables for sensitive data
- [ ] Disable error display in production
- [ ] Enable error logging

### 3. EC2 Deployment Checklist

- [ ] Install LAMP stack on EC2
- [ ] Configure security groups (ports 80, 443, 22)
- [ ] Set up domain/subdomain
- [ ] Install SSL certificate (Let's Encrypt)
- [ ] Configure Apache virtual host
- [ ] Set proper file permissions
- [ ] Import database on EC2 MySQL
- [ ] Update config.php with EC2 database credentials

## Support

If you encounter any issues:

1. Check the error logs
2. Verify all prerequisites are installed
3. Ensure MySQL is running
4. Check database credentials
5. Review this guide's troubleshooting section

## Amazon Linux Specific Setup

### Install LAMP Stack on Amazon Linux 2023

```bash
# Update system
sudo dnf update -y

# Install Apache
sudo dnf install httpd -y
sudo systemctl start httpd
sudo systemctl enable httpd

# Install PHP 8.x
sudo dnf install php php-cli php-mysqlnd php-json php-mbstring -y

# Install MariaDB
sudo dnf install mariadb105-server -y
sudo systemctl start mariadb
sudo systemctl enable mariadb

# Secure MariaDB installation
sudo mysql_secure_installation

# Verify installations
php -v
mysql --version
```

### Install LAMP Stack on Amazon Linux 2

```bash
# Update system
sudo yum update -y

# Install Apache
sudo yum install httpd -y
sudo systemctl start httpd
sudo systemctl enable httpd

# Install PHP 7.4+
sudo amazon-linux-extras install php7.4 -y

# Install MariaDB
sudo yum install mariadb-server -y
sudo systemctl start mariadb
sudo systemctl enable mariadb

# Secure MariaDB installation
sudo mysql_secure_installation
```

### Deploy Application on Amazon Linux

```bash
# Navigate to web root
cd /var/www/html

# Clone repository
sudo git clone https://github.com/yaulia-search/PHP-MySQL-Employee-Management-CRUD.git .

# Set permissions
sudo chown -R apache:apache /var/www/html
sudo chmod -R 755 /var/www/html

# Import database
sudo mysql < database/schema.sql

# Configure database credentials in config.php
sudo nano config.php

# Restart Apache
sudo systemctl restart httpd
```

## Resources

- [PHP Documentation](https://www.php.net/docs.php)
- [MySQL Documentation](https://dev.mysql.com/doc/)
- [MariaDB Documentation](https://mariadb.org/documentation/)
- [Amazon Linux Documentation](https://docs.aws.amazon.com/linux/)
- [Bootstrap Documentation](https://getbootstrap.com/docs/)

---

**Happy Coding! 🚀**
