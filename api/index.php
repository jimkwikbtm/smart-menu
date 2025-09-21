<?php
// api/index.php

define('DEBUG', false);
define('CACHE_TTL', 300); // 5 minutes
define('RATE_LIMIT_REQUESTS', 100); // Max requests per hour
define('RATE_LIMIT_PERIOD', 3600); // 1 hour in seconds

require_once __DIR__ . '/../config/config.php';

// ————————————————
// Global CORS & JSON Headers
// ————————————————
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST, DELETE, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type, Authorization');

// Security headers
header('X-Content-Type-Options: nosniff');
header('X-Frame-Options: DENY');
header('X-XSS-Protection: 1; mode=block');
header('Strict-Transport-Security: max-age=31536000; includeSubDomains');

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(204);
    exit;
}

// Initialize rate limiting
checkRateLimit();

try {
    // Initialize PDO
    $db = getDbConnection();
    $db->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

    // Build URI segments after "/api"
    $uri       = parse_url($_SERVER['REQUEST_URI'], PHP_URL_PATH);
    $apiRoot   = rtrim(dirname($_SERVER['SCRIPT_NAME']), '/');
    $path      = substr($uri, strlen($apiRoot));
    $segments  = array_values(array_filter(explode('/', $path)));

    // Dispatch to the right handler
    route($_SERVER['REQUEST_METHOD'], $segments, $db);

} catch (ApiException $e) {
    sendJson(null, $e->getCode(), $e->getMessage(), $e->getErrors());
} catch (Exception $e) {
    if (DEBUG) {
        echo json_encode([
            'status'  => 'error',
            'message' => $e->getMessage(),
            'trace'   => $e->getTraceAsString(),
            'timestamp' => time()
        ]);
        http_response_code(500);
        exit;
    } else {
        sendJson(null, 500, 'Internal server error.');
    }
}

// -----------------------------------------------------------------------------
// Input Validation Functions
// -----------------------------------------------------------------------------
function validateInput($data, $rules) {
    $errors = [];
    
    foreach ($rules as $field => $rule) {
        if (!isset($data[$field])) {
            if (strpos($rule, 'required') !== false) {
                $errors[$field] = "$field is required";
            }
            continue;
        }
        
        $value = $data[$field];
        
        if (strpos($rule, 'email') !== false && !filter_var($value, FILTER_VALIDATE_EMAIL)) {
            $errors[$field] = "$field must be a valid email";
        }
        
        if (strpos($rule, 'numeric') !== false && !is_numeric($value)) {
            $errors[$field] = "$field must be numeric";
        }
        
        if (strpos($rule, 'int') !== false && !filter_var($value, FILTER_VALIDATE_INT)) {
            $errors[$field] = "$field must be an integer";
        }
        
        if (strpos($rule, 'float') !== false && !filter_var($value, FILTER_VALIDATE_FLOAT)) {
            $errors[$field] = "$field must be a decimal number";
        }
        
        if (strpos($rule, 'min:') !== false) {
            $min = (int)explode(':', $rule)[1];
            if (is_numeric($value) && $value < $min) {
                $errors[$field] = "$field must be at least $min";
            }
        }
        
        if (strpos($rule, 'max:') !== false) {
            $max = (int)explode(':', $rule)[1];
            if (is_numeric($value) && $value > $max) {
                $errors[$field] = "$field cannot exceed $max";
            }
        }
    }
    
    return $errors;
}

function sanitizeInput($input) {
    if (is_array($input)) {
        return array_map('sanitizeInput', $input);
    }
    
    return htmlspecialchars(strip_tags(trim($input)), ENT_QUOTES, 'UTF-8');
}

// -----------------------------------------------------------------------------
// Rate Limiting
// -----------------------------------------------------------------------------
function checkRateLimit() {
    // Skip rate limiting for health checks
    if (strpos($_SERVER['REQUEST_URI'], '/health') !== false) {
        return true;
    }
    
    $identifier = $_SERVER['REMOTE_ADDR'] . ':' . $_SERVER['REQUEST_URI'];
    $cacheFile = __DIR__ . '/cache/ratelimit_' . md5($identifier) . '.json';
    
    // Create cache directory if it doesn't exist
    if (!is_dir(__DIR__ . '/cache')) {
        mkdir(__DIR__ . '/cache', 0755, true);
    }
    
    if (file_exists($cacheFile)) {
        $data = json_decode(file_get_contents($cacheFile), true);
        if (time() - $data['timestamp'] < RATE_LIMIT_PERIOD) {
            if ($data['count'] >= RATE_LIMIT_REQUESTS) {
                throw new ApiException('Rate limit exceeded. Please try again later.', 429);
            }
            $data['count']++;
        } else {
            $data = ['count' => 1, 'timestamp' => time()];
        }
    } else {
        $data = ['count' => 1, 'timestamp' => time()];
    }
    
    file_put_contents($cacheFile, json_encode($data));
    return true;
}

// -----------------------------------------------------------------------------
// Caching Functions
// -----------------------------------------------------------------------------
function getCachedData($key, $callback, $ttl = CACHE_TTL) {
    $cacheDir = __DIR__ . '/cache/';
    if (!is_dir($cacheDir)) mkdir($cacheDir, 0755, true);
    
    $cacheFile = $cacheDir . md5($key) . '.json';
    
    if (file_exists($cacheFile) && (time() - filemtime($cacheFile)) < $ttl) {
        return json_decode(file_get_contents($cacheFile), true);
    }
    
    $data = $callback();
    file_put_contents($cacheFile, json_encode($data));
    return $data;
}

function clearCache($key = null) {
    $cacheDir = __DIR__ . '/cache/';
    
    if ($key) {
        $cacheFile = $cacheDir . md5($key) . '.json';
        if (file_exists($cacheFile)) {
            unlink($cacheFile);
        }
    } else {
        // Clear all cache files
        $files = glob($cacheDir . '*.json');
        foreach ($files as $file) {
            if (is_file($file)) {
                unlink($file);
            }
        }
    }
}

// -----------------------------------------------------------------------------
// Pagination Functions
// -----------------------------------------------------------------------------
function applyPagination($query, $params) {
    $page = max(1, isset($params['page']) ? (int)$params['page'] : 1);
    $limit = min(100, max(1, isset($params['limit']) ? (int)$params['limit'] : 20));
    $offset = ($page - 1) * $limit;
    
    return [
        'query' => $query . " LIMIT $limit OFFSET $offset",
        'page' => $page,
        'limit' => $limit,
        'offset' => $offset
    ];
}

function getPaginationMeta($page, $limit, $total) {
    $totalPages = ceil($total / $limit);
    
    return [
        'pagination' => [
            'current_page' => $page,
            'per_page' => $limit,
            'total' => $total,
            'total_pages' => $totalPages,
            'has_next' => $page < $totalPages,
            'has_prev' => $page > 1
        ]
    ];
}

// -----------------------------------------------------------------------------
// Enhanced Error Handling
// -----------------------------------------------------------------------------
class ApiException extends Exception {
    protected $errors;
    protected $statusCode;
    
    public function __construct($message, $statusCode = 400, $errors = []) {
        parent::__construct($message);
        $this->statusCode = $statusCode;
        $this->errors = $errors;
    }
    
    public function getStatusCode() {
        return $this->statusCode;
    }
    
    public function getErrors() {
        return $this->errors;
    }
    
    public function toArray() {
        return [
            'status' => 'error',
            'message' => $this->getMessage(),
            'errors' => $this->getErrors(),
            'code' => $this->getStatusCode(),
            'timestamp' => time()
        ];
    }
}

// -----------------------------------------------------------------------------
// Enhanced JSON Response
// -----------------------------------------------------------------------------
function sendJson($data = null, $status = 200, $message = '', $meta = []) {
    http_response_code($status);
    
    $response = [
        'status' => $status < 300 ? 'success' : 'error',
        'message' => $message,
        'data' => $data,
        'timestamp' => time()
    ];
    
    if (!empty($meta)) {
        $response['meta'] = $meta;
    }
    
    // Add execution time if in debug mode
    if (DEBUG) {
        $response['debug'] = [
            'execution_time' => microtime(true) - $_SERVER['REQUEST_TIME_FLOAT']
        ];
    }
    
    echo json_encode($response, JSON_PRETTY_PRINT | JSON_UNESCAPED_SLASHES);
    exit;
}

// -----------------------------------------------------------------------------
// Routing Dispatcher
// -----------------------------------------------------------------------------
function route(string $method, array $seg, PDO $db)
{
    // Health-check endpoints
    if (isset($seg[0]) && $seg[0] === 'health') {
        if (!isset($seg[1])) {
            return healthCheck($db);
        }
        
        switch ($seg[1]) {
            case 'detailed':
                return detailedHealthCheck($db);
            case 'cache':
                return cacheHealthCheck();
            default:
                throw new ApiException('Health endpoint not found.', 404);
        }
    }

    switch ($seg[0] ?? '') {
        case 'branches':
            handleBranches($method, $seg, $db);
            break;
        case 'menu':
            handleMenu($method, $seg, $db);
            break;
        case 'orders':
            handleOrders($method, $seg, $db);
            break;
        case 'promotions':
            handlePromotions($method, $seg, $db);
            break;
        case 'tables':
            handleTables($method, $seg, $db);
            break;
        case 'servicerequests':
            handleServiceRequests($method, $seg, $db);
            break;
        case 'translations':
            handleTranslations($method, $seg, $db);
            break;
        case 'feedback':
            handleFeedback($method, $seg, $db);
            break;
        case 'restaurant':
            handleRestaurant($method, $seg, $db);
            break;
        case 'cart':
            handleCart($method, $seg, $db);
            break;
                case 'customizations':
            handleCustomizations($method, $seg, $db);
            break;      
        default:
            throw new ApiException('Endpoint not found.', 404);
    }
}

// -----------------------------------------------------------------------------
// Health Check Endpoints
// -----------------------------------------------------------------------------
function healthCheck(PDO $db) {
    // Basic health check
    try {
        $db->query('SELECT 1');
        sendJson(['status' => 'OK', 'database' => 'connected'], 200, 'Service is healthy');
    } catch (Exception $e) {
        sendJson(['status' => 'ERROR', 'database' => 'disconnected'], 503, 'Service unavailable');
    }
}

function detailedHealthCheck(PDO $db) {
    // Detailed health check with system metrics
    $status = [
        'status' => 'OK',
        'timestamp' => time(),
        'components' => []
    ];
    
    // Database check
    try {
        $db->query('SELECT 1');
        $status['components']['database'] = 'connected';
    } catch (Exception $e) {
        $status['components']['database'] = 'disconnected';
        $status['status'] = 'DEGRADED';
    }
    
    // Cache directory check
    $cacheDir = __DIR__ . '/cache';
    if (is_dir($cacheDir)) {
        $status['components']['cache'] = 'available';
        
        // Check if cache is writable
        $testFile = $cacheDir . '/test_write.tmp';
        if (@file_put_contents($testFile, 'test')) {
            $status['components']['cache_writable'] = 'yes';
            unlink($testFile);
        } else {
            $status['components']['cache_writable'] = 'no';
            $status['status'] = 'DEGRADED';
        }
    } else {
        $status['components']['cache'] = 'unavailable';
        $status['status'] = 'DEGRADED';
    }
    
    // System metrics
    $status['system'] = [
        'memory_usage' => memory_get_usage(true),
        'memory_peak' => memory_get_peak_usage(true),
        'php_version' => PHP_VERSION,
        'server' => $_SERVER['SERVER_SOFTWARE'] ?? 'Unknown'
    ];
    
    sendJson($status, $status['status'] === 'OK' ? 200 : 503, 'Detailed health check');
}

function cacheHealthCheck() {
    $cacheDir = __DIR__ . '/cache';
    $cacheFiles = glob($cacheDir . '/*.json');
    
    $cacheInfo = [
        'total_files' => count($cacheFiles),
        'total_size' => 0,
        'files' => []
    ];
    
    foreach ($cacheFiles as $file) {
        $size = filesize($file);
        $cacheInfo['total_size'] += $size;
        $cacheInfo['files'][] = [
            'name' => basename($file),
            'size' => $size,
            'modified' => filemtime($file)
        ];
    }
    
    sendJson($cacheInfo, 200, 'Cache health check');
}

// -----------------------------------------------------------------------------
// SQLite Schema Inspector
// -----------------------------------------------------------------------------
function hasColumn(PDO $db, string $table, string $column): bool
{
    $stmt = $db->prepare("PRAGMA table_info(`{$table}`)");
    $stmt->execute();
    $cols = array_column($stmt->fetchAll(PDO::FETCH_ASSOC), 'name');
    return in_array($column, $cols, true);
}

// =============================================================================
// 1. Branches (with caching)
// =============================================================================
function handleBranches(string $method, array $seg, PDO $db)
{
    if ($method !== 'GET') {
        throw new ApiException('Method not allowed.', 405);
    }

    if (!isset($seg[1])) {
        return getBranches($db);
    }

    $branchId = $seg[1];
    if (!ctype_digit($branchId)) {
        throw new ApiException('Invalid branch ID.', 400);
    }

    if (!isset($seg[2])) {
        return getBranch($db, (int)$branchId);
    }

    switch ($seg[2]) {
        case 'menu':
            getBranchMenu($db, (int)$branchId);
            break;
        case 'banners':
            getBranchBanners($db, (int)$branchId);
            break;
        case 'settings':
            getBranchSettings($db, (int)$branchId);
            break;
        case 'tables':
            getBranchTables($db, (int)$branchId);
            break;    
        default:
            throw new ApiException('Endpoint not found.', 404);
    }
}

function getBranches(PDO $db)
{
    $branches = getCachedData('branches_all', function() use ($db) {
        $sql = <<<SQL
SELECT
  b.branch_id,
  b.internal_name,
  b.address,
  b.latitude,
  b.longitude,
  b.timezone,
  b.contact_email,
  b.is_active,
  bs.display_name_translation_key AS name_translation_key,
  bs.logo_url,
  bs.cover_photo_url,
  bs.phone_number,
  bs.vat_percentage,
  bs.service_charge_percentage
FROM Branches b
LEFT JOIN BranchSettings bs
  ON b.branch_id = bs.branch_id
WHERE b.is_active = 1
SQL;
        $stmt = $db->query($sql);
        return $stmt->fetchAll(PDO::FETCH_ASSOC);
    });
    
    sendJson($branches);
}

function getBranch(PDO $db, int $branchId)
{
    $branch = getCachedData("branch_$branchId", function() use ($db, $branchId) {
        $sql = <<<SQL
SELECT
  b.branch_id,
  b.internal_name,
  b.address,
  b.latitude,
  b.longitude,
  b.timezone,
  b.contact_email,
  b.is_active,
  bs.display_name_translation_key AS name_translation_key,
  bs.logo_url,
  bs.cover_photo_url,
  bs.phone_number,
  bs.vat_percentage,
  bs.service_charge_percentage
FROM Branches b
LEFT JOIN BranchSettings bs
  ON b.branch_id = bs.branch_id
WHERE b.branch_id = ? 
  AND b.is_active = 1
SQL;
        $stmt = $db->prepare($sql);
        $stmt->execute([$branchId]);
        return $stmt->fetch(PDO::FETCH_ASSOC);
    });
    
    if (!$branch) {
        throw new ApiException('Branch not found.', 404);
    }
    sendJson($branch);
}

function getBranchSettings(PDO $db, int $branchId)
{
    $settings = getCachedData("branch_settings_$branchId", function() use ($db, $branchId) {
        $stmt = $db->prepare('SELECT * FROM BranchSettings WHERE branch_id = ?');
        $stmt->execute([$branchId]);
        return $stmt->fetch(PDO::FETCH_ASSOC);
    });
    
    if (!$settings) {
        throw new ApiException('Settings not found.', 404);
    }
    sendJson($settings);
}

function getBranchMenu(PDO $db, int $branchId)
{
    $menu = getCachedData("branch_menu_$branchId", function() use ($db, $branchId) {
        $sql = <<<SQL
SELECT
  mc.category_id,
  mc.name_translation_key AS category_name,
  mc.image_url AS category_image,
  bm.branch_menu_id,
  bm.item_id,
  mi.name_translation_key AS item_name,
  mi.description_translation_key AS item_description,
  mi.image_url,
  mi.preparation_time_minutes,
  bm.price,
  bm.is_available,
  bm.is_featured,
  bm.customization_options,
  bm.display_order
FROM BranchMenu bm
JOIN MenuItems_Global mi ON bm.item_id = mi.item_id
JOIN MenuCategories mc ON mi.category_id = mc.category_id
WHERE bm.branch_id = ?
  AND bm.is_available = 1
  AND mi.is_active = 1
  AND mc.is_active = 1
ORDER BY mc.display_order, bm.display_order
SQL;
        $stmt  = $db->prepare($sql);
        $stmt->execute([$branchId]);
        $items = $stmt->fetchAll(PDO::FETCH_ASSOC);

        $menuData = [];
        foreach ($items as $row) {
            $cid = $row['category_id'];
            if (!isset($menuData[$cid])) {
                $menuData[$cid] = [
                    'category_id'   => (int)$cid,
                    'category_name' => $row['category_name'],
                    'name_translation_key' => $row['category_name'],
                    'category_image' => $row['category_image'],
                    'items'         => []
                ];
            }
            
            $customizationOptions = [];
            if (!empty($row['customization_options'])) {
                $customizationOptions = json_decode($row['customization_options'], true);
            }
            
            $menuData[$cid]['items'][] = [
                'branch_menu_id' => (int)$row['branch_menu_id'],
                'item_id'        => (int)$row['item_id'],
                'name'           => $row['item_name'],
                'name_translation_key' => $row['item_name'],
                'description'    => $row['item_description'],
                'description_translation_key' => $row['item_description'],
                'image_url'      => $row['image_url'],
                'price'          => (float)$row['price'],
                'preparation_time' => (int)$row['preparation_time_minutes'],
                'is_available'   => (bool)$row['is_available'],
                'is_featured'    => (bool)$row['is_featured'],
                'has_customizations' => !empty($customizationOptions['groups']),
                'display_order'  => (int)$row['display_order']
            ];
        }

        return array_values($menuData);
    });
    
    sendJson($menu);
}

function getBranchBanners(PDO $db, int $branchId)
{
    $banners = getCachedData("branch_banners_$branchId", function() use ($db, $branchId) {
        $sql = <<<SQL
SELECT *
FROM BranchBanners
WHERE branch_id = ?
  AND is_active = 1
  AND (start_date IS NULL OR start_date <= datetime('now','localtime'))
  AND (end_date   IS NULL OR end_date   >= datetime('now','localtime'))
ORDER BY display_order
SQL;
        $stmt = $db->prepare($sql);
        $stmt->execute([$branchId]);
        return $stmt->fetchAll(PDO::FETCH_ASSOC);
    });
    
    sendJson($banners);
}

function getBranchTables(PDO $db, int $branchId)
{
    $tables = getCachedData("branch_tables_$branchId", function() use ($db, $branchId) {
        $stmt = $db->prepare(
            'SELECT
                table_id,
                table_identifier,
                qr_code_hash,
                capacity,
                table_type,
                location_description
             FROM Tables
             WHERE branch_id = ?
               AND is_active = 1
             ORDER BY table_identifier'
        );
        $stmt->execute([$branchId]);
        return $stmt->fetchAll(PDO::FETCH_ASSOC);
    });
    
    sendJson($tables);
}

// =============================================================================
// Customizations Endpoint - FIXED
// =============================================================================
function handleCustomizations(string $method, array $seg, PDO $db)
{
    if ($method !== 'GET') {
        throw new ApiException('Method not allowed.', 405);
    }
    
    if (!isset($seg[1]) || !ctype_digit($seg[1])) {
        throw new ApiException('Invalid branch menu ID.', 400);
    }
    
    $branchMenuId = (int)$seg[1];
    getCustomizations($db, $branchMenuId);
}

function getCustomizations(PDO $db, int $branchMenuId)
{
    $customizations = getCachedData("customizations_$branchMenuId", function() use ($db, $branchMenuId) {
        $stmt = $db->prepare('SELECT customization_options FROM BranchMenu WHERE branch_menu_id = ?');
        $stmt->execute([$branchMenuId]);
        $result = $stmt->fetch(PDO::FETCH_ASSOC);
        
        if (!$result) {
            throw new ApiException('Branch menu item not found.', 404);
        }
        
        if (empty($result['customization_options'])) {
            return ['groups' => []];
        }
        
        $decoded = json_decode($result['customization_options'], true);
        
        if (json_last_error() !== JSON_ERROR_NONE) {
            return ['groups' => []];
        }
        
        return $decoded;
    });
    
    sendJson($customizations);
}

// =============================================================================
// 2. Menu (with caching)
// =============================================================================
function handleMenu(string $method, array $seg, PDO $db)
{
    if ($method !== 'GET') {
        throw new ApiException('Method not allowed.', 405);
    }
    if (!isset($seg[1])) {
        throw new ApiException('Endpoint not found.', 404);
    }

    switch ($seg[1]) {
        case 'categories':
            getMenuCategories($db);
            break;
        case 'items':
            if (!isset($seg[2]) || !ctype_digit($seg[2])) {
                throw new ApiException('Invalid menu item ID.', 400);
            }
            getMenuItem($db, (int)$seg[2]);
            break;
        default:
            throw new ApiException('Endpoint not found.', 404);
    }
}

function getMenuCategories(PDO $db)
{
    $categories = getCachedData('menu_categories', function() use ($db) {
        $stmt = $db->query('SELECT * FROM MenuCategories WHERE is_active = 1 ORDER BY display_order');
        return $stmt->fetchAll(PDO::FETCH_ASSOC);
    });
    
    sendJson($categories);
}

function getMenuItem(PDO $db, int $itemId)
{
    $item = getCachedData("menu_item_$itemId", function() use ($db, $itemId) {
        $sql = <<<SQL
SELECT
  mi.*,
  mc.name_translation_key AS category_name,
  mi.name_translation_key,
  mi.description_translation_key
FROM MenuItems_Global mi
JOIN MenuCategories mc ON mi.category_id = mc.category_id
WHERE mi.item_id = ?
  AND mi.is_active = 1
  AND mc.is_active = 1
SQL;
        $stmt = $db->prepare($sql);
        $stmt->execute([$itemId]);
        return $stmt->fetch(PDO::FETCH_ASSOC);
    });
    
    if (!$item) {
        throw new ApiException('Menu item not found.', 404);
    }
    sendJson($item);
}

// =============================================================================
// 3. Orders (with enhanced validation)
// =============================================================================
function handleOrders(string $method, array $seg, PDO $db)
{
    if ($method === 'POST' && !isset($seg[1])) {
        return createOrder($db);
    }
    
    // Handle order history endpoint: GET /orders/history
    if ($method === 'GET' && isset($seg[1]) && $seg[1] === 'history') {
        return getOrderHistory($db);
    }
    
    if (!isset($seg[1])) {
        throw new ApiException('Endpoint not found.', 404);
    }

    $orderUid = $seg[1];

    if ($method === 'GET') {
        if (isset($seg[2])) {
            switch ($seg[2]) {
                case 'items':
                    getOrderItems($db, $orderUid);
                    break;
                case 'timeline':
                    getOrderTimeline($db, $orderUid);
                    break;
                case 'tracking':
                    getOrderTracking($db, $orderUid);
                    break;
                default:
                    throw new ApiException('Endpoint not found.', 404);
            }
        } else {
            getOrder($db, $orderUid);
        }
    } elseif ($method === 'DELETE') {
        cancelOrder($db, $orderUid);
    } else {
        throw new ApiException('Method not allowed.', 405);
    }
}

// -----------------------------------------------------------------------------
// Delivery Charge Calculation Function
// -----------------------------------------------------------------------------
function calculateDeliveryChargeBackend($deliveryFeeConfig, $subtotal, $orderType) {
    // Only calculate delivery charge for delivery orders
    if ($orderType !== 'delivery') {
        return 0.0;
    }
    
    if (empty($deliveryFeeConfig)) {
        return 50.0; // Default delivery charge if no config
    }
    
    try {
        $config = is_string($deliveryFeeConfig) ? json_decode($deliveryFeeConfig, true) : $deliveryFeeConfig;
        
        // Check for minimum order free delivery
        if (!empty($config['minimum_order_free']) && $subtotal >= $config['minimum_order_free']) {
            return 0.0; // Free delivery for orders above minimum
        }
        
        // Calculate based on fee type
        switch ($config['type'] ?? 'fixed') {
            case 'fixed':
                return (float)($config['amount'] ?? 0.0);
            
            case 'percentage':
                if (!empty($config['percentage_based']['rate'])) {
                    return round(($subtotal * $config['percentage_based']['rate']) / 100, 2);
                }
                return 0.0;
            
            case 'distance':
                // For distance-based, return base amount (distance calculation would require geolocation)
                if (!empty($config['distance_based']['base_amount'])) {
                    return (float)$config['distance_based']['base_amount'];
                }
                return (float)($config['amount'] ?? 0.0);
            
            default:
                return (float)($config['amount'] ?? 50.0); // Default fallback
        }
    } catch (Exception $e) {
        // If config is malformed, use default
        return 50.0;
    }
}

function createOrder(PDO $db)
{
    $raw  = file_get_contents('php://input');
    $data = json_decode($raw, true);
    if (json_last_error() !== JSON_ERROR_NONE) {
        throw new ApiException('JSON parse error: ' . json_last_error_msg(), 400);
    }

    // Validate input
    $validationRules = [
        'branch_id' => 'required|int',
        'items' => 'required|array',
        'order_type' => 'required|in:dine-in,takeaway,delivery'
    ];
    
    // Add optional fields validation
    $optionalFields = [
        'table_id' => 'int',
        'payment_method' => 'in:cash,card,mobile',
        'delivery_address' => 'string',
        'pickup_time' => 'string',
        'special_instructions' => 'string'
    ];
    
    $errors = validateInput($data, $validationRules);
    if (!empty($errors)) {
        throw new ApiException('Invalid input data', 400, $errors);
    }
    
    // Validate optional fields if present
    foreach ($optionalFields as $field => $rule) {
        if (isset($data[$field])) {
            $fieldErrors = validateInput([$field => $data[$field]], [$field => $rule]);
            if (!empty($fieldErrors)) {
                $errors = array_merge($errors, $fieldErrors);
            }
        }
    }
    
    if (!empty($errors)) {
        throw new ApiException('Invalid input data', 400, $errors);
    }
    
    // Sanitize input
    $data = sanitizeInput($data);

    if (count($data['items']) === 0) {
        throw new ApiException('Requires non-empty items array.', 400);
    }

    // Extract optional fields
    $tableId = isset($data['table_id']) ? (int)$data['table_id'] : null;
    $paymentMethod = $data['payment_method'] ?? 'cash';
    $deliveryAddress = $data['delivery_address'] ?? null;
    $pickupTime = $data['pickup_time'] ?? null;
    $specialInstructions = $data['special_instructions'] ?? null;
    $promoId = isset($data['promo_id']) ? (int)$data['promo_id'] : null;
    $discountAmount = isset($data['discount_amount']) ? (float)$data['discount_amount'] : 0.00;

    // Fetch branch settings for charges
    $cfgStmt = $db->prepare(
        'SELECT service_charge_percentage, vat_percentage, delivery_fee_config
         FROM BranchSettings
         WHERE branch_id = ?'
    );
    $cfgStmt->execute([$data['branch_id']]);
    $cfg    = $cfgStmt->fetch(PDO::FETCH_ASSOC) ?: [];
    $svcPct = (float)($cfg['service_charge_percentage'] ?? 0.0);
    $vatPct = (float)($cfg['vat_percentage']          ?? 0.0);
    $deliveryFeeConfig = $cfg['delivery_fee_config'] ?? null;

    // Prepare OrderItems INSERT
    $liSql  = <<<SQL
INSERT INTO OrderItems
  (order_id, branch_menu_id, quantity, price_at_order, item_total, customizations)
VALUES
  (?, ?, ?, ?, ?, ?)
SQL;
    $liStmt = $db->prepare($liSql);

    $db->beginTransaction();
    try {
        // 1) Insert Orders with zero totals
        $orderUid = 'ORD-' . strtoupper(uniqid());
        $db->prepare(
            'INSERT INTO Orders
              (order_uid, branch_id, table_id, promo_id, order_type, status,
               items_subtotal, discount_amount, subtotal_after_discount,
               service_charge_amount, vat_amount,
               delivery_charge_amount, final_amount,
               payment_status, payment_method, delivery_address, pickup_time, notes, created_at)
             VALUES
              (?, ?, ?, ?, ?, "pending", 0, ?, 0, 0, 0, 0, 0, "unpaid", ?, ?, ?, ?, datetime("now","localtime"))'
        )->execute([
            $orderUid,
            $data['branch_id'],
            $tableId,
            $promoId,
            $data['order_type'] ?? 'takeaway',
            $discountAmount,
            $paymentMethod,
            $deliveryAddress,
            $pickupTime,
            $specialInstructions
        ]);

        // 2) Get the new order_id
        $orderId = $db->lastInsertId();

        // 3) Loop items → lookup price & insert line
        $subTotal = 0.0;
        $inserted = [];

        foreach ($data['items'] as $idx => $itm) {
            // Validate item
            $itemErrors = validateInput($itm, [
                'item_id' => 'required|int|min:1',
                'quantity' => 'required|int|min:1'
            ]);
            
            if (!empty($itemErrors)) {
                throw new ApiException("Invalid item at index {$idx}", 400, $itemErrors);
            }
            
            $itemId = (int)$itm['item_id'];
            $qty    = (int)$itm['quantity'];
            
            // Fetch branch_menu record
            $bmStmt = $db->prepare(
                'SELECT branch_menu_id, price, customization_options
                 FROM BranchMenu
                 WHERE branch_id = ?
                   AND item_id   = ?
                   AND is_available = 1'
            );
            $bmStmt->execute([$data['branch_id'], $itemId]);
            $bm = $bmStmt->fetch(PDO::FETCH_ASSOC);
            if (!$bm) {
                throw new ApiException("Item {$itemId} not available at this branch.", 400);
            }

            $pmenu     = (float)$bm['price'];
            $customizations = [];
            $customizationPrice = 0;
            
            // Process customizations if provided
            if (!empty($itm['customizations'])) {
                $availableOptions = json_decode($bm['customization_options'] ?? '{"groups":[]}', true);
                
                // Validate each customization
                foreach ($itm['customizations'] as $customization) {
                    $isValid = validateCustomization($customization, $availableOptions);
                    if (!$isValid) {
                        throw new ApiException("Invalid customization for item {$itemId} at index {$idx}", 400);
                    }
                    
                    // Calculate price adjustments
                    if (!empty($customization['selected_options'])) {
                        foreach ($customization['selected_options'] as $optionId) {
                            foreach ($availableOptions['groups'] as $group) {
                                if ($group['id'] === $customization['group_id']) {
                                    foreach ($group['options'] as $option) {
                                        if ($option['id'] === $optionId) {
                                            $customizationPrice += (float)($option['price_adjustment'] ?? 0);
                                            break;
                                        }
                                    }
                                    break;
                                }
                            }
                        }
                    }
                    
                    $customizations[] = $customization;
                }
            }
            
            // Adjust price with customizations
            $adjustedPrice = $pmenu + $customizationPrice;
            $lineTotal = round($adjustedPrice * $qty, 2);
            $subTotal += $lineTotal;

            // Store customizations in order items
            $liStmt->execute([
                $orderId,
                (int)$bm['branch_menu_id'],
                $qty,
                $adjustedPrice,
                $lineTotal,
                json_encode($customizations)
            ]);

            $inserted[] = [
                'branch_menu_id' => (int)$bm['branch_menu_id'],
                'quantity'       => $qty,
                'price_at_order' => $adjustedPrice,
                'item_total'     => $lineTotal,
                'customizations' => $customizations
            ];
        }

        // 4) Recalculate totals & update Orders
        $discountAmount = max(0, min($discountAmount, $subTotal)); // Ensure discount doesn't exceed subtotal
        $subtotalAfterDiscount = $subTotal - $discountAmount;
        $svcAmt = round($subtotalAfterDiscount * $svcPct / 100, 2);
        $vatAmt = round(($subtotalAfterDiscount + $svcAmt) * $vatPct / 100, 2);
        
        // Calculate delivery charge
        $deliveryChargeAmount = calculateDeliveryChargeBackend($deliveryFeeConfig, $subTotal, $data['order_type']);
        
        $final  = round($subtotalAfterDiscount + $svcAmt + $vatAmt + $deliveryChargeAmount, 2);
        
        // Create applied_rates_snapshot with the percentages used
        $appliedRatesSnapshot = json_encode([
            'service_charge_percentage' => $svcPct,
            'vat_percentage' => $vatPct,
            'applied_at' => date('c')
        ]);

        $db->prepare(
            'UPDATE Orders SET
               items_subtotal          = ?,
               discount_amount         = ?,
               subtotal_after_discount = ?,
               service_charge_amount   = ?,
               vat_amount              = ?,
               delivery_charge_amount  = ?,
               final_amount            = ?,
               applied_rates_snapshot  = ?,
               payment_method          = ?,
               delivery_address        = ?,
               pickup_time             = ?,
               notes                   = ?
             WHERE order_id = ?'
        )->execute([
            $subTotal,
            $discountAmount,
            $subtotalAfterDiscount,
            $svcAmt,
            $vatAmt,
            $deliveryChargeAmount,
            $final,
            $appliedRatesSnapshot,
            $paymentMethod,
            $deliveryAddress,
            $pickupTime,
            $specialInstructions,
            $orderId
        ]);

        $db->commit();
        
        // Clear cache for this branch's menu
        clearCache("branch_menu_{$data['branch_id']}");

        sendJson(
            [
                'order_uid' => $orderUid, 
                'items' => $inserted,
                'final_amount' => $final,
                'items_subtotal' => $subTotal,
                'service_charge_amount' => $svcAmt,
                'vat_amount' => $vatAmt,
                'delivery_charge_amount' => $deliveryChargeAmount,
                'discount_amount' => $discountAmount
            ],
            201,
            'Order created successfully.'
        );

    } catch (Exception $e) {
        $db->rollBack();
        throw $e;
    }
}

function validateCustomization($customization, $availableOptions) {
    if (empty($customization['group_id']) || !isset($customization['selected_options'])) {
        return false;
    }
    
    // Find the group
    $group = null;
    foreach ($availableOptions['groups'] as $availableGroup) {
        if ($availableGroup['id'] === $customization['group_id']) {
            $group = $availableGroup;
            break;
        }
    }
    
    if (!$group) {
        return false;
    }
    
    // Validate selection based on group type
    if ($group['type'] === 'radio' && count($customization['selected_options']) > 1) {
        return false;
    }
    
    if ($group['required'] && empty($customization['selected_options'])) {
        return false;
    }
    
    // Validate each selected option
    foreach ($customization['selected_options'] as $optionId) {
        $optionExists = false;
        foreach ($group['options'] as $option) {
            if ($option['id'] === $optionId) {
                $optionExists = true;
                break;
            }
        }
        
        if (!$optionExists) {
            return false;
        }
    }
    
    return true;
}

function getOrder(PDO $db, string $orderUid)
{
    $order = getCachedData("order_$orderUid", function() use ($db, $orderUid) {
        $stmt = $db->prepare('
            SELECT o.*, 
                   p.code as promo_code, p.type as promo_type, p.value as promo_value,
                   b.internal_name as branch_name,
                   bs.display_name_translation_key as branch_name_translation_key,
                   t.table_identifier as table_identifier
            FROM Orders o 
            LEFT JOIN Promotions p ON o.promo_id = p.promo_id 
            LEFT JOIN Branches b ON o.branch_id = b.branch_id
            LEFT JOIN BranchSettings bs ON o.branch_id = bs.branch_id
            LEFT JOIN Tables t ON o.table_id = t.table_id
            WHERE o.order_uid = ?
        ');
        $stmt->execute([$orderUid]);
        return $stmt->fetch(PDO::FETCH_ASSOC);
    });
    
    if (!$order) {
        throw new ApiException('Order not found.', 404);
    }
    sendJson($order);
}

function getOrderItems(PDO $db, string $orderUid)
{
    $items = getCachedData("order_items_$orderUid", function() use ($db, $orderUid) {
        // Resolve numeric order_id
        $stmt = $db->prepare('SELECT order_id FROM Orders WHERE order_uid = ?');
        $stmt->execute([$orderUid]);
        $row = $stmt->fetch(PDO::FETCH_ASSOC);
        if (!$row) {
            return null;
        }
        $orderId = (int)$row['order_id'];

        // Join through branch_menu to menu_items
        $sql = <<<SQL
SELECT
  oi.order_item_id,
  oi.branch_menu_id,
  oi.quantity,
  oi.price_at_order,
  oi.item_total,
  oi.customizations,
  bm.item_id         AS menu_item_id,
  mi.name_translation_key AS item_name,
  mi.name_translation_key AS name,
  mi.name_translation_key AS name_translation_key,
  mi.description_translation_key AS item_description,
  mi.description_translation_key AS description,
  mi.description_translation_key AS description_translation_key,
  mi.image_url
FROM OrderItems oi
JOIN BranchMenu bm ON oi.branch_menu_id = bm.branch_menu_id
JOIN MenuItems_Global mi ON bm.item_id = mi.item_id
WHERE oi.order_id = ?
SQL;
        $stmt = $db->prepare($sql);
        $stmt->execute([$orderId]);
        $items = $stmt->fetchAll(PDO::FETCH_ASSOC);
        
        // Decode customizations
        foreach ($items as &$item) {
            if (!empty($item['customizations'])) {
                $item['customizations'] = json_decode($item['customizations'], true);
            } else {
                $item['customizations'] = [];
            }
        }
        
        return $items;
    });
    
    if ($items === null) {
        throw new ApiException('Order not found.', 404);
    }
    
    sendJson($items);
}

function getOrderTimeline(PDO $db, string $orderUid)
{
    $timeline = getCachedData("order_timeline_$orderUid", function() use ($db, $orderUid) {
        // Resolve numeric order_id
        $stmt = $db->prepare('SELECT order_id FROM Orders WHERE order_uid = ?');
        $stmt->execute([$orderUid]);
        $row = $stmt->fetch(PDO::FETCH_ASSOC);
        if (!$row) {
            return null;
        }
        $orderId = (int)$row['order_id'];

        $sql = <<<SQL
SELECT 
    ot.timeline_id,
    ot.event_type,
    ot.event_description,
    ot.timestamp,
    ot.metadata,
    u.full_name as staff_name
FROM OrderTimeline ot
LEFT JOIN Users u ON ot.staff_id = u.user_id
WHERE ot.order_id = ?
ORDER BY ot.timestamp ASC
SQL;
        
        $stmt = $db->prepare($sql);
        $stmt->execute([$orderId]);
        $timeline = $stmt->fetchAll(PDO::FETCH_ASSOC);
        
        // Decode metadata JSON
        foreach ($timeline as &$event) {
            if (!empty($event['metadata'])) {
                $event['metadata'] = json_decode($event['metadata'], true);
            } else {
                $event['metadata'] = [];
            }
        }
        
        return $timeline;
    });
    
    if ($timeline === null) {
        throw new ApiException('Order not found.', 404);
    }
    
    sendJson($timeline);
}

function getOrderTracking(PDO $db, string $orderUid)
{
    $tracking = getCachedData("order_tracking_$orderUid", function() use ($db, $orderUid) {
        // Get basic order info first
        $stmt = $db->prepare('SELECT order_id, order_type, table_id FROM Orders WHERE order_uid = ?');
        $stmt->execute([$orderUid]);
        $order = $stmt->fetch(PDO::FETCH_ASSOC);
        
        if (!$order) {
            return null;
        }
        
        $orderId = (int)$order['order_id'];
        $trackingData = [
            'order_type' => $order['order_type'],
            'basic_info' => []
        ];
        
        // Get order type specific tracking data
        switch ($order['order_type']) {
            case 'dine-in':
                $trackingData['table_service'] = getTableServiceTracking($db, $orderId);
                break;
            case 'delivery':
                $trackingData['delivery'] = getDeliveryTracking($db, $orderId);
                break;
            case 'takeaway':
                $trackingData['pickup'] = getPickupTracking($db, $orderId);
                break;
        }
        
        // Get recent notifications
        $trackingData['notifications'] = getOrderNotifications($db, $orderId);
        
        return $trackingData;
    });
    
    if ($tracking === null) {
        throw new ApiException('Order not found.', 404);
    }
    
    sendJson($tracking);
}

function getTableServiceTracking(PDO $db, int $orderId)
{
    $sql = <<<SQL
SELECT 
    tss.*,
    t.table_identifier,
    u.full_name as server_name
FROM TableServiceStatus tss
LEFT JOIN Tables t ON tss.table_id = t.table_id
LEFT JOIN Users u ON tss.server_id = u.user_id
WHERE tss.order_id = ?
ORDER BY tss.created_at DESC
LIMIT 1
SQL;
    
    $stmt = $db->prepare($sql);
    $stmt->execute([$orderId]);
    return $stmt->fetch(PDO::FETCH_ASSOC);
}

function getDeliveryTracking(PDO $db, int $orderId)
{
    $sql = <<<SQL
SELECT 
    dt.*,
    o.driver_name,
    o.driver_phone,
    o.driver_vehicle
FROM DeliveryTracking dt
LEFT JOIN Orders o ON dt.order_id = o.order_id
WHERE dt.order_id = ?
ORDER BY dt.created_at DESC
LIMIT 1
SQL;
    
    $stmt = $db->prepare($sql);
    $stmt->execute([$orderId]);
    return $stmt->fetch(PDO::FETCH_ASSOC);
}

function getPickupTracking(PDO $db, int $orderId)
{
    $sql = <<<SQL
SELECT 
    pq.*,
    o.pickup_time
FROM PickupQueue pq
LEFT JOIN Orders o ON pq.order_id = o.order_id
WHERE pq.order_id = ?
ORDER BY pq.created_at DESC
LIMIT 1
SQL;
    
    $stmt = $db->prepare($sql);
    $stmt->execute([$orderId]);
    return $stmt->fetch(PDO::FETCH_ASSOC);
}

function getOrderNotifications(PDO $db, int $orderId)
{
    $sql = <<<SQL
SELECT 
    notification_id,
    notification_type,
    notification_title,
    notification_message,
    notification_data,
    status,
    created_at
FROM OrderNotifications 
WHERE order_id = ?
ORDER BY created_at DESC
LIMIT 10
SQL;
    
    $stmt = $db->prepare($sql);
    $stmt->execute([$orderId]);
    $notifications = $stmt->fetchAll(PDO::FETCH_ASSOC);
    
    // Decode notification data
    foreach ($notifications as &$notification) {
        if (!empty($notification['notification_data'])) {
            $notification['notification_data'] = json_decode($notification['notification_data'], true);
        } else {
            $notification['notification_data'] = [];
        }
    }
    
    return $notifications;
}

function cancelOrder(PDO $db, string $orderUid)
{
    $chk = $db->prepare('SELECT status FROM Orders WHERE order_uid = ?');
    $chk->execute([$orderUid]);
    $row = $chk->fetch(PDO::FETCH_ASSOC);

    if (!$row) {
        throw new ApiException('Order not found.', 404);
    }
    if ($row['status'] !== 'pending') {
        throw new ApiException('Only pending orders can be cancelled.', 400);
    }

    $db->prepare(
        'UPDATE Orders
         SET status     = ?, updated_at = datetime("now","localtime")
         WHERE order_uid = ?'
    )->execute(['cancelled', $orderUid]);
    
    // Clear order cache
    clearCache("order_$orderUid");
    clearCache("order_items_$orderUid");

    sendJson(null, 200, 'Order cancelled successfully.');
}

function getOrderHistory(PDO $db)
{
    // Check if specific order IDs are requested
    $orderIds = isset($_GET['order_ids']) ? $_GET['order_ids'] : null;
    
    $page = isset($_GET['page']) ? max(1, (int)$_GET['page']) : 1;
    $limit = isset($_GET['limit']) ? min(50, max(10, (int)$_GET['limit'])) : 20;
    $offset = ($page - 1) * $limit;
    
    $sql = <<<SQL
SELECT 
    o.order_uid,
    o.order_type,
    o.status,
    o.final_amount,
    o.payment_status,
    o.payment_method,
    o.delivery_address,
    o.pickup_time,
    o.notes,
    o.created_at,
    o.updated_at,
    b.internal_name as branch_name,
    bs.display_name_translation_key as branch_name_translation_key,
    b.address as branch_address,
    COUNT(oi.order_item_id) as item_count
FROM Orders o
LEFT JOIN Branches b ON o.branch_id = b.branch_id
LEFT JOIN BranchSettings bs ON o.branch_id = bs.branch_id
LEFT JOIN OrderItems oi ON o.order_id = oi.order_id
SQL;

    $params = [];
    
    if ($orderIds) {
        // Parse comma-separated order IDs and validate them
        $orderIdArray = array_map('trim', explode(',', $orderIds));
        $validOrderIds = [];
        foreach ($orderIdArray as $id) {
            if (!empty($id) && preg_match('/^ORD-[A-Z0-9]+$/', $id)) {
                $validOrderIds[] = $id;
            }
        }
        $orderIdArray = $validOrderIds;
        
        if (!empty($orderIdArray)) {
            $placeholders = str_repeat('?,', count($orderIdArray) - 1) . '?';
            $sql .= " WHERE o.order_uid IN ($placeholders)";
            $params = array_merge($params, $orderIdArray);
        } else {
            // Invalid order IDs, return empty result
            sendJson([], 200, 'No valid orders found.', ['page' => $page, 'limit' => $limit, 'total' => 0]);
            return;
        }
    }
    
    $sql .= " GROUP BY o.order_id ORDER BY o.created_at DESC LIMIT ? OFFSET ?";
    $params[] = $limit;
    $params[] = $offset;
    
    try {
        $stmt = $db->prepare($sql);
        $stmt->execute($params);
        $orders = $stmt->fetchAll(PDO::FETCH_ASSOC);
        
        // Get total count for pagination
        if ($orderIds && !empty($orderIdArray)) {
            $countPlaceholders = str_repeat('?,', count($orderIdArray) - 1) . '?';
            $countSql = "SELECT COUNT(*) as total FROM Orders WHERE order_uid IN ($countPlaceholders)";
            $countStmt = $db->prepare($countSql);
            $countStmt->execute($orderIdArray);
        } else {
            $countStmt = $db->query('SELECT COUNT(*) as total FROM Orders');
        }
        $totalCount = $countStmt->fetch(PDO::FETCH_ASSOC)['total'];
        
        $meta = getPaginationMeta($page, $limit, $totalCount);
        
        sendJson($orders, 200, 'Order history retrieved successfully.', $meta);
    } catch (Exception $e) {
        throw new ApiException('Failed to retrieve order history: ' . $e->getMessage(), 500);
    }
}

// =============================================================================
// 4. Promotions (with caching)
// =============================================================================
function handlePromotions(string $method, array $seg, PDO $db)
{
    if ($method !== 'GET') {
        throw new ApiException('Method not allowed.', 405);
    }

    if (isset($seg[1]) && ctype_digit($seg[1])) {
        getBranchPromotions($db, (int)$seg[1]);
    } else {
        getActivePromotions($db);
    }
}

function getActivePromotions(PDO $db)
{
    $promotions = getCachedData('promotions_active', function() use ($db) {
        $stmt = $db->query(<<<SQL
SELECT *
FROM Promotions
WHERE is_active = 1
  AND is_customer_visible = 1
  AND (start_date IS NULL OR start_date <= datetime('now','localtime'))
  AND (end_date   IS NULL OR end_date   >= datetime('now','localtime'))
SQL
        );
        return $stmt->fetchAll(PDO::FETCH_ASSOC);
    });
    
    sendJson($promotions);
}

function getBranchPromotions(PDO $db, int $branchId)
{
    $promotions = getCachedData("promotions_branch_$branchId", function() use ($db, $branchId) {
        $sql = <<<SQL
SELECT p.*
FROM Promotions p
JOIN Promotion_Branches pb ON p.promo_id = pb.promo_id
WHERE pb.branch_id = ?
  AND p.is_active = 1
  AND p.is_customer_visible = 1
  AND (p.start_date IS NULL OR p.start_date <= datetime('now','localtime'))
  AND (p.end_date   IS NULL OR p.end_date   >= datetime('now','localtime'))
SQL;
        $stmt = $db->prepare($sql);
        $stmt->execute([$branchId]);
        return $stmt->fetchAll(PDO::FETCH_ASSOC);
    });
    
    sendJson($promotions);
}

// =============================================================================
// 5. Tables & Service Requests
// =============================================================================
function handleTables(string $method, array $seg, PDO $db)
{
    if ($method !== 'GET') {
        throw new ApiException('Method not allowed.', 405);
    }

    // GET /tables/qr/{qrHash}
    if (isset($seg[1]) && $seg[1] === 'qr' && isset($seg[2])) {
        getTableByQrHash($db, $seg[2]);
        return;
    }

    // GET /tables/{table_id}/servicerequests
    if (
        isset($seg[1]) &&
        ctype_digit($seg[1]) &&
        isset($seg[2]) &&
        $seg[2] === 'servicerequests'
    ) {
        getServiceRequestsForTable($db, (int)$seg[1]);
        return;
    }

    throw new ApiException('Endpoint not found.', 404);
}

function getTableByQrHash(PDO $db, string $qrHash)
{
    $table = getCachedData("table_qr_$qrHash", function() use ($db, $qrHash) {
        $stmt = $db->prepare(
            'SELECT t.table_id, t.table_identifier, b.branch_id, b.internal_name AS branch_name
             FROM Tables t
             JOIN Branches b ON t.branch_id = b.branch_id
             WHERE t.qr_code_hash = ?
               AND t.is_active = 1
               AND b.is_active = 1'
        );
        $stmt->execute([$qrHash]);
        return $stmt->fetch(PDO::FETCH_ASSOC);
    });
    
    if (!$table) {
        throw new ApiException('Table not found for the given QR code.', 404);
    }
    sendJson($table);
}

function getServiceRequestsForTable(PDO $db, int $tableId)
{
    $requests = getCachedData("service_requests_table_$tableId", function() use ($db, $tableId) {
        $stmt = $db->prepare(
            'SELECT request_id, request_type, status, requested_at
             FROM ServiceRequests
             WHERE table_id = ?
               AND status = "PENDING"
             ORDER BY requested_at DESC'
        );
        $stmt->execute([$tableId]);
        return $stmt->fetchAll(PDO::FETCH_ASSOC);
    }, 30); // Shorter cache TTL for service requests
    
    sendJson($requests);
}
   

// =============================================================================
// 6. Service Requests (with validation)
// =============================================================================
function handleServiceRequests(string $method, array $seg, PDO $db)
{
    if ($method !== 'POST') {
        throw new ApiException('Method not allowed.', 405);
    }
    createServiceRequest($db);
}

function createServiceRequest(PDO $db)
{
    $in = json_decode(file_get_contents('php://input'), true);
    if (json_last_error() !== JSON_ERROR_NONE) {
        throw new ApiException('JSON parse error: ' . json_last_error_msg(), 400);
    }
    
    // Validate input
    $validationRules = [
        'branch_id' => 'required|int',
        'table_id' => 'required|int',
        'request_type' => 'required'
    ];
    
    $errors = validateInput($in, $validationRules);
    if (!empty($errors)) {
        throw new ApiException('Invalid input data', 400, $errors);
    }
    
    // Sanitize input
    $in = sanitizeInput($in);

    // Validate against CHECK constraint
    $validTypes = [
        'CALL_WAITER',
        'REQUEST_BILL',
        'CLEANING_ASSISTANCE',
        'OTHER'
    ];
    if (!in_array($in['request_type'], $validTypes, true)) {
        throw new ApiException(
            'Invalid request_type; must be one of: ' . implode(', ', $validTypes),
            400
        );
    }

    $stmt = $db->prepare(
        'INSERT INTO ServiceRequests
         (branch_id, table_id, request_type, status, requested_at)
         VALUES (?, ?, ?, "PENDING", datetime("now","localtime"))'
    );
    $stmt->execute([
        $in['branch_id'],
        $in['table_id'],
        $in['request_type']
    ]);
    
    // Clear cache for this table's service requests
    clearCache("service_requests_table_{$in['table_id']}");

    sendJson(null, 201, 'Service request submitted.');
}

// =============================================================================
// 7. Translations (with caching)
// =============================================================================
function handleTranslations(string $method, array $seg, PDO $db)
{
    if ($method !== 'GET') {
        throw new ApiException('Method not allowed.', 405);
    }
    if (!isset($seg[1])) {
        throw new ApiException('Language code is required. e.g., /translations/en-US', 400);
    }
    getTranslationsByLanguage($db, $seg[1]);
}

function getTranslationsByLanguage(PDO $db, string $languageCode)
{
    // Validate language code format
    if (!preg_match('/^[a-z]{2}(-[A-Z]{2})?$/', $languageCode)) {
        throw new ApiException('Invalid language code format.', 400);
    }
    
    $translations = getCachedData("translations_$languageCode", function() use ($db, $languageCode) {
        $stmt = $db->prepare(
            'SELECT translation_key, translation_text
             FROM Translations
             WHERE language_code = ?'
        );
        $stmt->execute([$languageCode]);
        $results = $stmt->fetchAll(PDO::FETCH_KEY_PAIR);
        return (object)$results;
    });
    
    sendJson($translations);
}

// =============================================================================
// 8. Feedback (with pagination)
// =============================================================================
function handleFeedback(string $method, array $seg, PDO $db)
{
    switch ($method) {
        case 'POST':
            createFeedback($db);
            break;
        case 'GET':
            if (!isset($seg[1])) {
                listFeedback($db);
            } elseif ($seg[1] === 'branch' && isset($seg[2]) && ctype_digit($seg[2])) {
                getFeedbackByBranch($db, (int)$seg[2]);
            } elseif ($seg[1] === 'order' && isset($seg[2]) && ctype_digit($seg[2])) {
                getFeedbackByOrder($db, (int)$seg[2]);
            } elseif (ctype_digit($seg[1])) {
                getFeedback($db, (int)$seg[1]);
            } else {
                throw new ApiException('Endpoint not found.', 404);
            }
            break;
        default:
            throw new ApiException('Method not allowed.', 405);
    }
}

function createFeedback(PDO $db)
{
    $in = json_decode(file_get_contents('php://input'), true);
    if (json_last_error() !== JSON_ERROR_NONE) {
        throw new ApiException('JSON parse error: ' . json_last_error_msg(), 400);
    }
    
    // Validate input
    $validationRules = [
        'branch_id' => 'required|int',
        'rating' => 'required|int|min:1|max:5'
    ];
    
    $errors = validateInput($in, $validationRules);
    if (!empty($errors)) {
        throw new ApiException('Invalid input data', 400, $errors);
    }
    
    // Sanitize input
    $in = sanitizeInput($in);

    // Validate base rating
    $r = (int)$in['rating'];
    if ($r < 1 || $r > 5) {
        throw new ApiException('rating must be between 1 and 5.', 400);
    }

    // Build insert columns & values
    $cols = ['branch_id','rating'];
    $vals = [(int)$in['branch_id'], $r];

    if (isset($in['order_id'])) {
        if (!ctype_digit((string)$in['order_id'])) {
            throw new ApiException('order_id must be an integer.', 400);
        }
        $cols[] = 'order_id';
        $vals[] = (int)$in['order_id'];
    }

    if (!empty($in['feedback_text'])) {
        $cols[] = 'feedback_text';
        $vals[] = $in['feedback_text'];
    }

    // Optional sub-ratings
    foreach ([
        'service_quality_rating',
        'food_quality_rating',
        'ambiance_rating',
        'value_for_money_rating'
    ] as $sub) {
        if (isset($in[$sub])) {
            $x = (int)$in[$sub];
            if ($x < 1 || $x > 5) {
                throw new ApiException("$sub must be between 1 and 5.", 400);
            }
            $cols[] = $sub;
            $vals[] = $x;
        }
    }

    if (isset($in['would_recommend'])) {
        $cols[] = 'would_recommend';
        $vals[] = $in['would_recommend'] ? 1 : 0;
    }

    if (isset($in['tags'])) {
        $cols[] = 'tags';
        $vals[] = json_encode($in['tags']);
    }

    // INSERT into Feedback
    $placeholders = implode(',', array_fill(0, count($cols), '?'));
    $sql = 'INSERT INTO Feedback (' . implode(',', $cols) . ")
            VALUES ({$placeholders})";
    $stmt = $db->prepare($sql);
    $stmt->execute($vals);

    $id = (int)$db->lastInsertId();
    
    // Clear feedback cache
    clearCache('feedback_all');
    clearCache("feedback_branch_{$in['branch_id']}");
    if (isset($in['order_id'])) {
        clearCache("feedback_order_{$in['order_id']}");
    }

    sendJson(['feedback_id' => $id], 201, 'Feedback submitted successfully.');
}

function listFeedback(PDO $db)
{
    // Get pagination parameters
    $page = max(1, isset($_GET['page']) ? (int)$_GET['page'] : 1);
    $limit = min(100, max(1, isset($_GET['limit']) ? (int)$_GET['limit'] : 20));
    
    $cacheKey = "feedback_page_{$page}_limit_{$limit}";
    
    $result = getCachedData($cacheKey, function() use ($db, $page, $limit) {
        // Get total count
        $countStmt = $db->query('SELECT COUNT(*) FROM Feedback');
        $total = (int)$countStmt->fetchColumn();
        
        // Apply pagination
        $offset = ($page - 1) * $limit;
        $stmt = $db->prepare('SELECT * FROM Feedback ORDER BY created_at DESC LIMIT ? OFFSET ?');
        $stmt->execute([$limit, $offset]);
        $rows = $stmt->fetchAll(PDO::FETCH_ASSOC);
        
        foreach ($rows as &$r) {
            $r['rating']  = (int)$r['rating'];
            $r['branch_id'] = (int)$r['branch_id'];
            $r['order_id']  = $r['order_id'] !== null ? (int)$r['order_id'] : null;
            $r['would_recommend'] = (bool)$r['would_recommend'];
            $r['tags']     = $r['tags'] ? json_decode($r['tags'], true) : [];
        }
        
        return [
            'data' => $rows,
            'meta' => getPaginationMeta($page, $limit, $total)
        ];
    });
    
    sendJson($result['data'], 200, 'Feedback list', $result['meta']);
}

function getFeedback(PDO $db, int $id)
{
    $feedback = getCachedData("feedback_$id", function() use ($db, $id) {
        $stmt = $db->prepare('SELECT * FROM Feedback WHERE feedback_id = ?');
        $stmt->execute([$id]);
        $r = $stmt->fetch(PDO::FETCH_ASSOC);
        
        if ($r) {
            $r['rating']          = (int)$r['rating'];
            $r['branch_id']       = (int)$r['branch_id'];
            $r['order_id']        = $r['order_id'] !== null ? (int)$r['order_id'] : null;
            $r['would_recommend'] = (bool)$r['would_recommend'];
            $r['tags']            = $r['tags'] ? json_decode($r['tags'], true) : [];
        }
        
        return $r;
    });
    
    if (!$feedback) {
        throw new ApiException('Feedback not found.', 404);
    }
    sendJson($feedback);
}

function getFeedbackByBranch(PDO $db, int $branchId)
{
    // Get pagination parameters
    $page = max(1, isset($_GET['page']) ? (int)$_GET['page'] : 1);
    $limit = min(100, max(1, isset($_GET['limit']) ? (int)$_GET['limit'] : 20));
    
    $cacheKey = "feedback_branch_{$branchId}_page_{$page}_limit_{$limit}";
    
    $result = getCachedData($cacheKey, function() use ($db, $branchId, $page, $limit) {
        // Get total count
        $countStmt = $db->prepare('SELECT COUNT(*) FROM Feedback WHERE branch_id = ?');
        $countStmt->execute([$branchId]);
        $total = (int)$countStmt->fetchColumn();
        
        // Apply pagination
        $offset = ($page - 1) * $limit;
        $stmt = $db->prepare('SELECT * FROM Feedback WHERE branch_id = ? ORDER BY created_at DESC LIMIT ? OFFSET ?');
        $stmt->execute([$branchId, $limit, $offset]);
        $rows = $stmt->fetchAll(PDO::FETCH_ASSOC);
        
        foreach ($rows as &$r) {
            $r['rating']          = (int)$r['rating'];
            $r['order_id']        = $r['order_id'] !== null ? (int)$r['order_id'] : null;
            $r['would_recommend'] = (bool)$r['would_recommend'];
            $r['tags']            = $r['tags'] ? json_decode($r['tags'], true) : [];
        }
        
        return [
            'data' => $rows,
            'meta' => getPaginationMeta($page, $limit, $total)
        ];
    });
    
    sendJson($result['data'], 200, "Feedback for branch $branchId", $result['meta']);
}

function getFeedbackByOrder(PDO $db, int $orderId)
{
    $feedback = getCachedData("feedback_order_$orderId", function() use ($db, $orderId) {
        $stmt = $db->prepare('SELECT * FROM Feedback WHERE order_id = ? ORDER BY created_at DESC');
        $stmt->execute([$orderId]);
        $rows = $stmt->fetchAll(PDO::FETCH_ASSOC);
        
        foreach ($rows as &$r) {
            $r['rating']          = (int)$r['rating'];
            $r['branch_id']       = (int)$r['branch_id'];
            $r['would_recommend'] = (bool)$r['would_recommend'];
            $r['tags']            = $r['tags'] ? json_decode($r['tags'], true) : [];
        }
        
        return $rows;
    });
    
    sendJson($feedback);
}

// =============================================================================
// 9. RestaurantDetails (read-only with caching)
// =============================================================================
function handleRestaurant(string $method, array $seg, PDO $db)
{
    if ($method !== 'GET') {
        throw new ApiException('Method not allowed.', 405);
    }
    
    // GET /api/restaurant or /api/restaurant/{id}
    if (isset($seg[1]) && ctype_digit($seg[1])) {
        getRestaurantById($db, (int)$seg[1]);
    } else {
        getActiveRestaurant($db);
    }
}

function getActiveRestaurant(PDO $db)
{
    $restaurant = getCachedData('restaurant_active', function() use ($db) {
        $stmt = $db->query(
            'SELECT * FROM RestaurantDetails WHERE is_active = 1 LIMIT 1'
        );
        $row = $stmt->fetch(PDO::FETCH_ASSOC);
        
        if ($row) {
            // decode JSON columns
            $row['social_media_links'] = json_decode($row['social_media_links'] ?? '{}', true);
            $row['business_hours']     = json_decode($row['business_hours'] ?? '{}', true);
        }
        
        return $row;
    });
    
    if (!$restaurant) {
        throw new ApiException('No active restaurant found.', 404);
    }
    sendJson($restaurant);
}

function getRestaurantById(PDO $db, int $id)
{
    $restaurant = getCachedData("restaurant_$id", function() use ($db, $id) {
        $stmt = $db->prepare(
            'SELECT * FROM RestaurantDetails WHERE restaurant_id = ?'
        );
        $stmt->execute([$id]);
        $row = $stmt->fetch(PDO::FETCH_ASSOC);
        
        if ($row) {
            $row['social_media_links'] = json_decode($row['social_media_links'] ?? '{}', true);
            $row['business_hours']     = json_decode($row['business_hours'] ?? '{}', true);
        }
        
        return $row;
    });
    
    if (!$restaurant) {
        throw new ApiException('Restaurant not found.', 404);
    }
    sendJson($restaurant);
}

// =============================================================================
// 10. Cart Validation Endpoints (for local storage)
// =============================================================================
function handleCart(string $method, array $seg, PDO $db)
{
    if ($method !== 'POST') {
        throw new ApiException('Method not allowed.', 405);
    }
    
    if (!isset($seg[1])) {
        throw new ApiException('Cart action required.', 400);
    }
    
    switch ($seg[1]) {
        case 'validate':
            validateCart($db);
            break;
        case 'prices':
            getCartPrices($db);
            break;
        default:
            throw new ApiException('Endpoint not found.', 404);
    }
}

function validateCart(PDO $db)
{
    $raw = file_get_contents('php://input');
    $data = json_decode($raw, true);
    if (json_last_error() !== JSON_ERROR_NONE) {
        throw new ApiException('JSON parse error: ' . json_last_error_msg(), 400);
    }
    
    // Validate input
    $validationRules = [
        'branch_id' => 'required|int',
        'items' => 'required|array'
    ];
    
    $errors = validateInput($data, $validationRules);
    if (!empty($errors)) {
        throw new ApiException('Invalid input data', 400, $errors);
    }
    
    // Sanitize input
    $data = sanitizeInput($data);
    
    $validated = [];
    $errors = [];
    
    foreach ($data['items'] as $idx => $itm) {
        if (!isset($itm['branch_menu_id'], $itm['quantity'])) {
            $errors[] = ['index' => $idx, 'message' => 'Invalid cart item format'];
            continue;
        }
        
        // Check if item exists and is available
        $stmt = $db->prepare('
            SELECT bm.branch_menu_id, bm.price, bm.is_available, 
                   mi.name_translation_key, mi.name_translation_key AS name, mi.image_url
            FROM BranchMenu bm
            JOIN MenuItems_Global mi ON bm.item_id = mi.item_id
            WHERE bm.branch_menu_id = ? AND bm.branch_id = ?
        ');
        $stmt->execute([$itm['branch_menu_id'], $data['branch_id']]);
        $dbItem = $stmt->fetch(PDO::FETCH_ASSOC);
        
        if (!$dbItem) {
            $errors[] = ['index' => $idx, 'message' => 'Item not found'];
            continue;
        }
        
        if (!$dbItem['is_available']) {
            $errors[] = ['index' => $idx, 'message' => 'Item not available'];
            continue;
        }
        
        $validated[] = [
            'branch_menu_id' => $dbItem['branch_menu_id'],
            'price' => (float)$dbItem['price'],
            'name' => $dbItem['name_translation_key'],
            'image_url' => $dbItem['image_url'],
            'quantity' => (int)$itm['quantity'],
            'total' => (float)$dbItem['price'] * (int)$itm['quantity']
        ];
    }
    
    sendJson([        'validated' => $validated,
        'errors' => $errors
    ], 200, 'Cart validation completed');
}

function getCartPrices(PDO $db)
{
    $raw = file_get_contents('php://input');
    $data = json_decode($raw, true);
    if (json_last_error() !== JSON_ERROR_NONE) {
        throw new ApiException('JSON parse error: ' . json_last_error_msg(), 400);
    }
    
    // Validate input
    $validationRules = [
        'branch_id' => 'required|int',
        'items' => 'required|array'
    ];
    
    $errors = validateInput($data, $validationRules);
    if (!empty($errors)) {
        throw new ApiException('Invalid input data', 400, $errors);
    }
    
    // Sanitize input
    $data = sanitizeInput($data);
    
    $prices = [];
    
    foreach ($data['items'] as $itm) {
        if (!isset($itm['branch_menu_id'])) {
            continue;
        }
        
        // Get current price
        $stmt = $db->prepare('
            SELECT bm.branch_menu_id, bm.price
            FROM BranchMenu bm
            WHERE bm.branch_menu_id = ? AND bm.branch_id = ? AND bm.is_available = 1
        ');
        $stmt->execute([$itm['branch_menu_id'], $data['branch_id']]);
        $dbItem = $stmt->fetch(PDO::FETCH_ASSOC);
        
        if ($dbItem) {
            $prices[] = [
                'branch_menu_id' => $dbItem['branch_menu_id'],
                'price' => (float)$dbItem['price']
            ];
        }
    }
    
    sendJson($prices, 200, 'Current prices retrieved');
}

