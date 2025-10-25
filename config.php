<?php
/**
 * Database Configuration File
 * 
 * This file contains all database connection settings.
 * Update these values according to your local/production environment.
 */

// Database Configuration
define('DB_HOST', 'localhost');
define('DB_USER', 'root');
define('DB_PASS', '');
define('DB_NAME', 'php_employee_management');

// Application Configuration
define('APP_NAME', 'Employee Management System');
define('APP_VERSION', '1.0.0');

// Timezone
date_default_timezone_set('Asia/Jakarta');

/**
 * Create Database Connection
 * 
 * @return mysqli Database connection object
 */
function getDatabaseConnection() {
    $connection = new mysqli(DB_HOST, DB_USER, DB_PASS, DB_NAME);
    
    if ($connection->connect_error) {
        die("Connection failed: " . $connection->connect_error);
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
