# Luna Dine Database Structure Documentation

## Overview
Luna Dine is a comprehensive restaurant management system designed to handle multiple restaurant branches with different cuisines. The database is built on SQLite and contains 33 interconnected tables that support:

- Multi-branch restaurant operations
- Order management and tracking
- Menu management with customizable options
- User management with role-based permissions
- Notification and communication systems
- Analytics and reporting
- Table service and delivery tracking

---

## Core System Tables

### 1. **Users** - Central user management
**Purpose**: Stores all system users (customers, staff, admins)

| Column | Type | Description |
|--------|------|-------------|
| user_id | INTEGER PRIMARY KEY | Unique user identifier |
| username | TEXT UNIQUE NOT NULL | Login username |
| email | TEXT UNIQUE NOT NULL | User email address |
| password_hash | TEXT NOT NULL | Hashed password |
| first_name | TEXT | User's first name |
| last_name | TEXT | User's last name |
| phone | TEXT | Contact phone number |
| role_id | INTEGER | References Roles table |
| branch_id | INTEGER | References Branches table (for staff) |
| profile_image | TEXT | Profile image path |
| date_of_birth | DATE | User's birth date |
| last_login | DATETIME | Last login timestamp |
| failed_login_attempts | INTEGER DEFAULT 0 | Security tracking |
| account_locked_until | DATETIME | Account lockout timestamp |
| is_active | BOOLEAN DEFAULT 1 | Account status |
| created_at | DATETIME DEFAULT CURRENT_TIMESTAMP | Creation time |
| updated_at | DATETIME DEFAULT CURRENT_TIMESTAMP | Last update time |

**Key Relationships**:
- `role_id` → `Roles.role_id`
- `branch_id` → `Branches.branch_id`

---

### 2. **Roles** - Permission management
**Purpose**: Defines user roles and permissions

| Column | Type | Description |
|--------|------|-------------|
| role_id | INTEGER PRIMARY KEY | Unique role identifier |
| role_name | TEXT NOT NULL | Role display name |
| description | TEXT | Role description |
| permissions | TEXT | JSON permissions object |
| is_system_role | BOOLEAN DEFAULT 0 | System-defined role flag |
| created_at | DATETIME DEFAULT CURRENT_TIMESTAMP | Creation time |
| updated_at | DATETIME DEFAULT CURRENT_TIMESTAMP | Last update time |

---

### 3. **Branches** - Restaurant locations
**Purpose**: Manages multiple restaurant locations

| Column | Type | Description |
|--------|------|-------------|
| branch_id | INTEGER PRIMARY KEY | Unique branch identifier |
| branch_name | TEXT NOT NULL | Branch display name |
| address | TEXT NOT NULL | Physical address |
| latitude | REAL | GPS latitude |
| longitude | REAL | GPS longitude |
| timezone | TEXT DEFAULT 'UTC' | Branch timezone |
| contact_email | TEXT | Branch contact email |
| is_active | BOOLEAN DEFAULT 1 | Branch status |
| created_at | DATETIME DEFAULT CURRENT_TIMESTAMP | Creation time |
| updated_at | DATETIME DEFAULT CURRENT_TIMESTAMP | Last update time |
| created_by | INTEGER | Creator user ID |
| updated_by | INTEGER | Last updater user ID |

---

## Menu Management System

### 4. **MenuCategories** - Menu organization
**Purpose**: Categorizes menu items by type (e.g., Pizza, Burgers, etc.)

| Column | Type | Description |
|--------|------|-------------|
| category_id | INTEGER PRIMARY KEY | Unique category identifier |
| category_name_key | TEXT NOT NULL | Translation key for category name |
| category_description_key | TEXT | Translation key for description |
| display_order | INTEGER | Category sorting order |
| image_url | TEXT | Category image path |
| is_active | BOOLEAN DEFAULT 1 | Category status |
| branch_id | INTEGER | Branch-specific category |

### 5. **MenuItems_Global** - Global menu items
**Purpose**: Stores master menu items available across branches

| Column | Type | Description |
|--------|------|-------------|
| item_id | INTEGER PRIMARY KEY | Unique item identifier |
| category_id | INTEGER NOT NULL | References MenuCategories |
| item_code | TEXT UNIQUE NOT NULL | Unique item code |
| item_name_key | TEXT NOT NULL | Translation key for item name |
| item_description_key | TEXT | Translation key for description |
| image_url | TEXT | Item image path |
| tags | TEXT | JSON array of tags |
| allergens | TEXT | JSON array of allergens |
| preparation_time | INTEGER | Prep time in minutes |
| dietary_info | TEXT | JSON array of dietary information |
| is_active | BOOLEAN DEFAULT 1 | Item status |

### 6. **BranchMenu** - Branch-specific menu items
**Purpose**: Links global menu items to branches with pricing and customizations

| Column | Type | Description |
|--------|------|-------------|
| branch_menu_id | INTEGER PRIMARY KEY | Unique branch menu identifier |
| branch_id | INTEGER NOT NULL | References Branches |
| global_item_id | INTEGER NOT NULL | References MenuItems_Global |
| price | DECIMAL(10,2) NOT NULL | Branch-specific price |
| is_available | BOOLEAN DEFAULT 1 | Availability status |
| customization_groups | TEXT | JSON customization options |
| display_order | INTEGER | Item sorting order |

---

## Order Management System

### 7. **Orders** - Main order entity
**Purpose**: Central order management table

| Column | Type | Description |
|--------|------|-------------|
| order_id | INTEGER PRIMARY KEY | Unique order identifier |
| order_number | TEXT UNIQUE NOT NULL | Human-readable order number |
| customer_id | INTEGER | References Users (customers) |
| branch_id | INTEGER NOT NULL | References Branches |
| table_id | INTEGER | References Tables (for dine-in) |
| order_type | TEXT CHECK(order_type IN ('dine-in', 'takeaway', 'delivery')) | Order type |
| status | TEXT DEFAULT 'pending' | Order status |
| subtotal | DECIMAL(10,2) NOT NULL | Items subtotal |
| tax_amount | DECIMAL(10,2) DEFAULT 0 | Tax amount |
| discount_amount | DECIMAL(10,2) DEFAULT 0 | Discount amount |
| delivery_fee | DECIMAL(10,2) DEFAULT 0 | Delivery fee |
| total_amount | DECIMAL(10,2) NOT NULL | Final total |
| payment_status | TEXT DEFAULT 'pending' | Payment status |
| payment_method | TEXT | Payment method used |
| special_instructions | TEXT | Customer notes |
| estimated_ready_time | DATETIME | Estimated completion time |
| actual_ready_time | DATETIME | Actual completion time |
| delivery_address | TEXT | Delivery address (for delivery orders) |
| created_at | DATETIME DEFAULT CURRENT_TIMESTAMP | Order time |

### 8. **OrderItems** - Order line items
**Purpose**: Individual items within an order

| Column | Type | Description |
|--------|------|-------------|
| order_item_id | INTEGER PRIMARY KEY | Unique order item identifier |
| order_id | INTEGER NOT NULL | References Orders |
| branch_menu_id | INTEGER NOT NULL | References BranchMenu |
| quantity | INTEGER NOT NULL | Item quantity |
| unit_price | DECIMAL(10,2) NOT NULL | Price per unit |
| customizations | TEXT | JSON customization selections |
| special_instructions | TEXT | Item-specific notes |
| status | TEXT DEFAULT 'pending' | Item preparation status |
| discount_amount | DECIMAL(10,2) DEFAULT 0 | Item discount |
| tax_amount | DECIMAL(10,2) DEFAULT 0 | Item tax |
| total_price | DECIMAL(10,2) NOT NULL | Total item price |

### 9. **OrderTimeline** - Order tracking
**Purpose**: Tracks order status changes and events

| Column | Type | Description |
|--------|------|-------------|
| timeline_id | INTEGER PRIMARY KEY | Unique timeline identifier |
| order_id | INTEGER NOT NULL | References Orders |
| event_type | TEXT NOT NULL | Event type (ORDER_PLACED, etc.) |
| event_description | TEXT | Human-readable description |
| timestamp | DATETIME DEFAULT CURRENT_TIMESTAMP | Event timestamp |
| staff_id | INTEGER | Staff member who performed action |
| metadata | TEXT | JSON additional event data |

---

## Service Management

### 10. **Tables** - Restaurant tables
**Purpose**: Manages restaurant table assignments

| Column | Type | Description |
|--------|------|-------------|
| table_id | INTEGER PRIMARY KEY | Unique table identifier |
| branch_id | INTEGER NOT NULL | References Branches |
| table_number | TEXT NOT NULL | Table display number |
| table_name | TEXT | Table display name |
| capacity | INTEGER NOT NULL | Maximum seating capacity |
| location_info | TEXT | Table location description |
| qr_code | TEXT | QR code for mobile ordering |
| table_type | TEXT DEFAULT 'regular' | Table type |
| is_active | BOOLEAN DEFAULT 1 | Table availability |

### 11. **TableServiceStatus** - Table service tracking
**Purpose**: Tracks table service status and assignments

| Column | Type | Description |
|--------|------|-------------|
| service_id | INTEGER PRIMARY KEY | Unique service identifier |
| table_id | INTEGER NOT NULL | References Tables |
| order_id | INTEGER | References Orders |
| server_id | INTEGER | Assigned server (References Users) |
| service_status | TEXT DEFAULT 'available' | Service status |
| customer_count | INTEGER | Number of customers |
| seated_at | DATETIME | Seating time |
| service_started_at | DATETIME | Service start time |
| estimated_completion | DATETIME | Estimated completion time |
| special_requests | TEXT | Customer special requests |

### 12. **ServiceRequests** - Customer service requests
**Purpose**: Handles customer service requests (refills, assistance, etc.)

| Column | Type | Description |
|--------|------|-------------|
| request_id | INTEGER PRIMARY KEY | Unique request identifier |
| table_id | INTEGER NOT NULL | References Tables |
| branch_id | INTEGER NOT NULL | References Branches |
| request_type | TEXT NOT NULL | Type of request |
| description | TEXT | Request description |
| status | TEXT DEFAULT 'pending' | Request status |
| priority | TEXT DEFAULT 'normal' | Request priority |
| requested_at | DATETIME DEFAULT CURRENT_TIMESTAMP | Request time |
| assigned_to_user_id | INTEGER | Assigned staff member |
| resolved_at | DATETIME | Resolution time |
| resolved_by_user_id | INTEGER | Staff who resolved |

---

## Delivery & Pickup Management

### 13. **DeliveryTracking** - Delivery management
**Purpose**: Tracks delivery orders and status

| Column | Type | Description |
|--------|------|-------------|
| tracking_id | INTEGER PRIMARY KEY | Unique tracking identifier |
| order_id | INTEGER NOT NULL | References Orders |
| delivery_address | TEXT | Delivery address |
| delivery_fee | DECIMAL(10,2) | Delivery fee |
| driver_id | INTEGER | Assigned driver (References Users) |
| delivery_status | TEXT DEFAULT 'assigned' | Delivery status |
| estimated_delivery_time | DATETIME | Estimated delivery time |
| actual_pickup_time | DATETIME | When order was picked up |
| actual_delivery_time | DATETIME | When order was delivered |
| delivery_instructions | TEXT | Delivery notes |
| contact_phone | TEXT | Customer contact |
| tracking_session_id | TEXT | External tracking ID |

### 14. **PickupQueue** - Takeaway pickup management
**Purpose**: Manages takeaway order pickup queue

| Column | Type | Description |
|--------|------|-------------|
| queue_id | INTEGER PRIMARY KEY | Unique queue identifier |
| order_id | INTEGER NOT NULL | References Orders |
| queue_position | INTEGER | Position in queue |
| estimated_ready_time | DATETIME | Estimated ready time |
| actual_ready_time | DATETIME | Actual ready time |
| pickup_status | TEXT DEFAULT 'waiting' | Pickup status |
| customer_notified_at | DATETIME | Customer notification time |
| pickup_code | TEXT | Pickup verification code |

---

## Notification & Communication System

### 15. **NotificationTemplates** - Notification templates
**Purpose**: Predefined notification message templates

| Column | Type | Description |
|--------|------|-------------|
| template_id | INTEGER PRIMARY KEY | Unique template identifier |
| template_key | TEXT UNIQUE NOT NULL | Template identifier key |
| category | TEXT NOT NULL | Notification category |
| title | TEXT NOT NULL | Notification title |
| message | TEXT NOT NULL | Message template with placeholders |
| notification_type | TEXT DEFAULT 'info' | Notification type |
| required_variables | TEXT | JSON array of required variables |
| is_active | BOOLEAN DEFAULT 1 | Template status |

### 16. **Notifications** - User notifications
**Purpose**: Stores user notifications

| Column | Type | Description |
|--------|------|-------------|
| notification_id | INTEGER PRIMARY KEY | Unique notification identifier |
| user_id | INTEGER NOT NULL | References Users |
| title | TEXT NOT NULL | Notification title |
| message | TEXT NOT NULL | Notification message |
| notification_type | TEXT DEFAULT 'info' | Notification type |
| is_read | BOOLEAN DEFAULT 0 | Read status |
| metadata | TEXT | JSON additional data |
| created_at | DATETIME DEFAULT CURRENT_TIMESTAMP | Creation time |

### 17. **ScheduledNotifications** - Scheduled notifications
**Purpose**: Manages scheduled notification delivery

| Column | Type | Description |
|--------|------|-------------|
| scheduled_id | INTEGER PRIMARY KEY | Unique scheduled notification identifier |
| template_id | INTEGER NOT NULL | References NotificationTemplates |
| recipient_type | TEXT NOT NULL | Recipient type (user, role, etc.) |
| recipient_ids | TEXT | JSON array of recipient IDs |
| variables | TEXT | JSON template variables |
| scheduled_at | DATETIME NOT NULL | Scheduled delivery time |
| status | TEXT DEFAULT 'pending' | Delivery status |
| sent_at | DATETIME | Actual send time |
| error_message | TEXT | Error details if failed |

---

## Settings & Configuration

### 18. **Settings** - System settings
**Purpose**: Stores system-wide configuration settings

| Column | Type | Description |
|--------|------|-------------|
| setting_id | INTEGER PRIMARY KEY | Unique setting identifier |
| setting_key | TEXT UNIQUE NOT NULL | Setting key |
| setting_value | TEXT | Setting value |
| setting_type | TEXT DEFAULT 'string' | Data type |
| category | TEXT DEFAULT 'general' | Setting category |
| description | TEXT | Setting description |
| is_public | BOOLEAN DEFAULT 0 | Public visibility |
| created_at | DATETIME DEFAULT CURRENT_TIMESTAMP | Creation time |

### 19. **BranchSettings** - Branch-specific settings
**Purpose**: Branch-specific configuration and customization

| Column | Type | Description |
|--------|------|-------------|
| branch_id | INTEGER PRIMARY KEY | References Branches |
| branch_display_name | TEXT | Custom branch display name |
| logo_url | TEXT | Branch logo image |
| cover_image_url | TEXT | Branch cover image |
| contact_phone | TEXT | Branch contact phone |
| tax_rate | DECIMAL(5,2) DEFAULT 0 | Tax rate percentage |
| service_charge_rate | DECIMAL(5,2) DEFAULT 0 | Service charge rate |
| delivery_settings | TEXT | JSON delivery configuration |
| operating_hours | TEXT | JSON operating hours |
| minimum_order_amount | DECIMAL(10,2) | Minimum order amount |
| average_preparation_time | INTEGER | Average prep time in minutes |

### 20. **Translations** - Multi-language support
**Purpose**: Stores translations for internationalization

| Column | Type | Description |
|--------|------|-------------|
| translation_id | INTEGER PRIMARY KEY | Unique translation identifier |
| translation_key | TEXT NOT NULL | Translation key |
| language_code | TEXT NOT NULL | Language code (en-US, bn-BD, etc.) |
| translation_value | TEXT NOT NULL | Translated text |
| created_at | DATETIME DEFAULT CURRENT_TIMESTAMP | Creation time |

---

## Analytics & Tracking

### 21. **OrderTrackingAnalytics** - Order analytics
**Purpose**: Stores order analytics and metrics

| Column | Type | Description |
|--------|------|-------------|
| analytics_id | INTEGER PRIMARY KEY | Unique analytics identifier |
| order_id | INTEGER NOT NULL | References Orders |
| branch_id | INTEGER NOT NULL | References Branches |
| order_date | DATE NOT NULL | Order date |
| order_hour | INTEGER | Order hour (0-23) |
| day_of_week | INTEGER | Day of week (1-7) |
| preparation_time_actual | INTEGER | Actual preparation time |
| customer_wait_time | INTEGER | Customer wait time |
| order_value_category | TEXT | Order value category |
| peak_hour_indicator | BOOLEAN | Peak hour flag |
| customer_satisfaction_score | INTEGER | Satisfaction rating |

### 22. **AdminLogs** - Admin activity logging
**Purpose**: Logs administrative actions for audit trails

| Column | Type | Description |
|--------|------|-------------|
| log_id | INTEGER PRIMARY KEY | Unique log identifier |
| admin_id | INTEGER NOT NULL | References Users (admin) |
| action_type | TEXT NOT NULL | Action type |
| table_name | TEXT | Affected table |
| record_id | INTEGER | Affected record ID |
| old_values | TEXT | JSON old values |
| new_values | TEXT | JSON new values |
| ip_address | TEXT | Admin IP address |
| user_agent | TEXT | Browser user agent |
| timestamp | DATETIME DEFAULT CURRENT_TIMESTAMP | Action timestamp |

### 23. **AdminSessions** - Admin session management
**Purpose**: Tracks admin login sessions

| Column | Type | Description |
|--------|------|-------------|
| session_id | TEXT PRIMARY KEY | Session identifier |
| admin_id | INTEGER NOT NULL | References Users (admin) |
| ip_address | TEXT | Session IP address |
| user_agent | TEXT | Browser user agent |
| login_time | DATETIME DEFAULT CURRENT_TIMESTAMP | Login time |
| last_activity | DATETIME DEFAULT CURRENT_TIMESTAMP | Last activity time |
| is_active | BOOLEAN DEFAULT 1 | Session status |

---

## Promotion & Marketing

### 24. **Promotions** - Promotional campaigns
**Purpose**: Manages discount promotions and campaigns

| Column | Type | Description |
|--------|------|-------------|
| promotion_id | INTEGER PRIMARY KEY | Unique promotion identifier |
| promotion_name | TEXT NOT NULL | Promotion display name |
| description | TEXT | Promotion description |
| promotion_type | TEXT NOT NULL | Promotion type |
| discount_type | TEXT NOT NULL | Discount type (percentage/fixed) |
| discount_value | DECIMAL(10,2) NOT NULL | Discount amount |
| minimum_order_amount | DECIMAL(10,2) | Minimum order requirement |
| maximum_discount | DECIMAL(10,2) | Maximum discount cap |
| usage_limit | INTEGER | Usage limit per customer |
| total_usage_limit | INTEGER | Total usage limit |
| start_date | DATETIME NOT NULL | Promotion start time |
| end_date | DATETIME NOT NULL | Promotion end time |
| is_active | BOOLEAN DEFAULT 1 | Promotion status |

### 25. **Promotion_Branches** - Promotion branch associations
**Purpose**: Links promotions to specific branches

| Column | Type | Description |
|--------|------|-------------|
| promotion_id | INTEGER NOT NULL | References Promotions |
| branch_id | INTEGER NOT NULL | References Branches |

### 26. **Promotion_Items** - Promotion item associations
**Purpose**: Links promotions to specific menu items

| Column | Type | Description |
|--------|------|-------------|
| promotion_id | INTEGER NOT NULL | References Promotions |
| item_id | INTEGER NOT NULL | References MenuItems_Global |

---

## Additional System Tables

### 27. **FeatureFlags** - Feature management
**Purpose**: Controls feature availability and rollout

| Column | Type | Description |
|--------|------|-------------|
| flag_id | INTEGER PRIMARY KEY | Unique flag identifier |
| flag_key | TEXT UNIQUE NOT NULL | Feature flag key |
| flag_name | TEXT NOT NULL | Feature display name |
| description | TEXT | Feature description |
| is_enabled | BOOLEAN DEFAULT 0 | Feature status |
| target_audience | TEXT DEFAULT 'all' | Target audience |
| rollout_percentage | INTEGER DEFAULT 100 | Rollout percentage |
| start_date | DATETIME | Feature start date |
| end_date | DATETIME | Feature end date |
| metadata | TEXT | JSON additional data |

### 28. **ErrorLogs** - Error logging
**Purpose**: Logs system errors and exceptions

| Column | Type | Description |
|--------|------|-------------|
| error_id | INTEGER PRIMARY KEY | Unique error identifier |
| error_type | TEXT NOT NULL | Error type |
| error_message | TEXT NOT NULL | Error message |
| stack_trace | TEXT | Error stack trace |
| user_id | INTEGER | User who encountered error |
| request_url | TEXT | Request URL |
| request_method | TEXT | HTTP method |
| request_data | TEXT | Request data |
| ip_address | TEXT | Client IP address |
| user_agent | TEXT | Browser user agent |
| severity | TEXT DEFAULT 'error' | Error severity |
| is_resolved | BOOLEAN DEFAULT 0 | Resolution status |
| resolved_at | DATETIME | Resolution time |
| resolved_by | INTEGER | Resolver user ID |
| timestamp | DATETIME DEFAULT CURRENT_TIMESTAMP | Error time |

### 29. **Feedback** - Customer feedback
**Purpose**: Stores customer feedback and reviews

| Column | Type | Description |
|--------|------|-------------|
| feedback_id | INTEGER PRIMARY KEY | Unique feedback identifier |
| order_id | INTEGER | References Orders |
| customer_id | INTEGER | References Users |
| branch_id | INTEGER NOT NULL | References Branches |
| rating | INTEGER CHECK(rating >= 1 AND rating <= 5) | Rating (1-5) |
| feedback_text | TEXT | Feedback message |
| feedback_type | TEXT DEFAULT 'general' | Feedback category |
| is_anonymous | BOOLEAN DEFAULT 0 | Anonymous flag |
| staff_response | TEXT | Staff response |
| response_date | DATETIME | Response date |
| is_public | BOOLEAN DEFAULT 1 | Public visibility |
| tags | TEXT | JSON feedback tags |
| sentiment_score | REAL | AI sentiment analysis score |
| created_at | DATETIME DEFAULT CURRENT_TIMESTAMP | Feedback time |

### 30. **UserDevices** - User device management
**Purpose**: Manages user devices for push notifications

| Column | Type | Description |
|--------|------|-------------|
| device_id | INTEGER PRIMARY KEY | Unique device identifier |
| user_id | INTEGER NOT NULL | References Users |
| device_token | TEXT UNIQUE NOT NULL | Push notification token |
| device_type | TEXT NOT NULL | Device type (iOS/Android) |
| device_name | TEXT | Device display name |
| app_version | TEXT | App version |
| os_version | TEXT | OS version |
| is_active | BOOLEAN DEFAULT 1 | Device status |
| last_used | DATETIME DEFAULT CURRENT_TIMESTAMP | Last usage time |
| created_at | DATETIME DEFAULT CURRENT_TIMESTAMP | Registration time |

### 31. **BranchBanners** - Promotional banners
**Purpose**: Manages promotional banners for branches

| Column | Type | Description |
|--------|------|-------------|
| banner_id | INTEGER PRIMARY KEY | Unique banner identifier |
| branch_id | INTEGER NOT NULL | References Branches |
| title_key | TEXT NOT NULL | Banner title translation key |
| description_key | TEXT | Banner description translation key |
| image_url | TEXT | Banner image URL |
| link_url | TEXT | Banner click destination |
| display_order | INTEGER DEFAULT 0 | Banner sorting order |
| is_active | BOOLEAN DEFAULT 1 | Banner status |
| start_date | DATETIME | Banner start time |
| end_date | DATETIME | Banner end time |
| target_audience | TEXT | Target audience |
| click_count | INTEGER DEFAULT 0 | Click tracking |
| view_count | INTEGER DEFAULT 0 | View tracking |
| created_at | DATETIME DEFAULT CURRENT_TIMESTAMP | Creation time |

### 32. **BranchUsers** - User-Branch associations
**Purpose**: Links users to specific branches (for multi-branch access)

| Column | Type | Description |
|--------|------|-------------|
| association_id | INTEGER PRIMARY KEY | Unique association identifier |
| user_id | INTEGER NOT NULL | References Users |
| branch_id | INTEGER NOT NULL | References Branches |
| role_in_branch | TEXT | Role within this branch |
| permissions | TEXT | JSON branch-specific permissions |
| is_active | BOOLEAN DEFAULT 1 | Association status |
| assigned_at | DATETIME DEFAULT CURRENT_TIMESTAMP | Assignment time |
| assigned_by | INTEGER | Assigner user ID |
| removed_at | DATETIME | Removal time |
| removed_by | INTEGER | Remover user ID |

### 33. **RestaurantDetails** - Restaurant information
**Purpose**: Stores general restaurant information

| Column | Type | Description |
|--------|------|-------------|
| restaurant_id | INTEGER PRIMARY KEY | Unique restaurant identifier |
| restaurant_name | TEXT NOT NULL | Restaurant name |
| description | TEXT | Restaurant description |
| cuisine_types | TEXT | JSON array of cuisine types |
| price_range | TEXT | Price range category |
| website_url | TEXT | Website URL |
| facebook_url | TEXT | Facebook page URL |
| instagram_url | TEXT | Instagram profile URL |
| twitter_url | TEXT | Twitter profile URL |
| logo_url | TEXT | Restaurant logo URL |
| cover_image_url | TEXT | Cover image URL |
| established_year | INTEGER | Establishment year |
| license_number | TEXT | Business license number |
| tax_id | TEXT | Tax identification number |
| contact_email | TEXT | Primary contact email |
| contact_phone | TEXT | Primary contact phone |
| emergency_contact | TEXT | Emergency contact |
| business_hours | TEXT | JSON business hours |
| delivery_radius | REAL | Delivery radius in km |
| accepts_reservations | BOOLEAN DEFAULT 1 | Reservation acceptance |
| has_parking | BOOLEAN DEFAULT 0 | Parking availability |
| has_wifi | BOOLEAN DEFAULT 1 | WiFi availability |
| is_active | BOOLEAN DEFAULT 1 | Restaurant status |

---

## Database Triggers

The database includes several automated triggers:

### 1. **order_placed_trigger**
- Automatically creates an OrderTimeline entry when a new order is placed
- Triggers on: `INSERT INTO Orders`

### 2. **order_status_change_trigger**
- Logs order status changes in OrderTimeline
- Triggers on: `UPDATE OF status ON Orders`

### 3. **delivery_order_trigger**
- Creates DeliveryTracking entry for delivery orders
- Triggers on: `INSERT INTO Orders WHERE order_type = 'delivery'`

### 4. **takeaway_order_trigger**
- Creates PickupQueue entry for takeaway orders
- Triggers on: `INSERT INTO Orders WHERE order_type = 'takeaway'`

### 5. **dinein_order_trigger**
- Creates TableServiceStatus entry for dine-in orders
- Triggers on: `INSERT INTO Orders WHERE order_type = 'dine-in'`

---

## Key Database Indexes

The database includes comprehensive indexing for optimal performance:

### Performance-Critical Indexes:
- Order queries: `idx_orders_customer`, `idx_orders_status`, `idx_orders_created`
- User lookups: `idx_users_role`, `idx_users_branch`, `idx_users_active`
- Menu filtering: `idx_branchmenu_branch`, `idx_branchmenu_item`, `idx_branchmenu_availability`
- Notification delivery: `idx_notifications_user`, `idx_notifications_read`
- Analytics queries: `idx_orderanalytics_date`, `idx_orderanalytics_branch`

---

## Data Relationships Summary

### Core Entity Relationships:
1. **Users** ↔ **Roles**: Many-to-One (users have roles)
2. **Users** ↔ **Branches**: Many-to-One (staff assigned to branches)
3. **Branches** ↔ **BranchMenu**: One-to-Many (branches have menu items)
4. **MenuItems_Global** ↔ **BranchMenu**: One-to-Many (global items in branch menus)
5. **Orders** ↔ **OrderItems**: One-to-Many (orders contain items)
6. **Orders** ↔ **Users**: Many-to-One (customers place orders)
7. **Orders** ↔ **Tables**: Many-to-One (dine-in orders at tables)

### Service Relationships:
8. **Orders** ↔ **DeliveryTracking**: One-to-One (delivery orders)
9. **Orders** ↔ **PickupQueue**: One-to-One (takeaway orders)
10. **Orders** ↔ **TableServiceStatus**: One-to-One (dine-in orders)

---

## Development Guidelines

### 1. **Data Integrity**
- Always use foreign key constraints
- Implement proper validation at application level
- Use database triggers for automatic logging

### 2. **Performance Considerations**
- Use indexes for frequently queried columns
- Implement proper pagination for large datasets
- Consider caching for frequently accessed data

### 3. **Security**
- Store sensitive data encrypted
- Use parameterized queries to prevent SQL injection
- Implement proper session management

### 4. **Maintenance**
- Regular backup of critical data
- Monitor performance with query analysis
- Archive old data to maintain performance

---

## Sample Queries for Development

### Get user orders with items:
```sql
SELECT o.*, oi.*, bm.price, mg.item_name_key
FROM Orders o
JOIN OrderItems oi ON o.order_id = oi.order_id
JOIN BranchMenu bm ON oi.branch_menu_id = bm.branch_menu_id
JOIN MenuItems_Global mg ON bm.global_item_id = mg.item_id
WHERE o.customer_id = ?
ORDER BY o.created_at DESC;
```

### Get branch menu with categories:
```sql
SELECT mc.category_name_key, mg.item_name_key, bm.price, bm.is_available
FROM BranchMenu bm
JOIN MenuItems_Global mg ON bm.global_item_id = mg.item_id
JOIN MenuCategories mc ON mg.category_id = mc.category_id
WHERE bm.branch_id = ? AND bm.is_available = 1
ORDER BY mc.display_order, bm.display_order;
```

### Get order tracking information:
```sql
SELECT o.order_number, o.status, ot.event_type, ot.event_description, ot.timestamp
FROM Orders o
LEFT JOIN OrderTimeline ot ON o.order_id = ot.order_id
WHERE o.order_id = ?
ORDER BY ot.timestamp;
```

This documentation provides a comprehensive overview of the Luna Dine database structure, enabling efficient development and maintenance of the restaurant management system.