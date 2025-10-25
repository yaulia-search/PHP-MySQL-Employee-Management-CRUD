#!/bin/bash

# Employee Management System - Quick Start Script
# This script starts the PHP development server

echo "🚀 Starting Employee Management System..."
echo ""

# Check if PHP is installed
if ! command -v php &> /dev/null
then
    echo "❌ PHP is not installed. Please install PHP 7.4 or higher."
    exit 1
fi

# Display PHP version
echo "✅ PHP Version: $(php -v | head -n 1)"
echo ""

# Check if MySQL is running
if command -v mysql &> /dev/null
then
    if mysql -u root -e "SELECT 1" &> /dev/null
    then
        echo "✅ MySQL is running"
    else
        echo "⚠️  MySQL might not be running. Please start MySQL first."
        echo "   Run: brew services start mysql (macOS with Homebrew)"
        echo "   Or: mysql.server start"
    fi
else
    echo "⚠️  MySQL command not found. Make sure MySQL is installed and running."
fi

echo ""
echo "📂 Project Directory: $(pwd)"
echo ""
echo "🌐 Starting PHP Development Server..."
echo "   URL: http://localhost:8000"
echo ""
echo "📋 Available endpoints:"
echo "   • http://localhost:8000/index.php - Employee List"
echo "   • http://localhost:8000/test-connection.php - Test Database Connection"
echo ""
echo "Press Ctrl+C to stop the server"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Start PHP server
php -S localhost:8000
