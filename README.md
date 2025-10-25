# Employee Management System - PHP CRUD Application

A simple and efficient Employee Management System built with PHP and MySQL. This application demonstrates basic CRUD (Create, Read, Update, Delete) operations with a clean, modern interface.

## 🌟 Features

- ✅ **View Employees** - Display all employees in a clean table format
- ➕ **Add Employee** - Create new employee records with validation
- ✏️ **Edit Employee** - Update existing employee information
- 🗑️ **Delete Employee** - Remove employee records
- 📱 **Responsive Design** - Works on desktop, tablet, and mobile devices
- 🎨 **Modern UI** - Built with Bootstrap 5
- 🔒 **Form Validation** - Client and server-side validation

## 🛠️ Technology Stack

### Frontend
- HTML5
- CSS3
- Bootstrap 5.3.2
- JavaScript

### Backend
- PHP 7.4+
- Core PHP (No frameworks)

### Database
- MySQL 5.7+ / MariaDB 10.3+

## 📋 Prerequisites

Before you begin, ensure you have the following installed:

- **PHP 7.4 or higher** - [Download](https://www.php.net/downloads)
- **MySQL 5.7+ or MariaDB 10.3+** - [Download](https://dev.mysql.com/downloads/)
- **Web Server** - Apache/Nginx or use PHP's built-in server

## 🚀 Quick Start

### 1. Clone the Repository

```bash
git clone https://github.com/yaulia-search/PHP-MySQL-Employee-Management-CRUD.git
cd PHP-MySQL-Employee-Management-CRUD
```

### 2. Setup Database

```bash
# Login to MySQL
mysql -u root -p

# Import database schema
source database/schema.sql

# Or use this command directly
mysql -u root -p < database/schema.sql
```

### 3. Configure Database Connection

Update `config.php` with your database credentials:

```php
define('DB_HOST', 'localhost');
define('DB_USER', 'root');
define('DB_PASS', '');  // Your MySQL password
define('DB_NAME', 'php_employee_management');
```

### 4. Start the Application

**Option A: Quick Start Script (Recommended)**

```bash
./start-server.sh
```

**Option B: Manual Start**

```bash
php -S localhost:8000
```

### 5. Access the Application

Open your browser and visit:
- **Application:** http://localhost:8000/index.php
- **Connection Test:** http://localhost:8000/test-connection.php

## 📁 Project Structure

```
PHP-MySQL-Employee-Management-CRUD/
├── config.php                  # Database configuration
├── index.php                   # Home page - List employees
├── create-new-employee.php     # Add new employee
├── edit-employee.php           # Edit employee details
├── delete-employee.php         # Delete employee
├── test-connection.php         # Database connection test
├── start-server.sh            # Quick start script
├── database/
│   └── schema.sql             # Database schema and sample data
├── SETUP_GUIDE.md             # Detailed setup instructions
├── EC2_DEPLOYMENT_GUIDE.md    # AWS EC2 deployment guide
├── .gitignore                 # Git ignore rules
└── README.md                  # This file
```

## 📖 Documentation

- **[SETUP_GUIDE.md](SETUP_GUIDE.md)** - Comprehensive local setup guide with troubleshooting
- **[EC2_DEPLOYMENT_GUIDE.md](EC2_DEPLOYMENT_GUIDE.md)** - Complete AWS EC2 deployment guide

## 🎯 Usage

### View Employees
Navigate to the home page to see a list of all employees with their details (Name, Email, Phone, Address, Created Date).

### Add New Employee
1. Click the "New Employee" button
2. Fill in all required fields:
   - Name
   - Email
   - Phone
   - Address
3. Click "Submit" to save

### Edit Employee
1. Click the "Edit" button next to any employee
2. Update the information
3. Click "Submit" to save changes

### Delete Employee
1. Click the "Delete" button next to any employee
2. The employee will be removed from the database

## 🔧 Configuration

### Database Settings

Edit `config.php` to change database settings:

```php
define('DB_HOST', 'localhost');     // Database host
define('DB_USER', 'root');          // Database username
define('DB_PASS', '');              // Database password
define('DB_NAME', 'php_employee_management'); // Database name
```

### Application Settings

```php
define('APP_NAME', 'Employee Management System');
define('APP_VERSION', '1.0.0');
date_default_timezone_set('Asia/Jakarta'); // Set your timezone
```

## 🐛 Troubleshooting

### Database Connection Failed

```bash
# Check if MySQL is running
mysql.server status

# Start MySQL
mysql.server start  # macOS
sudo systemctl start mysql  # Linux
```

### Table Doesn't Exist

```bash
# Import the database schema
mysql -u root -p php_employee_management < database/schema.sql
```

### Port Already in Use

```bash
# Use a different port
php -S localhost:8080
```

For more troubleshooting tips, see [SETUP_GUIDE.md](SETUP_GUIDE.md).

## 🚀 Deployment to AWS EC2

Ready to deploy to production? Follow our comprehensive guide:

👉 **[EC2_DEPLOYMENT_GUIDE.md](EC2_DEPLOYMENT_GUIDE.md)**

The guide includes:
- EC2 instance setup
- LAMP stack installation
- Security configuration
- SSL certificate setup
- Performance optimization
- Backup strategies

## 🔒 Security Considerations

**⚠️ Important:** This is a basic CRUD application for learning purposes. Before deploying to production:

- [ ] Implement prepared statements to prevent SQL injection
- [ ] Add input validation and sanitization
- [ ] Implement user authentication and authorization
- [ ] Add CSRF protection
- [ ] Use HTTPS in production
- [ ] Implement rate limiting
- [ ] Add logging and monitoring
- [ ] Remove test files (test-connection.php)
- [ ] Disable error display in production
- [ ] Use environment variables for sensitive data

## 📸 Screenshots

### Home Page - Employee List
![home](https://github.com/mdtalalwasim/PHP-MySQL-CRUD-Operation-Employee-Management-CRUD/assets/91146041/7b9187bc-c32b-4d5b-9b45-c9ab34ed8d2c)

### Add New Employee Form
![add-new-employee-form](https://github.com/mdtalalwasim/PHP-MySQL-CRUD-Operation-Employee-Management-CRUD/assets/91146041/f04bbda7-46aa-441c-9538-5d31c461fd39)

### Edit Employee
![Edit-Employee](https://github.com/mdtalalwasim/PHP-MySQL-CRUD-Operation-Employee-Management-CRUD/assets/91146041/dfdbda99-36be-4d69-951d-d678dac1bf62)

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📝 License

This project is open source and available under the [MIT License](LICENSE).

## 👨‍💻 Author

**YSA Education Team**

## 🙏 Acknowledgments

- Bootstrap team for the amazing CSS framework
- PHP and MySQL communities
- All contributors and users

## 📞 Support

If you encounter any issues or have questions:

1. Check the [SETUP_GUIDE.md](SETUP_GUIDE.md) for detailed instructions
2. Review the troubleshooting section
3. Open an issue on GitHub

## 🔗 Useful Links

- [PHP Documentation](https://www.php.net/docs.php)
- [MySQL Documentation](https://dev.mysql.com/doc/)
- [Bootstrap Documentation](https://getbootstrap.com/docs/)
- [AWS EC2 Documentation](https://docs.aws.amazon.com/ec2/)

---

**Made with ❤️ for learning and development**

⭐ Star this repository if you find it helpful!
