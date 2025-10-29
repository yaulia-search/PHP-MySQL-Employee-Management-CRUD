<?php
/**
 * Production Database Configuration File for AWS Lightsail
 * 
 * This file contains production database connection settings.
 * Update these values according to your Lightsail environment.
 */

// Database Configuration for Production
define('DB_HOST', 'localhost');
define('DB_USER', 'empuser');
define('DB_PASS', 'SecurePass123!');
define('DB_NAME', 'php_employee_management');

// Application Configuration
define('APP_NAME', 'Employee Management System');
define('APP_VERSION', '1.0.0');

// Timezone
date_default_timezone_set('UTC');

// Production settings
ini_set('display_errors', 0);
ini_set('log_errors', 1);
error_reporting(E_ALL & ~E_NOTICE & ~E_WARNING);

/**
 * Create Database Connection
 * 
 * @return mysqli Database connection object
 */
function getDatabaseConnection() {
    $connection = new mysqli(DB_HOST, DB_USER, DB_PASS, DB_NAME);
    
    if ($connection->connect_error) {
        error_log("Database connection failed: " . $connection->connect_error);
        die("Database connection failed. Please try again later.");
    }
    
    return $connection;
}

/**
 * Close Database Connection
 * 
 * @param mysqli $connection Database connection object
 */
function closeDatabaseConnection($connection) {
    if ($connection) {
        $connection->close();
    }
}
?>
