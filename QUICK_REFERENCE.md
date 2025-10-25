# Quick Reference Guide

Quick commands and tips for working with the Employee Management System.

## 🚀 Quick Start Commands

### Start Application
```bash
# Quick start (recommended)
./start-server.sh

# Manual start
php -S localhost:8000

# Custom port
php -S localhost:8080
```

### Database Commands
```bash
# Login to MySQL
mysql -u root -p

# Import database
mysql -u root -p < database/schema.sql

# Backup database
mysqldump -u root -p php_employee_management > backup.sql

# Restore database
mysql -u root -p php_employee_management < backup.sql

# Check database exists
mysql -u root -p -e "SHOW DATABASES LIKE 'php_employee_management';"

# View tables
mysql -u root -p php_employee_management -e "SHOW TABLES;"

# Count employees
mysql -u root -p php_employee_management -e "SELECT COUNT(*) FROM employee;"
```

### MySQL Service Commands

**macOS:**
```bash
# Start MySQL
brew services start mysql
# or
mysql.server start

# Stop MySQL
brew services stop mysql
# or
mysql.server stop

# Restart MySQL
brew services restart mysql
# or
mysql.server restart

# Check status
brew services list
# or
mysql.server status
```

**Linux:**
```bash
# Start MySQL
sudo systemctl start mysql

# Stop MySQL
sudo systemctl stop mysql

# Restart MySQL
sudo systemctl restart mysql

# Check status
sudo systemctl status mysql
```

**Windows (XAMPP/WAMP):**
- Use the control panel to start/stop MySQL

## 📁 File Locations

### Configuration
- **Database Config:** `config.php`
- **Database Schema:** `database/schema.sql`

### Application Files
- **Home Page:** `index.php`
- **Add Employee:** `create-new-employee.php`
- **Edit Employee:** `edit-employee.php`
- **Delete Employee:** `delete-employee.php`
- **Test Connection:** `test-connection.php`

## 🔧 Common Tasks

### Change Database Password
```php
// In config.php
define('DB_PASS', 'your_new_password');
```

### Add Sample Data
```sql
INSERT INTO employee (name, email, phone, address) VALUES
('John Doe', 'john@example.com', '1234567890', '123 Main St');
```

### Clear All Data
```sql
TRUNCATE TABLE employee;
```

### Reset Auto Increment
```sql
ALTER TABLE employee AUTO_INCREMENT = 1;
```

### View All Employees
```sql
SELECT * FROM employee ORDER BY created_at DESC;
```

## 🐛 Troubleshooting Quick Fixes

### Can't Connect to Database
```bash
# Check if MySQL is running
ps aux | grep mysql

# Start MySQL
mysql.server start

# Test connection
mysql -u root -p -e "SELECT 1"
```

### Port Already in Use
```bash
# Find process using port 8000
lsof -i :8000

# Kill process
kill -9 <PID>

# Or use different port
php -S localhost:8080
```

### Permission Denied
```bash
# Fix permissions
chmod +x start-server.sh
chmod 644 config.php
```

### Database Doesn't Exist
```bash
# Create database
mysql -u root -p -e "CREATE DATABASE php_employee_management;"

# Import schema
mysql -u root -p php_employee_management < database/schema.sql
```

## 📊 Useful SQL Queries

### View Recent Employees
```sql
SELECT * FROM employee ORDER BY created_at DESC LIMIT 10;
```

### Search by Name
```sql
SELECT * FROM employee WHERE name LIKE '%John%';
```

### Count Employees
```sql
SELECT COUNT(*) as total FROM employee;
```

### Find Duplicate Emails
```sql
SELECT email, COUNT(*) as count 
FROM employee 
GROUP BY email 
HAVING count > 1;
```

### Delete Old Records (older than 1 year)
```sql
DELETE FROM employee 
WHERE created_at < DATE_SUB(NOW(), INTERVAL 1 YEAR);
```

## 🔍 Debugging

### Enable PHP Error Display
```php
// Add to top of PHP file
error_reporting(E_ALL);
ini_set('display_errors', 1);
```

### Check PHP Version
```bash
php -v
```

### Check PHP Extensions
```bash
php -m | grep mysqli
```

### View PHP Configuration
```bash
php -i | grep mysqli
```

### Test PHP Syntax
```bash
php -l index.php
```

## 📝 Git Commands

### Initial Setup
```bash
git init
git add .
git commit -m "Initial commit"
git remote add origin <your-repo-url>
git push -u origin main
```

### Daily Workflow
```bash
# Check status
git status

# Add changes
git add .

# Commit
git commit -m "Your message"

# Push
git push

# Pull latest
git pull
```

## 🌐 URLs

### Local Development
- **Home:** http://localhost:8000/index.php
- **Add Employee:** http://localhost:8000/create-new-employee.php
- **Test Connection:** http://localhost:8000/test-connection.php

### After EC2 Deployment
- **HTTP:** http://your-ec2-ip/index.php
- **HTTPS:** https://yourdomain.com/index.php

## 📦 Backup Strategy

### Quick Backup
```bash
# Database backup
mysqldump -u root -p php_employee_management > backup_$(date +%Y%m%d).sql

# Full project backup
tar -czf backup_$(date +%Y%m%d).tar.gz .
```

### Automated Daily Backup Script
```bash
#!/bin/bash
# Save as backup.sh
BACKUP_DIR="$HOME/backups"
DATE=$(date +%Y%m%d_%H%M%S)
mkdir -p $BACKUP_DIR

# Database backup
mysqldump -u root -p'yourpassword' php_employee_management > $BACKUP_DIR/db_$DATE.sql

# Keep only last 7 days
find $BACKUP_DIR -name "db_*.sql" -mtime +7 -delete

echo "Backup completed: db_$DATE.sql"
```

## 🔐 Security Checklist

- [ ] Change default database password
- [ ] Remove test-connection.php in production
- [ ] Use prepared statements
- [ ] Validate all inputs
- [ ] Enable HTTPS
- [ ] Set proper file permissions
- [ ] Disable error display in production
- [ ] Regular backups
- [ ] Update dependencies

## 📞 Quick Help

### Check Everything is Working
```bash
# 1. Check PHP
php -v

# 2. Check MySQL
mysql --version

# 3. Test MySQL connection
mysql -u root -p -e "SELECT 1"

# 4. Check database exists
mysql -u root -p -e "SHOW DATABASES LIKE 'php_employee_management';"

# 5. Start application
./start-server.sh
```

### Reset Everything
```bash
# 1. Drop database
mysql -u root -p -e "DROP DATABASE IF EXISTS php_employee_management;"

# 2. Recreate database
mysql -u root -p < database/schema.sql

# 3. Restart application
./start-server.sh
```

## 🎯 Performance Tips

### MySQL Optimization
```sql
-- Add indexes for better performance
CREATE INDEX idx_email ON employee(email);
CREATE INDEX idx_created_at ON employee(created_at);

-- Analyze table
ANALYZE TABLE employee;

-- Optimize table
OPTIMIZE TABLE employee;
```

### PHP Optimization
```ini
; In php.ini
opcache.enable=1
opcache.memory_consumption=128
max_execution_time=30
memory_limit=128M
```

## 📚 Additional Resources

- [PHP Manual](https://www.php.net/manual/en/)
- [MySQL Reference](https://dev.mysql.com/doc/refman/8.0/en/)
- [Bootstrap Docs](https://getbootstrap.com/docs/5.3/)
- [MDN Web Docs](https://developer.mozilla.org/)

---

**Keep this guide handy for quick reference! 📌**
