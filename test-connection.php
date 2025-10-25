<?php
/**
 * Database Connection Test
 * 
 * This file tests the database connection and displays system information.
 * Delete this file before deploying to production.
 */

require_once 'config.php';

?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Database Connection Test</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
    <style>
        .success { color: #28a745; }
        .error { color: #dc3545; }
        .info { color: #17a2b8; }
    </style>
</head>
<body>
    <div class="container my-5">
        <h1 class="text-center mb-4">🔧 System Check</h1>
        
        <div class="card">
            <div class="card-body">
                <h3>PHP Information</h3>
                <ul class="list-group list-group-flush">
                    <li class="list-group-item">
                        <strong>PHP Version:</strong> 
                        <span class="<?php echo version_compare(PHP_VERSION, '7.4.0', '>=') ? 'success' : 'error'; ?>">
                            <?php echo PHP_VERSION; ?>
                            <?php echo version_compare(PHP_VERSION, '7.4.0', '>=') ? '✅' : '❌ (Requires 7.4+)'; ?>
                        </span>
                    </li>
                    <li class="list-group-item">
                        <strong>MySQLi Extension:</strong> 
                        <span class="<?php echo extension_loaded('mysqli') ? 'success' : 'error'; ?>">
                            <?php echo extension_loaded('mysqli') ? '✅ Loaded' : '❌ Not Loaded'; ?>
                        </span>
                    </li>
                </ul>
            </div>
        </div>

        <div class="card mt-4">
            <div class="card-body">
                <h3>Database Connection</h3>
                <?php
                try {
                    $connection = getDatabaseConnection();
                    
                    echo '<div class="alert alert-success">';
                    echo '<h4>✅ Database Connection Successful!</h4>';
                    echo '<ul>';
                    echo '<li><strong>Host:</strong> ' . DB_HOST . '</li>';
                    echo '<li><strong>Database:</strong> ' . DB_NAME . '</li>';
                    echo '<li><strong>User:</strong> ' . DB_USER . '</li>';
                    echo '</ul>';
                    echo '</div>';
                    
                    // Test query
                    $result = $connection->query("SELECT COUNT(*) as count FROM employee");
                    if ($result) {
                        $row = $result->fetch_assoc();
                        echo '<div class="alert alert-info">';
                        echo '<strong>📊 Database Status:</strong><br>';
                        echo 'Total employees in database: <strong>' . $row['count'] . '</strong>';
                        echo '</div>';
                        
                        // Show sample data
                        $result = $connection->query("SELECT * FROM employee LIMIT 3");
                        if ($result && $result->num_rows > 0) {
                            echo '<h4>Sample Data:</h4>';
                            echo '<table class="table table-striped">';
                            echo '<thead><tr><th>ID</th><th>Name</th><th>Email</th></tr></thead>';
                            echo '<tbody>';
                            while ($row = $result->fetch_assoc()) {
                                echo '<tr>';
                                echo '<td>' . $row['id'] . '</td>';
                                echo '<td>' . $row['name'] . '</td>';
                                echo '<td>' . $row['email'] . '</td>';
                                echo '</tr>';
                            }
                            echo '</tbody></table>';
                        }
                    }
                    
                    closeDatabaseConnection($connection);
                    
                } catch (Exception $e) {
                    echo '<div class="alert alert-danger">';
                    echo '<h4>❌ Database Connection Failed!</h4>';
                    echo '<p><strong>Error:</strong> ' . $e->getMessage() . '</p>';
                    echo '<h5>Troubleshooting Steps:</h5>';
                    echo '<ol>';
                    echo '<li>Check if MySQL is running</li>';
                    echo '<li>Verify database credentials in config.php</li>';
                    echo '<li>Ensure database "' . DB_NAME . '" exists</li>';
                    echo '<li>Run: <code>mysql -u root -p < database/schema.sql</code></li>';
                    echo '</ol>';
                    echo '</div>';
                }
                ?>
            </div>
        </div>

        <div class="card mt-4">
            <div class="card-body">
                <h3>Quick Actions</h3>
                <a href="index.php" class="btn btn-primary">Go to Application</a>
                <a href="database/schema.sql" class="btn btn-secondary" download>Download Database Schema</a>
            </div>
        </div>

        <div class="alert alert-warning mt-4">
            <strong>⚠️ Security Note:</strong> Delete this file before deploying to production!
        </div>
    </div>
</body>
</html>
