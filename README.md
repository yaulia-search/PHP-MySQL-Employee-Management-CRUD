# Employee Management System - PHP CRUD Application

A simple and efficient Employee Management System built with PHP and MySQL, deployed on AWS Lightsail with Apache.

## 🌟 Features

- ✅ **View Employees** - Display all employees in a clean table format
- ➕ **Add Employee** - Create new employee records with validation
- ✏️ **Edit Employee** - Update existing employee information
- 🗑️ **Delete Employee** - Remove employee records
- 📱 **Responsive Design** - Works on desktop, tablet, and mobile devices
- 🎨 **Modern UI** - Built with Bootstrap 5

## 🛠️ Technology Stack

- **Frontend:** HTML5, CSS3, Bootstrap 5, JavaScript
- **Backend:** PHP 8.3, Apache
- **Database:** MariaDB 10.5
- **Hosting:** AWS Lightsail (Amazon Linux 2023)

## 🚀 Quick Deployment

### Prerequisites
- AWS Account with Lightsail access

### Deploy to AWS Lightsail

1. **Run deployment script:**
```bash
./deploy-to-lightsail.sh
```

2. **Access your application:**
- **URL:** http://52.91.83.238
- **Test:** http://52.91.83.238/test-connection.php

3. **SSH access:**
```bash
ssh -i LightsailDefaultKey-us-east-1.pem ec2-user@52.91.83.238
```

## 📁 Project Structure

```
PHP-MySQL-Employee-Management-CRUD/
├── config.php                     # Database configuration
├── config-production.php          # Production database config
├── index.php                      # Home page - List employees
├── create-new-employee.php        # Add new employee
├── edit-employee.php              # Edit employee details
├── delete-employee.php            # Delete employee
├── test-connection.php            # Database connection test
├── deploy-to-lightsail.sh         # Deployment script
├── LIGHTSAIL_DEPLOYMENT.md        # Deployment guide
├── LightsailDefaultKey-us-east-1.pem # SSH key
└── database/
    └── schema.sql                 # Database schema and sample data
```

## 🎯 Usage

### View Employees
Navigate to the home page to see all employees with their details.

### Add New Employee
1. Click "New Employee" button
2. Fill required fields (Name, Email, Phone, Address)
3. Click "Submit"

### Edit Employee
1. Click "Edit" button next to employee
2. Update information
3. Click "Submit"

### Delete Employee
1. Click "Delete" button next to employee
2. Employee will be removed

## 💰 Cost

- **Instance:** $7/month (Micro - 1GB RAM, 40GB SSD)
- **Data Transfer:** 2TB included
- **Total:** ~$7/month

## 🔒 Security

- Apache web server
- PHP 8.3 with security settings
- MariaDB with dedicated user
- Firewall configured (HTTP/HTTPS/SSH only)

## 📸 Screenshots

### Home Page
![Employee List](https://github.com/mdtalalwasim/PHP-MySQL-CRUD-Operation-Employee-Management-CRUD/assets/91146041/7b9187bc-c32b-4d5b-9b45-c9ab34ed8d2c)

### Add Employee
![Add Employee](https://github.com/mdtalalwasim/PHP-MySQL-CRUD-Operation-Employee-Management-CRUD/assets/91146041/f04bbda7-46aa-441c-9538-5d31c461fd39)

## 📞 Support

For deployment issues, check the [LIGHTSAIL_DEPLOYMENT.md](LIGHTSAIL_DEPLOYMENT.md) guide.

---

**Deployed on AWS Lightsail with ❤️**
