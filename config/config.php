<?php
// config.php

// -- Database Configuration --
// Specifies the path to your SQLite database file, relative to this config file.
define('DATABASE_PATH', __DIR__ . '/../database/restaurant.db');

// -- API Configuration --
// The base path for your API. This is used to construct URLs.
define('API_BASE_PATH', '/api');

// -- Error Reporting --
// Set to true for development to see all errors, false for production.
error_reporting(E_ALL);
ini_set('display_errors', 1);

// -- Admin Panel Configuration --
// Debug mode for admin panel
define('DEBUG_MODE', true);

// Enable Progressive Web App features
define('ENABLE_PWA', false);

/**
 * Establishes a connection to the SQLite database.
 * @return PDO The PDO object for database interaction.
 */
function getDbConnection() {
    try {
        // Create a new PDO instance to connect to the SQLite database.
        $db = new PDO('sqlite:' . DATABASE_PATH);
        // Set PDO attributes to throw exceptions on error, which allows for better error handling.
        $db->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
        // Set the default fetch mode to associative array for cleaner results.
        $db->setAttribute(PDO::ATTR_DEFAULT_FETCH_MODE, PDO::FETCH_ASSOC);
        return $db;
    } catch (PDOException $e) {
        // If the connection fails, send a 500 Internal Server Error response and terminate.
        http_response_code(500);
        echo json_encode(['error' => 'Database connection failed: ' . $e->getMessage()]);
        exit;
    }
}
