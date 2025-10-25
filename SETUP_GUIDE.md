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

### Check MySQL Installation

```bash
mysql --version
```

## Installation Steps

### Step 1: Clone or Download the Project

If you haven't already:

```bash
cd /Users/admin/ysa-edu.website
git clone https://github.com/yaulia-search/PHP-MySQL-Employee-Management-CRUD.git
cd PHP-MySQL-Employee-Management-CRUD
```

### Step 2: Start MySQL Server

**On macOS:**

```bash
# If using Homebrew
brew services start mysql

# Or manually
mysql.server start
```

**On Windows:**
- Start MySQL from XAMPP/WAMP control panel
- Or start from Services

**On Linux:**

```bash
sudo systemctl start mysql
```

### Step 3: Create Database

**Option A: Using Command Line**

```bash
# Login to MySQL
mysql -u root -p

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
mysql -u root -p < database/schema.sql
```

### Step 4: Configure Database Connection

The application uses `config.php` for database settings. Update if needed:

```php
// config.php
define('DB_HOST', 'localhost');
define('DB_USER', 'root');
define('DB_PASS', '');  // Your MySQL password
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
- Check if MySQL is running: `mysql.server status`
- Verify database credentials in `config.php`
- Ensure database exists: `SHOW DATABASES;`

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

### Issue 5: MySQL Access Denied

**Solution:**
```bash
# Reset MySQL root password
mysql -u root
ALTER USER 'root'@'localhost' IDENTIFIED BY 'your_new_password';
FLUSH PRIVILEGES;
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
# Backup database
mysqldump -u root -p php_employee_management > backup.sql

# Restore database
mysql -u root -p php_employee_management < backup.sql
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

## Resources

- [PHP Documentation](https://www.php.net/docs.php)
- [MySQL Documentation](https://dev.mysql.com/doc/)
- [Bootstrap Documentation](https://getbootstrap.com/docs/)

---

**Happy Coding! 🚀**
