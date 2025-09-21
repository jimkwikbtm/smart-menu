BEGIN TRANSACTION;
CREATE TABLE IF NOT EXISTS "AdminLogs" (
	"log_id"	INTEGER,
	"user_id"	INTEGER NOT NULL,
	"action"	VARCHAR(255) NOT NULL,
	"description"	TEXT,
	"metadata"	JSON,
	"ip_address"	VARCHAR(45),
	"user_agent"	TEXT,
	"created_at"	TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	PRIMARY KEY("log_id" AUTOINCREMENT),
	FOREIGN KEY("user_id") REFERENCES "Users"("user_id") ON DELETE CASCADE
);
CREATE TABLE IF NOT EXISTS "AdminSessions" (
	"session_id"	VARCHAR(64),
	"user_id"	INTEGER NOT NULL,
	"expires_at"	TIMESTAMP NOT NULL,
	"created_at"	TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	PRIMARY KEY("session_id"),
	FOREIGN KEY("user_id") REFERENCES "Users"("user_id") ON DELETE CASCADE
);
CREATE TABLE IF NOT EXISTS "BranchBanners" (
	"banner_id"	INTEGER,
	"branch_id"	INTEGER NOT NULL,
	"title_translation_key"	VARCHAR(255) NOT NULL,
	"image_url"	VARCHAR(255) NOT NULL,
	"target_url"	VARCHAR(255),
	"background_color"	VARCHAR(7) DEFAULT '#FFFFFF',
	"text_color"	VARCHAR(7) DEFAULT '#000000',
	"banner_type"	VARCHAR(20) DEFAULT 'promotion',
	"start_date"	TIMESTAMP,
	"end_date"	TIMESTAMP,
	"is_active"	BOOLEAN DEFAULT true,
	"display_order"	INTEGER DEFAULT 0,
	"created_at"	TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	"updated_at"	TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	PRIMARY KEY("banner_id" AUTOINCREMENT),
	FOREIGN KEY("branch_id") REFERENCES "Branches"("branch_id") ON DELETE CASCADE
);
CREATE TABLE IF NOT EXISTS "BranchMenu" (
	"branch_menu_id"	INTEGER,
	"branch_id"	INTEGER NOT NULL,
	"item_id"	INTEGER NOT NULL,
	"price"	DECIMAL(10, 2) NOT NULL,
	"is_available"	BOOLEAN DEFAULT true,
	"is_featured"	BOOLEAN DEFAULT false,
	"preparation_time_override"	INTEGER,
	"available_start_time"	TIME,
	"available_end_time"	TIME,
	"display_order"	INTEGER DEFAULT 0,
	"customization_options"	JSON,
	"inventory_count"	INTEGER DEFAULT -1,
	"created_at"	TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	"updated_at"	TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	UNIQUE("branch_id","item_id"),
	PRIMARY KEY("branch_menu_id" AUTOINCREMENT),
	FOREIGN KEY("branch_id") REFERENCES "Branches"("branch_id") ON DELETE CASCADE,
	FOREIGN KEY("item_id") REFERENCES "MenuItems_Global"("item_id")
);
CREATE TABLE IF NOT EXISTS "BranchSettings" (
	"branch_id"	INTEGER,
	"display_name_translation_key"	VARCHAR(255) NOT NULL,
	"logo_url"	VARCHAR(255),
	"cover_photo_url"	VARCHAR(255),
	"phone_number"	VARCHAR(20),
	"vat_percentage"	DECIMAL(5, 2) DEFAULT 0.00,
	"service_charge_percentage"	DECIMAL(5, 2) DEFAULT 0.00,
	"delivery_fee_config"	JSON,
	"operating_hours"	JSON,
	"minimum_order_amount"	DECIMAL(10, 2) DEFAULT 0.00,
	"delivery_radius_km"	DECIMAL(5, 2),
	PRIMARY KEY("branch_id"),
	FOREIGN KEY("branch_id") REFERENCES "Branches"("branch_id") ON DELETE CASCADE
);
CREATE TABLE IF NOT EXISTS "BranchUsers" (
	"branch_user_id"	INTEGER,
	"branch_id"	INTEGER NOT NULL,
	"user_id"	INTEGER NOT NULL,
	"assigned_at"	TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	"assigned_by"	INTEGER,
	"is_active"	BOOLEAN DEFAULT 1,
	"created_at"	TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	"updated_at"	TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	UNIQUE("branch_id","user_id"),
	PRIMARY KEY("branch_user_id" AUTOINCREMENT),
	FOREIGN KEY("assigned_by") REFERENCES "Users"("user_id"),
	FOREIGN KEY("branch_id") REFERENCES "Branches"("branch_id") ON DELETE CASCADE,
	FOREIGN KEY("user_id") REFERENCES "Users"("user_id") ON DELETE CASCADE
);
CREATE TABLE IF NOT EXISTS "Branches" (
	"branch_id"	INTEGER,
	"internal_name"	VARCHAR(100) NOT NULL,
	"address"	TEXT NOT NULL,
	"latitude"	DECIMAL(10, 8),
	"longitude"	DECIMAL(11, 8),
	"timezone"	VARCHAR(50) DEFAULT 'UTC',
	"contact_email"	VARCHAR(100),
	"is_active"	BOOLEAN DEFAULT true,
	"created_at"	TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	"updated_at"	TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	"created_by"	INTEGER,
	"updated_by"	INTEGER,
	PRIMARY KEY("branch_id" AUTOINCREMENT),
	FOREIGN KEY("created_by") REFERENCES "Users"("user_id"),
	FOREIGN KEY("updated_by") REFERENCES "Users"("user_id")
);
CREATE TABLE IF NOT EXISTS "DeliveryTracking" (
	"tracking_id"	INTEGER,
	"order_id"	INTEGER NOT NULL,
	"driver_name"	VARCHAR(100),
	"driver_phone"	VARCHAR(20),
	"driver_vehicle"	TEXT,
	"driver_vehicle_plate"	VARCHAR(20),
	"current_latitude"	DECIMAL(10, 8),
	"current_longitude"	DECIMAL(11, 8),
	"estimated_arrival_time"	TIMESTAMP,
	"pickup_time"	TIMESTAMP,
	"delivery_status"	TEXT DEFAULT 'assigned' CHECK("delivery_status" IN ('assigned', 'picked_up', 'in_transit', 'arriving', 'arrived', 'delivered', 'failed')),
	"driver_rating"	INTEGER CHECK("driver_rating" >= 1 AND "driver_rating" <= 5),
	"driver_notes"	TEXT,
	"created_at"	TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	"updated_at"	TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	PRIMARY KEY("tracking_id" AUTOINCREMENT),
	FOREIGN KEY("order_id") REFERENCES "Orders"("order_id") ON DELETE CASCADE
);
CREATE TABLE IF NOT EXISTS "ErrorLogs" (
	"log_id"	INTEGER,
	"level"	VARCHAR(20) NOT NULL,
	"message"	TEXT NOT NULL,
	"context"	TEXT,
	"file_path"	VARCHAR(500),
	"line_number"	INTEGER,
	"user_id"	INTEGER,
	"ip_address"	VARCHAR(45),
	"user_agent"	TEXT,
	"request_uri"	VARCHAR(1000),
	"request_method"	VARCHAR(10),
	"session_id"	VARCHAR(255),
	"created_at"	DATETIME DEFAULT CURRENT_TIMESTAMP,
	PRIMARY KEY("log_id" AUTOINCREMENT),
	FOREIGN KEY("user_id") REFERENCES "Users"("user_id")
);
CREATE TABLE IF NOT EXISTS "FeatureFlags" (
	"flag_id"	INTEGER,
	"flag_key"	VARCHAR(255) NOT NULL UNIQUE,
	"flag_name"	VARCHAR(255) NOT NULL,
	"description"	TEXT,
	"is_enabled"	BOOLEAN DEFAULT false,
	"target_audience"	TEXT DEFAULT 'all' CHECK("target_audience" IN ('all', 'admin', 'staff', 'custom')),
	"target_roles"	JSON,
	"target_branches"	JSON,
	"start_date"	TIMESTAMP,
	"end_date"	TIMESTAMP,
	"created_at"	TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	"updated_at"	TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	"created_by"	INTEGER,
	"updated_by"	INTEGER,
	PRIMARY KEY("flag_id" AUTOINCREMENT),
	FOREIGN KEY("created_by") REFERENCES "Users"("user_id"),
	FOREIGN KEY("updated_by") REFERENCES "Users"("user_id")
);
CREATE TABLE IF NOT EXISTS "Feedback" (
	"feedback_id"	INTEGER,
	"order_id"	INTEGER,
	"branch_id"	INTEGER NOT NULL,
	"rating"	INTEGER NOT NULL CHECK("rating" >= 1 AND "rating" <= 5),
	"feedback_text"	TEXT,
	"service_quality_rating"	INTEGER CHECK("service_quality_rating" >= 1 AND "service_quality_rating" <= 5),
	"food_quality_rating"	INTEGER CHECK("food_quality_rating" >= 1 AND "food_quality_rating" <= 5),
	"ambiance_rating"	INTEGER CHECK("ambiance_rating" >= 1 AND "ambiance_rating" <= 5),
	"value_for_money_rating"	INTEGER CHECK("value_for_money_rating" >= 1 AND "value_for_money_rating" <= 5),
	"would_recommend"	BOOLEAN,
	"tags"	JSON,
	"response_text"	TEXT,
	"responded_by_user_id"	INTEGER,
	"responded_at"	TIMESTAMP,
	"status"	TEXT NOT NULL DEFAULT 'PENDING' CHECK("status" IN ('PENDING', 'REVIEWED', 'RESPONDED', 'RESOLVED')),
	"created_at"	TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	"updated_at"	TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	PRIMARY KEY("feedback_id" AUTOINCREMENT),
	FOREIGN KEY("branch_id") REFERENCES "Branches"("branch_id"),
	FOREIGN KEY("order_id") REFERENCES "Orders"("order_id"),
	FOREIGN KEY("responded_by_user_id") REFERENCES "Users"("user_id")
);
CREATE TABLE IF NOT EXISTS "MenuCategories" (
	"category_id"	INTEGER,
	"name_translation_key"	VARCHAR(255) NOT NULL,
	"description_translation_key"	VARCHAR(255),
	"display_order"	INTEGER DEFAULT 0,
	"image_url"	VARCHAR(255),
	"is_active"	BOOLEAN DEFAULT true,
	"parent_category_id"	INTEGER,
	"created_at"	TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	"updated_at"	TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	"created_by"	INTEGER,
	"updated_by"	INTEGER,
	PRIMARY KEY("category_id" AUTOINCREMENT),
	FOREIGN KEY("created_by") REFERENCES "Users"("user_id"),
	FOREIGN KEY("parent_category_id") REFERENCES "MenuCategories"("category_id"),
	FOREIGN KEY("updated_by") REFERENCES "Users"("user_id")
);
CREATE TABLE IF NOT EXISTS "MenuItems_Global" (
	"item_id"	INTEGER,
	"category_id"	INTEGER NOT NULL,
	"sku"	VARCHAR(50) NOT NULL UNIQUE,
	"name_translation_key"	VARCHAR(255) NOT NULL,
	"description_translation_key"	VARCHAR(255),
	"image_url"	VARCHAR(255),
	"tags"	JSON,
	"allergen_information"	JSON,
	"preparation_time_minutes"	INTEGER,
	"dietary_restrictions"	JSON,
	"is_active"	BOOLEAN DEFAULT true,
	"created_at"	TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	"updated_at"	TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	"created_by"	INTEGER,
	"updated_by"	INTEGER,
	PRIMARY KEY("item_id" AUTOINCREMENT),
	FOREIGN KEY("category_id") REFERENCES "MenuCategories"("category_id"),
	FOREIGN KEY("created_by") REFERENCES "Users"("user_id"),
	FOREIGN KEY("updated_by") REFERENCES "Users"("user_id")
);
CREATE TABLE IF NOT EXISTS "NotificationTemplates" (
	"template_id"	INTEGER,
	"name"	TEXT NOT NULL,
	"category"	TEXT NOT NULL,
	"title"	TEXT NOT NULL,
	"message"	TEXT NOT NULL,
	"type"	TEXT DEFAULT 'info' CHECK("type" IN ('info', 'warning', 'success', 'error')),
	"variables"	JSON,
	"usage_count"	INTEGER DEFAULT 0,
	"created_at"	TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	"updated_at"	TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	"created_by"	INTEGER,
	PRIMARY KEY("template_id" AUTOINCREMENT),
	FOREIGN KEY("created_by") REFERENCES "Users"("user_id")
);
CREATE TABLE IF NOT EXISTS "Notifications" (
	"notification_id"	INTEGER,
	"user_id"	INTEGER NOT NULL,
	"title"	VARCHAR(255) NOT NULL,
	"message"	TEXT NOT NULL,
	"data"	JSON,
	"type"	TEXT DEFAULT 'info' CHECK("type" IN ('info', 'warning', 'success', 'error')),
	"is_read"	BOOLEAN DEFAULT false,
	"created_at"	TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	"updated_at"	TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	PRIMARY KEY("notification_id" AUTOINCREMENT),
	FOREIGN KEY("user_id") REFERENCES "Users"("user_id") ON DELETE CASCADE
);
CREATE TABLE IF NOT EXISTS "OrderItems" (
	"order_item_id"	INTEGER,
	"order_id"	INTEGER NOT NULL,
	"branch_menu_id"	INTEGER NOT NULL,
	"quantity"	INTEGER NOT NULL,
	"price_at_order"	DECIMAL(10, 2) NOT NULL,
	"selected_modifiers"	JSON,
	"notes"	TEXT,
	"status"	TEXT DEFAULT 'pending',
	"preparation_start_time"	TIMESTAMP,
	"preparation_end_time"	TIMESTAMP,
	"customizations"	JSON,
	"sequence_number"	INTEGER,
	"item_total"	DECIMAL(10, 2) NOT NULL,
	"created_at"	TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	"updated_at"	TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	PRIMARY KEY("order_item_id" AUTOINCREMENT),
	FOREIGN KEY("branch_menu_id") REFERENCES "BranchMenu"("branch_menu_id"),
	FOREIGN KEY("order_id") REFERENCES "Orders"("order_id") ON DELETE CASCADE
);
CREATE TABLE IF NOT EXISTS "OrderNotifications" (
	"notification_id"	INTEGER,
	"order_id"	INTEGER NOT NULL,
	"notification_type"	TEXT NOT NULL CHECK("notification_type" IN ('STATUS_UPDATE', 'DELAY_ALERT', 'DRIVER_ASSIGNED', 'DRIVER_ARRIVING', 'ORDER_READY', 'PICKUP_READY', 'PAYMENT_CONFIRMED', 'FEEDBACK_REQUEST', 'PROMOTIONAL', 'SERVICE_REQUEST', 'BILL_READY')),
	"notification_title"	TEXT NOT NULL,
	"notification_message"	TEXT NOT NULL,
	"notification_data"	JSON,
	"delivery_method"	TEXT DEFAULT 'app' CHECK("delivery_method" IN ('app', 'sms', 'email', 'push')),
	"status"	TEXT DEFAULT 'pending' CHECK("status" IN ('pending', 'sent', 'delivered', 'read', 'failed')),
	"scheduled_time"	TIMESTAMP,
	"sent_time"	TIMESTAMP,
	"delivered_time"	TIMESTAMP,
	"read_time"	TIMESTAMP,
	"created_at"	TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	"updated_at"	TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	PRIMARY KEY("notification_id" AUTOINCREMENT),
	FOREIGN KEY("order_id") REFERENCES "Orders"("order_id") ON DELETE CASCADE
);
CREATE TABLE IF NOT EXISTS "OrderTimeline" (
	"timeline_id"	INTEGER,
	"order_id"	INTEGER NOT NULL,
	"event_type"	TEXT NOT NULL CHECK("event_type" IN ('ORDER_PLACED', 'ORDER_CONFIRMED', 'ORDER_PREPARING', 'ORDER_READY', 'TABLE_ASSIGNED', 'SERVER_ASSIGNED', 'FOOD_SERVING', 'DINING_STARTED', 'BILL_REQUESTED', 'BILL_PAID', 'ORDER_COMPLETED', 'ORDER_CANCELLED', 'DRIVER_ASSIGNED', 'DRIVER_PICKED_UP', 'DRIVER_IN_TRANSIT', 'DRIVER_ARRIVING', 'DRIVER_ARRIVED', 'ORDER_DELIVERED', 'PICKUP_READY', 'PICKUP_COMPLETED', 'PAYMENT_RECEIVED', 'PAYMENT_FAILED', 'DELAY_NOTIFICATION', 'STAFF_NOTE')),
	"event_description"	TEXT,
	"timestamp"	TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	"staff_id"	INTEGER,
	"metadata"	JSON,
	"created_at"	TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	"updated_at"	TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	PRIMARY KEY("timeline_id" AUTOINCREMENT),
	FOREIGN KEY("order_id") REFERENCES "Orders"("order_id") ON DELETE CASCADE,
	FOREIGN KEY("staff_id") REFERENCES "Users"("user_id")
);
CREATE TABLE IF NOT EXISTS "OrderTrackingAnalytics" (
	"analytics_id"	INTEGER,
	"order_id"	INTEGER NOT NULL,
	"tracking_session_id"	VARCHAR(100),
	"customer_device_type"	TEXT,
	"customer_browser_info"	TEXT,
	"page_load_time"	INTEGER,
	"time_to_first_update"	INTEGER,
	"total_tracking_time"	INTEGER,
	"interaction_events"	JSON,
	"notification_views"	INTEGER DEFAULT 0,
	"notification_clicks"	INTEGER DEFAULT 0,
	"map_views"	INTEGER DEFAULT 0,
	"driver_contacts"	INTEGER DEFAULT 0,
	"created_at"	TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	PRIMARY KEY("analytics_id" AUTOINCREMENT),
	FOREIGN KEY("order_id") REFERENCES "Orders"("order_id") ON DELETE CASCADE
);
CREATE TABLE IF NOT EXISTS "Orders" (
	"order_id"	INTEGER,
	"order_uid"	VARCHAR(20) NOT NULL UNIQUE,
	"branch_id"	INTEGER NOT NULL,
	"table_id"	INTEGER,
	"promo_id"	INTEGER,
	"customer_id"	INTEGER,
	"order_type"	TEXT NOT NULL CHECK("order_type" IN ('dine-in', 'takeaway', 'delivery')),
	"status"	TEXT NOT NULL CHECK("status" IN ('pending', 'confirmed', 'preparing', 'ready', 'completed', 'cancelled')),
	"items_subtotal"	DECIMAL(10, 2) NOT NULL,
	"discount_amount"	DECIMAL(10, 2) DEFAULT 0.00,
	"subtotal_after_discount"	DECIMAL(10, 2) NOT NULL,
	"service_charge_amount"	DECIMAL(10, 2) NOT NULL,
	"vat_amount"	DECIMAL(10, 2) NOT NULL,
	"delivery_charge_amount"	DECIMAL(10, 2) DEFAULT 0.00,
	"final_amount"	DECIMAL(10, 2) NOT NULL,
	"payment_status"	TEXT NOT NULL CHECK("payment_status" IN ('unpaid', 'paid', 'refunded')),
	"payment_method"	TEXT,
	"delivery_address"	TEXT,
	"estimated_delivery_time"	TIMESTAMP,
	"actual_delivery_time"	TIMESTAMP,
	"pickup_time"	TIMESTAMP,
	"staff_id"	INTEGER,
	"notes"	TEXT,
	"order_source"	TEXT DEFAULT 'qr_code',
	"applied_rates_snapshot"	JSON,
	"created_at"	TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	"updated_at"	TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	"estimated_preparation_time"	INTEGER,
	"actual_preparation_time"	TIMESTAMP,
	"staff_notes"	TEXT,
	"customer_phone"	VARCHAR(20),
	"order_priority"	TEXT DEFAULT 'normal' CHECK("order_priority" IN ('low', 'normal', 'high', 'urgent')),
	PRIMARY KEY("order_id" AUTOINCREMENT),
	FOREIGN KEY("branch_id") REFERENCES "Branches"("branch_id"),
	FOREIGN KEY("promo_id") REFERENCES "Promotions"("promo_id"),
	FOREIGN KEY("staff_id") REFERENCES "Users"("user_id"),
	FOREIGN KEY("table_id") REFERENCES "Tables"("table_id")
);
CREATE TABLE IF NOT EXISTS "PickupQueue" (
	"queue_id"	INTEGER,
	"order_id"	INTEGER NOT NULL,
	"pickup_counter"	INTEGER DEFAULT 1,
	"queue_position"	INTEGER,
	"estimated_ready_time"	TIMESTAMP,
	"actual_ready_time"	TIMESTAMP,
	"pickup_time"	TIMESTAMP,
	"pickup_status"	TEXT DEFAULT 'waiting' CHECK("pickup_status" IN ('waiting', 'preparing', 'ready', 'awaiting_pickup', 'picked_up', 'expired')),
	"customer_notified"	BOOLEAN DEFAULT false,
	"notification_method"	TEXT DEFAULT 'app' CHECK("notification_method" IN ('app', 'sms', 'call', 'none')),
	"pickup_instructions"	TEXT,
	"created_at"	TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	"updated_at"	TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	PRIMARY KEY("queue_id" AUTOINCREMENT),
	FOREIGN KEY("order_id") REFERENCES "Orders"("order_id") ON DELETE CASCADE
);
CREATE TABLE IF NOT EXISTS "Promotion_Branches" (
	"promo_id"	INTEGER NOT NULL,
	"branch_id"	INTEGER NOT NULL,
	PRIMARY KEY("promo_id","branch_id"),
	FOREIGN KEY("branch_id") REFERENCES "Branches"("branch_id") ON DELETE CASCADE,
	FOREIGN KEY("promo_id") REFERENCES "Promotions"("promo_id") ON DELETE CASCADE
);
CREATE TABLE IF NOT EXISTS "Promotion_Items" (
	"promo_id"	INTEGER NOT NULL,
	"item_id"	INTEGER NOT NULL,
	PRIMARY KEY("promo_id","item_id"),
	FOREIGN KEY("item_id") REFERENCES "MenuItems_Global"("item_id") ON DELETE CASCADE,
	FOREIGN KEY("promo_id") REFERENCES "Promotions"("promo_id") ON DELETE CASCADE
);
CREATE TABLE IF NOT EXISTS "Promotions" (
	"promo_id"	INTEGER,
	"code"	VARCHAR(50) UNIQUE,
	"description_translation_key"	VARCHAR(255) NOT NULL,
	"type"	TEXT NOT NULL CHECK("type" IN ('PERCENTAGE', 'FIXED_AMOUNT')),
	"value"	DECIMAL(10, 2) NOT NULL,
	"min_order_value"	DECIMAL(10, 2),
	"max_discount_amount"	DECIMAL(10, 2),
	"usage_limit"	INTEGER,
	"usage_count"	INTEGER DEFAULT 0,
	"start_date"	TIMESTAMP,
	"end_date"	TIMESTAMP,
	"is_active"	BOOLEAN DEFAULT true,
	"auto_apply"	BOOLEAN DEFAULT false,
	"is_customer_visible"	BOOLEAN DEFAULT true,
	"created_at"	TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	"updated_at"	TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	"created_by"	INTEGER,
	"updated_by"	INTEGER,
	PRIMARY KEY("promo_id" AUTOINCREMENT),
	FOREIGN KEY("created_by") REFERENCES "Users"("user_id"),
	FOREIGN KEY("updated_by") REFERENCES "Users"("user_id")
);
CREATE TABLE IF NOT EXISTS "RestaurantDetails" (
	"restaurant_id"	INTEGER,
	"name"	VARCHAR(100) NOT NULL,
	"legal_name"	VARCHAR(100),
	"description"	TEXT,
	"tagline"	VARCHAR(255),
	"logo_url"	VARCHAR(255),
	"cover_photo_url"	VARCHAR(255),
	"website_url"	VARCHAR(255),
	"support_email"	VARCHAR(100),
	"support_phone"	VARCHAR(20),
	"tax_id"	VARCHAR(50),
	"currency_code"	VARCHAR(3) DEFAULT 'BDT',
	"timezone"	VARCHAR(50) DEFAULT 'Asia/Dhaka',
	"social_media_links"	JSON,
	"business_hours"	JSON,
	"address"	TEXT,
	"latitude"	DECIMAL(10, 8),
	"longitude"	DECIMAL(11, 8),
	"is_active"	BOOLEAN DEFAULT true,
	"created_at"	TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	"updated_at"	TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	PRIMARY KEY("restaurant_id" AUTOINCREMENT)
);
CREATE TABLE IF NOT EXISTS "Roles" (
	"role_id"	INTEGER,
	"role_name"	VARCHAR(50) NOT NULL UNIQUE,
	"permissions"	JSON,
	"description"	TEXT,
	"hierarchy_level"	INTEGER DEFAULT 0,
	"created_at"	TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	"updated_at"	TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	"is_active"	BOOLEAN DEFAULT 1,
	PRIMARY KEY("role_id" AUTOINCREMENT)
);
CREATE TABLE IF NOT EXISTS "ScheduledNotifications" (
	"schedule_id"	INTEGER,
	"recipient_type"	TEXT NOT NULL CHECK("recipient_type" IN ('all', 'branch', 'role', 'user')),
	"recipient_id"	INTEGER,
	"template_id"	INTEGER,
	"title"	TEXT,
	"message"	TEXT,
	"type"	TEXT DEFAULT 'info' CHECK("type" IN ('info', 'warning', 'success', 'error')),
	"data"	JSON,
	"variables"	JSON,
	"scheduled_at"	TIMESTAMP NOT NULL,
	"status"	TEXT DEFAULT 'PENDING' CHECK("status" IN ('PENDING', 'SENT', 'FAILED')),
	"sent_at"	TIMESTAMP,
	"result_data"	JSON,
	"error_message"	TEXT,
	"created_at"	TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	PRIMARY KEY("schedule_id" AUTOINCREMENT),
	FOREIGN KEY("template_id") REFERENCES "NotificationTemplates"("template_id")
);
CREATE TABLE IF NOT EXISTS "ServiceRequests" (
	"request_id"	INTEGER,
	"branch_id"	INTEGER NOT NULL,
	"table_id"	INTEGER NOT NULL,
	"request_type"	TEXT NOT NULL CHECK("request_type" IN ('CALL_WAITER', 'REQUEST_BILL', 'CLEANING_ASSISTANCE', 'OTHER')),
	"status"	TEXT NOT NULL CHECK("status" IN ('PENDING', 'ACKNOWLEDGED', 'RESOLVED', 'CANCELLED')),
	"requested_at"	TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	"acknowledged_at"	TIMESTAMP,
	"resolved_at"	TIMESTAMP,
	"resolved_by_user_id"	INTEGER,
	"created_at"	TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	"updated_at"	TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	PRIMARY KEY("request_id" AUTOINCREMENT),
	FOREIGN KEY("branch_id") REFERENCES "Branches"("branch_id"),
	FOREIGN KEY("resolved_by_user_id") REFERENCES "Users"("user_id"),
	FOREIGN KEY("table_id") REFERENCES "Tables"("table_id")
);
CREATE TABLE IF NOT EXISTS "Settings" (
	"setting_id"	INTEGER,
	"setting_key"	VARCHAR(255) NOT NULL UNIQUE,
	"setting_value"	TEXT,
	"setting_type"	VARCHAR(50) DEFAULT 'string' CHECK("setting_type" IN ('string', 'integer', 'boolean', 'json', 'text')),
	"description"	TEXT,
	"category"	VARCHAR(100) DEFAULT 'general',
	"is_public"	BOOLEAN DEFAULT false,
	"created_at"	TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	"updated_at"	TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	"created_by"	INTEGER,
	"updated_by"	INTEGER,
	PRIMARY KEY("setting_id" AUTOINCREMENT),
	FOREIGN KEY("created_by") REFERENCES "Users"("user_id"),
	FOREIGN KEY("updated_by") REFERENCES "Users"("user_id")
);
CREATE TABLE IF NOT EXISTS "TableServiceStatus" (
	"service_id"	INTEGER,
	"order_id"	INTEGER NOT NULL,
	"table_id"	INTEGER NOT NULL,
	"server_id"	INTEGER,
	"service_status"	TEXT DEFAULT 'assigned' CHECK("service_status" IN ('assigned', 'preparing', 'serving', 'dining', 'billing', 'completed')),
	"estimated_serving_time"	TIMESTAMP,
	"actual_serving_time"	TIMESTAMP,
	"dining_start_time"	TIMESTAMP,
	"dining_end_time"	TIMESTAMP,
	"service_requests_count"	INTEGER DEFAULT 0,
	"service_notes"	TEXT,
	"created_at"	TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	"updated_at"	TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	PRIMARY KEY("service_id" AUTOINCREMENT),
	FOREIGN KEY("order_id") REFERENCES "Orders"("order_id") ON DELETE CASCADE,
	FOREIGN KEY("server_id") REFERENCES "Users"("user_id"),
	FOREIGN KEY("table_id") REFERENCES "Tables"("table_id")
);
CREATE TABLE IF NOT EXISTS "Tables" (
	"table_id"	INTEGER,
	"branch_id"	INTEGER NOT NULL,
	"table_identifier"	VARCHAR(50) NOT NULL,
	"qr_code_hash"	VARCHAR(255) NOT NULL UNIQUE,
	"capacity"	INTEGER DEFAULT 4,
	"table_type"	VARCHAR(20) DEFAULT 'table',
	"is_active"	BOOLEAN DEFAULT true,
	"location_description"	VARCHAR(255),
	"created_at"	TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	"updated_at"	TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	"created_by"	INTEGER,
	"updated_by"	INTEGER,
	"table_number"	VARCHAR(20),
	PRIMARY KEY("table_id" AUTOINCREMENT),
	FOREIGN KEY("branch_id") REFERENCES "Branches"("branch_id") ON DELETE CASCADE,
	FOREIGN KEY("created_by") REFERENCES "Users"("user_id"),
	FOREIGN KEY("updated_by") REFERENCES "Users"("user_id")
);
CREATE TABLE IF NOT EXISTS "Translations" (
	"translation_key"	VARCHAR(255) NOT NULL,
	"language_code"	VARCHAR(10) NOT NULL,
	"translation_text"	TEXT NOT NULL,
	"created_at"	TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	"updated_at"	TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	PRIMARY KEY("translation_key","language_code")
);
CREATE TABLE IF NOT EXISTS "UserDevices" (
	"device_id"	INTEGER,
	"user_id"	INTEGER NOT NULL,
	"device_token"	TEXT NOT NULL,
	"platform"	TEXT NOT NULL CHECK("platform" IN ('android', 'ios', 'web')),
	"app_version"	TEXT,
	"created_at"	TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	"last_active"	TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	"is_active"	BOOLEAN DEFAULT true,
	PRIMARY KEY("device_id" AUTOINCREMENT),
	FOREIGN KEY("user_id") REFERENCES "Users"("user_id") ON DELETE CASCADE
);
CREATE TABLE IF NOT EXISTS "Users" (
	"user_id"	INTEGER,
	"role_id"	INTEGER NOT NULL,
	"branch_id"	INTEGER,
	"full_name"	VARCHAR(100) NOT NULL,
	"username"	VARCHAR(50) NOT NULL UNIQUE,
	"password_hash"	VARCHAR(255) NOT NULL,
	"email"	VARCHAR(100) UNIQUE,
	"preferred_language"	VARCHAR(10) DEFAULT 'en-US',
	"last_login"	TIMESTAMP,
	"password_reset_token"	VARCHAR(255),
	"password_reset_expires"	TIMESTAMP,
	"failed_login_attempts"	INTEGER DEFAULT 0,
	"account_locked_until"	TIMESTAMP,
	"is_active"	BOOLEAN DEFAULT true,
	"created_at"	TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	"updated_at"	TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	PRIMARY KEY("user_id" AUTOINCREMENT),
	FOREIGN KEY("branch_id") REFERENCES "Branches"("branch_id"),
	FOREIGN KEY("role_id") REFERENCES "Roles"("role_id")
);
INSERT INTO "AdminLogs" VALUES (904,1,'LOGOUT','User logged out','[]','::1','Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36','2025-09-20 15:57:32');
INSERT INTO "BranchBanners" VALUES (1,1,'banner_new_menu','/assets/images/banners/fastfood-new-menu.jpg','/menu','#FF5733','#FFFFFF','promotion','2025-09-19 16:10:15','2025-10-04 16:10:15',1,1,'2025-09-19 14:10:15','2025-09-19 14:10:15');
INSERT INTO "BranchBanners" VALUES (2,1,'banner_weekend_special','/assets/images/banners/fastfood-weekend.jpg','/promotions','#33FF57','#000000','promotion','2025-09-19 16:10:15','2025-09-26 16:10:15',1,2,'2025-09-19 14:10:15','2025-09-19 14:10:15');
INSERT INTO "BranchBanners" VALUES (3,2,'banner_new_menu','/assets/images/banners/desi-new-menu.jpg','/menu','#FF5733','#FFFFFF','promotion','2025-09-19 16:10:15','2025-10-04 16:10:15',1,1,'2025-09-19 14:10:15','2025-09-19 14:10:15');
INSERT INTO "BranchBanners" VALUES (4,2,'banner_weekend_special','/assets/images/banners/desi-weekend.jpg','/promotions','#33FF57','#000000','promotion','2025-09-19 16:10:15','2025-09-26 16:10:15',1,2,'2025-09-19 14:10:15','2025-09-19 14:10:15');
INSERT INTO "BranchBanners" VALUES (5,3,'banner_new_menu','/assets/images/banners/chinese-new-menu.jpg','/menu','#FF5733','#FFFFFF','promotion','2025-09-19 16:10:15','2025-10-04 16:10:15',1,1,'2025-09-19 14:10:15','2025-09-19 14:10:15');
INSERT INTO "BranchBanners" VALUES (6,3,'banner_weekend_special','/assets/images/banners/chinese-weekend.jpg','/promotions','#33FF57','#000000','promotion','2025-09-19 16:10:15','2025-09-26 16:10:15',1,2,'2025-09-19 14:10:15','2025-09-19 14:10:15');
INSERT INTO "BranchBanners" VALUES (7,4,'banner_new_menu','/assets/images/banners/indian-new-menu.jpg','/menu','#FF5733','#FFFFFF','promotion','2025-09-19 16:10:15','2025-10-04 16:10:15',1,1,'2025-09-19 14:10:15','2025-09-19 14:10:15');
INSERT INTO "BranchBanners" VALUES (8,4,'banner_weekend_special','/assets/images/banners/indian-weekend.jpg','/promotions','#33FF57','#000000','promotion','2025-09-19 16:10:15','2025-09-26 16:10:15',1,2,'2025-09-19 14:10:15','2025-09-19 14:10:15');
INSERT INTO "BranchBanners" VALUES (9,5,'banner_new_menu','/assets/images/banners/italian-new-menu.jpg','/menu','#FF5733','#FFFFFF','promotion','2025-09-19 16:10:15','2025-10-04 16:10:15',1,1,'2025-09-19 14:10:15','2025-09-19 14:10:15');
INSERT INTO "BranchBanners" VALUES (10,5,'banner_weekend_special','/assets/images/banners/italian-weekend.jpg','/promotions','#33FF57','#000000','promotion','2025-09-19 16:10:15','2025-09-26 16:10:15',1,2,'2025-09-19 14:10:15','2025-09-19 14:10:15');
INSERT INTO "BranchBanners" VALUES (11,6,'banner_new_menu','/assets/images/banners/japanese-new-menu.jpg','/menu','#FF5733','#FFFFFF','promotion','2025-09-19 16:10:15','2025-10-04 16:10:15',1,1,'2025-09-19 14:10:15','2025-09-19 14:10:15');
INSERT INTO "BranchBanners" VALUES (12,6,'banner_weekend_special','/assets/images/banners/japanese-weekend.jpg','/promotions','#33FF57','#000000','promotion','2025-09-19 16:10:15','2025-09-26 16:10:15',1,2,'2025-09-19 14:10:15','2025-09-19 14:10:15');
INSERT INTO "BranchMenu" VALUES (1,1,1,180,1,1,NULL,NULL,NULL,1,'{"groups":[{"id":"cheese_group","name":{"en-US":"Cheese","bn-BD":"\u09aa\u09a8\u09bf\u09b0"},"type":"checkbox","required":false,"options":[{"id":"cheddar","name":{"en-US":"Cheddar Cheese","bn-BD":"\u099a\u09c7\u09a1\u09be\u09b0 \u09aa\u09a8\u09bf\u09b0"},"price_adjustment":20},{"id":"swiss","name":{"en-US":"Swiss Cheese","bn-BD":"\u09b8\u09c1\u0987\u09b8 \u09aa\u09a8\u09bf\u09b0"},"price_adjustment":20}]},{"id":"extras_group","name":{"en-US":"Extras","bn-BD":"\u0985\u09a4\u09bf\u09b0\u09bf\u0995\u09cd\u09a4"},"type":"checkbox","required":false,"options":[{"id":"bacon","name":{"en-US":"Bacon","bn-BD":"\u09ac\u09c7\u0995\u09a8"},"price_adjustment":30},{"id":"extra_patty","name":{"en-US":"Extra Patty","bn-BD":"\u0985\u09a4\u09bf\u09b0\u09bf\u0995\u09cd\u09a4 \u09aa\u09cd\u09af\u09be\u099f\u09bf"},"price_adjustment":50}]}]}',-1,'2025-09-19 14:10:13','2025-09-19 14:10:13');
INSERT INTO "BranchMenu" VALUES (2,1,2,150,1,1,NULL,NULL,NULL,2,'{"groups":[{"id":"spice_level_group","name":{"en-US":"Spice Level","bn-BD":"\u099d\u09be\u09b2"},"type":"radio","required":false,"options":[{"id":"mild","name":{"en-US":"Mild","bn-BD":"\u099d\u09be\u09b2\u09b9\u09c0\u09a8"},"price_adjustment":0},{"id":"medium","name":{"en-US":"Medium","bn-BD":"\u09ae\u09be\u099d\u09be\u09b0\u09bf \u099d\u09be\u09b2"},"price_adjustment":0},{"id":"hot","name":{"en-US":"Hot","bn-BD":"\u0996\u09c1\u09ac \u099d\u09be\u09b2"},"price_adjustment":0}]}]}',-1,'2025-09-19 14:10:13','2025-09-19 14:10:13');
INSERT INTO "BranchMenu" VALUES (3,1,3,200,1,'',NULL,NULL,NULL,3,'{"groups":[{"id":"cheese_group","name":{"en-US":"Cheese","bn-BD":"\u09aa\u09a8\u09bf\u09b0"},"type":"checkbox","required":false,"options":[{"id":"cheddar","name":{"en-US":"Cheddar Cheese","bn-BD":"\u099a\u09c7\u09a1\u09be\u09b0 \u09aa\u09a8\u09bf\u09b0"},"price_adjustment":20},{"id":"swiss","name":{"en-US":"Swiss Cheese","bn-BD":"\u09b8\u09c1\u0987\u09b8 \u09aa\u09a8\u09bf\u09b0"},"price_adjustment":20}]},{"id":"extras_group","name":{"en-US":"Extras","bn-BD":"\u0985\u09a4\u09bf\u09b0\u09bf\u0995\u09cd\u09a4"},"type":"checkbox","required":false,"options":[{"id":"bacon","name":{"en-US":"Bacon","bn-BD":"\u09ac\u09c7\u0995\u09a8"},"price_adjustment":30},{"id":"extra_patty","name":{"en-US":"Extra Patty","bn-BD":"\u0985\u09a4\u09bf\u09b0\u09bf\u0995\u09cd\u09a4 \u09aa\u09cd\u09af\u09be\u099f\u09bf"},"price_adjustment":50}]}]}',-1,'2025-09-19 14:10:13','2025-09-19 14:10:13');
INSERT INTO "BranchMenu" VALUES (4,1,4,180,1,'',NULL,NULL,NULL,4,'{"groups":[{"id":"spice_level_group","name":{"en-US":"Spice Level","bn-BD":"\u099d\u09be\u09b2"},"type":"radio","required":false,"options":[{"id":"mild","name":{"en-US":"Mild","bn-BD":"\u099d\u09be\u09b2\u09b9\u09c0\u09a8"},"price_adjustment":0},{"id":"medium","name":{"en-US":"Medium","bn-BD":"\u09ae\u09be\u099d\u09be\u09b0\u09bf \u099d\u09be\u09b2"},"price_adjustment":0},{"id":"hot","name":{"en-US":"Hot","bn-BD":"\u0996\u09c1\u09ac \u099d\u09be\u09b2"},"price_adjustment":0}]}]}',-1,'2025-09-19 14:10:13','2025-09-19 14:10:13');
INSERT INTO "BranchMenu" VALUES (5,1,5,160,1,'',NULL,NULL,NULL,5,'{"groups":[{"id":"spice_level_group","name":{"en-US":"Spice Level","bn-BD":"\u099d\u09be\u09b2"},"type":"radio","required":false,"options":[{"id":"mild","name":{"en-US":"Mild","bn-BD":"\u099d\u09be\u09b2\u09b9\u09c0\u09a8"},"price_adjustment":0},{"id":"medium","name":{"en-US":"Medium","bn-BD":"\u09ae\u09be\u099d\u09be\u09b0\u09bf \u099d\u09be\u09b2"},"price_adjustment":0},{"id":"hot","name":{"en-US":"Hot","bn-BD":"\u0996\u09c1\u09ac \u099d\u09be\u09b2"},"price_adjustment":0}]}]}',-1,'2025-09-19 14:10:13','2025-09-19 14:10:13');
INSERT INTO "BranchMenu" VALUES (6,1,6,120,1,'',NULL,NULL,NULL,6,'{"groups":[{"id":"sauce_group","name":{"en-US":"Sauce","bn-BD":"\u09b8\u09b8"},"type":"radio","required":true,"options":[{"id":"mayo","name":{"en-US":"Mayonnaise","bn-BD":"\u09ae\u09c7\u09af\u09bc\u09cb\u09a8\u09c7\u099c"},"price_adjustment":0},{"id":"garlic_mayo","name":{"en-US":"Garlic Mayo","bn-BD":"\u09b0\u09b8\u09c1\u09a8 \u09ae\u09c7\u09af\u09bc\u09cb\u09a8\u09c7\u099c"},"price_adjustment":5},{"id":"chili_sauce","name":{"en-US":"Chili Sauce","bn-BD":"\u09ae\u09b0\u09bf\u099a\u09c7\u09b0 \u09b8\u09b8"},"price_adjustment":5}]}]}',-1,'2025-09-19 14:10:13','2025-09-19 14:10:13');
INSERT INTO "BranchMenu" VALUES (7,1,7,150,1,'',NULL,NULL,NULL,7,'{"groups":[{"id":"sauce_group","name":{"en-US":"Sauce","bn-BD":"\u09b8\u09b8"},"type":"radio","required":true,"options":[{"id":"mayo","name":{"en-US":"Mayonnaise","bn-BD":"\u09ae\u09c7\u09af\u09bc\u09cb\u09a8\u09c7\u099c"},"price_adjustment":0},{"id":"garlic_mayo","name":{"en-US":"Garlic Mayo","bn-BD":"\u09b0\u09b8\u09c1\u09a8 \u09ae\u09c7\u09af\u09bc\u09cb\u09a8\u09c7\u099c"},"price_adjustment":5},{"id":"chili_sauce","name":{"en-US":"Chili Sauce","bn-BD":"\u09ae\u09b0\u09bf\u099a\u09c7\u09b0 \u09b8\u09b8"},"price_adjustment":5}]}]}',-1,'2025-09-19 14:10:13','2025-09-19 14:10:13');
INSERT INTO "BranchMenu" VALUES (8,1,8,140,1,'',NULL,NULL,NULL,8,'{"groups":[{"id":"sauce_group","name":{"en-US":"Sauce","bn-BD":"\u09b8\u09b8"},"type":"radio","required":true,"options":[{"id":"mayo","name":{"en-US":"Mayonnaise","bn-BD":"\u09ae\u09c7\u09af\u09bc\u09cb\u09a8\u09c7\u099c"},"price_adjustment":0},{"id":"garlic_mayo","name":{"en-US":"Garlic Mayo","bn-BD":"\u09b0\u09b8\u09c1\u09a8 \u09ae\u09c7\u09af\u09bc\u09cb\u09a8\u09c7\u099c"},"price_adjustment":5},{"id":"chili_sauce","name":{"en-US":"Chili Sauce","bn-BD":"\u09ae\u09b0\u09bf\u099a\u09c7\u09b0 \u09b8\u09b8"},"price_adjustment":5}]}]}',-1,'2025-09-19 14:10:13','2025-09-19 14:10:13');
INSERT INTO "BranchMenu" VALUES (9,1,9,60,1,'',NULL,NULL,NULL,9,'{"groups":[{"id":"size_group","name":{"en-US":"Size","bn-BD":"\u0986\u0995\u09be\u09b0"},"type":"radio","required":true,"options":[{"id":"small","name":{"en-US":"Small","bn-BD":"\u099b\u09cb\u099f"},"price_adjustment":0},{"id":"medium","name":{"en-US":"Medium","bn-BD":"\u09ae\u09be\u099d\u09be\u09b0\u09bf"},"price_adjustment":10},{"id":"large","name":{"en-US":"Large","bn-BD":"\u09ac\u09dc"},"price_adjustment":20}]}]}',-1,'2025-09-19 14:10:13','2025-09-19 14:10:13');
INSERT INTO "BranchMenu" VALUES (10,1,10,120,1,'',NULL,NULL,NULL,10,NULL,-1,'2025-09-19 14:10:13','2025-09-19 14:10:13');
INSERT INTO "BranchMenu" VALUES (11,1,11,80,1,'',NULL,NULL,NULL,11,NULL,-1,'2025-09-19 14:10:13','2025-09-19 14:10:13');
INSERT INTO "BranchMenu" VALUES (12,1,12,100,1,'',NULL,NULL,NULL,12,NULL,-1,'2025-09-19 14:10:13','2025-09-19 14:10:13');
INSERT INTO "BranchMenu" VALUES (13,1,13,80,1,'',NULL,NULL,NULL,13,NULL,-1,'2025-09-19 14:10:13','2025-09-19 14:10:13');
INSERT INTO "BranchMenu" VALUES (14,1,14,120,1,'',NULL,NULL,NULL,14,NULL,-1,'2025-09-19 14:10:13','2025-09-19 14:10:13');
INSERT INTO "BranchMenu" VALUES (15,1,15,140,1,'',NULL,NULL,NULL,15,NULL,-1,'2025-09-19 14:10:13','2025-09-19 14:10:13');
INSERT INTO "BranchMenu" VALUES (16,1,16,80,1,'',NULL,NULL,NULL,16,NULL,-1,'2025-09-19 14:10:13','2025-09-19 14:10:13');
INSERT INTO "BranchMenu" VALUES (17,1,17,80,1,'',NULL,NULL,NULL,17,NULL,-1,'2025-09-19 14:10:13','2025-09-19 14:10:13');
INSERT INTO "BranchMenu" VALUES (18,1,18,40,1,'',NULL,NULL,NULL,18,'{"groups":[{"id":"serving_size_group","name":{"en-US":"Serving Size","bn-BD":"\u09aa\u09b0\u09bf\u09ac\u09c7\u09b6\u09a8\u09c7\u09b0 \u0986\u0995\u09be\u09b0"},"type":"radio","required":true,"options":[{"id":"four_pieces","name":{"en-US":"4 Pieces","bn-BD":"\u09ea \u09aa\u09bf\u09b8"},"price_adjustment":0},{"id":"eight_pieces","name":{"en-US":"8 Pieces","bn-BD":"\u09ee \u09aa\u09bf\u09b8"},"price_adjustment":25},{"id":"twelve_pieces","name":{"en-US":"12 Pieces","bn-BD":"\u09e7\u09e8 \u09aa\u09bf\u09b8"},"price_adjustment":50}]}]}',-1,'2025-09-19 14:10:13','2025-09-19 14:10:13');
INSERT INTO "BranchMenu" VALUES (19,2,19,350,1,1,NULL,NULL,NULL,1,'{"groups":[{"id":"serving_size_group","name":{"en-US":"Serving Size","bn-BD":"\u09aa\u09b0\u09bf\u09ac\u09c7\u09b6\u09a8\u09c7\u09b0 \u0986\u0995\u09be\u09b0"},"type":"radio","required":true,"options":[{"id":"single","name":{"en-US":"Single","bn-BD":"\u098f\u0995 \u099c\u09a8\u09c7\u09b0"},"price_adjustment":0},{"id":"double","name":{"en-US":"Double","bn-BD":"\u09a6\u09c1\u0987 \u099c\u09a8\u09c7\u09b0"},"price_adjustment":100}]},{"id":"extras_group","name":{"en-US":"Extras","bn-BD":"\u0985\u09a4\u09bf\u09b0\u09bf\u0995\u09cd\u09a4"},"type":"checkbox","required":false,"options":[{"id":"extra_meat","name":{"en-US":"Extra Meat","bn-BD":"\u0985\u09a4\u09bf\u09b0\u09bf\u0995\u09cd\u09a4 \u09ae\u09be\u0982\u09b8"},"price_adjustment":80},{"id":"borhani","name":{"en-US":"Borhani","bn-BD":"\u09ac\u09cb\u09b0\u09b9\u09be\u09a8\u09c0"},"price_adjustment":30}]}]}',-1,'2025-09-19 14:10:13','2025-09-19 14:10:13');
INSERT INTO "BranchMenu" VALUES (20,2,20,280,1,1,NULL,NULL,NULL,2,NULL,-1,'2025-09-19 14:10:13','2025-09-19 14:10:13');
INSERT INTO "BranchMenu" VALUES (21,2,21,250,1,'',NULL,NULL,NULL,3,NULL,-1,'2025-09-19 14:10:13','2025-09-19 14:10:13');
INSERT INTO "BranchMenu" VALUES (22,2,22,320,1,'',NULL,NULL,NULL,4,NULL,-1,'2025-09-19 14:10:13','2025-09-19 14:10:13');
INSERT INTO "BranchMenu" VALUES (23,2,23,280,1,'',NULL,NULL,NULL,5,'{"groups":[{"id":"spice_level_group","name":{"en-US":"Spice Level","bn-BD":"\u099d\u09be\u09b2"},"type":"radio","required":false,"options":[{"id":"mild","name":{"en-US":"Mild","bn-BD":"\u099d\u09be\u09b2\u09b9\u09c0\u09a8"},"price_adjustment":0},{"id":"medium","name":{"en-US":"Medium","bn-BD":"\u09ae\u09be\u099d\u09be\u09b0\u09bf \u099d\u09be\u09b2"},"price_adjustment":0},{"id":"hot","name":{"en-US":"Hot","bn-BD":"\u0996\u09c1\u09ac \u099d\u09be\u09b2"},"price_adjustment":0}]}]}',-1,'2025-09-19 14:10:13','2025-09-19 14:10:13');
INSERT INTO "BranchMenu" VALUES (24,2,24,220,1,'',NULL,NULL,NULL,6,'{"groups":[{"id":"serving_size_group","name":{"en-US":"Serving Size","bn-BD":"\u09aa\u09b0\u09bf\u09ac\u09c7\u09b6\u09a8\u09c7\u09b0 \u0986\u0995\u09be\u09b0"},"type":"radio","required":true,"options":[{"id":"regular","name":{"en-US":"Regular","bn-BD":"\u09b8\u09be\u09a7\u09be\u09b0\u09a3"},"price_adjustment":0},{"id":"large","name":{"en-US":"Large","bn-BD":"\u09ac\u09dc"},"price_adjustment":40}]}]}',-1,'2025-09-19 14:10:13','2025-09-19 14:10:13');
INSERT INTO "BranchMenu" VALUES (25,2,25,180,1,'',NULL,NULL,NULL,7,'{"groups":[{"id":"serving_size_group","name":{"en-US":"Serving Size","bn-BD":"\u09aa\u09b0\u09bf\u09ac\u09c7\u09b6\u09a8\u09c7\u09b0 \u0986\u0995\u09be\u09b0"},"type":"radio","required":true,"options":[{"id":"regular","name":{"en-US":"Regular","bn-BD":"\u09b8\u09be\u09a7\u09be\u09b0\u09a3"},"price_adjustment":0},{"id":"large","name":{"en-US":"Large","bn-BD":"\u09ac\u09dc"},"price_adjustment":40}]}]}',-1,'2025-09-19 14:10:13','2025-09-19 14:10:13');
INSERT INTO "BranchMenu" VALUES (26,2,26,200,1,'',NULL,NULL,NULL,8,NULL,-1,'2025-09-19 14:10:13','2025-09-19 14:10:13');
INSERT INTO "BranchMenu" VALUES (27,2,27,240,1,'',NULL,NULL,NULL,9,NULL,-1,'2025-09-19 14:10:13','2025-09-19 14:10:13');
INSERT INTO "BranchMenu" VALUES (28,2,28,220,1,'',NULL,NULL,NULL,10,'{"groups":[{"id":"serving_size_group","name":{"en-US":"Serving Size","bn-BD":"\u09aa\u09b0\u09bf\u09ac\u09c7\u09b6\u09a8\u09c7\u09b0 \u0986\u0995\u09be\u09b0"},"type":"radio","required":true,"options":[{"id":"two_pieces","name":{"en-US":"2 Pieces","bn-BD":"\u09e8 \u09aa\u09bf\u09b8"},"price_adjustment":0},{"id":"four_pieces","name":{"en-US":"4 Pieces","bn-BD":"\u09ea \u09aa\u09bf\u09b8"},"price_adjustment":40},{"id":"six_pieces","name":{"en-US":"6 Pieces","bn-BD":"\u09ec \u09aa\u09bf\u09b8"},"price_adjustment":80}]}]}',-1,'2025-09-19 14:10:13','2025-09-19 14:10:13');
INSERT INTO "BranchMenu" VALUES (29,2,29,180,1,'',NULL,NULL,NULL,11,'{"groups":[{"id":"serving_size_group","name":{"en-US":"Serving Size","bn-BD":"\u09aa\u09b0\u09bf\u09ac\u09c7\u09b6\u09a8\u09c7\u09b0 \u0986\u0995\u09be\u09b0"},"type":"radio","required":true,"options":[{"id":"two_pieces","name":{"en-US":"2 Pieces","bn-BD":"\u09e8 \u09aa\u09bf\u09b8"},"price_adjustment":0},{"id":"four_pieces","name":{"en-US":"4 Pieces","bn-BD":"\u09ea \u09aa\u09bf\u09b8"},"price_adjustment":40},{"id":"six_pieces","name":{"en-US":"6 Pieces","bn-BD":"\u09ec \u09aa\u09bf\u09b8"},"price_adjustment":80}]}]}',-1,'2025-09-19 14:10:13','2025-09-19 14:10:13');
INSERT INTO "BranchMenu" VALUES (30,2,30,160,1,'',NULL,NULL,NULL,12,'{"groups":[{"id":"serving_size_group","name":{"en-US":"Serving Size","bn-BD":"\u09aa\u09b0\u09bf\u09ac\u09c7\u09b6\u09a8\u09c7\u09b0 \u0986\u0995\u09be\u09b0"},"type":"radio","required":true,"options":[{"id":"two_pieces","name":{"en-US":"2 Pieces","bn-BD":"\u09e8 \u09aa\u09bf\u09b8"},"price_adjustment":0},{"id":"four_pieces","name":{"en-US":"4 Pieces","bn-BD":"\u09ea \u09aa\u09bf\u09b8"},"price_adjustment":40},{"id":"six_pieces","name":{"en-US":"6 Pieces","bn-BD":"\u09ec \u09aa\u09bf\u09b8"},"price_adjustment":80}]}]}',-1,'2025-09-19 14:10:13','2025-09-19 14:10:13');
INSERT INTO "BranchMenu" VALUES (31,2,31,80,1,'',NULL,NULL,NULL,13,NULL,-1,'2025-09-19 14:10:13','2025-09-19 14:10:13');
INSERT INTO "BranchMenu" VALUES (32,2,32,60,1,'',NULL,NULL,NULL,14,NULL,-1,'2025-09-19 14:10:13','2025-09-19 14:10:13');
INSERT INTO "BranchMenu" VALUES (33,2,33,50,1,'',NULL,NULL,NULL,15,NULL,-1,'2025-09-19 14:10:14','2025-09-19 14:10:14');
INSERT INTO "BranchMenu" VALUES (34,2,34,120,1,'',NULL,NULL,NULL,16,NULL,-1,'2025-09-19 14:10:14','2025-09-19 14:10:14');
INSERT INTO "BranchMenu" VALUES (35,2,35,150,1,'',NULL,NULL,NULL,17,NULL,-1,'2025-09-19 14:10:14','2025-09-19 14:10:14');
INSERT INTO "BranchMenu" VALUES (36,2,36,180,1,'',NULL,NULL,NULL,18,NULL,-1,'2025-09-19 14:10:14','2025-09-19 14:10:14');
INSERT INTO "BranchMenu" VALUES (37,2,37,140,1,'',NULL,NULL,NULL,19,NULL,-1,'2025-09-19 14:10:14','2025-09-19 14:10:14');
INSERT INTO "BranchMenu" VALUES (38,2,38,30,1,'',NULL,NULL,NULL,20,'{"groups":[{"id":"serving_size_group","name":{"en-US":"Serving Size","bn-BD":"\u09aa\u09b0\u09bf\u09ac\u09c7\u09b6\u09a8\u09c7\u09b0 \u0986\u0995\u09be\u09b0"},"type":"radio","required":true,"options":[{"id":"regular","name":{"en-US":"Regular","bn-BD":"\u09b8\u09be\u09a7\u09be\u09b0\u09a3"},"price_adjustment":0},{"id":"large","name":{"en-US":"Large","bn-BD":"\u09ac\u09dc"},"price_adjustment":40}]},{"id":"sauce_group","name":{"en-US":"Sauce","bn-BD":"\u09b8\u09b8"},"type":"radio","required":true,"options":[{"id":"teriyaki","name":{"en-US":"Teriyaki","bn-BD":"\u099f\u09c7\u09b0\u09bf\u09af\u09bc\u09be\u0995\u09bf"},"price_adjustment":0},{"id":"garlic","name":{"en-US":"Garlic Soy","bn-BD":"\u09b0\u09b8\u09c1\u09a8 \u09b8\u09af\u09bc\u09be"},"price_adjustment":5}]}]}',-1,'2025-09-19 14:10:14','2025-09-19 14:10:14');
INSERT INTO "BranchMenu" VALUES (39,3,39,180,1,1,NULL,NULL,NULL,1,'{"groups":[{"id":"protein_group","name":{"en-US":"Protein","bn-BD":"\u09aa\u09cd\u09b0\u09cb\u099f\u09bf\u09a8"},"type":"radio","required":true,"options":[{"id":"chicken","name":{"en-US":"Chicken","bn-BD":"\u099a\u09bf\u0995\u09c7\u09a8"},"price_adjustment":0},{"id":"beef","name":{"en-US":"Beef","bn-BD":"\u09ac\u09bf\u09ab"},"price_adjustment":20},{"id":"shrimp","name":{"en-US":"Shrimp","bn-BD":"\u099a\u09bf\u0982\u09a1\u09bc\u09bf"},"price_adjustment":30}]},{"id":"spice_level_group","name":{"en-US":"Spice Level","bn-BD":"\u099d\u09be\u09b2"},"type":"radio","required":false,"options":[{"id":"mild","name":{"en-US":"Mild","bn-BD":"\u099d\u09be\u09b2\u09b9\u09c0\u09a8"},"price_adjustment":0},{"id":"medium","name":{"en-US":"Medium","bn-BD":"\u09ae\u09be\u099d\u09be\u09b0\u09bf \u099d\u09be\u09b2"},"price_adjustment":0},{"id":"hot","name":{"en-US":"Hot","bn-BD":"\u0996\u09c1\u09ac \u099d\u09be\u09b2"},"price_adjustment":0}]}]}',-1,'2025-09-19 14:10:14','2025-09-19 14:10:14');
INSERT INTO "BranchMenu" VALUES (40,3,40,120,1,'',NULL,NULL,NULL,2,NULL,-1,'2025-09-19 14:10:14','2025-09-19 14:10:14');
INSERT INTO "BranchMenu" VALUES (41,3,41,160,1,'',NULL,NULL,NULL,3,NULL,-1,'2025-09-19 14:10:14','2025-09-19 14:10:14');
INSERT INTO "BranchMenu" VALUES (42,3,42,130,1,'',NULL,NULL,NULL,4,NULL,-1,'2025-09-19 14:10:14','2025-09-19 14:10:14');
INSERT INTO "BranchMenu" VALUES (43,3,43,150,1,'',NULL,NULL,NULL,5,'{"groups":[{"id":"spice_level_group","name":{"en-US":"Spice Level","bn-BD":"\u099d\u09be\u09b2"},"type":"radio","required":false,"options":[{"id":"mild","name":{"en-US":"Mild","bn-BD":"\u099d\u09be\u09b2\u09b9\u09c0\u09a8"},"price_adjustment":0},{"id":"medium","name":{"en-US":"Medium","bn-BD":"\u09ae\u09be\u099d\u09be\u09b0\u09bf \u099d\u09be\u09b2"},"price_adjustment":0},{"id":"hot","name":{"en-US":"Hot","bn-BD":"\u0996\u09c1\u09ac \u099d\u09be\u09b2"},"price_adjustment":0}]}]}',-1,'2025-09-19 14:10:14','2025-09-19 14:10:14');
INSERT INTO "BranchMenu" VALUES (44,3,44,140,1,'',NULL,NULL,NULL,6,NULL,-1,'2025-09-19 14:10:14','2025-09-19 14:10:14');
INSERT INTO "BranchMenu" VALUES (45,3,45,160,1,'',NULL,NULL,NULL,7,NULL,-1,'2025-09-19 14:10:14','2025-09-19 14:10:14');
INSERT INTO "BranchMenu" VALUES (46,3,46,170,1,'',NULL,NULL,NULL,8,NULL,-1,'2025-09-19 14:10:14','2025-09-19 14:10:14');
INSERT INTO "BranchMenu" VALUES (47,3,47,120,1,'',NULL,NULL,NULL,9,'{"groups":[{"id":"serving_size_group","name":{"en-US":"Serving Size","bn-BD":"\u09aa\u09b0\u09bf\u09ac\u09c7\u09b6\u09a8\u09c7\u09b0 \u0986\u0995\u09be\u09b0"},"type":"radio","required":true,"options":[{"id":"small","name":{"en-US":"Small","bn-BD":"\u099b\u09cb\u099f"},"price_adjustment":0},{"id":"large","name":{"en-US":"Large","bn-BD":"\u09ac\u09dc"},"price_adjustment":20}]}]}',-1,'2025-09-19 14:10:14','2025-09-19 14:10:14');
INSERT INTO "BranchMenu" VALUES (48,3,48,120,1,'',NULL,NULL,NULL,10,NULL,-1,'2025-09-19 14:10:14','2025-09-19 14:10:14');
INSERT INTO "BranchMenu" VALUES (49,3,49,110,1,'',NULL,NULL,NULL,11,NULL,-1,'2025-09-19 14:10:14','2025-09-19 14:10:14');
INSERT INTO "BranchMenu" VALUES (50,3,50,90,1,'',NULL,NULL,NULL,12,NULL,-1,'2025-09-19 14:10:14','2025-09-19 14:10:14');
INSERT INTO "BranchMenu" VALUES (51,3,51,100,1,'',NULL,NULL,NULL,13,NULL,-1,'2025-09-19 14:10:14','2025-09-19 14:10:14');
INSERT INTO "BranchMenu" VALUES (52,3,52,140,1,'',NULL,NULL,NULL,14,NULL,-1,'2025-09-19 14:10:14','2025-09-19 14:10:14');
INSERT INTO "BranchMenu" VALUES (53,3,53,150,1,'',NULL,NULL,NULL,15,'{"groups":[{"id":"spice_level_group","name":{"en-US":"Spice Level","bn-BD":"\u099d\u09be\u09b2"},"type":"radio","required":false,"options":[{"id":"mild","name":{"en-US":"Mild","bn-BD":"\u099d\u09be\u09b2\u09b9\u09c0\u09a8"},"price_adjustment":0},{"id":"medium","name":{"en-US":"Medium","bn-BD":"\u09ae\u09be\u099d\u09be\u09b0\u09bf \u099d\u09be\u09b2"},"price_adjustment":0},{"id":"hot","name":{"en-US":"Hot","bn-BD":"\u0996\u09c1\u09ac \u099d\u09be\u09b2"},"price_adjustment":0}]}]}',-1,'2025-09-19 14:10:14','2025-09-19 14:10:14');
INSERT INTO "BranchMenu" VALUES (54,3,54,160,1,'',NULL,NULL,NULL,16,NULL,-1,'2025-09-19 14:10:14','2025-09-19 14:10:14');
INSERT INTO "BranchMenu" VALUES (55,3,55,140,1,'',NULL,NULL,NULL,17,NULL,-1,'2025-09-19 14:10:14','2025-09-19 14:10:14');
INSERT INTO "BranchMenu" VALUES (56,3,56,120,1,'',NULL,NULL,NULL,18,NULL,-1,'2025-09-19 14:10:14','2025-09-19 14:10:14');
INSERT INTO "BranchMenu" VALUES (57,3,57,130,1,'',NULL,NULL,NULL,19,NULL,-1,'2025-09-19 14:10:14','2025-09-19 14:10:14');
INSERT INTO "BranchMenu" VALUES (58,3,58,160,1,'',NULL,NULL,NULL,20,NULL,-1,'2025-09-19 14:10:14','2025-09-19 14:10:14');
INSERT INTO "BranchMenu" VALUES (59,3,59,140,1,'',NULL,NULL,NULL,21,NULL,-1,'2025-09-19 14:10:14','2025-09-19 14:10:14');
INSERT INTO "BranchMenu" VALUES (60,3,60,40,1,'',NULL,NULL,NULL,22,'{"groups":[{"id":"serving_size_group","name":{"en-US":"Serving Size","bn-BD":"\u09aa\u09b0\u09bf\u09ac\u09c7\u09b6\u09a8\u09c7\u09b0 \u0986\u0995\u09be\u09b0"},"type":"radio","required":true,"options":[{"id":"four_pieces","name":{"en-US":"4 Pieces","bn-BD":"\u09ea \u09aa\u09bf\u09b8"},"price_adjustment":0},{"id":"eight_pieces","name":{"en-US":"8 Pieces","bn-BD":"\u09ee \u09aa\u09bf\u09b8"},"price_adjustment":25},{"id":"twelve_pieces","name":{"en-US":"12 Pieces","bn-BD":"\u09e7\u09e8 \u09aa\u09bf\u09b8"},"price_adjustment":50}]}]}',-1,'2025-09-19 14:10:14','2025-09-19 14:10:14');
INSERT INTO "BranchMenu" VALUES (61,4,61,100,1,1,NULL,NULL,NULL,1,NULL,-1,'2025-09-19 14:10:14','2025-09-19 14:10:14');
INSERT INTO "BranchMenu" VALUES (62,4,62,80,1,'',NULL,NULL,NULL,2,NULL,-1,'2025-09-19 14:10:14','2025-09-19 14:10:14');
INSERT INTO "BranchMenu" VALUES (63,4,63,120,1,'',NULL,NULL,NULL,3,NULL,-1,'2025-09-19 14:10:14','2025-09-19 14:10:14');
INSERT INTO "BranchMenu" VALUES (64,4,64,140,1,'',NULL,NULL,NULL,4,NULL,-1,'2025-09-19 14:10:14','2025-09-19 14:10:14');
INSERT INTO "BranchMenu" VALUES (65,4,65,220,1,1,NULL,NULL,NULL,5,'{"groups":[{"id":"serving_size_group","name":{"en-US":"Serving Size","bn-BD":"\u09aa\u09b0\u09bf\u09ac\u09c7\u09b6\u09a8\u09c7\u09b0 \u0986\u0995\u09be\u09b0"},"type":"radio","required":true,"options":[{"id":"regular","name":{"en-US":"Regular","bn-BD":"\u09b8\u09be\u09a7\u09be\u09b0\u09a3"},"price_adjustment":0},{"id":"large","name":{"en-US":"Large","bn-BD":"\u09ac\u09dc"},"price_adjustment":50}]}]}',-1,'2025-09-19 14:10:14','2025-09-19 14:10:14');
INSERT INTO "BranchMenu" VALUES (66,4,66,240,1,'',NULL,NULL,NULL,6,NULL,-1,'2025-09-19 14:10:14','2025-09-19 14:10:14');
INSERT INTO "BranchMenu" VALUES (67,4,67,260,1,'',NULL,NULL,NULL,7,NULL,-1,'2025-09-19 14:10:14','2025-09-19 14:10:14');
INSERT INTO "BranchMenu" VALUES (68,4,68,160,1,'',NULL,NULL,NULL,8,NULL,-1,'2025-09-19 14:10:14','2025-09-19 14:10:14');
INSERT INTO "BranchMenu" VALUES (69,4,69,140,1,'',NULL,NULL,NULL,9,NULL,-1,'2025-09-19 14:10:14','2025-09-19 14:10:14');
INSERT INTO "BranchMenu" VALUES (70,4,70,180,1,'',NULL,NULL,NULL,10,NULL,-1,'2025-09-19 14:10:14','2025-09-19 14:10:14');
INSERT INTO "BranchMenu" VALUES (71,4,71,120,1,'',NULL,NULL,NULL,11,NULL,-1,'2025-09-19 14:10:14','2025-09-19 14:10:14');
INSERT INTO "BranchMenu" VALUES (72,4,72,140,1,'',NULL,NULL,NULL,12,NULL,-1,'2025-09-19 14:10:14','2025-09-19 14:10:14');
INSERT INTO "BranchMenu" VALUES (73,4,73,120,1,'',NULL,NULL,NULL,13,NULL,-1,'2025-09-19 14:10:14','2025-09-19 14:10:14');
INSERT INTO "BranchMenu" VALUES (74,4,74,140,1,'',NULL,NULL,NULL,14,NULL,-1,'2025-09-19 14:10:14','2025-09-19 14:10:14');
INSERT INTO "BranchMenu" VALUES (75,4,75,180,1,'',NULL,NULL,NULL,15,NULL,-1,'2025-09-19 14:10:14','2025-09-19 14:10:14');
INSERT INTO "BranchMenu" VALUES (76,4,76,250,1,'',NULL,NULL,NULL,16,'{"groups":[{"id":"serving_size_group","name":{"en-US":"Serving Size","bn-BD":"\u09aa\u09b0\u09bf\u09ac\u09c7\u09b6\u09a8\u09c7\u09b0 \u0986\u0995\u09be\u09b0"},"type":"radio","required":true,"options":[{"id":"quarter","name":{"en-US":"Quarter Chicken","bn-BD":"\u0995\u09cb\u09af\u09bc\u09be\u09b0\u09cd\u099f\u09be\u09b0 \u099a\u09bf\u0995\u09c7\u09a8"},"price_adjustment":0},{"id":"half","name":{"en-US":"Half Chicken","bn-BD":"\u09b9\u09be\u09ab \u099a\u09bf\u0995\u09c7\u09a8"},"price_adjustment":50},{"id":"full","name":{"en-US":"Full Chicken","bn-BD":"\u09ab\u09c1\u09b2 \u099a\u09bf\u0995\u09c7\u09a8"},"price_adjustment":100}]}]}',-1,'2025-09-19 14:10:14','2025-09-19 14:10:14');
INSERT INTO "BranchMenu" VALUES (77,4,77,140,1,'',NULL,NULL,NULL,17,NULL,-1,'2025-09-19 14:10:14','2025-09-19 14:10:14');
INSERT INTO "BranchMenu" VALUES (78,4,78,120,1,'',NULL,NULL,NULL,18,NULL,-1,'2025-09-19 14:10:14','2025-09-19 14:10:14');
INSERT INTO "BranchMenu" VALUES (79,4,79,280,1,'',NULL,NULL,NULL,19,NULL,-1,'2025-09-19 14:10:14','2025-09-19 14:10:14');
INSERT INTO "BranchMenu" VALUES (80,4,80,100,1,'',NULL,NULL,NULL,20,NULL,-1,'2025-09-19 14:10:14','2025-09-19 14:10:14');
INSERT INTO "BranchMenu" VALUES (81,4,81,120,1,'',NULL,NULL,NULL,21,NULL,-1,'2025-09-19 14:10:14','2025-09-19 14:10:14');
INSERT INTO "BranchMenu" VALUES (82,4,82,60,1,'',NULL,NULL,NULL,22,NULL,-1,'2025-09-19 14:10:14','2025-09-19 14:10:14');
INSERT INTO "BranchMenu" VALUES (83,4,83,120,1,'',NULL,NULL,NULL,23,NULL,-1,'2025-09-19 14:10:14','2025-09-19 14:10:14');
INSERT INTO "BranchMenu" VALUES (84,4,84,60,1,'',NULL,NULL,NULL,24,NULL,-1,'2025-09-19 14:10:14','2025-09-19 14:10:14');
INSERT INTO "BranchMenu" VALUES (85,4,85,160,1,'',NULL,NULL,NULL,25,NULL,-1,'2025-09-19 14:10:14','2025-09-19 14:10:14');
INSERT INTO "BranchMenu" VALUES (86,4,86,140,1,'',NULL,NULL,NULL,26,NULL,-1,'2025-09-19 14:10:14','2025-09-19 14:10:14');
INSERT INTO "BranchMenu" VALUES (87,4,87,120,1,'',NULL,NULL,NULL,27,NULL,-1,'2025-09-19 14:10:14','2025-09-19 14:10:14');
INSERT INTO "BranchMenu" VALUES (88,4,88,30,1,'',NULL,NULL,NULL,28,'{"groups":[{"id":"spice_level_group","name":{"en-US":"Spice Level","bn-BD":"\u099d\u09be\u09b2"},"type":"radio","required":false,"options":[{"id":"mild","name":{"en-US":"Mild","bn-BD":"\u099d\u09be\u09b2\u09b9\u09c0\u09a8"},"price_adjustment":0},{"id":"medium","name":{"en-US":"Medium","bn-BD":"\u09ae\u09be\u099d\u09be\u09b0\u09bf \u099d\u09be\u09b2"},"price_adjustment":0},{"id":"hot","name":{"en-US":"Hot","bn-BD":"\u0996\u09c1\u09ac \u099d\u09be\u09b2"},"price_adjustment":0}]},{"id":"toppings_group","name":{"en-US":"Extra Toppings","bn-BD":"\u0985\u09a4\u09bf\u09b0\u09bf\u0995\u09cd\u09a4 \u099f\u09aa\u09bf\u0982\u09b8"},"type":"checkbox","required":false,"options":[{"id":"egg","name":{"en-US":"Soft Boiled Egg","bn-BD":"\u09b8\u09ab\u099f \u09ac\u09af\u09bc\u09c7\u09b2\u09a1 \u09a1\u09bf\u09ae"},"price_adjustment":15},{"id":"extra_noodles","name":{"en-US":"Extra Noodles","bn-BD":"\u0985\u09a4\u09bf\u09b0\u09bf\u0995\u09cd\u09a4 \u09a8\u09c1\u09a1\u09b2\u09b8"},"price_adjustment":20}]}]}',-1,'2025-09-19 14:10:14','2025-09-19 14:10:14');
INSERT INTO "BranchMenu" VALUES (89,5,89,300,1,1,NULL,NULL,NULL,1,'{"groups":[{"id":"size_group","name":{"en-US":"Size","bn-BD":"\u0986\u0995\u09be\u09b0"},"type":"radio","required":true,"options":[{"id":"small","name":{"en-US":"Small (8\")","bn-BD":"\u099b\u09cb\u099f (\u09ee \u0987\u099e\u09cd\u099a\u09bf)"},"price_adjustment":0},{"id":"medium","name":{"en-US":"Medium (10\")","bn-BD":"\u09ae\u09be\u099d\u09be\u09b0\u09bf (\u09e7\u09e6 \u0987\u099e\u09cd\u099a\u09bf)"},"price_adjustment":50},{"id":"large","name":{"en-US":"Large (12\")","bn-BD":"\u09ac\u09dc (\u09e7\u09e8 \u0987\u099e\u09cd\u099a\u09bf)"},"price_adjustment":100}]},{"id":"crust_group","name":{"en-US":"Crust Type","bn-BD":"\u0995\u09cd\u09b0\u09be\u09b8\u09cd\u099f\u09c7\u09b0 \u09a7\u09b0\u09a8"},"type":"radio","required":true,"options":[{"id":"thin","name":{"en-US":"Thin Crust","bn-BD":"\u09aa\u09be\u09a4\u09b2\u09be \u0995\u09cd\u09b0\u09be\u09b8\u09cd\u099f"},"price_adjustment":0},{"id":"thick","name":{"en-US":"Thick Crust","bn-BD":"\u09ae\u09cb\u099f\u09be \u0995\u09cd\u09b0\u09be\u09b8\u09cd\u099f"},"price_adjustment":20}]}]}',-1,'2025-09-19 14:10:14','2025-09-19 14:10:14');
INSERT INTO "BranchMenu" VALUES (90,5,90,340,1,'',NULL,NULL,NULL,2,'{"groups":[{"id":"size_group","name":{"en-US":"Size","bn-BD":"\u0986\u0995\u09be\u09b0"},"type":"radio","required":true,"options":[{"id":"small","name":{"en-US":"Small (8\")","bn-BD":"\u099b\u09cb\u099f (\u09ee \u0987\u099e\u09cd\u099a\u09bf)"},"price_adjustment":0},{"id":"medium","name":{"en-US":"Medium (10\")","bn-BD":"\u09ae\u09be\u099d\u09be\u09b0\u09bf (\u09e7\u09e6 \u0987\u099e\u09cd\u099a\u09bf)"},"price_adjustment":50},{"id":"large","name":{"en-US":"Large (12\")","bn-BD":"\u09ac\u09dc (\u09e7\u09e8 \u0987\u099e\u09cd\u099a\u09bf)"},"price_adjustment":100}]},{"id":"crust_group","name":{"en-US":"Crust Type","bn-BD":"\u0995\u09cd\u09b0\u09be\u09b8\u09cd\u099f\u09c7\u09b0 \u09a7\u09b0\u09a8"},"type":"radio","required":true,"options":[{"id":"thin","name":{"en-US":"Thin Crust","bn-BD":"\u09aa\u09be\u09a4\u09b2\u09be \u0995\u09cd\u09b0\u09be\u09b8\u09cd\u099f"},"price_adjustment":0},{"id":"thick","name":{"en-US":"Thick Crust","bn-BD":"\u09ae\u09cb\u099f\u09be \u0995\u09cd\u09b0\u09be\u09b8\u09cd\u099f"},"price_adjustment":20}]}]}',-1,'2025-09-19 14:10:14','2025-09-19 14:10:14');
INSERT INTO "BranchMenu" VALUES (91,5,91,320,1,'',NULL,NULL,NULL,3,'{"groups":[{"id":"size_group","name":{"en-US":"Size","bn-BD":"\u0986\u0995\u09be\u09b0"},"type":"radio","required":true,"options":[{"id":"small","name":{"en-US":"Small (8\")","bn-BD":"\u099b\u09cb\u099f (\u09ee \u0987\u099e\u09cd\u099a\u09bf)"},"price_adjustment":0},{"id":"medium","name":{"en-US":"Medium (10\")","bn-BD":"\u09ae\u09be\u099d\u09be\u09b0\u09bf (\u09e7\u09e6 \u0987\u099e\u09cd\u099a\u09bf)"},"price_adjustment":50},{"id":"large","name":{"en-US":"Large (12\")","bn-BD":"\u09ac\u09dc (\u09e7\u09e8 \u0987\u099e\u09cd\u099a\u09bf)"},"price_adjustment":100}]},{"id":"crust_group","name":{"en-US":"Crust Type","bn-BD":"\u0995\u09cd\u09b0\u09be\u09b8\u09cd\u099f\u09c7\u09b0 \u09a7\u09b0\u09a8"},"type":"radio","required":true,"options":[{"id":"thin","name":{"en-US":"Thin Crust","bn-BD":"\u09aa\u09be\u09a4\u09b2\u09be \u0995\u09cd\u09b0\u09be\u09b8\u09cd\u099f"},"price_adjustment":0},{"id":"thick","name":{"en-US":"Thick Crust","bn-BD":"\u09ae\u09cb\u099f\u09be \u0995\u09cd\u09b0\u09be\u09b8\u09cd\u099f"},"price_adjustment":20}]}]}',-1,'2025-09-19 14:10:14','2025-09-19 14:10:14');
INSERT INTO "BranchMenu" VALUES (92,5,92,320,1,'',NULL,NULL,NULL,4,'{"groups":[{"id":"size_group","name":{"en-US":"Size","bn-BD":"\u0986\u0995\u09be\u09b0"},"type":"radio","required":true,"options":[{"id":"small","name":{"en-US":"Small (8\")","bn-BD":"\u099b\u09cb\u099f (\u09ee \u0987\u099e\u09cd\u099a\u09bf)"},"price_adjustment":0},{"id":"medium","name":{"en-US":"Medium (10\")","bn-BD":"\u09ae\u09be\u099d\u09be\u09b0\u09bf (\u09e7\u09e6 \u0987\u099e\u09cd\u099a\u09bf)"},"price_adjustment":50},{"id":"large","name":{"en-US":"Large (12\")","bn-BD":"\u09ac\u09dc (\u09e7\u09e8 \u0987\u099e\u09cd\u099a\u09bf)"},"price_adjustment":100}]},{"id":"crust_group","name":{"en-US":"Crust Type","bn-BD":"\u0995\u09cd\u09b0\u09be\u09b8\u09cd\u099f\u09c7\u09b0 \u09a7\u09b0\u09a8"},"type":"radio","required":true,"options":[{"id":"thin","name":{"en-US":"Thin Crust","bn-BD":"\u09aa\u09be\u09a4\u09b2\u09be \u0995\u09cd\u09b0\u09be\u09b8\u09cd\u099f"},"price_adjustment":0},{"id":"thick","name":{"en-US":"Thick Crust","bn-BD":"\u09ae\u09cb\u099f\u09be \u0995\u09cd\u09b0\u09be\u09b8\u09cd\u099f"},"price_adjustment":20}]}]}',-1,'2025-09-19 14:10:14','2025-09-19 14:10:14');
INSERT INTO "BranchMenu" VALUES (93,5,93,360,1,'',NULL,NULL,NULL,5,'{"groups":[{"id":"size_group","name":{"en-US":"Size","bn-BD":"\u0986\u0995\u09be\u09b0"},"type":"radio","required":true,"options":[{"id":"small","name":{"en-US":"Small (8\")","bn-BD":"\u099b\u09cb\u099f (\u09ee \u0987\u099e\u09cd\u099a\u09bf)"},"price_adjustment":0},{"id":"medium","name":{"en-US":"Medium (10\")","bn-BD":"\u09ae\u09be\u099d\u09be\u09b0\u09bf (\u09e7\u09e6 \u0987\u099e\u09cd\u099a\u09bf)"},"price_adjustment":50},{"id":"large","name":{"en-US":"Large (12\")","bn-BD":"\u09ac\u09dc (\u09e7\u09e8 \u0987\u099e\u09cd\u099a\u09bf)"},"price_adjustment":100}]},{"id":"crust_group","name":{"en-US":"Crust Type","bn-BD":"\u0995\u09cd\u09b0\u09be\u09b8\u09cd\u099f\u09c7\u09b0 \u09a7\u09b0\u09a8"},"type":"radio","required":true,"options":[{"id":"thin","name":{"en-US":"Thin Crust","bn-BD":"\u09aa\u09be\u09a4\u09b2\u09be \u0995\u09cd\u09b0\u09be\u09b8\u09cd\u099f"},"price_adjustment":0},{"id":"thick","name":{"en-US":"Thick Crust","bn-BD":"\u09ae\u09cb\u099f\u09be \u0995\u09cd\u09b0\u09be\u09b8\u09cd\u099f"},"price_adjustment":20}]}]}',-1,'2025-09-19 14:10:14','2025-09-19 14:10:14');
INSERT INTO "BranchMenu" VALUES (94,5,94,280,1,1,NULL,NULL,NULL,6,'{"groups":[{"id":"serving_size_group","name":{"en-US":"Serving Size","bn-BD":"\u09aa\u09b0\u09bf\u09ac\u09c7\u09b6\u09a8\u09c7\u09b0 \u0986\u0995\u09be\u09b0"},"type":"radio","required":true,"options":[{"id":"regular","name":{"en-US":"Regular","bn-BD":"\u09b8\u09be\u09a7\u09be\u09b0\u09a3"},"price_adjustment":0},{"id":"large","name":{"en-US":"Large","bn-BD":"\u09ac\u09dc"},"price_adjustment":40}]},{"id":"cheese_group","name":{"en-US":"Extra Cheese","bn-BD":"\u0985\u09a4\u09bf\u09b0\u09bf\u0995\u09cd\u09a4 \u09aa\u09a8\u09bf\u09b0"},"type":"checkbox","required":false,"options":[{"id":"parmesan","name":{"en-US":"Parmesan","bn-BD":"\u09aa\u09be\u09b0\u09ae\u09c7\u09b8\u09be\u09a8"},"price_adjustment":20}]}]}',-1,'2025-09-19 14:10:14','2025-09-19 14:10:14');
INSERT INTO "BranchMenu" VALUES (95,5,95,260,1,'',NULL,NULL,NULL,7,NULL,-1,'2025-09-19 14:10:14','2025-09-19 14:10:14');
INSERT INTO "BranchMenu" VALUES (96,5,96,240,1,'',NULL,NULL,NULL,8,NULL,-1,'2025-09-19 14:10:14','2025-09-19 14:10:14');
INSERT INTO "BranchMenu" VALUES (97,5,97,320,1,'',NULL,NULL,NULL,9,NULL,-1,'2025-09-19 14:10:14','2025-09-19 14:10:14');
INSERT INTO "BranchMenu" VALUES (98,5,98,300,1,'',NULL,NULL,NULL,10,NULL,-1,'2025-09-19 14:10:14','2025-09-19 14:10:14');
INSERT INTO "BranchMenu" VALUES (99,5,99,180,1,'',NULL,NULL,NULL,11,'{"groups":[{"id":"protein_group","name":{"en-US":"Add Protein","bn-BD":"\u09aa\u09cd\u09b0\u09cb\u099f\u09bf\u09a8 \u09af\u09cb\u0997 \u0995\u09b0\u09c1\u09a8"},"type":"radio","required":false,"options":[{"id":"none","name":{"en-US":"No Protein","bn-BD":"\u0995\u09cb\u09a8 \u09aa\u09cd\u09b0\u09cb\u099f\u09bf\u09a8 \u09a8\u09be"},"price_adjustment":0},{"id":"chicken","name":{"en-US":"Grilled Chicken","bn-BD":"\u0997\u09cd\u09b0\u09bf\u09b2\u09a1 \u099a\u09bf\u0995\u09c7\u09a8"},"price_adjustment":50},{"id":"shrimp","name":{"en-US":"Shrimp","bn-BD":"\u099a\u09bf\u0982\u09a1\u09bc\u09bf"},"price_adjustment":70}]}]}',-1,'2025-09-19 14:10:14','2025-09-19 14:10:14');
INSERT INTO "BranchMenu" VALUES (100,5,100,200,1,'',NULL,NULL,NULL,12,NULL,-1,'2025-09-19 14:10:14','2025-09-19 14:10:14');
INSERT INTO "BranchMenu" VALUES (101,5,101,220,1,'',NULL,NULL,NULL,13,NULL,-1,'2025-09-19 14:10:14','2025-09-19 14:10:14');
INSERT INTO "BranchMenu" VALUES (102,5,102,240,1,'',NULL,NULL,NULL,14,NULL,-1,'2025-09-19 14:10:14','2025-09-19 14:10:14');
INSERT INTO "BranchMenu" VALUES (103,5,103,100,1,'',NULL,NULL,NULL,15,NULL,-1,'2025-09-19 14:10:14','2025-09-19 14:10:14');
INSERT INTO "BranchMenu" VALUES (104,5,104,140,1,'',NULL,NULL,NULL,16,NULL,-1,'2025-09-19 14:10:14','2025-09-19 14:10:14');
INSERT INTO "BranchMenu" VALUES (105,5,105,120,1,'',NULL,NULL,NULL,17,NULL,-1,'2025-09-19 14:10:14','2025-09-19 14:10:14');
INSERT INTO "BranchMenu" VALUES (106,5,106,240,1,'',NULL,NULL,NULL,18,NULL,-1,'2025-09-19 14:10:14','2025-09-19 14:10:14');
INSERT INTO "BranchMenu" VALUES (107,5,107,260,1,'',NULL,NULL,NULL,19,NULL,-1,'2025-09-19 14:10:14','2025-09-19 14:10:14');
INSERT INTO "BranchMenu" VALUES (108,5,108,180,1,'',NULL,NULL,NULL,20,NULL,-1,'2025-09-19 14:10:14','2025-09-19 14:10:14');
INSERT INTO "BranchMenu" VALUES (109,5,109,160,1,'',NULL,NULL,NULL,21,NULL,-1,'2025-09-19 14:10:14','2025-09-19 14:10:14');
INSERT INTO "BranchMenu" VALUES (110,5,110,140,1,'',NULL,NULL,NULL,22,NULL,-1,'2025-09-19 14:10:14','2025-09-19 14:10:14');
INSERT INTO "BranchMenu" VALUES (111,5,111,40,1,'',NULL,NULL,NULL,23,'{"groups":[{"id":"serving_size_group","name":{"en-US":"Serving Size","bn-BD":"\u09aa\u09b0\u09bf\u09ac\u09c7\u09b6\u09a8\u09c7\u09b0 \u0986\u0995\u09be\u09b0"},"type":"radio","required":true,"options":[{"id":"four_pieces","name":{"en-US":"4 Pieces","bn-BD":"\u09ea \u09aa\u09bf\u09b8"},"price_adjustment":0},{"id":"eight_pieces","name":{"en-US":"8 Pieces","bn-BD":"\u09ee \u09aa\u09bf\u09b8"},"price_adjustment":25},{"id":"twelve_pieces","name":{"en-US":"12 Pieces","bn-BD":"\u09e7\u09e8 \u09aa\u09bf\u09b8"},"price_adjustment":50}]}]}',-1,'2025-09-19 14:10:14','2025-09-19 14:10:14');
INSERT INTO "BranchMenu" VALUES (112,6,112,280,1,1,NULL,NULL,NULL,1,'{"groups":[{"id":"size_group","name":{"en-US":"Size","bn-BD":"\u0986\u0995\u09be\u09b0"},"type":"radio","required":true,"options":[{"id":"small","name":{"en-US":"Small (8\")","bn-BD":"\u099b\u09cb\u099f (\u09ee \u0987\u099e\u09cd\u099a\u09bf)"},"price_adjustment":0},{"id":"medium","name":{"en-US":"Medium (10\")","bn-BD":"\u09ae\u09be\u099d\u09be\u09b0\u09bf (\u09e7\u09e6 \u0987\u099e\u09cd\u099a\u09bf)"},"price_adjustment":50},{"id":"large","name":{"en-US":"Large (12\")","bn-BD":"\u09ac\u09dc (\u09e7\u09e8 \u0987\u099e\u09cd\u099a\u09bf)"},"price_adjustment":100}]},{"id":"crust_group","name":{"en-US":"Crust Type","bn-BD":"\u0995\u09cd\u09b0\u09be\u09b8\u09cd\u099f\u09c7\u09b0 \u09a7\u09b0\u09a8"},"type":"radio","required":true,"options":[{"id":"thin","name":{"en-US":"Thin Crust","bn-BD":"\u09aa\u09be\u09a4\u09b2\u09be \u0995\u09cd\u09b0\u09be\u09b8\u09cd\u099f"},"price_adjustment":0},{"id":"thick","name":{"en-US":"Thick Crust","bn-BD":"\u09ae\u09cb\u099f\u09be \u0995\u09cd\u09b0\u09be\u09b8\u09cd\u099f"},"price_adjustment":20}]}]}',-1,'2025-09-19 14:10:14','2025-09-19 14:10:14');
INSERT INTO "BranchMenu" VALUES (113,6,113,320,1,'',NULL,NULL,NULL,2,NULL,-1,'2025-09-19 14:10:14','2025-09-19 14:10:14');
INSERT INTO "BranchMenu" VALUES (114,6,114,300,1,'',NULL,NULL,NULL,3,NULL,-1,'2025-09-19 14:10:14','2025-09-19 14:10:14');
INSERT INTO "BranchMenu" VALUES (115,6,115,350,1,'',NULL,NULL,NULL,4,NULL,-1,'2025-09-19 14:10:14','2025-09-19 14:10:14');
INSERT INTO "BranchMenu" VALUES (116,6,116,320,1,'',NULL,NULL,NULL,5,NULL,-1,'2025-09-19 14:10:14','2025-09-19 14:10:14');
INSERT INTO "BranchMenu" VALUES (117,6,117,400,1,'',NULL,NULL,NULL,6,NULL,-1,'2025-09-19 14:10:14','2025-09-19 14:10:14');
INSERT INTO "BranchMenu" VALUES (118,6,118,250,1,1,NULL,NULL,NULL,7,'{"groups":[{"id":"serving_size_group","name":{"en-US":"Serving Size","bn-BD":"\u09aa\u09b0\u09bf\u09ac\u09c7\u09b6\u09a8\u09c7\u09b0 \u0986\u0995\u09be\u09b0"},"type":"radio","required":true,"options":[{"id":"regular","name":{"en-US":"Regular","bn-BD":"\u09b8\u09be\u09a7\u09be\u09b0\u09a3"},"price_adjustment":0},{"id":"large","name":{"en-US":"Large","bn-BD":"\u09ac\u09dc"},"price_adjustment":40}]},{"id":"cheese_group","name":{"en-US":"Extra Cheese","bn-BD":"\u0985\u09a4\u09bf\u09b0\u09bf\u0995\u09cd\u09a4 \u09aa\u09a8\u09bf\u09b0"},"type":"checkbox","required":false,"options":[{"id":"parmesan","name":{"en-US":"Parmesan","bn-BD":"\u09aa\u09be\u09b0\u09ae\u09c7\u09b8\u09be\u09a8"},"price_adjustment":20}]}]}',-1,'2025-09-19 14:10:14','2025-09-19 14:10:14');
INSERT INTO "BranchMenu" VALUES (119,6,119,280,1,'',NULL,NULL,NULL,8,NULL,-1,'2025-09-19 14:10:14','2025-09-19 14:10:14');
INSERT INTO "BranchMenu" VALUES (120,6,120,240,1,'',NULL,NULL,NULL,9,NULL,-1,'2025-09-19 14:10:14','2025-09-19 14:10:14');
INSERT INTO "BranchMenu" VALUES (121,6,121,220,1,'',NULL,NULL,NULL,10,NULL,-1,'2025-09-19 14:10:14','2025-09-19 14:10:14');
INSERT INTO "BranchMenu" VALUES (122,6,122,200,1,1,NULL,NULL,NULL,11,'{"groups":[{"id":"protein_group","name":{"en-US":"Add Protein","bn-BD":"\u09aa\u09cd\u09b0\u09cb\u099f\u09bf\u09a8 \u09af\u09cb\u0997 \u0995\u09b0\u09c1\u09a8"},"type":"radio","required":false,"options":[{"id":"none","name":{"en-US":"No Protein","bn-BD":"\u0995\u09cb\u09a8 \u09aa\u09cd\u09b0\u09cb\u099f\u09bf\u09a8 \u09a8\u09be"},"price_adjustment":0},{"id":"chicken","name":{"en-US":"Grilled Chicken","bn-BD":"\u0997\u09cd\u09b0\u09bf\u09b2\u09a1 \u099a\u09bf\u0995\u09c7\u09a8"},"price_adjustment":50},{"id":"shrimp","name":{"en-US":"Shrimp","bn-BD":"\u099a\u09bf\u0982\u09a1\u09bc\u09bf"},"price_adjustment":70}]}]}',-1,'2025-09-19 14:10:14','2025-09-19 14:10:14');
INSERT INTO "BranchMenu" VALUES (123,6,123,240,1,'',NULL,NULL,NULL,12,NULL,-1,'2025-09-19 14:10:14','2025-09-19 14:10:14');
INSERT INTO "BranchMenu" VALUES (124,6,124,220,1,'',NULL,NULL,NULL,13,NULL,-1,'2025-09-19 14:10:14','2025-09-19 14:10:14');
INSERT INTO "BranchMenu" VALUES (125,6,125,260,1,'',NULL,NULL,NULL,14,NULL,-1,'2025-09-19 14:10:14','2025-09-19 14:10:14');
INSERT INTO "BranchMenu" VALUES (126,6,126,240,1,'',NULL,NULL,NULL,15,NULL,-1,'2025-09-19 14:10:14','2025-09-19 14:10:14');
INSERT INTO "BranchMenu" VALUES (127,6,127,280,1,'',NULL,NULL,NULL,16,NULL,-1,'2025-09-19 14:10:14','2025-09-19 14:10:14');
INSERT INTO "BranchMenu" VALUES (128,6,128,260,1,'',NULL,NULL,NULL,17,NULL,-1,'2025-09-19 14:10:14','2025-09-19 14:10:14');
INSERT INTO "BranchMenu" VALUES (129,6,129,160,1,'',NULL,NULL,NULL,18,NULL,-1,'2025-09-19 14:10:14','2025-09-19 14:10:14');
INSERT INTO "BranchMenu" VALUES (130,6,130,80,1,'',NULL,NULL,NULL,19,NULL,-1,'2025-09-19 14:10:14','2025-09-19 14:10:14');
INSERT INTO "BranchMenu" VALUES (131,6,131,120,1,'',NULL,NULL,NULL,20,NULL,-1,'2025-09-19 14:10:14','2025-09-19 14:10:14');
INSERT INTO "BranchMenu" VALUES (132,6,132,100,1,'',NULL,NULL,NULL,21,NULL,-1,'2025-09-19 14:10:14','2025-09-19 14:10:14');
INSERT INTO "BranchMenu" VALUES (133,6,133,320,1,'',NULL,NULL,NULL,22,NULL,-1,'2025-09-19 14:10:14','2025-09-19 14:10:14');
INSERT INTO "BranchMenu" VALUES (134,6,134,360,1,'',NULL,NULL,NULL,23,NULL,-1,'2025-09-19 14:10:14','2025-09-19 14:10:14');
INSERT INTO "BranchMenu" VALUES (135,6,135,280,1,'',NULL,NULL,NULL,24,NULL,-1,'2025-09-19 14:10:14','2025-09-19 14:10:14');
INSERT INTO "BranchMenu" VALUES (136,6,136,140,1,'',NULL,NULL,NULL,25,NULL,-1,'2025-09-19 14:10:14','2025-09-19 14:10:14');
INSERT INTO "BranchMenu" VALUES (137,6,137,120,1,'',NULL,NULL,NULL,26,NULL,-1,'2025-09-19 14:10:14','2025-09-19 14:10:14');
INSERT INTO "BranchMenu" VALUES (138,6,138,160,1,'',NULL,NULL,NULL,27,NULL,-1,'2025-09-19 14:10:14','2025-09-19 14:10:14');
INSERT INTO "BranchMenu" VALUES (139,6,139,40,1,'',NULL,NULL,NULL,28,'{"groups":[{"id":"serving_size_group","name":{"en-US":"Serving Size","bn-BD":"\u09aa\u09b0\u09bf\u09ac\u09c7\u09b6\u09a8\u09c7\u09b0 \u0986\u0995\u09be\u09b0"},"type":"radio","required":true,"options":[{"id":"four_pieces","name":{"en-US":"4 Pieces","bn-BD":"\u09ea \u09aa\u09bf\u09b8"},"price_adjustment":0},{"id":"eight_pieces","name":{"en-US":"8 Pieces","bn-BD":"\u09ee \u09aa\u09bf\u09b8"},"price_adjustment":25},{"id":"twelve_pieces","name":{"en-US":"12 Pieces","bn-BD":"\u09e7\u09e8 \u09aa\u09bf\u09b8"},"price_adjustment":50}]}]}',-1,'2025-09-19 14:10:14','2025-09-19 14:10:14');
INSERT INTO "BranchSettings" VALUES (1,'branch_fast_food_name','/assets/images/logos/fastfood-logo.jpg','/assets/images/covers/fastfood-cover.jpg','+8801234567890',15,10,'{"type": "fixed", "amount": 50.00, "minimum_order_free": 500.00}','{"monday": "10:00-23:00", "tuesday": "10:00-23:00", "wednesday": "10:00-23:00", "thursday": "10:00-23:00", "friday": "10:00-23:00", "saturday": "10:00-00:00", "sunday": "10:00-23:00"}',200,5);
INSERT INTO "BranchSettings" VALUES (2,'branch_desi_name','/assets/images/logos/desi-logo.jpg','/assets/images/covers/desi-cover.jpg','+8801987654321',15,10,'{"type": "distance", "distance_based": {"base_amount": 40.00, "per_km": 10.00}, "minimum_order_free": 600.00}','{"monday": "11:00-23:00", "tuesday": "11:00-23:00", "wednesday": "11:00-23:00", "thursday": "11:00-23:00", "friday": "11:00-23:00", "saturday": "11:00-00:00", "sunday": "11:00-23:00"}',300,7);
INSERT INTO "BranchSettings" VALUES (3,'branch_chinese_name','/assets/images/logos/chinese-logo.jpg','/assets/images/covers/chinese-cover.jpg','+8801122334455',15,10,'{"type": "percentage", "percentage_based": {"rate": 5.0}, "minimum_order_free": 800.00}','{"monday": "11:00-23:00", "tuesday": "11:00-23:00", "wednesday": "11:00-23:00", "thursday": "11:00-23:00", "friday": "11:00-23:00", "saturday": "11:00-00:00", "sunday": "11:00-23:00"}',250,5);
INSERT INTO "BranchSettings" VALUES (4,'branch_indian_name','/assets/images/logos/indian-logo.jpg','/assets/images/covers/indian-cover.jpg','+8801555666777',15,10,'{"type": "distance", "distance_based": {"base_amount": 40.00, "per_km": 10.00}, "minimum_order_free": 400.00}','{"monday": "08:00-22:00", "tuesday": "08:00-22:00", "wednesday": "08:00-22:00", "thursday": "08:00-22:00", "friday": "08:00-22:00", "saturday": "08:00-23:00", "sunday": "08:00-22:00"}',200,4);
INSERT INTO "BranchSettings" VALUES (5,'branch_italian_name','/assets/images/logos/italian-logo.jpg','/assets/images/covers/italian-cover.jpg','+8801777888999',15,10,'{"type": "fixed", "amount": 70.00, "minimum_order_free": 1000.00}','{"monday": "12:00-23:00", "tuesday": "12:00-23:00", "wednesday": "12:00-23:00", "thursday": "12:00-23:00", "friday": "12:00-23:00", "saturday": "12:00-00:00", "sunday": "12:00-23:00"}',400,5);
INSERT INTO "BranchSettings" VALUES (6,'branch_japanese_name','/assets/images/logos/japanese-logo.jpg','/assets/images/covers/japanese-cover.jpg','+8801888999000',15,10,'{"type": "distance", "distance_based": {"base_amount": 40.00, "per_km": 10.00}, "minimum_order_free": 700.00}','{"monday": "10:00-23:00", "tuesday": "10:00-23:00", "wednesday": "10:00-23:00", "thursday": "10:00-23:00", "friday": "10:00-23:00", "saturday": "10:00-00:00", "sunday": "10:00-23:00"}',350,6);
INSERT INTO "Branches" VALUES (1,'FastFood_01','House 15, Road 7, Dhanmondi, Dhaka',23.746466,90.376015,'Asia/Dhaka','fastfood@restaurant.com',1,'2025-09-19 14:10:13','2025-09-19 14:10:13',NULL,NULL);
INSERT INTO "Branches" VALUES (2,'Desi_01','Plot 8, Block C, Gulshan-1, Dhaka',23.781034,90.414415,'Asia/Dhaka','desi@restaurant.com',1,'2025-09-19 14:10:13','2025-09-19 14:10:13',NULL,NULL);
INSERT INTO "Branches" VALUES (3,'Chinese_01','Shop 205, Bashundhara City, Dhaka',23.746466,90.376015,'Asia/Dhaka','chinese@restaurant.com',1,'2025-09-19 14:10:13','2025-09-19 14:10:13',NULL,NULL);
INSERT INTO "Branches" VALUES (4,'Indian_01','House 42, Road 11, Banani, Dhaka',23.781034,90.414415,'Asia/Dhaka','indian@restaurant.com',1,'2025-09-19 14:10:13','2025-09-19 14:10:13',NULL,NULL);
INSERT INTO "Branches" VALUES (5,'Italian_01','Level 5, Jamuna Future Park, Dhaka',23.746466,90.376015,'Asia/Dhaka','italian@restaurant.com',1,'2025-09-19 14:10:13','2025-09-19 14:10:13',NULL,NULL);
INSERT INTO "Branches" VALUES (6,'Japanese_01','House 7, Road 27, Old DOHS, Dhaka',23.781034,90.414415,'Asia/Dhaka','japanese@restaurant.com',1,'2025-09-19 14:10:13','2025-09-19 14:10:13',NULL,NULL);
INSERT INTO "DeliveryTracking" VALUES (1,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'assigned',NULL,NULL,'2025-09-19 14:10:15','2025-09-19 14:10:15');
INSERT INTO "DeliveryTracking" VALUES (2,11,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'assigned',NULL,NULL,'2025-09-20 07:00:05','2025-09-20 07:00:05');
INSERT INTO "FeatureFlags" VALUES (1,'admin_dashboard_analytics','Advanced Dashboard Analytics','Enable advanced analytics charts and reports in admin dashboard',1,'admin',NULL,NULL,NULL,NULL,'2025-09-19 14:10:07','2025-09-19 14:10:07',NULL,NULL);
INSERT INTO "FeatureFlags" VALUES (2,'multi_branch_management','Multi-Branch Management','Enable multi-branch management features',1,'admin',NULL,NULL,NULL,NULL,'2025-09-19 14:10:07','2025-09-19 14:10:07',NULL,NULL);
INSERT INTO "FeatureFlags" VALUES (3,'real_time_notifications','Real-time Notifications','Enable real-time push notifications via Firebase',1,'all',NULL,NULL,NULL,NULL,'2025-09-19 14:10:07','2025-09-19 14:10:07',NULL,NULL);
INSERT INTO "FeatureFlags" VALUES (4,'advanced_reporting','Advanced Reporting','Enable advanced reporting features and custom reports',1,'admin',NULL,NULL,NULL,NULL,'2025-09-19 14:10:07','2025-09-19 14:10:07',NULL,NULL);
INSERT INTO "FeatureFlags" VALUES (5,'bulk_operations','Bulk Operations','Enable bulk operations for users, orders, and menu items',1,'admin',NULL,NULL,NULL,NULL,'2025-09-19 14:10:07','2025-09-19 14:10:07',NULL,NULL);
INSERT INTO "FeatureFlags" VALUES (6,'api_rate_limiting','API Rate Limiting','Enable API rate limiting for security',1,'all',NULL,NULL,NULL,NULL,'2025-09-19 14:10:07','2025-09-19 14:10:07',NULL,NULL);
INSERT INTO "FeatureFlags" VALUES (7,'audit_logging','Audit Logging','Enable detailed audit logging for all admin actions',1,'admin',NULL,NULL,NULL,NULL,'2025-09-19 14:10:07','2025-09-19 14:10:07',NULL,NULL);
INSERT INTO "FeatureFlags" VALUES (8,'user_impersonation','User Impersonation','Allow admins to impersonate other users',0,'admin',NULL,NULL,NULL,NULL,'2025-09-19 14:10:07','2025-09-19 14:10:07',NULL,NULL);
INSERT INTO "FeatureFlags" VALUES (9,'automatic_backups','Automatic Backups','Enable automatic database backups',1,'admin',NULL,NULL,NULL,NULL,'2025-09-19 14:10:07','2025-09-19 14:10:07',NULL,NULL);
INSERT INTO "FeatureFlags" VALUES (10,'two_factor_authentication','2FA Authentication','Enable two-factor authentication for admin users',0,'admin',NULL,NULL,NULL,NULL,'2025-09-19 14:10:07','2025-09-19 14:10:07',NULL,NULL);
INSERT INTO "FeatureFlags" VALUES (11,'dark_mode','Dark Mode UI','Enable dark mode interface option',1,'all',NULL,NULL,NULL,NULL,'2025-09-19 14:10:07','2025-09-19 14:10:07',NULL,NULL);
INSERT INTO "FeatureFlags" VALUES (12,'mobile_responsive','Mobile Responsive','Enable mobile responsive admin interface',1,'all',NULL,NULL,NULL,NULL,'2025-09-19 14:10:07','2025-09-19 14:10:07',NULL,NULL);
INSERT INTO "MenuCategories" VALUES (1,'category_burgers','category_burgers_desc',1,'/assets/images/categories/burgers.jpg',1,NULL,'2025-09-19 14:10:11','2025-09-19 14:10:11',NULL,NULL);
INSERT INTO "MenuCategories" VALUES (2,'category_sandwiches','category_sandwiches_desc',2,'/assets/images/categories/sandwiches.jpg',1,NULL,'2025-09-19 14:10:11','2025-09-19 14:10:11',NULL,NULL);
INSERT INTO "MenuCategories" VALUES (3,'category_fries','category_fries_desc',3,'/assets/images/categories/fries.jpg',1,NULL,'2025-09-19 14:10:11','2025-09-19 14:10:11',NULL,NULL);
INSERT INTO "MenuCategories" VALUES (4,'category_hot_dogs','category_hot_dogs_desc',4,'/assets/images/categories/hot-dogs.jpg',1,NULL,'2025-09-19 14:10:11','2025-09-19 14:10:11',NULL,NULL);
INSERT INTO "MenuCategories" VALUES (5,'category_wraps','category_wraps_desc',5,'/assets/images/categories/wraps.jpg',1,NULL,'2025-09-19 14:10:11','2025-09-19 14:10:11',NULL,NULL);
INSERT INTO "MenuCategories" VALUES (6,'category_fast_food_desserts','category_fast_food_desserts_desc',6,'/assets/images/categories/fastfood-desserts.jpg',1,NULL,'2025-09-19 14:10:11','2025-09-19 14:10:11',NULL,NULL);
INSERT INTO "MenuCategories" VALUES (7,'category_beverages','category_beverages_desc',7,'/assets/images/categories/beverages.jpg',1,NULL,'2025-09-19 14:10:11','2025-09-19 14:10:11',NULL,NULL);
INSERT INTO "MenuCategories" VALUES (8,'category_desi_rice','category_desi_rice_desc',1,'/assets/images/categories/desi-rice.jpg',1,NULL,'2025-09-19 14:10:11','2025-09-19 14:10:11',NULL,NULL);
INSERT INTO "MenuCategories" VALUES (9,'category_desi_curry','category_desi_curry_desc',2,'/assets/images/categories/desi-curry.jpg',1,NULL,'2025-09-19 14:10:11','2025-09-19 14:10:11',NULL,NULL);
INSERT INTO "MenuCategories" VALUES (10,'category_desi_kabab','category_desi_kabab_desc',3,'/assets/images/categories/desi-kabab.jpg',1,NULL,'2025-09-19 14:10:11','2025-09-19 14:10:11',NULL,NULL);
INSERT INTO "MenuCategories" VALUES (11,'category_desi_bread','category_desi_bread_desc',4,'/assets/images/categories/desi-bread.jpg',1,NULL,'2025-09-19 14:10:11','2025-09-19 14:10:11',NULL,NULL);
INSERT INTO "MenuCategories" VALUES (12,'category_desi_starters','category_desi_starters_desc',5,'/assets/images/categories/desi-starters.jpg',1,NULL,'2025-09-19 14:10:12','2025-09-19 14:10:12',NULL,NULL);
INSERT INTO "MenuCategories" VALUES (13,'category_desi_desserts','category_desi_desserts_desc',6,'/assets/images/categories/desi-desserts.jpg',1,NULL,'2025-09-19 14:10:12','2025-09-19 14:10:12',NULL,NULL);
INSERT INTO "MenuCategories" VALUES (14,'category_beverages','category_beverages_desc',7,'/assets/images/categories/beverages.jpg',1,NULL,'2025-09-19 14:10:12','2025-09-19 14:10:12',NULL,NULL);
INSERT INTO "MenuCategories" VALUES (15,'category_chinese_rice','category_chinese_rice_desc',1,'/assets/images/categories/chinese-rice.jpg',1,NULL,'2025-09-19 14:10:12','2025-09-19 14:10:12',NULL,NULL);
INSERT INTO "MenuCategories" VALUES (16,'category_chinese_noodles','category_chinese_noodles_desc',2,'/assets/images/categories/chinese-noodles.jpg',1,NULL,'2025-09-19 14:10:12','2025-09-19 14:10:12',NULL,NULL);
INSERT INTO "MenuCategories" VALUES (17,'category_chinese_soup','category_chinese_soup_desc',3,'/assets/images/categories/chinese-soup.jpg',1,NULL,'2025-09-19 14:10:12','2025-09-19 14:10:12',NULL,NULL);
INSERT INTO "MenuCategories" VALUES (18,'category_chinese_starters','category_chinese_starters_desc',4,'/assets/images/categories/chinese-starters.jpg',1,NULL,'2025-09-19 14:10:12','2025-09-19 14:10:12',NULL,NULL);
INSERT INTO "MenuCategories" VALUES (19,'category_chinese_main','category_chinese_main_desc',5,'/assets/images/categories/chinese-main.jpg',1,NULL,'2025-09-19 14:10:12','2025-09-19 14:10:12',NULL,NULL);
INSERT INTO "MenuCategories" VALUES (20,'category_chinese_desserts','category_chinese_desserts_desc',6,'/assets/images/categories/chinese-desserts.jpg',1,NULL,'2025-09-19 14:10:12','2025-09-19 14:10:12',NULL,NULL);
INSERT INTO "MenuCategories" VALUES (21,'category_beverages','category_beverages_desc',7,'/assets/images/categories/beverages.jpg',1,NULL,'2025-09-19 14:10:12','2025-09-19 14:10:12',NULL,NULL);
INSERT INTO "MenuCategories" VALUES (22,'category_indian_bread','category_indian_bread_desc',1,'/assets/images/categories/indian-bread.jpg',1,NULL,'2025-09-19 14:10:12','2025-09-19 14:10:12',NULL,NULL);
INSERT INTO "MenuCategories" VALUES (23,'category_indian_curry','category_indian_curry_desc',2,'/assets/images/categories/indian-curry.jpg',1,NULL,'2025-09-19 14:10:12','2025-09-19 14:10:12',NULL,NULL);
INSERT INTO "MenuCategories" VALUES (24,'category_indian_tandoor','category_indian_tandoor_desc',3,'/assets/images/categories/indian-tandoor.jpg',1,NULL,'2025-09-19 14:10:12','2025-09-19 14:10:12',NULL,NULL);
INSERT INTO "MenuCategories" VALUES (25,'category_indian_rice','category_indian_rice_desc',4,'/assets/images/categories/indian-rice.jpg',1,NULL,'2025-09-19 14:10:12','2025-09-19 14:10:12',NULL,NULL);
INSERT INTO "MenuCategories" VALUES (26,'category_indian_starters','category_indian_starters_desc',5,'/assets/images/categories/indian-starters.jpg',1,NULL,'2025-09-19 14:10:12','2025-09-19 14:10:12',NULL,NULL);
INSERT INTO "MenuCategories" VALUES (27,'category_indian_desserts','category_indian_desserts_desc',6,'/assets/images/categories/indian-desserts.jpg',1,NULL,'2025-09-19 14:10:12','2025-09-19 14:10:12',NULL,NULL);
INSERT INTO "MenuCategories" VALUES (28,'category_beverages','category_beverages_desc',7,'/assets/images/categories/beverages.jpg',1,NULL,'2025-09-19 14:10:12','2025-09-19 14:10:12',NULL,NULL);
INSERT INTO "MenuCategories" VALUES (29,'category_pizza','category_pizza_desc',1,'/assets/images/categories/pizza.jpg',1,NULL,'2025-09-19 14:10:12','2025-09-19 14:10:12',NULL,NULL);
INSERT INTO "MenuCategories" VALUES (30,'category_pasta','category_pasta_desc',2,'/assets/images/categories/pasta.jpg',1,NULL,'2025-09-19 14:10:12','2025-09-19 14:10:12',NULL,NULL);
INSERT INTO "MenuCategories" VALUES (31,'category_salad','category_salad_desc',3,'/assets/images/categories/salad.jpg',1,NULL,'2025-09-19 14:10:12','2025-09-19 14:10:12',NULL,NULL);
INSERT INTO "MenuCategories" VALUES (32,'category_italian_starters','category_italian_starters_desc',4,'/assets/images/categories/italian-starters.jpg',1,NULL,'2025-09-19 14:10:12','2025-09-19 14:10:12',NULL,NULL);
INSERT INTO "MenuCategories" VALUES (33,'category_italian_main','category_italian_main_desc',5,'/assets/images/categories/italian-main.jpg',1,NULL,'2025-09-19 14:10:12','2025-09-19 14:10:12',NULL,NULL);
INSERT INTO "MenuCategories" VALUES (34,'category_italian_desserts','category_italian_desserts_desc',6,'/assets/images/categories/italian-desserts.jpg',1,NULL,'2025-09-19 14:10:12','2025-09-19 14:10:12',NULL,NULL);
INSERT INTO "MenuCategories" VALUES (35,'category_beverages','category_beverages_desc',7,'/assets/images/categories/beverages.jpg',1,NULL,'2025-09-19 14:10:12','2025-09-19 14:10:12',NULL,NULL);
INSERT INTO "MenuCategories" VALUES (36,'category_sushi','category_sushi_desc',1,'/assets/images/categories/sushi.jpg',1,NULL,'2025-09-19 14:10:12','2025-09-19 14:10:12',NULL,NULL);
INSERT INTO "MenuCategories" VALUES (37,'category_ramen','category_ramen_desc',2,'/assets/images/categories/ramen.jpg',1,NULL,'2025-09-19 14:10:12','2025-09-19 14:10:12',NULL,NULL);
INSERT INTO "MenuCategories" VALUES (38,'category_tepanyaki','category_tepanyaki_desc',3,'/assets/images/categories/tepanyaki.jpg',1,NULL,'2025-09-19 14:10:12','2025-09-19 14:10:12',NULL,NULL);
INSERT INTO "MenuCategories" VALUES (39,'category_japanese_starters','category_japanese_starters_desc',4,'/assets/images/categories/japanese-starters.jpg',1,NULL,'2025-09-19 14:10:12','2025-09-19 14:10:12',NULL,NULL);
INSERT INTO "MenuCategories" VALUES (40,'category_japanese_bento','category_japanese_bento_desc',5,'/assets/images/categories/japanese-bento.jpg',1,NULL,'2025-09-19 14:10:12','2025-09-19 14:10:12',NULL,NULL);
INSERT INTO "MenuCategories" VALUES (41,'category_japanese_desserts','category_japanese_desserts_desc',6,'/assets/images/categories/japanese-desserts.jpg',1,NULL,'2025-09-19 14:10:12','2025-09-19 14:10:12',NULL,NULL);
INSERT INTO "MenuCategories" VALUES (42,'category_beverages','category_beverages_desc',7,'/assets/images/categories/beverages.jpg',1,NULL,'2025-09-19 14:10:12','2025-09-19 14:10:12',NULL,NULL);
INSERT INTO "MenuItems_Global" VALUES (1,1,'FF-BURGER-001','item_beef_burger','item_beef_burger_desc','/assets/images/items/beef-burger.jpg','["Beef", "Fast Food"]','["Gluten"]',15,'["Halal"]',1,'2025-09-19 14:10:12','2025-09-19 14:10:12',NULL,NULL);
INSERT INTO "MenuItems_Global" VALUES (2,1,'FF-BURGER-002','item_chicken_burger','item_chicken_burger_desc','/assets/images/items/chicken-burger.jpg','["Chicken", "Fast Food"]','["Gluten"]',12,'["Halal"]',1,'2025-09-19 14:10:12','2025-09-19 14:10:12',NULL,NULL);
INSERT INTO "MenuItems_Global" VALUES (3,1,'FF-BURGER-003','item_cheese_burger','item_cheese_burger_desc','/assets/images/items/cheese-burger.jpg','["Beef", "Cheese"]','["Gluten", "Dairy"]',20,'["Halal"]',1,'2025-09-19 14:10:12','2025-09-19 14:10:12',NULL,NULL);
INSERT INTO "MenuItems_Global" VALUES (4,1,'FF-BURGER-004','item_fish_burger','item_fish_burger_desc','/assets/images/items/fish-burger.jpg','["Fish", "Fast Food"]','["Gluten", "Seafood"]',18,NULL,1,'2025-09-19 14:10:12','2025-09-19 14:10:12',NULL,NULL);
INSERT INTO "MenuItems_Global" VALUES (5,1,'FF-BURGER-005','item_veggie_burger','item_veggie_burger_desc','/assets/images/items/veggie-burger.jpg','["Vegetarian", "Plant-based"]','["Gluten"]',16,'["Vegetarian"]',1,'2025-09-19 14:10:12','2025-09-19 14:10:12',NULL,NULL);
INSERT INTO "MenuItems_Global" VALUES (6,2,'FF-SANDWICH-001','item_chicken_sandwich','item_chicken_sandwich_desc','/assets/images/items/chicken-sandwich.jpg','["Chicken", "Grilled"]','["Gluten"]',10,'["Halal"]',1,'2025-09-19 14:10:12','2025-09-19 14:10:12',NULL,NULL);
INSERT INTO "MenuItems_Global" VALUES (7,2,'FF-SANDWICH-002','item_club_sandwich','item_club_sandwich_desc','/assets/images/items/club-sandwich.jpg','["Chicken", "Bacon"]','["Gluten"]',15,NULL,1,'2025-09-19 14:10:12','2025-09-19 14:10:12',NULL,NULL);
INSERT INTO "MenuItems_Global" VALUES (8,2,'FF-SANDWICH-003','item_tuna_sandwich','item_tuna_sandwich_desc','/assets/images/items/tuna-sandwich.jpg','["Fish", "Sandwich"]','["Gluten", "Seafood"]',14,NULL,1,'2025-09-19 14:10:12','2025-09-19 14:10:12',NULL,NULL);
INSERT INTO "MenuItems_Global" VALUES (9,3,'FF-FRIES-001','item_french_fries','item_french_fries_desc','/assets/images/items/french-fries.jpg','["Vegetarian", "Fast Food"]',NULL,5,'["Vegetarian"]',1,'2025-09-19 14:10:12','2025-09-19 14:10:12',NULL,NULL);
INSERT INTO "MenuItems_Global" VALUES (10,3,'FF-FRIES-002','item_crispy_chicken','item_crispy_chicken_desc','/assets/images/items/crispy-chicken.jpg','["Chicken", "Spicy"]','["Gluten"]',12,'["Halal"]',1,'2025-09-19 14:10:12','2025-09-19 14:10:12',NULL,NULL);
INSERT INTO "MenuItems_Global" VALUES (11,3,'FF-FRIES-003','item_onion_rings','item_onion_rings_desc','/assets/images/items/onion-rings.jpg','["Vegetarian", "Appetizer"]','["Gluten"]',8,'["Vegetarian"]',1,'2025-09-19 14:10:12','2025-09-19 14:10:12',NULL,NULL);
INSERT INTO "MenuItems_Global" VALUES (12,3,'FF-FRIES-004','item_mozzarella_sticks','item_mozzarella_sticks_desc','/assets/images/items/mozzarella-sticks.jpg','["Vegetarian", "Cheese"]','["Gluten", "Dairy"]',10,'["Vegetarian"]',1,'2025-09-19 14:10:12','2025-09-19 14:10:12',NULL,NULL);
INSERT INTO "MenuItems_Global" VALUES (13,4,'FF-HOTDOG-001','item_hot_dog','item_hot_dog_desc','/assets/images/items/hot-dog.jpg','["Beef", "Fast Food"]','["Gluten"]',8,'["Halal"]',1,'2025-09-19 14:10:12','2025-09-19 14:10:12',NULL,NULL);
INSERT INTO "MenuItems_Global" VALUES (14,4,'FF-HOTDOG-002','item_chili_dog','item_chili_dog_desc','/assets/images/items/chili-dog.jpg','["Beef", "Spicy"]','["Gluten"]',12,'["Halal"]',1,'2025-09-19 14:10:12','2025-09-19 14:10:12',NULL,NULL);
INSERT INTO "MenuItems_Global" VALUES (15,5,'FF-WRAP-001','item_chicken_wrap','item_chicken_wrap_desc','/assets/images/items/chicken-wrap.jpg','["Chicken", "Wrap"]','["Gluten"]',14,'["Halal"]',1,'2025-09-19 14:10:12','2025-09-19 14:10:12',NULL,NULL);
INSERT INTO "MenuItems_Global" VALUES (16,5,'FF-WRAP-002','item_veggie_wrap','item_veggie_wrap_desc','/assets/images/items/veggie-wrap.jpg','["Vegetarian", "Healthy"]','["Gluten"]',12,'["Vegetarian"]',1,'2025-09-19 14:10:12','2025-09-19 14:10:12',NULL,NULL);
INSERT INTO "MenuItems_Global" VALUES (17,6,'FF-DESSERT-001','item_chocolate_shake','item_chocolate_shake_desc','/assets/images/items/chocolate-shake.jpg','["Dessert", "Chocolate"]','["Dairy"]',8,'["Vegetarian"]',1,'2025-09-19 14:10:12','2025-09-19 14:10:12',NULL,NULL);
INSERT INTO "MenuItems_Global" VALUES (18,6,'FF-DESSERT-002','item_vanilla_shake','item_vanilla_shake_desc','/assets/images/items/vanilla-shake.jpg','["Dessert", "Vanilla"]','["Dairy"]',8,'["Vegetarian"]',1,'2025-09-19 14:10:12','2025-09-19 14:10:12',NULL,NULL);
INSERT INTO "MenuItems_Global" VALUES (19,8,'DS-RICE-001','item_biryani','item_biryani_desc','/assets/images/items/biryani.jpg','["Mutton", "Rice Dish"]','["Nuts"]',30,'["Halal"]',1,'2025-09-19 14:10:12','2025-09-19 14:10:12',NULL,NULL);
INSERT INTO "MenuItems_Global" VALUES (20,8,'DS-RICE-002','item_morog_polao','item_morog_polao_desc','/assets/images/items/morog-polao.jpg','["Chicken", "Rice Dish"]','["Nuts"]',28,'["Halal"]',1,'2025-09-19 14:10:12','2025-09-19 14:10:12',NULL,NULL);
INSERT INTO "MenuItems_Global" VALUES (21,8,'DS-RICE-003','item_tehari','item_tehari_desc','/assets/images/items/tehari.jpg','["Beef", "Rice Dish"]','["Gluten"]',25,'["Halal"]',1,'2025-09-19 14:10:12','2025-09-19 14:10:12',NULL,NULL);
INSERT INTO "MenuItems_Global" VALUES (22,8,'DS-RICE-004','item_kacchi_gosht','item_kacchi_gosht_desc','/assets/images/items/kacchi-gosht.jpg','["Beef", "Traditional"]','["Gluten"]',32,'["Halal"]',1,'2025-09-19 14:10:12','2025-09-19 14:10:12',NULL,NULL);
INSERT INTO "MenuItems_Global" VALUES (23,9,'DS-CURRY-001','item_bhuna_khichuri','item_bhuna_khichuri_desc','/assets/images/items/bhuna-khichuri.jpg','["Beef", "Rice Dish"]','["Gluten"]',25,'["Halal"]',1,'2025-09-19 14:10:12','2025-09-19 14:10:12',NULL,NULL);
INSERT INTO "MenuItems_Global" VALUES (24,9,'DS-CURRY-002','item_chicken_rezala','item_chicken_rezala_desc','/assets/images/items/chicken-rezala.jpg','["Chicken", "Mild"]','["Dairy"]',15,'["Halal"]',1,'2025-09-19 14:10:12','2025-09-19 14:10:12',NULL,NULL);
INSERT INTO "MenuItems_Global" VALUES (25,9,'DS-CURRY-003','item_chicken_korma','item_chicken_korma_desc','/assets/images/items/chicken-korma.jpg','["Chicken", "Creamy"]','["Dairy", "Nuts"]',18,'["Halal"]',1,'2025-09-19 14:10:12','2025-09-19 14:10:12',NULL,NULL);
INSERT INTO "MenuItems_Global" VALUES (26,9,'DS-CURRY-004','item_beef_bhuna','item_beef_bhuna_desc','/assets/images/items/beef-bhuna.jpg','["Beef", "Spicy"]','["Gluten"]',20,'["Halal"]',1,'2025-09-19 14:10:12','2025-09-19 14:10:12',NULL,NULL);
INSERT INTO "MenuItems_Global" VALUES (27,9,'DS-CURRY-005','item_mutton_curry','item_mutton_curry_desc','/assets/images/items/mutton-curry.jpg','["Mutton", "Spicy"]',NULL,24,'["Halal"]',1,'2025-09-19 14:10:12','2025-09-19 14:10:12',NULL,NULL);
INSERT INTO "MenuItems_Global" VALUES (28,10,'DS-KABAB-001','item_seekh_kabab','item_seekh_kabab_desc','/assets/images/items/seekh-kabab.jpg','["Beef", "Grilled"]',NULL,20,'["Halal"]',1,'2025-09-19 14:10:12','2025-09-19 14:10:12',NULL,NULL);
INSERT INTO "MenuItems_Global" VALUES (29,10,'DS-KABAB-002','item_chapli_kabab','item_chapli_kabab_desc','/assets/images/items/chapli-kabab.jpg','["Beef", "Spicy"]',NULL,18,'["Halal"]',1,'2025-09-19 14:10:12','2025-09-19 14:10:12',NULL,NULL);
INSERT INTO "MenuItems_Global" VALUES (30,10,'DS-KABAB-003','item_shami_kabab','item_shami_kabab_desc','/assets/images/items/shami-kabab.jpg','["Beef", "Lentil"]','["Gluten"]',16,'["Halal"]',1,'2025-09-19 14:10:12','2025-09-19 14:10:12',NULL,NULL);
INSERT INTO "MenuItems_Global" VALUES (31,11,'DS-BREAD-001','item_paratha','item_paratha_desc','/assets/images/items/paratha.jpg','["Bread", "Vegetarian"]','["Gluten"]',8,'["Vegetarian"]',1,'2025-09-19 14:10:12','2025-09-19 14:10:12',NULL,NULL);
INSERT INTO "MenuItems_Global" VALUES (32,11,'DS-BREAD-002','item_luchi','item_luchi_desc','/assets/images/items/luchi.jpg','["Bread", "Vegetarian"]','["Gluten"]',6,'["Vegetarian"]',1,'2025-09-19 14:10:12','2025-09-19 14:10:12',NULL,NULL);
INSERT INTO "MenuItems_Global" VALUES (33,11,'DS-BREAD-003','item_ruti','item_ruti_desc','/assets/images/items/ruti.jpg','["Bread", "Whole Wheat"]','["Gluten"]',5,'["Vegetarian"]',1,'2025-09-19 14:10:12','2025-09-19 14:10:12',NULL,NULL);
INSERT INTO "MenuItems_Global" VALUES (34,12,'DS-STARTER-001','item_beguni','item_beguni_desc','/assets/images/items/beguni.jpg','["Vegetarian", "Appetizer"]','["Gluten"]',6,'["Vegetarian"]',1,'2025-09-19 14:10:12','2025-09-19 14:10:12',NULL,NULL);
INSERT INTO "MenuItems_Global" VALUES (35,12,'DS-STARTER-002','item_chop','item_chop_desc','/assets/images/items/chop.jpg','["Vegetarian", "Potato"]','["Gluten"]',8,'["Vegetarian"]',1,'2025-09-19 14:10:12','2025-09-19 14:10:12',NULL,NULL);
INSERT INTO "MenuItems_Global" VALUES (36,12,'DS-STARTER-003','item_singara','item_singara_desc','/assets/images/items/singara.jpg','["Vegetarian", "Snack"]','["Gluten"]',10,'["Vegetarian"]',1,'2025-09-19 14:10:12','2025-09-19 14:10:12',NULL,NULL);
INSERT INTO "MenuItems_Global" VALUES (37,12,'DS-STARTER-004','item_fuchka','item_fuchka_desc','/assets/images/items/fuchka.jpg','["Vegetarian", "Street Food"]',NULL,12,'["Vegetarian"]',1,'2025-09-19 14:10:12','2025-09-19 14:10:12',NULL,NULL);
INSERT INTO "MenuItems_Global" VALUES (38,13,'DS-DESSERT-001','item_rasmalai','item_rasmalai_desc','/assets/images/items/rasmalai.jpg','["Dessert", "Dairy"]','["Dairy"]',15,'["Vegetarian"]',1,'2025-09-19 14:10:12','2025-09-19 14:10:12',NULL,NULL);
INSERT INTO "MenuItems_Global" VALUES (39,13,'DS-DESSERT-002','item_mishti_doi','item_mishti_doi_desc','/assets/images/items/mishti-doi.jpg','["Dessert", "Yogurt"]','["Dairy"]',12,'["Vegetarian"]',1,'2025-09-19 14:10:12','2025-09-19 14:10:12',NULL,NULL);
INSERT INTO "MenuItems_Global" VALUES (40,13,'DS-DESSERT-003','item_chomchom','item_chomchom_desc','/assets/images/items/chomchom.jpg','["Dessert", "Sweet"]','["Dairy"]',18,'["Vegetarian"]',1,'2025-09-19 14:10:12','2025-09-19 14:10:12',NULL,NULL);
INSERT INTO "MenuItems_Global" VALUES (41,13,'DS-DESSERT-004','item_shondesh','item_shondesh_desc','/assets/images/items/shondesh.jpg','["Dessert", "Traditional"]','["Dairy"]',14,'["Vegetarian"]',1,'2025-09-19 14:10:12','2025-09-19 14:10:12',NULL,NULL);
INSERT INTO "MenuItems_Global" VALUES (42,15,'CN-RICE-001','item_chicken_fried_rice','item_chicken_fried_rice_desc','/assets/images/items/chicken-fried-rice.jpg','["Chicken", "Rice Dish"]',NULL,15,'["Halal"]',1,'2025-09-19 14:10:12','2025-09-19 14:10:12',NULL,NULL);
INSERT INTO "MenuItems_Global" VALUES (43,15,'CN-RICE-002','item_veg_fried_rice','item_veg_fried_rice_desc','/assets/images/items/veg-fried-rice.jpg','["Vegetarian", "Rice Dish"]',NULL,12,'["Vegetarian"]',1,'2025-09-19 14:10:12','2025-09-19 14:10:12',NULL,NULL);
INSERT INTO "MenuItems_Global" VALUES (44,15,'CN-RICE-003','item_szechuan_rice','item_szechuan_rice_desc','/assets/images/items/szechuan-rice.jpg','["Spicy", "Rice Dish"]',NULL,16,'["Vegetarian"]',1,'2025-09-19 14:10:12','2025-09-19 14:10:12',NULL,NULL);
INSERT INTO "MenuItems_Global" VALUES (45,15,'CN-RICE-004','item_egg_fried_rice','item_egg_fried_rice_desc','/assets/images/items/egg-fried-rice.jpg','["Egg", "Rice Dish"]',NULL,13,NULL,1,'2025-09-19 14:10:12','2025-09-19 14:10:12',NULL,NULL);
INSERT INTO "MenuItems_Global" VALUES (46,16,'CN-NOODLES-001','item_chowmein','item_chowmein_desc','/assets/images/items/chowmein.jpg','["Chicken", "Noodles"]','["Gluten"]',15,'["Halal"]',1,'2025-09-19 14:10:12','2025-09-19 14:10:12',NULL,NULL);
INSERT INTO "MenuItems_Global" VALUES (47,16,'CN-NOODLES-002','item_hakka_noodles','item_hakka_noodles_desc','/assets/images/items/hakka-noodles.jpg','["Vegetarian", "Noodles"]','["Gluten"]',14,'["Vegetarian"]',1,'2025-09-19 14:10:12','2025-09-19 14:10:12',NULL,NULL);
INSERT INTO "MenuItems_Global" VALUES (48,16,'CN-NOODLES-003','item_singapore_noodles','item_singapore_noodles_desc','/assets/images/items/singapore-noodles.jpg','["Vegetarian", "Noodles"]','["Gluten"]',16,'["Vegetarian"]',1,'2025-09-19 14:10:12','2025-09-19 14:10:12',NULL,NULL);
INSERT INTO "MenuItems_Global" VALUES (49,16,'CN-NOODLES-004','item_schezwan_noodles','item_schezwan_noodles_desc','/assets/images/items/schezwan-noodles.jpg','["Spicy", "Noodles"]','["Gluten"]',17,'["Vegetarian"]',1,'2025-09-19 14:10:12','2025-09-19 14:10:12',NULL,NULL);
INSERT INTO "MenuItems_Global" VALUES (50,17,'CN-SOUP-001','item_hot_and_sour_soup','item_hot_and_sour_soup_desc','/assets/images/items/hot-sour-soup.jpg','["Chicken", "Spicy"]',NULL,10,'["Halal"]',1,'2025-09-19 14:10:12','2025-09-19 14:10:12',NULL,NULL);
INSERT INTO "MenuItems_Global" VALUES (51,17,'CN-SOUP-002','item_wanton_soup','item_wanton_soup_desc','/assets/images/items/wanton-soup.jpg','["Pork", "Soup"]','["Gluten"]',12,NULL,1,'2025-09-19 14:10:12','2025-09-19 14:10:12',NULL,NULL);
INSERT INTO "MenuItems_Global" VALUES (52,17,'CN-SOUP-003','item_sweetcorn_soup','item_sweetcorn_soup_desc','/assets/images/items/sweetcorn-soup.jpg','["Chicken", "Creamy"]','["Dairy"]',11,'["Halal"]',1,'2025-09-19 14:10:12','2025-09-19 14:10:12',NULL,NULL);
INSERT INTO "MenuItems_Global" VALUES (53,17,'CN-SOUP-004','item_tomato_soup','item_tomato_soup_desc','/assets/images/items/tomato-soup.jpg','["Vegetarian", "Soup"]',NULL,9,'["Vegetarian"]',1,'2025-09-19 14:10:12','2025-09-19 14:10:12',NULL,NULL);
INSERT INTO "MenuItems_Global" VALUES (54,18,'CN-STARTER-001','item_spring_rolls','item_spring_rolls_desc','/assets/images/items/spring-rolls.jpg','["Vegetarian", "Appetizer"]','["Gluten"]',10,'["Vegetarian"]',1,'2025-09-19 14:10:12','2025-09-19 14:10:12',NULL,NULL);
INSERT INTO "MenuItems_Global" VALUES (55,18,'CN-STARTER-002','item_dumplings','item_dumplings_desc','/assets/images/items/dumplings.jpg','["Pork", "Appetizer"]','["Gluten"]',14,NULL,1,'2025-09-19 14:10:12','2025-09-19 14:10:12',NULL,NULL);
INSERT INTO "MenuItems_Global" VALUES (56,19,'CN-MAIN-001','item_chili_chicken','item_chili_chicken_desc','/assets/images/items/chili-chicken.jpg','["Chicken", "Spicy"]',NULL,15,'["Halal"]',1,'2025-09-19 14:10:12','2025-09-19 14:10:12',NULL,NULL);
INSERT INTO "MenuItems_Global" VALUES (57,19,'CN-MAIN-002','item_crispy_chili_chicken','item_crispy_chili_chicken_desc','/assets/images/items/crispy-chicken.jpg','["Chicken", "Spicy"]','["Gluten"]',16,'["Halal"]',1,'2025-09-19 14:10:12','2025-09-19 14:10:12',NULL,NULL);
INSERT INTO "MenuItems_Global" VALUES (58,19,'CN-MAIN-003','item_garlic_chicken','item_garlic_chicken_desc','/assets/images/items/garlic-chicken.jpg','["Chicken", "Garlic"]',NULL,14,'["Halal"]',1,'2025-09-19 14:10:12','2025-09-19 14:10:12',NULL,NULL);
INSERT INTO "MenuItems_Global" VALUES (59,19,'CN-MAIN-004','item_manchurian','item_manchurian_desc','/assets/images/items/manchurian.jpg','["Vegetarian", "Cauliflower"]',NULL,12,'["Vegetarian"]',1,'2025-09-19 14:10:12','2025-09-19 14:10:12',NULL,NULL);
INSERT INTO "MenuItems_Global" VALUES (60,19,'CN-MAIN-005','item_paneer_chilli','item_paneer_chilli_desc','/assets/images/items/paneer-chilli.jpg','["Vegetarian", "Paneer"]','["Dairy"]',13,'["Vegetarian"]',1,'2025-09-19 14:10:12','2025-09-19 14:10:12',NULL,NULL);
INSERT INTO "MenuItems_Global" VALUES (61,20,'CN-DESSERT-001','item_fried_ice_cream','item_fried_ice_cream_desc','/assets/images/items/fried-ice-cream.jpg','["Dessert", "Ice Cream"]','["Dairy"]',16,'["Vegetarian"]',1,'2025-09-19 14:10:12','2025-09-19 14:10:12',NULL,NULL);
INSERT INTO "MenuItems_Global" VALUES (62,20,'CN-DESSERT-002','item_darsaan','item_darsaan_desc','/assets/images/items/darsaan.jpg','["Dessert", "Sweet"]','["Gluten", "Dairy"]',14,'["Vegetarian"]',1,'2025-09-19 14:10:12','2025-09-19 14:10:12',NULL,NULL);
INSERT INTO "MenuItems_Global" VALUES (63,22,'IN-BREAD-001','item_naan','item_naan_desc','/assets/images/items/naan.jpg','["Vegetarian", "Bread"]','["Gluten"]',10,'["Vegetarian"]',1,'2025-09-19 14:10:12','2025-09-19 14:10:12',NULL,NULL);
INSERT INTO "MenuItems_Global" VALUES (64,22,'IN-BREAD-002','item_tandoori_roti','item_tandoori_roti_desc','/assets/images/items/tandoori-roti.jpg','["Vegetarian", "Whole Wheat"]','["Gluten"]',8,'["Vegetarian"]',1,'2025-09-19 14:10:12','2025-09-19 14:10:12',NULL,NULL);
INSERT INTO "MenuItems_Global" VALUES (65,22,'IN-BREAD-003','item_garlic_naan','item_garlic_naan_desc','/assets/images/items/garlic-naan.jpg','["Vegetarian", "Garlic"]','["Gluten"]',12,'["Vegetarian"]',1,'2025-09-19 14:10:12','2025-09-19 14:10:12',NULL,NULL);
INSERT INTO "MenuItems_Global" VALUES (66,22,'IN-BREAD-004','item_lachha_paratha','item_lachha_paratha_desc','/assets/images/items/lachha-paratha.jpg','["Vegetarian", "Layered"]','["Gluten"]',14,'["Vegetarian"]',1,'2025-09-19 14:10:12','2025-09-19 14:10:12',NULL,NULL);
INSERT INTO "MenuItems_Global" VALUES (67,23,'IN-CURRY-001','item_butter_chicken','item_butter_chicken_desc','/assets/images/items/butter-chicken.jpg','["Chicken", "Creamy"]','["Dairy"]',20,'["Halal"]',1,'2025-09-19 14:10:12','2025-09-19 14:10:12',NULL,NULL);
INSERT INTO "MenuItems_Global" VALUES (68,23,'IN-CURRY-002','item_chicken_tikka_masala','item_chicken_tikka_masala_desc','/assets/images/items/chicken-tikka-masala.jpg','["Chicken", "Creamy"]','["Dairy", "Nuts"]',22,'["Halal"]',1,'2025-09-19 14:10:12','2025-09-19 14:10:12',NULL,NULL);
INSERT INTO "MenuItems_Global" VALUES (69,23,'IN-CURRY-003','item_rogan_josh','item_rogan_josh_desc','/assets/images/items/rogan-josh.jpg','["Lamb", "Aromatic"]',NULL,26,'["Halal"]',1,'2025-09-19 14:10:12','2025-09-19 14:10:12',NULL,NULL);
INSERT INTO "MenuItems_Global" VALUES (70,23,'IN-CURRY-004','item_dal_makhani','item_dal_makhani_desc','/assets/images/items/dal-makhani.jpg','["Vegetarian", "Lentils"]','["Dairy"]',16,'["Vegetarian"]',1,'2025-09-19 14:10:12','2025-09-19 14:10:12',NULL,NULL);
INSERT INTO "MenuItems_Global" VALUES (71,23,'IN-CURRY-005','item_chana_masala','item_chana_masala_desc','/assets/images/items/chana-masala.jpg','["Vegetarian", "Chickpeas"]',NULL,14,'["Vegetarian"]',1,'2025-09-19 14:10:12','2025-09-19 14:10:12',NULL,NULL);
INSERT INTO "MenuItems_Global" VALUES (72,23,'IN-CURRY-006','item_malai_kofta','item_malai_kofta_desc','/assets/images/items/malai-kofta.jpg','["Vegetarian", "Creamy"]','["Dairy", "Nuts"]',18,'["Vegetarian"]',1,'2025-09-19 14:10:12','2025-09-19 14:10:12',NULL,NULL);
INSERT INTO "MenuItems_Global" VALUES (73,23,'IN-CURRY-007','item_aloo_gobi','item_aloo_gobi_desc','/assets/images/items/aloo-gobi.jpg','["Vegetarian", "Potato"]',NULL,12,'["Vegetarian"]',1,'2025-09-19 14:10:12','2025-09-19 14:10:12',NULL,NULL);
INSERT INTO "MenuItems_Global" VALUES (74,23,'IN-CURRY-008','item_baingan_bharta','item_baingan_bharta_desc','/assets/images/items/baingan-bharta.jpg','["Vegetarian", "Eggplant"]',NULL,14,'["Vegetarian"]',1,'2025-09-19 14:10:12','2025-09-19 14:10:12',NULL,NULL);
INSERT INTO "MenuItems_Global" VALUES (75,23,'IN-CURRY-009','item_palak_paneer','item_palak_paneer_desc','/assets/images/items/palak-paneer.jpg','["Vegetarian", "Spinach"]','["Dairy"]',18,'["Vegetarian"]',1,'2025-09-19 14:10:12','2025-09-19 14:10:12',NULL,NULL);
INSERT INTO "MenuItems_Global" VALUES (76,24,'IN-TANDOOR-001','item_tandoori_chicken','item_tandoori_chicken_desc','/assets/images/items/tandoori-chicken.jpg','["Chicken", "Grilled"]','["Dairy"]',25,'["Halal"]',1,'2025-09-19 14:10:12','2025-09-19 14:10:12',NULL,NULL);
INSERT INTO "MenuItems_Global" VALUES (77,25,'IN-RICE-001','item_pulao','item_pulao_desc','/assets/images/items/pulao.jpg','["Vegetarian", "Rice"]',NULL,14,'["Vegetarian"]',1,'2025-09-19 14:10:12','2025-09-19 14:10:12',NULL,NULL);
INSERT INTO "MenuItems_Global" VALUES (78,25,'IN-RICE-002','item_jeera_rice','item_jeera_rice_desc','/assets/images/items/jeera-rice.jpg','["Vegetarian", "Cumin"]',NULL,12,'["Vegetarian"]',1,'2025-09-19 14:10:12','2025-09-19 14:10:12',NULL,NULL);
INSERT INTO "MenuItems_Global" VALUES (79,25,'IN-RICE-003','item_biryani_rice','item_biryani_rice_desc','/assets/images/items/biryani-rice.jpg','["Meat", "Rice"]','["Nuts"]',28,'["Halal"]',1,'2025-09-19 14:10:12','2025-09-19 14:10:12',NULL,NULL);
INSERT INTO "MenuItems_Global" VALUES (80,26,'IN-STARTER-001','item_samosa','item_samosa_desc','/assets/images/items/samosa.jpg','["Vegetarian", "Potato"]','["Gluten"]',10,'["Vegetarian"]',1,'2025-09-19 14:10:12','2025-09-19 14:10:12',NULL,NULL);
INSERT INTO "MenuItems_Global" VALUES (81,26,'IN-STARTER-002','item_pakora','item_pakora_desc','/assets/images/items/pakora.jpg','["Vegetarian", "Gram Flour"]',NULL,12,'["Vegetarian"]',1,'2025-09-19 14:10:12','2025-09-19 14:10:12',NULL,NULL);
INSERT INTO "MenuItems_Global" VALUES (82,26,'IN-STARTER-003','item_papad','item_papad_desc','/assets/images/items/papad.jpg','["Vegetarian", "Lentil"]',NULL,6,'["Vegetarian"]',1,'2025-09-19 14:10:12','2025-09-19 14:10:12',NULL,NULL);
INSERT INTO "MenuItems_Global" VALUES (83,27,'IN-DESSERT-001','item_gulab_jamun','item_gulab_jamun_desc','/assets/images/items/gulab-jamun.jpg','["Dessert", "Dairy"]','["Dairy"]',16,'["Vegetarian"]',1,'2025-09-19 14:10:12','2025-09-19 14:10:12',NULL,NULL);
INSERT INTO "MenuItems_Global" VALUES (84,27,'IN-DESSERT-002','item_kheer','item_kheer_desc','/assets/images/items/kheer.jpg','["Dessert", "Rice"]','["Dairy", "Nuts"]',14,'["Vegetarian"]',1,'2025-09-19 14:10:12','2025-09-19 14:10:12',NULL,NULL);
INSERT INTO "MenuItems_Global" VALUES (85,27,'IN-DESSERT-003','item_jalebi','item_jalebi_desc','/assets/images/items/jalebi.jpg','["Dessert", "Sweet"]','["Gluten"]',12,'["Vegetarian"]',1,'2025-09-19 14:10:12','2025-09-19 14:10:12',NULL,NULL);
INSERT INTO "MenuItems_Global" VALUES (86,29,'IT-PIZZA-001','item_margherita_pizza','item_margherita_pizza_desc','/assets/images/items/margherita-pizza.jpg','["Vegetarian", "Cheese"]','["Gluten"]',20,'["Vegetarian"]',1,'2025-09-19 14:10:12','2025-09-19 14:10:12',NULL,NULL);
INSERT INTO "MenuItems_Global" VALUES (87,29,'IT-PIZZA-002','item_pepperoni_pizza','item_pepperoni_pizza_desc','/assets/images/items/pepperoni-pizza.jpg','["Pepperoni", "Meat"]','["Gluten"]',24,NULL,1,'2025-09-19 14:10:12','2025-09-19 14:10:12',NULL,NULL);
INSERT INTO "MenuItems_Global" VALUES (88,29,'IT-PIZZA-003','item_hawaiian_pizza','item_hawaiian_pizza_desc','/assets/images/items/hawaiian-pizza.jpg','["Ham", "Pineapple"]','["Gluten"]',22,NULL,1,'2025-09-19 14:10:12','2025-09-19 14:10:12',NULL,NULL);
INSERT INTO "MenuItems_Global" VALUES (89,29,'IT-PIZZA-004','item_veggie_pizza','item_veggie_pizza_desc','/assets/images/items/veggie-pizza.jpg','["Vegetarian", "Vegetables"]','["Gluten"]',22,'["Vegetarian"]',1,'2025-09-19 14:10:12','2025-09-19 14:10:12',NULL,NULL);
INSERT INTO "MenuItems_Global" VALUES (90,29,'IT-PIZZA-005','item_bbq_chicken_pizza','item_bbq_chicken_pizza_desc','/assets/images/items/bbq-chicken-pizza.jpg','["Chicken", "BBQ"]','["Gluten"]',26,'["Halal"]',1,'2025-09-19 14:10:12','2025-09-19 14:10:12',NULL,NULL);
INSERT INTO "MenuItems_Global" VALUES (91,30,'IT-PASTA-001','item_spaghetti_pasta','item_spaghetti_pasta_desc','/assets/images/items/spaghetti-bolognese.jpg','["Beef", "Pasta"]','["Gluten"]',20,'["Halal"]',1,'2025-09-19 14:10:12','2025-09-19 14:10:12',NULL,NULL);
INSERT INTO "MenuItems_Global" VALUES (92,30,'IT-PASTA-002','item_fettuccine_alfredo','item_fettuccine_alfredo_desc','/assets/images/items/fettuccine-alfredo.jpg','["Vegetarian", "Creamy"]','["Gluten", "Dairy"]',18,'["Vegetarian"]',1,'2025-09-19 14:10:12','2025-09-19 14:10:12',NULL,NULL);
INSERT INTO "MenuItems_Global" VALUES (93,30,'IT-PASTA-003','item_penne_arrabbiata','item_penne_arrabbiata_desc','/assets/images/items/penne-arrabbiata.jpg','["Vegetarian", "Spicy"]','["Gluten"]',16,'["Vegetarian"]',1,'2025-09-19 14:10:12','2025-09-19 14:10:12',NULL,NULL);
INSERT INTO "MenuItems_Global" VALUES (94,30,'IT-PASTA-004','item_lasagna','item_lasagna_desc','/assets/images/items/lasagna.jpg','["Beef", "Cheese"]','["Gluten", "Dairy"]',24,'["Halal"]',1,'2025-09-19 14:10:12','2025-09-19 14:10:12',NULL,NULL);
INSERT INTO "MenuItems_Global" VALUES (95,30,'IT-PASTA-005','item_ravioli','item_ravioli_desc','/assets/images/items/ravioli.jpg','["Vegetarian", "Cheese"]','["Gluten", "Dairy"]',20,'["Vegetarian"]',1,'2025-09-19 14:10:12','2025-09-19 14:10:12',NULL,NULL);
INSERT INTO "MenuItems_Global" VALUES (96,31,'IT-SALAD-001','item_caesar_salad','item_caesar_salad_desc','/assets/images/items/caesar-salad.jpg','["Vegetarian", "Healthy"]',NULL,10,'["Vegetarian"]',1,'2025-09-19 14:10:12','2025-09-19 14:10:12',NULL,NULL);
INSERT INTO "MenuItems_Global" VALUES (97,31,'IT-SALAD-002','item_greek_salad','item_greek_salad_desc','/assets/images/items/greek-salad.jpg','["Vegetarian", "Feta"]','["Dairy"]',12,'["Vegetarian"]',1,'2025-09-19 14:10:12','2025-09-19 14:10:12',NULL,NULL);
INSERT INTO "MenuItems_Global" VALUES (98,31,'IT-SALAD-003','item_caprese_salad','item_caprese_salad_desc','/assets/images/items/caprese-salad.jpg','["Vegetarian", "Mozzarella"]','["Dairy"]',14,'["Vegetarian"]',1,'2025-09-19 14:10:12','2025-09-19 14:10:12',NULL,NULL);
INSERT INTO "MenuItems_Global" VALUES (99,31,'IT-SALAD-004','item_antonio_salad','item_antonio_salad_desc','/assets/images/items/antonio-salad.jpg','["Chicken", "Healthy"]',NULL,16,'["Halal"]',1,'2025-09-19 14:10:12','2025-09-19 14:10:12',NULL,NULL);
INSERT INTO "MenuItems_Global" VALUES (100,32,'IT-STARTER-001','item_bruschetta','item_bruschetta_desc','/assets/images/items/bruschetta.jpg','["Vegetarian", "Tomato"]','["Gluten"]',10,'["Vegetarian"]',1,'2025-09-19 14:10:12','2025-09-19 14:10:12',NULL,NULL);
INSERT INTO "MenuItems_Global" VALUES (101,32,'IT-STARTER-002','item_calamari','item_calamari_desc','/assets/images/items/calamari.jpg','["Seafood", "Appetizer"]','["Gluten", "Seafood"]',14,NULL,1,'2025-09-19 14:10:12','2025-09-19 14:10:12',NULL,NULL);
INSERT INTO "MenuItems_Global" VALUES (102,32,'IT-STARTER-003','item_arancini','item_arancini_desc','/assets/images/items/arancini.jpg','["Vegetarian", "Rice"]','["Gluten", "Dairy"]',12,'["Vegetarian"]',1,'2025-09-19 14:10:12','2025-09-19 14:10:12',NULL,NULL);
INSERT INTO "MenuItems_Global" VALUES (103,33,'IT-MAIN-001','item_chicken_marsala','item_chicken_marsala_desc','/assets/images/items/chicken-marsala.jpg','["Chicken", "Mushroom"]','["Dairy"]',24,'["Halal"]',1,'2025-09-19 14:10:12','2025-09-19 14:10:12',NULL,NULL);
INSERT INTO "MenuItems_Global" VALUES (104,33,'IT-MAIN-002','item_veal_scaloppine','item_veal_scaloppine_desc','/assets/images/items/veal-scaloppine.jpg','["Veal", "Lemon"]','["Gluten", "Dairy"]',26,NULL,1,'2025-09-19 14:10:12','2025-09-19 14:10:12',NULL,NULL);
INSERT INTO "MenuItems_Global" VALUES (105,34,'IT-DESSERT-001','item_tiramisu','item_tiramisu_desc','/assets/images/items/tiramisu.jpg','["Dessert", "Coffee"]','["Dairy"]',18,'["Vegetarian"]',1,'2025-09-19 14:10:12','2025-09-19 14:10:12',NULL,NULL);
INSERT INTO "MenuItems_Global" VALUES (106,34,'IT-DESSERT-002','item_panna_cotta','item_panna_cotta_desc','/assets/images/items/panna-cotta.jpg','["Dessert", "Vanilla"]','["Dairy"]',16,'["Vegetarian"]',1,'2025-09-19 14:10:12','2025-09-19 14:10:12',NULL,NULL);
INSERT INTO "MenuItems_Global" VALUES (107,34,'IT-DESSERT-003','item_cannoli','item_cannoli_desc','/assets/images/items/cannoli.jpg','["Dessert", "Ricotta"]','["Gluten", "Dairy"]',16,'["Vegetarian"]',1,'2025-09-19 14:10:12','2025-09-19 14:10:12',NULL,NULL);
INSERT INTO "MenuItems_Global" VALUES (108,34,'IT-DESSERT-004','item_gelato','item_gelato_desc','/assets/images/items/gelato.jpg','["Dessert", "Ice Cream"]','["Dairy"]',14,'["Vegetarian"]',1,'2025-09-19 14:10:12','2025-09-19 14:10:12',NULL,NULL);
INSERT INTO "MenuItems_Global" VALUES (109,36,'JP-SUSHI-001','item_california_roll','item_california_roll_desc','/assets/images/items/california-roll.jpg','["Seafood", "Rice"]','["Gluten"]',25,NULL,1,'2025-09-19 14:10:12','2025-09-19 14:10:12',NULL,NULL);
INSERT INTO "MenuItems_Global" VALUES (110,36,'JP-SUSHI-002','item_salmon_roll','item_salmon_roll_desc','/assets/images/items/salmon-roll.jpg','["Seafood", "Salmon"]','["Gluten"]',28,NULL,1,'2025-09-19 14:10:13','2025-09-19 14:10:13',NULL,NULL);
INSERT INTO "MenuItems_Global" VALUES (111,36,'JP-SUSHI-003','item_tuna_roll','item_tuna_roll_desc','/assets/images/items/tuna-roll.jpg','["Seafood", "Tuna"]','["Gluten"]',26,NULL,1,'2025-09-19 14:10:13','2025-09-19 14:10:13',NULL,NULL);
INSERT INTO "MenuItems_Global" VALUES (112,36,'JP-SUSHI-004','item_rainbow_roll','item_rainbow_roll_desc','/assets/images/items/rainbow-roll.jpg','["Seafood", "Assorted"]','["Gluten"]',32,NULL,1,'2025-09-19 14:10:13','2025-09-19 14:10:13',NULL,NULL);
INSERT INTO "MenuItems_Global" VALUES (113,36,'JP-SUSHI-005','item_dragon_roll','item_dragon_roll_desc','/assets/images/items/dragon-roll.jpg','["Seafood", "Eel"]','["Gluten"]',30,NULL,1,'2025-09-19 14:10:13','2025-09-19 14:10:13',NULL,NULL);
INSERT INTO "MenuItems_Global" VALUES (114,36,'JP-SUSHI-006','item_sashimi_platter','item_sashimi_platter_desc','/assets/images/items/sashimi-platter.jpg','["Seafood", "Raw"]',NULL,35,NULL,1,'2025-09-19 14:10:13','2025-09-19 14:10:13',NULL,NULL);
INSERT INTO "MenuItems_Global" VALUES (115,37,'JP-RAMEN-001','item_chicken_ramen','item_chicken_ramen_desc','/assets/images/items/chicken-ramen.jpg','["Chicken", "Noodles"]','["Gluten"]',22,'["Halal"]',1,'2025-09-19 14:10:13','2025-09-19 14:10:13',NULL,NULL);
INSERT INTO "MenuItems_Global" VALUES (116,37,'JP-RAMEN-002','item_tonkotsu_ramen','item_tonkotsu_ramen_desc','/assets/images/items/tonkotsu-ramen.jpg','["Pork", "Noodles"]','["Gluten"]',24,NULL,1,'2025-09-19 14:10:13','2025-09-19 14:10:13',NULL,NULL);
INSERT INTO "MenuItems_Global" VALUES (117,37,'JP-RAMEN-003','item_udon_noodles','item_udon_noodles_desc','/assets/images/items/udon-noodles.jpg','["Beef", "Noodles"]','["Gluten"]',20,'["Halal"]',1,'2025-09-19 14:10:13','2025-09-19 14:10:13',NULL,NULL);
INSERT INTO "MenuItems_Global" VALUES (118,37,'JP-RAMEN-004','item_yakisoba','item_yakisoba_desc','/assets/images/items/yakisoba.jpg','["Pork", "Noodles"]','["Gluten"]',18,NULL,1,'2025-09-19 14:10:13','2025-09-19 14:10:13',NULL,NULL);
INSERT INTO "MenuItems_Global" VALUES (119,38,'JP-TEPPAN-001','item_tempura','item_tempura_desc','/assets/images/items/tempura.jpg','["Vegetarian", "Fried"]','["Gluten"]',18,'["Vegetarian"]',1,'2025-09-19 14:10:13','2025-09-19 14:10:13',NULL,NULL);
INSERT INTO "MenuItems_Global" VALUES (120,38,'JP-TEPPAN-002','item_shrimp_tempura','item_shrimp_tempura_desc','/assets/images/items/shrimp-tempura.jpg','["Seafood", "Shrimp"]','["Gluten", "Seafood"]',22,NULL,1,'2025-09-19 14:10:13','2025-09-19 14:10:13',NULL,NULL);
INSERT INTO "MenuItems_Global" VALUES (121,38,'JP-TEPPAN-003','item_chicken_katsu','item_chicken_katsu_desc','/assets/images/items/chicken-katsu.jpg','["Chicken", "Fried"]','["Gluten"]',20,'["Halal"]',1,'2025-09-19 14:10:13','2025-09-19 14:10:13',NULL,NULL);
INSERT INTO "MenuItems_Global" VALUES (122,38,'JP-TEPPAN-004','item_tepanyaki_chicken','item_tepanyaki_chicken_desc','/assets/images/items/tepanyaki-chicken.jpg','["Chicken", "Grilled"]',NULL,24,'["Halal"]',1,'2025-09-19 14:10:13','2025-09-19 14:10:13',NULL,NULL);
INSERT INTO "MenuItems_Global" VALUES (123,38,'JP-TEPPAN-005','item_beef_teriyaki','item_beef_teriyaki_desc','/assets/images/items/beef-teriyaki.jpg','["Beef", "Teriyaki"]',NULL,26,'["Halal"]',1,'2025-09-19 14:10:13','2025-09-19 14:10:13',NULL,NULL);
INSERT INTO "MenuItems_Global" VALUES (124,38,'JP-TEPPAN-006','item_salmon_teriyaki','item_salmon_teriyaki_desc','/assets/images/items/salmon-teriyaki.jpg','["Seafood", "Salmon"]',NULL,28,NULL,1,'2025-09-19 14:10:13','2025-09-19 14:10:13',NULL,NULL);
INSERT INTO "MenuItems_Global" VALUES (125,38,'JP-TEPPAN-007','item_tofu_steak','item_tofu_steak_desc','/assets/images/items/tofu-steak.jpg','["Vegetarian", "Tofu"]',NULL,16,'["Vegetarian"]',1,'2025-09-19 14:10:13','2025-09-19 14:10:13',NULL,NULL);
INSERT INTO "MenuItems_Global" VALUES (126,39,'JP-STARTER-001','item_edamame','item_edamame_desc','/assets/images/items/edamame.jpg','["Vegetarian", "Soybeans"]',NULL,8,'["Vegetarian"]',1,'2025-09-19 14:10:13','2025-09-19 14:10:13',NULL,NULL);
INSERT INTO "MenuItems_Global" VALUES (127,39,'JP-STARTER-003','item_miso_soup','item_miso_soup_desc','/assets/images/items/miso-soup.jpg','["Vegetarian", "Soup"]',NULL,10,'["Vegetarian"]',1,'2025-09-19 14:10:13','2025-09-19 14:10:13',NULL,NULL);
INSERT INTO "MenuItems_Global" VALUES (128,40,'JP-BENTO-001','item_chicken_bento','item_chicken_bento_desc','/assets/images/items/chicken-bento.jpg','["Chicken", "Complete Meal"]',NULL,28,'["Halal"]',1,'2025-09-19 14:10:13','2025-09-19 14:10:13',NULL,NULL);
INSERT INTO "MenuItems_Global" VALUES (129,40,'JP-BENTO-002','item_salmon_bento','item_salmon_bento_desc','/assets/images/items/salmon-bento.jpg','["Seafood", "Complete Meal"]',NULL,32,NULL,1,'2025-09-19 14:10:13','2025-09-19 14:10:13',NULL,NULL);
INSERT INTO "MenuItems_Global" VALUES (130,40,'JP-BENTO-003','item_vegetable_bento','item_vegetable_bento_desc','/assets/images/items/vegetable-bento.jpg','["Vegetarian", "Complete Meal"]',NULL,24,'["Vegetarian"]',1,'2025-09-19 14:10:13','2025-09-19 14:10:13',NULL,NULL);
INSERT INTO "MenuItems_Global" VALUES (131,41,'JP-DESSERT-001','item_mochi_ice_cream','item_mochi_ice_cream_desc','/assets/images/items/mochi-ice-cream.jpg','["Dessert", "Rice Cake"]','["Dairy"]',14,'["Vegetarian"]',1,'2025-09-19 14:10:13','2025-09-19 14:10:13',NULL,NULL);
INSERT INTO "MenuItems_Global" VALUES (132,41,'JP-DESSERT-002','item_dorayaki','item_dorayaki_desc','/assets/images/items/dorayaki.jpg','["Dessert", "Red Bean"]','["Gluten"]',12,'["Vegetarian"]',1,'2025-09-19 14:10:13','2025-09-19 14:10:13',NULL,NULL);
INSERT INTO "MenuItems_Global" VALUES (133,41,'JP-DESSERT-003','item_matcha_cake','item_matcha_cake_desc','/assets/images/items/matcha-cake.jpg','["Dessert", "Green Tea"]','["Dairy"]',16,'["Vegetarian"]',1,'2025-09-19 14:10:13','2025-09-19 14:10:13',NULL,NULL);
INSERT INTO "MenuItems_Global" VALUES (134,7,'BV-COKE-001','item_coke','item_coke_desc','/assets/images/items/coke.jpg','["Cold", "Soft Drink"]',NULL,2,NULL,1,'2025-09-19 14:10:13','2025-09-19 14:10:13',NULL,NULL);
INSERT INTO "MenuItems_Global" VALUES (135,14,'BV-LASSI-001','item_mango_lassi','item_mango_lassi_desc','/assets/images/items/mango-lassi.jpg','["Cold", "Dairy"]','["Dairy"]',3,'["Vegetarian"]',1,'2025-09-19 14:10:13','2025-09-19 14:10:13',NULL,NULL);
INSERT INTO "MenuItems_Global" VALUES (136,21,'BV-TEA-001','item_tea','item_tea_desc','/assets/images/items/deshi-tea.jpg','["Hot", "Tea"]','["Dairy"]',3,'["Vegetarian"]',1,'2025-09-19 14:10:13','2025-09-19 14:10:13',NULL,NULL);
INSERT INTO "MenuItems_Global" VALUES (137,28,'BV-BORHANI-001','item_borhani','item_borhani_desc','/assets/images/items/borhani.jpg','["Cold", "Yogurt"]','["Dairy"]',3,'["Vegetarian"]',1,'2025-09-19 14:10:13','2025-09-19 14:10:13',NULL,NULL);
INSERT INTO "MenuItems_Global" VALUES (138,35,'BV-COKE-002','item_coke','item_coke_desc','/assets/images/items/coke.jpg','["Cold", "Soft Drink"]',NULL,2,NULL,1,'2025-09-19 14:10:13','2025-09-19 14:10:13',NULL,NULL);
INSERT INTO "MenuItems_Global" VALUES (139,42,'BV-COKE-003','item_coke','item_coke_desc','/assets/images/items/coke.jpg','["Cold", "Soft Drink"]',NULL,2,NULL,1,'2025-09-19 14:10:13','2025-09-19 14:10:13',NULL,NULL);
INSERT INTO "NotificationTemplates" VALUES (1,'order_confirmed','orders','Order Confirmed','Your order #{order_id} has been confirmed and is being prepared.','success','["order_id", "estimated_time"]',0,'2025-09-19 14:10:07','2025-09-19 14:10:07',NULL);
INSERT INTO "NotificationTemplates" VALUES (2,'order_ready','orders','Order Ready','Your order #{order_id} is ready for pickup/delivery.','success','["order_id", "table_number"]',0,'2025-09-19 14:10:07','2025-09-19 14:10:07',NULL);
INSERT INTO "NotificationTemplates" VALUES (3,'order_delayed','orders','Order Delayed','Your order #{order_id} is experiencing a delay. New estimated time: {new_time}','warning','["order_id", "new_time", "reason"]',0,'2025-09-19 14:10:07','2025-09-19 14:10:07',NULL);
INSERT INTO "NotificationTemplates" VALUES (4,'table_assigned','service','Table Assigned','You have been assigned to table {table_number}.','info','["table_number", "customer_count"]',0,'2025-09-19 14:10:07','2025-09-19 14:10:07',NULL);
INSERT INTO "NotificationTemplates" VALUES (5,'service_request','service','Service Request','Table {table_number} has requested assistance: {request_type}','warning','["table_number", "request_type"]',0,'2025-09-19 14:10:07','2025-09-19 14:10:07',NULL);
INSERT INTO "NotificationTemplates" VALUES (6,'shift_reminder','staff','Shift Reminder','Your shift starts in {time_until} at {start_time}.','info','["time_until", "start_time", "location"]',0,'2025-09-19 14:10:07','2025-09-19 14:10:07',NULL);
INSERT INTO "NotificationTemplates" VALUES (7,'promotion_alert','marketing','New Promotion','New promotion available: {promo_title}. Discount: {discount}%','success','["promo_title", "discount", "valid_until"]',0,'2025-09-19 14:10:07','2025-09-19 14:10:07',NULL);
INSERT INTO "NotificationTemplates" VALUES (8,'inventory_low','inventory','Low Inventory Alert','Item "{item_name}" is running low. Current stock: {current_stock}','warning','["item_name", "current_stock", "reorder_level"]',0,'2025-09-19 14:10:07','2025-09-19 14:10:07',NULL);
INSERT INTO "NotificationTemplates" VALUES (9,'daily_report','reports','Daily Report','Daily sales report is ready. Total orders: {order_count}, Revenue: {revenue}','info','["order_count", "revenue", "report_date"]',0,'2025-09-19 14:10:07','2025-09-19 14:10:07',NULL);
INSERT INTO "NotificationTemplates" VALUES (10,'system_maintenance','system','System Maintenance','System maintenance scheduled for {maintenance_time}. Duration: {duration}','warning','["maintenance_time", "duration", "affected_services"]',0,'2025-09-19 14:10:07','2025-09-19 14:10:07',NULL);
INSERT INTO "NotificationTemplates" VALUES (11,'order_confirmed','order','Order Confirmed','Your order {{order_id}} has been confirmed and is being prepared.','success','{"order_id": "string", "estimated_time": "string"}',0,'2025-09-19 14:10:16','2025-09-19 14:10:16',NULL);
INSERT INTO "NotificationTemplates" VALUES (12,'order_ready','order','Order Ready','Your order {{order_id}} is ready for pickup.','success','{"order_id": "string", "table_number": "string"}',0,'2025-09-19 14:10:16','2025-09-19 14:10:16',NULL);
INSERT INTO "NotificationTemplates" VALUES (13,'order_delayed','order','Order Delayed','Your order {{order_id}} is taking longer than expected. Estimated delay: {{delay_time}} minutes.','warning','{"order_id": "string", "delay_time": "number"}',0,'2025-09-19 14:10:16','2025-09-19 14:10:16',NULL);
INSERT INTO "NotificationTemplates" VALUES (14,'table_service_request','service','Service Request','Table {{table_number}} is requesting assistance: {{request_type}}','info','{"table_number": "string", "request_type": "string"}',0,'2025-09-19 14:10:16','2025-09-19 14:10:16',NULL);
INSERT INTO "NotificationTemplates" VALUES (15,'shift_reminder','staff','Shift Reminder','Your shift starts in {{time_remaining}} minutes at {{branch_name}}.','info','{"time_remaining": "number", "branch_name": "string", "shift_time": "string"}',0,'2025-09-19 14:10:16','2025-09-19 14:10:16',NULL);
INSERT INTO "NotificationTemplates" VALUES (16,'low_inventory','inventory','Low Inventory Alert','Item {{item_name}} is running low. Current stock: {{current_stock}} units.','warning','{"item_name": "string", "current_stock": "number", "branch_name": "string"}',0,'2025-09-19 14:10:16','2025-09-19 14:10:16',NULL);
INSERT INTO "NotificationTemplates" VALUES (17,'new_promotion','marketing','New Promotion','Check out our new promotion: {{promotion_title}}! Valid until {{end_date}}.','info','{"promotion_title": "string", "end_date": "string", "discount_amount": "string"}',0,'2025-09-19 14:10:16','2025-09-19 14:10:16',NULL);
INSERT INTO "NotificationTemplates" VALUES (18,'payment_received','payment','Payment Received','Payment of {{amount}} has been received for order {{order_id}}.','success','{"amount": "string", "order_id": "string", "payment_method": "string"}',0,'2025-09-19 14:10:16','2025-09-19 14:10:16',NULL);
INSERT INTO "NotificationTemplates" VALUES (19,'daily_report','report','Daily Report Ready','Your daily report for {{date}} is ready. Total sales: {{total_sales}}.','info','{"date": "string", "total_sales": "string", "orders_count": "number"}',0,'2025-09-19 14:10:16','2025-09-19 14:10:16',NULL);
INSERT INTO "NotificationTemplates" VALUES (20,'system_maintenance','system','System Maintenance','System maintenance is scheduled for {{maintenance_time}}. Expected downtime: {{duration}}.','warning','{"maintenance_time": "string", "duration": "string"}',0,'2025-09-19 14:10:16','2025-09-19 14:10:16',NULL);
INSERT INTO "OrderItems" VALUES (1,1,1,2,180,'{"cheese": ["cheddar"], "extras": ["bacon"]}',NULL,'completed',NULL,NULL,NULL,1,360,'2025-09-19 14:10:15','2025-09-19 14:10:15');
INSERT INTO "OrderItems" VALUES (2,1,10,2,60,'{"size": "large"}',NULL,'completed',NULL,NULL,NULL,2,120,'2025-09-19 14:10:15','2025-09-19 14:10:15');
INSERT INTO "OrderItems" VALUES (3,2,2,1,150,'{"spice_level": "medium"}',NULL,'completed',NULL,NULL,NULL,1,150,'2025-09-19 14:10:15','2025-09-19 14:10:15');
INSERT INTO "OrderItems" VALUES (4,2,7,1,120,'{"sauce": "garlic_mayo"}',NULL,'completed',NULL,NULL,NULL,2,120,'2025-09-19 14:10:15','2025-09-19 14:10:15');
INSERT INTO "OrderItems" VALUES (5,2,18,2,40,'{"size": "medium"}',NULL,'completed',NULL,NULL,NULL,3,80,'2025-09-19 14:10:15','2025-09-19 14:10:15');
INSERT INTO "OrderItems" VALUES (6,3,19,1,350,'{"serving_size": "double", "extras": ["extra_meat"]}',NULL,'completed',NULL,NULL,NULL,1,350,'2025-09-19 14:10:15','2025-09-19 14:10:15');
INSERT INTO "OrderItems" VALUES (7,3,24,2,220,'{"serving_size": "large"}',NULL,'completed',NULL,NULL,NULL,2,440,'2025-09-19 14:10:15','2025-09-19 14:10:15');
INSERT INTO "OrderItems" VALUES (8,3,38,1,30,'{}',NULL,'completed',NULL,NULL,NULL,3,30,'2025-09-19 14:10:15','2025-09-19 14:10:15');
INSERT INTO "OrderItems" VALUES (9,4,19,2,350,'{"serving_size": "double"}',NULL,'preparing',NULL,NULL,NULL,1,700,'2025-09-19 14:10:15','2025-09-19 14:10:15');
INSERT INTO "OrderItems" VALUES (10,4,28,1,220,'{"serving_size": "six_pieces"}',NULL,'pending',NULL,NULL,NULL,2,220,'2025-09-19 14:10:15','2025-09-19 14:10:15');
INSERT INTO "OrderItems" VALUES (11,5,39,1,180,'{"protein": "chicken", "spice_level": "hot"}',NULL,'completed',NULL,NULL,NULL,1,180,'2025-09-19 14:10:15','2025-09-19 14:10:15');
INSERT INTO "OrderItems" VALUES (12,5,43,1,150,'{"spice_level": "medium"}',NULL,'completed',NULL,NULL,NULL,2,150,'2025-09-19 14:10:15','2025-09-19 14:10:15');
INSERT INTO "OrderItems" VALUES (13,5,47,1,120,'{"serving_size": "large"}',NULL,'completed',NULL,NULL,NULL,3,120,'2025-09-19 14:10:15','2025-09-19 14:10:15');
INSERT INTO "OrderItems" VALUES (14,5,60,1,40,'{"size": "medium"}',NULL,'completed',NULL,NULL,NULL,4,40,'2025-09-19 14:10:15','2025-09-19 14:10:15');
INSERT INTO "OrderItems" VALUES (15,6,65,2,220,'{"serving_size": "large"}',NULL,'completed',NULL,NULL,NULL,1,440,'2025-09-19 14:10:15','2025-09-19 14:10:15');
INSERT INTO "OrderItems" VALUES (16,6,63,1,120,'{"serving_size": "four_pieces"}',NULL,'completed',NULL,NULL,NULL,2,120,'2025-09-19 14:10:15','2025-09-19 14:10:15');
INSERT INTO "OrderItems" VALUES (17,7,89,1,300,'{"size": "medium", "crust": "thin"}',NULL,'completed',NULL,NULL,NULL,1,300,'2025-09-19 14:10:15','2025-09-19 14:10:15');
INSERT INTO "OrderItems" VALUES (18,7,94,1,280,'{"serving_size": "regular", "cheese": "parmesan"}',NULL,'completed',NULL,NULL,NULL,2,280,'2025-09-19 14:10:15','2025-09-19 14:10:15');
INSERT INTO "OrderItems" VALUES (19,7,99,1,180,'{"protein": "chicken"}',NULL,'completed',NULL,NULL,NULL,3,180,'2025-09-19 14:10:15','2025-09-19 14:10:15');
INSERT INTO "OrderItems" VALUES (20,8,112,2,280,'{"serving_size": "eight_pieces"}',NULL,'completed',NULL,NULL,NULL,1,560,'2025-09-19 14:10:15','2025-09-19 14:10:15');
INSERT INTO "OrderItems" VALUES (21,8,118,1,250,'{"spice_level": "medium", "toppings": ["egg"]}',NULL,'completed',NULL,NULL,NULL,2,250,'2025-09-19 14:10:15','2025-09-19 14:10:15');
INSERT INTO "OrderItems" VALUES (22,8,122,1,200,'{"serving_size": "medium"}',NULL,'completed',NULL,NULL,NULL,3,200,'2025-09-19 14:10:16','2025-09-19 14:10:16');
INSERT INTO "OrderItems" VALUES (23,8,125,1,260,'{"serving_size": "large", "sauce": "teriyaki"}',NULL,'completed',NULL,NULL,NULL,4,260,'2025-09-19 14:10:16','2025-09-19 14:10:16');
INSERT INTO "OrderItems" VALUES (24,9,20,1,280,NULL,NULL,'pending',NULL,NULL,'[]',NULL,280,'2025-09-19 15:33:56','2025-09-19 15:33:56');
INSERT INTO "OrderItems" VALUES (25,10,19,1,350,NULL,NULL,'pending',NULL,NULL,'[]',NULL,350,'2025-09-19 16:46:04','2025-09-19 16:46:04');
INSERT INTO "OrderItems" VALUES (26,11,20,1,280,NULL,NULL,'pending',NULL,NULL,'[]',NULL,280,'2025-09-20 07:00:05','2025-09-20 07:00:05');
INSERT INTO "OrderItems" VALUES (27,11,21,1,250,NULL,NULL,'pending',NULL,NULL,'[]',NULL,250,'2025-09-20 07:00:05','2025-09-20 07:00:05');
INSERT INTO "OrderItems" VALUES (28,12,127,1,280,NULL,NULL,'pending',NULL,NULL,'[]',NULL,280,'2025-09-20 07:14:31','2025-09-20 07:14:31');
INSERT INTO "OrderItems" VALUES (29,12,129,1,160,NULL,NULL,'pending',NULL,NULL,'[]',NULL,160,'2025-09-20 07:14:31','2025-09-20 07:14:31');
INSERT INTO "OrderItems" VALUES (30,13,24,1,220,NULL,NULL,'pending',NULL,NULL,'[]',NULL,220,'2025-09-20 07:22:42','2025-09-20 07:22:42');
INSERT INTO "OrderItems" VALUES (31,13,25,1,180,NULL,NULL,'pending',NULL,NULL,'[]',NULL,180,'2025-09-20 07:22:42','2025-09-20 07:22:42');
INSERT INTO "OrderItems" VALUES (32,14,1,1,180,NULL,NULL,'pending',NULL,NULL,'[]',NULL,180,'2025-09-20 08:13:17','2025-09-20 08:13:17');
INSERT INTO "OrderItems" VALUES (33,14,3,1,200,NULL,NULL,'pending',NULL,NULL,'[]',NULL,200,'2025-09-20 08:13:17','2025-09-20 08:13:17');
INSERT INTO "OrderItems" VALUES (34,15,89,1,300,NULL,NULL,'pending',NULL,NULL,'[]',NULL,300,'2025-09-20 08:14:16','2025-09-20 08:14:16');
INSERT INTO "OrderTimeline" VALUES (1,1,'ORDER_PLACED','Order was placed by customer','2025-09-19 14:10:15',NULL,NULL,'2025-09-19 14:10:15','2025-09-19 14:10:15');
INSERT INTO "OrderTimeline" VALUES (2,2,'ORDER_PLACED','Order was placed by customer','2025-09-19 14:10:15',NULL,NULL,'2025-09-19 14:10:15','2025-09-19 14:10:15');
INSERT INTO "OrderTimeline" VALUES (3,3,'ORDER_PLACED','Order was placed by customer','2025-09-19 14:10:15',NULL,NULL,'2025-09-19 14:10:15','2025-09-19 14:10:15');
INSERT INTO "OrderTimeline" VALUES (4,4,'ORDER_PLACED','Order was placed by customer','2025-09-19 14:10:15',NULL,NULL,'2025-09-19 14:10:15','2025-09-19 14:10:15');
INSERT INTO "OrderTimeline" VALUES (5,5,'ORDER_PLACED','Order was placed by customer','2025-09-19 14:10:15',NULL,NULL,'2025-09-19 14:10:15','2025-09-19 14:10:15');
INSERT INTO "OrderTimeline" VALUES (6,6,'ORDER_PLACED','Order was placed by customer','2025-09-19 14:10:15',NULL,NULL,'2025-09-19 14:10:15','2025-09-19 14:10:15');
INSERT INTO "OrderTimeline" VALUES (7,7,'ORDER_PLACED','Order was placed by customer','2025-09-19 14:10:15',NULL,NULL,'2025-09-19 14:10:15','2025-09-19 14:10:15');
INSERT INTO "OrderTimeline" VALUES (8,8,'ORDER_PLACED','Order was placed by customer','2025-09-19 14:10:15',NULL,NULL,'2025-09-19 14:10:15','2025-09-19 14:10:15');
INSERT INTO "OrderTimeline" VALUES (9,9,'ORDER_PLACED','Order was placed by customer','2025-09-19 15:33:56',NULL,NULL,'2025-09-19 15:33:56','2025-09-19 15:33:56');
INSERT INTO "OrderTimeline" VALUES (10,10,'ORDER_PLACED','Order was placed by customer','2025-09-19 16:46:04',NULL,NULL,'2025-09-19 16:46:04','2025-09-19 16:46:04');
INSERT INTO "OrderTimeline" VALUES (11,11,'ORDER_PLACED','Order was placed by customer','2025-09-20 07:00:05',NULL,NULL,'2025-09-20 07:00:05','2025-09-20 07:00:05');
INSERT INTO "OrderTimeline" VALUES (12,11,'ORDER_CANCELLED','Order status changed from pending to cancelled','2025-09-20 07:00:44',NULL,'{"old_status":"pending","new_status":"cancelled"}','2025-09-20 07:00:44','2025-09-20 07:00:44');
INSERT INTO "OrderTimeline" VALUES (13,12,'ORDER_PLACED','Order was placed by customer','2025-09-20 07:14:31',NULL,NULL,'2025-09-20 07:14:31','2025-09-20 07:14:31');
INSERT INTO "OrderTimeline" VALUES (14,12,'ORDER_CANCELLED','Order status changed from pending to cancelled','2025-09-20 07:14:47',NULL,'{"old_status":"pending","new_status":"cancelled"}','2025-09-20 07:14:47','2025-09-20 07:14:47');
INSERT INTO "OrderTimeline" VALUES (15,13,'ORDER_PLACED','Order was placed by customer','2025-09-20 07:22:42',NULL,NULL,'2025-09-20 07:22:42','2025-09-20 07:22:42');
INSERT INTO "OrderTimeline" VALUES (16,14,'ORDER_PLACED','Order was placed by customer','2025-09-20 08:13:17',NULL,NULL,'2025-09-20 08:13:17','2025-09-20 08:13:17');
INSERT INTO "OrderTimeline" VALUES (17,15,'ORDER_PLACED','Order was placed by customer','2025-09-20 08:14:16',NULL,NULL,'2025-09-20 08:14:16','2025-09-20 08:14:16');
INSERT INTO "Orders" VALUES (1,'ORD-FF-1001',1,1,1,NULL,'dine-in','completed',480,72,408,40.8,61.2,50,560,'paid','card',NULL,NULL,NULL,'2025-09-19 17:10:15',21,'Extra cheese please','qr_code','{"vat_pct": 15.0, "service_charge_pct": 10.0}','2025-09-19 14:10:15','2025-09-19 14:10:15',NULL,NULL,NULL,NULL,'normal');
INSERT INTO "Orders" VALUES (2,'ORD-FF-1002',1,5,NULL,NULL,'takeaway','completed',350,0,350,35,52.5,0,437.5,'paid','cash',NULL,NULL,NULL,'2025-09-19 16:55:15',22,'No onions','app','{"vat_pct": 15.0, "service_charge_pct": 10.0}','2025-09-19 14:10:15','2025-09-19 14:10:15',NULL,NULL,NULL,NULL,'normal');
INSERT INTO "Orders" VALUES (3,'ORD-DS-1001',2,NULL,2,NULL,'delivery','completed',800,100,700,70,105,70,945,'paid','mobile_payment','House 25, Road 10, Gulshan-2, Dhaka','2025-09-19 17:10:15','2025-09-19 17:40:15',NULL,23,'Call upon arrival','website','{"vat_pct": 15.0, "service_charge_pct": 10.0}','2025-09-19 14:10:15','2025-09-19 14:10:15',NULL,NULL,NULL,NULL,'normal');
INSERT INTO "Orders" VALUES (4,'ORD-DS-1002',2,3,NULL,NULL,'dine-in','preparing',1000,0,1000,100,150,0,1250,'unpaid',NULL,NULL,NULL,NULL,NULL,24,'Birthday celebration','qr_code','{"vat_pct": 15.0, "service_charge_pct": 10.0}','2025-09-19 14:10:15','2025-09-19 14:10:15',NULL,NULL,NULL,NULL,'normal');
INSERT INTO "Orders" VALUES (5,'ORD-CN-1001',3,2,1,NULL,'dine-in','completed',600,90,510,51,76.5,0,637.5,'paid','card',NULL,NULL,NULL,NULL,25,'Extra spicy please','qr_code','{"vat_pct": 15.0, "service_charge_pct": 10.0}','2025-09-19 14:10:15','2025-09-19 14:10:15',NULL,NULL,NULL,NULL,'normal');
INSERT INTO "Orders" VALUES (6,'ORD-IN-1001',4,NULL,NULL,NULL,'takeaway','completed',300,0,300,30,45,0,375,'paid','cash',NULL,NULL,NULL,'2025-09-19 16:40:15',27,'Less spicy','app','{"vat_pct": 15.0, "service_charge_pct": 10.0}','2025-09-19 14:10:15','2025-09-19 14:10:15',NULL,NULL,NULL,NULL,'normal');
INSERT INTO "Orders" VALUES (7,'ORD-IT-1001',5,4,2,NULL,'dine-in','completed',700,100,600,60,90,0,750,'paid','card',NULL,NULL,NULL,NULL,29,'Anniversary dinner','qr_code','{"vat_pct": 15.0, "service_charge_pct": 10.0}','2025-09-19 14:10:15','2025-09-19 14:10:15',NULL,NULL,NULL,NULL,'normal');
INSERT INTO "Orders" VALUES (8,'ORD-JP-1001',6,NULL,NULL,NULL,'takeaway','completed',250,0,250,25,37.5,0,312.5,'paid','cash',NULL,NULL,NULL,'2025-09-19 16:55:15',31,'Party order','app','{"vat_pct": 15.0, "service_charge_pct": 10.0}','2025-09-19 14:10:15','2025-09-19 14:10:15',NULL,NULL,NULL,NULL,'normal');
INSERT INTO "Orders" VALUES (9,'ORD-68CD77E42F9D8',2,20,NULL,NULL,'dine-in','pending',280,0,280,28,46.2,0,354.2,'unpaid','cash',NULL,NULL,NULL,NULL,NULL,'','qr_code','{"service_charge_percentage":10,"vat_percentage":15,"applied_at":"2025-09-19T17:33:56+02:00"}','2025-09-19 21:33:56','2025-09-19 15:33:56',NULL,NULL,NULL,NULL,'normal');
INSERT INTO "Orders" VALUES (10,'ORD-68CD88CC3E42D',2,11,2,NULL,'dine-in','pending',350,100,250,25,41.25,0,316.25,'unpaid','cash',NULL,NULL,NULL,NULL,NULL,'','qr_code','{"service_charge_percentage":10,"vat_percentage":15,"applied_at":"2025-09-19T18:46:04+02:00"}','2025-09-19 22:46:04','2025-09-19 16:46:04',NULL,NULL,NULL,NULL,'normal');
INSERT INTO "Orders" VALUES (11,'ORD-68CE50F57B004',2,NULL,NULL,NULL,'delivery','cancelled',530,0,530,53,87.45,40,710.45,'unpaid','cash','house 14. road 2',NULL,NULL,NULL,NULL,'','qr_code','{"service_charge_percentage":10,"vat_percentage":15,"applied_at":"2025-09-20T09:00:05+02:00"}','2025-09-20 13:00:05','2025-09-20 13:00:44',NULL,NULL,NULL,NULL,'normal');
INSERT INTO "Orders" VALUES (12,'ORD-68CE545744BBA',6,51,NULL,NULL,'dine-in','cancelled',440,0,440,44,72.6,0,556.6,'unpaid','cash',NULL,NULL,NULL,NULL,NULL,'','qr_code','{"service_charge_percentage":10,"vat_percentage":15,"applied_at":"2025-09-20T09:14:31+02:00"}','2025-09-20 13:14:31','2025-09-20 13:14:47',NULL,NULL,NULL,NULL,'normal');
INSERT INTO "Orders" VALUES (13,'ORD-68CE56424482D',2,20,NULL,NULL,'dine-in','pending',400,0,400,40,66,0,506,'unpaid','cash',NULL,NULL,NULL,NULL,NULL,'','qr_code','{"service_charge_percentage":10,"vat_percentage":15,"applied_at":"2025-09-20T09:22:42+02:00"}','2025-09-20 13:22:42','2025-09-20 07:22:42',NULL,NULL,NULL,NULL,'normal');
INSERT INTO "Orders" VALUES (14,'ORD-68CE621D32D48',1,1,NULL,NULL,'dine-in','pending',380,0,380,38,62.7,0,480.7,'unpaid','cash',NULL,NULL,NULL,NULL,NULL,'','qr_code','{"service_charge_percentage":10,"vat_percentage":15,"applied_at":"2025-09-20T10:13:17+02:00"}','2025-09-20 14:13:17','2025-09-20 08:13:17',NULL,NULL,NULL,NULL,'normal');
INSERT INTO "Orders" VALUES (15,'ORD-68CE625852027',5,50,NULL,NULL,'dine-in','pending',300,0,300,30,49.5,0,379.5,'unpaid','cash',NULL,NULL,NULL,NULL,NULL,'','qr_code','{"service_charge_percentage":10,"vat_percentage":15,"applied_at":"2025-09-20T10:14:16+02:00"}','2025-09-20 14:14:16','2025-09-20 08:14:16',NULL,NULL,NULL,NULL,'normal');
INSERT INTO "PickupQueue" VALUES (1,2,1,NULL,NULL,NULL,NULL,'waiting',0,'app',NULL,'2025-09-19 14:10:15','2025-09-19 14:10:15');
INSERT INTO "PickupQueue" VALUES (2,6,1,NULL,NULL,NULL,NULL,'waiting',0,'app',NULL,'2025-09-19 14:10:15','2025-09-19 14:10:15');
INSERT INTO "PickupQueue" VALUES (3,8,1,NULL,NULL,NULL,NULL,'waiting',0,'app',NULL,'2025-09-19 14:10:15','2025-09-19 14:10:15');
INSERT INTO "Promotion_Branches" VALUES (1,1);
INSERT INTO "Promotion_Branches" VALUES (1,2);
INSERT INTO "Promotion_Branches" VALUES (1,3);
INSERT INTO "Promotion_Branches" VALUES (1,4);
INSERT INTO "Promotion_Branches" VALUES (1,5);
INSERT INTO "Promotion_Branches" VALUES (1,6);
INSERT INTO "Promotion_Branches" VALUES (2,1);
INSERT INTO "Promotion_Branches" VALUES (2,2);
INSERT INTO "Promotion_Branches" VALUES (2,3);
INSERT INTO "Promotion_Branches" VALUES (2,4);
INSERT INTO "Promotion_Branches" VALUES (2,5);
INSERT INTO "Promotion_Branches" VALUES (2,6);
INSERT INTO "Promotion_Items" VALUES (1,19);
INSERT INTO "Promotion_Items" VALUES (1,20);
INSERT INTO "Promotion_Items" VALUES (1,21);
INSERT INTO "Promotion_Items" VALUES (1,22);
INSERT INTO "Promotion_Items" VALUES (1,23);
INSERT INTO "Promotion_Items" VALUES (1,24);
INSERT INTO "Promotion_Items" VALUES (1,25);
INSERT INTO "Promotion_Items" VALUES (1,26);
INSERT INTO "Promotion_Items" VALUES (1,27);
INSERT INTO "Promotion_Items" VALUES (1,39);
INSERT INTO "Promotion_Items" VALUES (1,41);
INSERT INTO "Promotion_Items" VALUES (1,43);
INSERT INTO "Promotion_Items" VALUES (1,53);
INSERT INTO "Promotion_Items" VALUES (1,54);
INSERT INTO "Promotion_Items" VALUES (1,55);
INSERT INTO "Promotion_Items" VALUES (1,65);
INSERT INTO "Promotion_Items" VALUES (1,66);
INSERT INTO "Promotion_Items" VALUES (1,67);
INSERT INTO "Promotion_Items" VALUES (1,76);
INSERT INTO "Promotion_Items" VALUES (1,89);
INSERT INTO "Promotion_Items" VALUES (1,90);
INSERT INTO "Promotion_Items" VALUES (1,91);
INSERT INTO "Promotion_Items" VALUES (1,92);
INSERT INTO "Promotion_Items" VALUES (1,93);
INSERT INTO "Promotion_Items" VALUES (1,94);
INSERT INTO "Promotion_Items" VALUES (1,97);
INSERT INTO "Promotion_Items" VALUES (1,106);
INSERT INTO "Promotion_Items" VALUES (1,107);
INSERT INTO "Promotion_Items" VALUES (1,112);
INSERT INTO "Promotion_Items" VALUES (1,113);
INSERT INTO "Promotion_Items" VALUES (1,114);
INSERT INTO "Promotion_Items" VALUES (1,115);
INSERT INTO "Promotion_Items" VALUES (1,116);
INSERT INTO "Promotion_Items" VALUES (1,118);
INSERT INTO "Promotion_Items" VALUES (1,119);
INSERT INTO "Promotion_Items" VALUES (1,120);
INSERT INTO "Promotion_Items" VALUES (1,126);
INSERT INTO "Promotion_Items" VALUES (1,127);
INSERT INTO "Promotion_Items" VALUES (1,128);
INSERT INTO "Promotion_Items" VALUES (1,129);
INSERT INTO "Promotion_Items" VALUES (2,1);
INSERT INTO "Promotion_Items" VALUES (2,2);
INSERT INTO "Promotion_Items" VALUES (2,3);
INSERT INTO "Promotion_Items" VALUES (2,4);
INSERT INTO "Promotion_Items" VALUES (2,5);
INSERT INTO "Promotion_Items" VALUES (2,6);
INSERT INTO "Promotion_Items" VALUES (2,7);
INSERT INTO "Promotion_Items" VALUES (2,8);
INSERT INTO "Promotion_Items" VALUES (2,9);
INSERT INTO "Promotion_Items" VALUES (2,10);
INSERT INTO "Promotion_Items" VALUES (2,11);
INSERT INTO "Promotion_Items" VALUES (2,12);
INSERT INTO "Promotion_Items" VALUES (2,13);
INSERT INTO "Promotion_Items" VALUES (2,14);
INSERT INTO "Promotion_Items" VALUES (2,15);
INSERT INTO "Promotion_Items" VALUES (2,16);
INSERT INTO "Promotion_Items" VALUES (2,17);
INSERT INTO "Promotion_Items" VALUES (2,18);
INSERT INTO "Promotion_Items" VALUES (2,19);
INSERT INTO "Promotion_Items" VALUES (2,20);
INSERT INTO "Promotion_Items" VALUES (2,21);
INSERT INTO "Promotion_Items" VALUES (2,22);
INSERT INTO "Promotion_Items" VALUES (2,23);
INSERT INTO "Promotion_Items" VALUES (2,24);
INSERT INTO "Promotion_Items" VALUES (2,25);
INSERT INTO "Promotion_Items" VALUES (2,26);
INSERT INTO "Promotion_Items" VALUES (2,27);
INSERT INTO "Promotion_Items" VALUES (2,28);
INSERT INTO "Promotion_Items" VALUES (2,29);
INSERT INTO "Promotion_Items" VALUES (2,30);
INSERT INTO "Promotion_Items" VALUES (2,31);
INSERT INTO "Promotion_Items" VALUES (2,32);
INSERT INTO "Promotion_Items" VALUES (2,33);
INSERT INTO "Promotion_Items" VALUES (2,34);
INSERT INTO "Promotion_Items" VALUES (2,35);
INSERT INTO "Promotion_Items" VALUES (2,36);
INSERT INTO "Promotion_Items" VALUES (2,37);
INSERT INTO "Promotion_Items" VALUES (2,38);
INSERT INTO "Promotion_Items" VALUES (2,39);
INSERT INTO "Promotion_Items" VALUES (2,40);
INSERT INTO "Promotion_Items" VALUES (2,41);
INSERT INTO "Promotion_Items" VALUES (2,42);
INSERT INTO "Promotion_Items" VALUES (2,43);
INSERT INTO "Promotion_Items" VALUES (2,44);
INSERT INTO "Promotion_Items" VALUES (2,45);
INSERT INTO "Promotion_Items" VALUES (2,46);
INSERT INTO "Promotion_Items" VALUES (2,47);
INSERT INTO "Promotion_Items" VALUES (2,48);
INSERT INTO "Promotion_Items" VALUES (2,49);
INSERT INTO "Promotion_Items" VALUES (2,50);
INSERT INTO "Promotion_Items" VALUES (2,51);
INSERT INTO "Promotion_Items" VALUES (2,52);
INSERT INTO "Promotion_Items" VALUES (2,53);
INSERT INTO "Promotion_Items" VALUES (2,54);
INSERT INTO "Promotion_Items" VALUES (2,55);
INSERT INTO "Promotion_Items" VALUES (2,56);
INSERT INTO "Promotion_Items" VALUES (2,57);
INSERT INTO "Promotion_Items" VALUES (2,58);
INSERT INTO "Promotion_Items" VALUES (2,59);
INSERT INTO "Promotion_Items" VALUES (2,61);
INSERT INTO "Promotion_Items" VALUES (2,62);
INSERT INTO "Promotion_Items" VALUES (2,63);
INSERT INTO "Promotion_Items" VALUES (2,64);
INSERT INTO "Promotion_Items" VALUES (2,65);
INSERT INTO "Promotion_Items" VALUES (2,66);
INSERT INTO "Promotion_Items" VALUES (2,67);
INSERT INTO "Promotion_Items" VALUES (2,68);
INSERT INTO "Promotion_Items" VALUES (2,69);
INSERT INTO "Promotion_Items" VALUES (2,70);
INSERT INTO "Promotion_Items" VALUES (2,71);
INSERT INTO "Promotion_Items" VALUES (2,72);
INSERT INTO "Promotion_Items" VALUES (2,73);
INSERT INTO "Promotion_Items" VALUES (2,74);
INSERT INTO "Promotion_Items" VALUES (2,75);
INSERT INTO "Promotion_Items" VALUES (2,76);
INSERT INTO "Promotion_Items" VALUES (2,77);
INSERT INTO "Promotion_Items" VALUES (2,78);
INSERT INTO "Promotion_Items" VALUES (2,79);
INSERT INTO "Promotion_Items" VALUES (2,80);
INSERT INTO "Promotion_Items" VALUES (2,81);
INSERT INTO "Promotion_Items" VALUES (2,82);
INSERT INTO "Promotion_Items" VALUES (2,83);
INSERT INTO "Promotion_Items" VALUES (2,84);
INSERT INTO "Promotion_Items" VALUES (2,85);
INSERT INTO "Promotion_Items" VALUES (2,86);
INSERT INTO "Promotion_Items" VALUES (2,87);
INSERT INTO "Promotion_Items" VALUES (2,88);
INSERT INTO "Promotion_Items" VALUES (2,89);
INSERT INTO "Promotion_Items" VALUES (2,90);
INSERT INTO "Promotion_Items" VALUES (2,91);
INSERT INTO "Promotion_Items" VALUES (2,92);
INSERT INTO "Promotion_Items" VALUES (2,93);
INSERT INTO "Promotion_Items" VALUES (2,94);
INSERT INTO "Promotion_Items" VALUES (2,95);
INSERT INTO "Promotion_Items" VALUES (2,96);
INSERT INTO "Promotion_Items" VALUES (2,97);
INSERT INTO "Promotion_Items" VALUES (2,98);
INSERT INTO "Promotion_Items" VALUES (2,99);
INSERT INTO "Promotion_Items" VALUES (2,100);
INSERT INTO "Promotion_Items" VALUES (2,101);
INSERT INTO "Promotion_Items" VALUES (2,102);
INSERT INTO "Promotion_Items" VALUES (2,103);
INSERT INTO "Promotion_Items" VALUES (2,104);
INSERT INTO "Promotion_Items" VALUES (2,105);
INSERT INTO "Promotion_Items" VALUES (2,106);
INSERT INTO "Promotion_Items" VALUES (2,107);
INSERT INTO "Promotion_Items" VALUES (2,108);
INSERT INTO "Promotion_Items" VALUES (2,109);
INSERT INTO "Promotion_Items" VALUES (2,110);
INSERT INTO "Promotion_Items" VALUES (2,111);
INSERT INTO "Promotion_Items" VALUES (2,112);
INSERT INTO "Promotion_Items" VALUES (2,113);
INSERT INTO "Promotion_Items" VALUES (2,114);
INSERT INTO "Promotion_Items" VALUES (2,115);
INSERT INTO "Promotion_Items" VALUES (2,116);
INSERT INTO "Promotion_Items" VALUES (2,117);
INSERT INTO "Promotion_Items" VALUES (2,118);
INSERT INTO "Promotion_Items" VALUES (2,119);
INSERT INTO "Promotion_Items" VALUES (2,120);
INSERT INTO "Promotion_Items" VALUES (2,121);
INSERT INTO "Promotion_Items" VALUES (2,122);
INSERT INTO "Promotion_Items" VALUES (2,123);
INSERT INTO "Promotion_Items" VALUES (2,124);
INSERT INTO "Promotion_Items" VALUES (2,125);
INSERT INTO "Promotion_Items" VALUES (2,126);
INSERT INTO "Promotion_Items" VALUES (2,127);
INSERT INTO "Promotion_Items" VALUES (2,128);
INSERT INTO "Promotion_Items" VALUES (2,129);
INSERT INTO "Promotion_Items" VALUES (2,131);
INSERT INTO "Promotion_Items" VALUES (2,132);
INSERT INTO "Promotion_Items" VALUES (2,133);
INSERT INTO "Promotion_Items" VALUES (2,134);
INSERT INTO "Promotion_Items" VALUES (2,135);
INSERT INTO "Promotion_Items" VALUES (2,136);
INSERT INTO "Promotion_Items" VALUES (2,137);
INSERT INTO "Promotion_Items" VALUES (2,138);
INSERT INTO "Promotion_Items" VALUES (2,139);
INSERT INTO "Promotions" VALUES (1,'WEEKEND15','promo_weekend_discount','PERCENTAGE',15,500,200,100,0,'2025-09-19 16:10:14','2025-10-19 16:10:14',1,'',1,'2025-09-19 14:10:14','2025-09-19 14:10:14',3,NULL);
INSERT INTO "Promotions" VALUES (2,'FIRSTORDER','promo_first_order','FIXED_AMOUNT',100,300,NULL,50,0,'2025-09-19 16:10:14','2025-11-18 16:10:14',1,1,1,'2025-09-19 14:10:14','2025-09-19 14:10:14',4,NULL);
INSERT INTO "RestaurantDetails" VALUES (1,'Luna Dine','Luna Dine Restaurant Ltd.','Experience culinary excellence under the moonlight. Luna Dine offers a unique dining experience with carefully crafted dishes that blend tradition and innovation.','Dine Under the Stars','/images/restaurant/luna-dine-logo.png','/images/restaurant/luna-dine-cover.jpg','https://lunadine.com','hello@lunadine.com','+8801234567890','LUNA-TAX-2023-001','BDT','Asia/Dhaka','{"facebook": "https://facebook.com/lunadine", "instagram": "https://instagram.com/lunadine", "twitter": "https://twitter.com/lunadine"}','{"monday": "11:00-23:00", "tuesday": "11:00-23:00", "wednesday": "11:00-23:00", "thursday": "11:00-23:00", "friday": "11:00-23:00", "saturday": "11:00-00:00", "sunday": "11:00-23:00"}','House 15, Road 7, Dhanmondi, Dhaka-1205, Bangladesh',23.746466,90.376015,1,'2025-09-19 14:10:07','2025-09-19 14:10:07');
INSERT INTO "Roles" VALUES (1,'ADMIN','{
        "admin_full_access": true,
        "user_view": true, "user_create": true, "user_edit": true, "user_delete": true,
        "role_view": true, "role_create": true, "role_edit": true, "role_delete": true,
        "branch_view": true, "branch_create": true, "branch_edit": true, "branch_delete": true,
        "menu_view": true, "menu_create": true, "menu_edit": true, "menu_delete": true,
        "order_view": true, "order_edit": true, "order_cancel": true,
        "table_view": true, "table_create": true, "table_edit": true, "table_delete": true,
        "promotion_view": true, "promotion_create": true, "promotion_edit": true, "promotion_delete": true,
        "service_view": true, "service_resolve": true,
        "feedback_view": true, "feedback_respond": true,
        "report_view": true, "report_create": true, "report_export": true,
        "notification_view": true, "notification_send": true,
        "dashboard_view": true,
        "settings_view": true, "settings_edit": true
    }','System Administrator with full access to all features',100,'2025-09-19 14:10:07','2025-09-19 14:10:07',1);
INSERT INTO "Roles" VALUES (2,'RESTAURANT_OWNER','{
        "user_view": true, "user_create": true, "user_edit": true,
        "role_view": true,
        "branch_view": true, "branch_create": true, "branch_edit": true,
        "menu_view": true, "menu_create": true, "menu_edit": true,
        "order_view": true, "order_edit": true,
        "table_view": true, "table_create": true, "table_edit": true,
        "promotion_view": true, "promotion_create": true, "promotion_edit": true,
        "service_view": true, "service_resolve": true,
        "feedback_view": true, "feedback_respond": true,
        "report_view": true, "report_create": true, "report_export": true,
        "notification_view": true, "notification_send": true,
        "dashboard_view": true
    }','Restaurant Owner with management access across all branches',90,'2025-09-19 14:10:07','2025-09-19 14:10:07',1);
INSERT INTO "Roles" VALUES (3,'MANAGER','{
        "user_view": true, "user_edit": true,
        "menu_view": true, "menu_edit": true,
        "order_view": true, "order_edit": true,
        "table_view": true, "table_edit": true,
        "promotion_view": true,
        "service_view": true, "service_resolve": true,
        "feedback_view": true, "feedback_respond": true,
        "report_view": true, "report_create": true,
        "notification_view": true, "notification_send": true,
        "dashboard_view": true
    }','Branch Manager with operational management access',80,'2025-09-19 14:10:07','2025-09-19 14:10:07',1);
INSERT INTO "Roles" VALUES (4,'BRANCH_MANAGER','{
        "user_view": true,
        "menu_view": true,
        "order_view": true, "order_edit": true,
        "table_view": true,
        "service_view": true, "service_resolve": true,
        "feedback_view": true,
        "report_view": true,
        "notification_view": true,
        "dashboard_view": true
    }','Branch Manager with day-to-day operational access',70,'2025-09-19 14:10:07','2025-09-19 14:10:07',1);
INSERT INTO "Roles" VALUES (5,'CHEF','{
        "menu_view": true,
        "order_view": true, "order_edit": true,
        "dashboard_view": true
    }','Chef with kitchen management access',60,'2025-09-19 14:10:07','2025-09-19 14:10:07',1);
INSERT INTO "Roles" VALUES (6,'WAITER','{
        "order_view": true, "order_edit": true,
        "table_view": true,
        "service_view": true, "service_resolve": true,
        "dashboard_view": true
    }','Waiter with floor service access',50,'2025-09-19 14:10:07','2025-09-19 14:10:07',1);
INSERT INTO "Roles" VALUES (7,'DELIVERY_RIDER','{
        "order_view": true,
        "dashboard_view": true
    }','Delivery Rider with delivery management access',40,'2025-09-19 14:10:07','2025-09-19 14:10:07',1);
INSERT INTO "Roles" VALUES (8,'RESTAURANT_STAFF','{
        "order_view": true,
        "dashboard_view": true
    }','General Restaurant Staff with basic access',30,'2025-09-19 14:10:07','2025-09-19 14:10:07',1);
INSERT INTO "Settings" VALUES (1,'app_name','Luna Dine Admin','string','Application name displayed in admin panel','general',0,'2025-09-19 14:10:07','2025-09-19 14:10:07',NULL,NULL);
INSERT INTO "Settings" VALUES (2,'app_version','1.0.0','string','Current application version','general',1,'2025-09-19 14:10:07','2025-09-19 14:10:07',NULL,NULL);
INSERT INTO "Settings" VALUES (3,'maintenance_mode','false','boolean','Enable maintenance mode','system',0,'2025-09-19 14:10:07','2025-09-19 14:10:07',NULL,NULL);
INSERT INTO "Settings" VALUES (4,'max_login_attempts','5','integer','Maximum login attempts before account lockout','security',0,'2025-09-19 14:10:07','2025-09-19 14:10:07',NULL,NULL);
INSERT INTO "Settings" VALUES (5,'session_timeout','3600','integer','Session timeout in seconds','security',0,'2025-09-19 14:10:07','2025-09-19 14:10:07',NULL,NULL);
INSERT INTO "Settings" VALUES (6,'firebase_config','{}','json','Firebase configuration for push notifications','notifications',0,'2025-09-19 14:10:07','2025-09-19 14:10:07',NULL,NULL);
INSERT INTO "Settings" VALUES (7,'auto_refresh_dashboard','true','boolean','Auto refresh dashboard data','ui',0,'2025-09-19 14:10:07','2025-09-19 14:10:07',NULL,NULL);
INSERT INTO "Settings" VALUES (8,'default_language','en-US','string','Default language for new users','localization',0,'2025-09-19 14:10:07','2025-09-19 14:10:07',NULL,NULL);
INSERT INTO "Settings" VALUES (9,'currency_symbol','BDT','string','Default currency symbol','general',1,'2025-09-19 14:10:07','2025-09-19 14:10:07',NULL,NULL);
INSERT INTO "Settings" VALUES (10,'date_format','Y-m-d','string','Default date format','general',0,'2025-09-19 14:10:07','2025-09-19 14:10:07',NULL,NULL);
INSERT INTO "Settings" VALUES (11,'time_format','H:i:s','string','Default time format','general',0,'2025-09-19 14:10:07','2025-09-19 14:10:07',NULL,NULL);
INSERT INTO "Settings" VALUES (12,'backup_frequency','daily','string','Automated backup frequency','system',0,'2025-09-19 14:10:07','2025-09-19 14:10:07',NULL,NULL);
INSERT INTO "Settings" VALUES (13,'email_notifications','true','boolean','Enable email notifications','notifications',0,'2025-09-19 14:10:07','2025-09-19 14:10:07',NULL,NULL);
INSERT INTO "Settings" VALUES (14,'sms_notifications','false','boolean','Enable SMS notifications','notifications',0,'2025-09-19 14:10:07','2025-09-19 14:10:07',NULL,NULL);
INSERT INTO "TableServiceStatus" VALUES (1,1,1,NULL,'assigned',NULL,NULL,NULL,NULL,0,NULL,'2025-09-19 14:10:15','2025-09-19 14:10:15');
INSERT INTO "TableServiceStatus" VALUES (2,4,3,NULL,'assigned',NULL,NULL,NULL,NULL,0,NULL,'2025-09-19 14:10:15','2025-09-19 14:10:15');
INSERT INTO "TableServiceStatus" VALUES (3,5,2,NULL,'assigned',NULL,NULL,NULL,NULL,0,NULL,'2025-09-19 14:10:15','2025-09-19 14:10:15');
INSERT INTO "TableServiceStatus" VALUES (4,7,4,NULL,'assigned',NULL,NULL,NULL,NULL,0,NULL,'2025-09-19 14:10:15','2025-09-19 14:10:15');
INSERT INTO "TableServiceStatus" VALUES (5,9,20,NULL,'assigned',NULL,NULL,NULL,NULL,0,NULL,'2025-09-19 15:33:56','2025-09-19 15:33:56');
INSERT INTO "TableServiceStatus" VALUES (6,10,11,NULL,'assigned',NULL,NULL,NULL,NULL,0,NULL,'2025-09-19 16:46:04','2025-09-19 16:46:04');
INSERT INTO "TableServiceStatus" VALUES (7,12,51,NULL,'assigned',NULL,NULL,NULL,NULL,0,NULL,'2025-09-20 07:14:31','2025-09-20 07:14:31');
INSERT INTO "TableServiceStatus" VALUES (8,13,20,NULL,'assigned',NULL,NULL,NULL,NULL,0,NULL,'2025-09-20 07:22:42','2025-09-20 07:22:42');
INSERT INTO "TableServiceStatus" VALUES (9,14,1,NULL,'assigned',NULL,NULL,NULL,NULL,0,NULL,'2025-09-20 08:13:17','2025-09-20 08:13:17');
INSERT INTO "TableServiceStatus" VALUES (10,15,50,NULL,'assigned',NULL,NULL,NULL,NULL,0,NULL,'2025-09-20 08:14:16','2025-09-20 08:14:16');
INSERT INTO "Tables" VALUES (1,1,'Table 1','branch1_table1',4,'table',1,'Main hall','2025-09-19 14:10:13','2025-09-19 14:10:13',NULL,NULL,'Table 1');
INSERT INTO "Tables" VALUES (2,1,'Table 2','branch1_table2',4,'table',1,'Main hall','2025-09-19 14:10:13','2025-09-19 14:10:13',NULL,NULL,'Table 2');
INSERT INTO "Tables" VALUES (3,1,'Table 3','branch1_table3',4,'table',1,'Main hall','2025-09-19 14:10:13','2025-09-19 14:10:13',NULL,NULL,'Table 3');
INSERT INTO "Tables" VALUES (4,1,'Table 4','branch1_table4',4,'table',1,'Main hall','2025-09-19 14:10:13','2025-09-19 14:10:13',NULL,NULL,'Table 4');
INSERT INTO "Tables" VALUES (5,1,'Table 5','branch1_table5',4,'table',1,'Main hall','2025-09-19 14:10:13','2025-09-19 14:10:13',NULL,NULL,'Table 5');
INSERT INTO "Tables" VALUES (6,1,'Table 6','branch1_table6',6,'booth',1,'Main hall','2025-09-19 14:10:13','2025-09-19 14:10:13',NULL,NULL,'Table 6');
INSERT INTO "Tables" VALUES (7,1,'Table 7','branch1_table7',6,'booth',1,'Main hall','2025-09-19 14:10:13','2025-09-19 14:10:13',NULL,NULL,'Table 7');
INSERT INTO "Tables" VALUES (8,1,'Table 8','branch1_table8',6,'booth',1,'Main hall','2025-09-19 14:10:13','2025-09-19 14:10:13',NULL,NULL,'Table 8');
INSERT INTO "Tables" VALUES (9,1,'Table 9','branch1_table9',8,'outdoor',1,'Garden area','2025-09-19 14:10:13','2025-09-19 14:10:13',NULL,NULL,'Table 9');
INSERT INTO "Tables" VALUES (10,1,'Table 10','branch1_table10',8,'outdoor',1,'Garden area','2025-09-19 14:10:13','2025-09-19 14:10:13',NULL,NULL,'Table 10');
INSERT INTO "Tables" VALUES (11,2,'Table 1','branch2_table1',4,'table',1,'Main hall','2025-09-19 14:10:13','2025-09-19 14:10:13',NULL,NULL,'Table 1');
INSERT INTO "Tables" VALUES (12,2,'Table 2','branch2_table2',4,'table',1,'Main hall','2025-09-19 14:10:13','2025-09-19 14:10:13',NULL,NULL,'Table 2');
INSERT INTO "Tables" VALUES (13,2,'Table 3','branch2_table3',4,'table',1,'Main hall','2025-09-19 14:10:13','2025-09-19 14:10:13',NULL,NULL,'Table 3');
INSERT INTO "Tables" VALUES (14,2,'Table 4','branch2_table4',4,'table',1,'Main hall','2025-09-19 14:10:13','2025-09-19 14:10:13',NULL,NULL,'Table 4');
INSERT INTO "Tables" VALUES (15,2,'Table 5','branch2_table5',4,'table',1,'Main hall','2025-09-19 14:10:13','2025-09-19 14:10:13',NULL,NULL,'Table 5');
INSERT INTO "Tables" VALUES (16,2,'Table 6','branch2_table6',6,'booth',1,'Main hall','2025-09-19 14:10:13','2025-09-19 14:10:13',NULL,NULL,'Table 6');
INSERT INTO "Tables" VALUES (17,2,'Table 7','branch2_table7',6,'booth',1,'Main hall','2025-09-19 14:10:13','2025-09-19 14:10:13',NULL,NULL,'Table 7');
INSERT INTO "Tables" VALUES (18,2,'Table 8','branch2_table8',6,'booth',1,'Main hall','2025-09-19 14:10:13','2025-09-19 14:10:13',NULL,NULL,'Table 8');
INSERT INTO "Tables" VALUES (19,2,'Table 9','branch2_table9',8,'outdoor',1,'Garden area','2025-09-19 14:10:13','2025-09-19 14:10:13',NULL,NULL,'Table 9');
INSERT INTO "Tables" VALUES (20,2,'Table 10','branch2_table10',8,'outdoor',1,'Garden area','2025-09-19 14:10:13','2025-09-19 14:10:13',NULL,NULL,'Table 10');
INSERT INTO "Tables" VALUES (21,3,'Table 1','branch3_table1',4,'table',1,'Main hall','2025-09-19 14:10:13','2025-09-19 14:10:13',NULL,NULL,'Table 1');
INSERT INTO "Tables" VALUES (22,3,'Table 2','branch3_table2',4,'table',1,'Main hall','2025-09-19 14:10:13','2025-09-19 14:10:13',NULL,NULL,'Table 2');
INSERT INTO "Tables" VALUES (23,3,'Table 3','branch3_table3',4,'table',1,'Main hall','2025-09-19 14:10:13','2025-09-19 14:10:13',NULL,NULL,'Table 3');
INSERT INTO "Tables" VALUES (24,3,'Table 4','branch3_table4',4,'table',1,'Main hall','2025-09-19 14:10:13','2025-09-19 14:10:13',NULL,NULL,'Table 4');
INSERT INTO "Tables" VALUES (25,3,'Table 5','branch3_table5',4,'table',1,'Main hall','2025-09-19 14:10:13','2025-09-19 14:10:13',NULL,NULL,'Table 5');
INSERT INTO "Tables" VALUES (26,3,'Table 6','branch3_table6',6,'booth',1,'Main hall','2025-09-19 14:10:13','2025-09-19 14:10:13',NULL,NULL,'Table 6');
INSERT INTO "Tables" VALUES (27,3,'Table 7','branch3_table7',6,'booth',1,'Main hall','2025-09-19 14:10:13','2025-09-19 14:10:13',NULL,NULL,'Table 7');
INSERT INTO "Tables" VALUES (28,3,'Table 8','branch3_table8',6,'booth',1,'Main hall','2025-09-19 14:10:13','2025-09-19 14:10:13',NULL,NULL,'Table 8');
INSERT INTO "Tables" VALUES (29,3,'Table 9','branch3_table9',8,'outdoor',1,'Garden area','2025-09-19 14:10:13','2025-09-19 14:10:13',NULL,NULL,'Table 9');
INSERT INTO "Tables" VALUES (30,3,'Table 10','branch3_table10',8,'outdoor',1,'Garden area','2025-09-19 14:10:13','2025-09-19 14:10:13',NULL,NULL,'Table 10');
INSERT INTO "Tables" VALUES (31,4,'Table 1','branch4_table1',4,'table',1,'Main hall','2025-09-19 14:10:13','2025-09-19 14:10:13',NULL,NULL,'Table 1');
INSERT INTO "Tables" VALUES (32,4,'Table 2','branch4_table2',4,'table',1,'Main hall','2025-09-19 14:10:13','2025-09-19 14:10:13',NULL,NULL,'Table 2');
INSERT INTO "Tables" VALUES (33,4,'Table 3','branch4_table3',4,'table',1,'Main hall','2025-09-19 14:10:13','2025-09-19 14:10:13',NULL,NULL,'Table 3');
INSERT INTO "Tables" VALUES (34,4,'Table 4','branch4_table4',4,'table',1,'Main hall','2025-09-19 14:10:13','2025-09-19 14:10:13',NULL,NULL,'Table 4');
INSERT INTO "Tables" VALUES (35,4,'Table 5','branch4_table5',4,'table',1,'Main hall','2025-09-19 14:10:13','2025-09-19 14:10:13',NULL,NULL,'Table 5');
INSERT INTO "Tables" VALUES (36,4,'Table 6','branch4_table6',6,'booth',1,'Main hall','2025-09-19 14:10:13','2025-09-19 14:10:13',NULL,NULL,'Table 6');
INSERT INTO "Tables" VALUES (37,4,'Table 7','branch4_table7',6,'booth',1,'Main hall','2025-09-19 14:10:13','2025-09-19 14:10:13',NULL,NULL,'Table 7');
INSERT INTO "Tables" VALUES (38,4,'Table 8','branch4_table8',6,'booth',1,'Main hall','2025-09-19 14:10:13','2025-09-19 14:10:13',NULL,NULL,'Table 8');
INSERT INTO "Tables" VALUES (39,4,'Table 9','branch4_table9',8,'outdoor',1,'Garden area','2025-09-19 14:10:13','2025-09-19 14:10:13',NULL,NULL,'Table 9');
INSERT INTO "Tables" VALUES (40,4,'Table 10','branch4_table10',8,'outdoor',1,'Garden area','2025-09-19 14:10:13','2025-09-19 14:10:13',NULL,NULL,'Table 10');
INSERT INTO "Tables" VALUES (41,5,'Table 1','branch5_table1',4,'table',1,'Main hall','2025-09-19 14:10:13','2025-09-19 14:10:13',NULL,NULL,'Table 1');
INSERT INTO "Tables" VALUES (42,5,'Table 2','branch5_table2',4,'table',1,'Main hall','2025-09-19 14:10:13','2025-09-19 14:10:13',NULL,NULL,'Table 2');
INSERT INTO "Tables" VALUES (43,5,'Table 3','branch5_table3',4,'table',1,'Main hall','2025-09-19 14:10:13','2025-09-19 14:10:13',NULL,NULL,'Table 3');
INSERT INTO "Tables" VALUES (44,5,'Table 4','branch5_table4',4,'table',1,'Main hall','2025-09-19 14:10:13','2025-09-19 14:10:13',NULL,NULL,'Table 4');
INSERT INTO "Tables" VALUES (45,5,'Table 5','branch5_table5',4,'table',1,'Main hall','2025-09-19 14:10:13','2025-09-19 14:10:13',NULL,NULL,'Table 5');
INSERT INTO "Tables" VALUES (46,5,'Table 6','branch5_table6',6,'booth',1,'Main hall','2025-09-19 14:10:13','2025-09-19 14:10:13',NULL,NULL,'Table 6');
INSERT INTO "Tables" VALUES (47,5,'Table 7','branch5_table7',6,'booth',1,'Main hall','2025-09-19 14:10:13','2025-09-19 14:10:13',NULL,NULL,'Table 7');
INSERT INTO "Tables" VALUES (48,5,'Table 8','branch5_table8',6,'booth',1,'Main hall','2025-09-19 14:10:13','2025-09-19 14:10:13',NULL,NULL,'Table 8');
INSERT INTO "Tables" VALUES (49,5,'Table 9','branch5_table9',8,'outdoor',1,'Garden area','2025-09-19 14:10:13','2025-09-19 14:10:13',NULL,NULL,'Table 9');
INSERT INTO "Tables" VALUES (50,5,'Table 10','branch5_table10',8,'outdoor',1,'Garden area','2025-09-19 14:10:13','2025-09-19 14:10:13',NULL,NULL,'Table 10');
INSERT INTO "Tables" VALUES (51,6,'Table 1','branch6_table1',4,'table',1,'Main hall','2025-09-19 14:10:13','2025-09-19 14:10:13',NULL,NULL,'Table 1');
INSERT INTO "Tables" VALUES (52,6,'Table 2','branch6_table2',4,'table',1,'Main hall','2025-09-19 14:10:13','2025-09-19 14:10:13',NULL,NULL,'Table 2');
INSERT INTO "Tables" VALUES (53,6,'Table 3','branch6_table3',4,'table',1,'Main hall','2025-09-19 14:10:13','2025-09-19 14:10:13',NULL,NULL,'Table 3');
INSERT INTO "Tables" VALUES (54,6,'Table 4','branch6_table4',4,'table',1,'Main hall','2025-09-19 14:10:13','2025-09-19 14:10:13',NULL,NULL,'Table 4');
INSERT INTO "Tables" VALUES (55,6,'Table 5','branch6_table5',4,'table',1,'Main hall','2025-09-19 14:10:13','2025-09-19 14:10:13',NULL,NULL,'Table 5');
INSERT INTO "Tables" VALUES (56,6,'Table 6','branch6_table6',6,'booth',1,'Main hall','2025-09-19 14:10:13','2025-09-19 14:10:13',NULL,NULL,'Table 6');
INSERT INTO "Tables" VALUES (57,6,'Table 7','branch6_table7',6,'booth',1,'Main hall','2025-09-19 14:10:13','2025-09-19 14:10:13',NULL,NULL,'Table 7');
INSERT INTO "Tables" VALUES (58,6,'Table 8','branch6_table8',6,'booth',1,'Main hall','2025-09-19 14:10:13','2025-09-19 14:10:13',NULL,NULL,'Table 8');
INSERT INTO "Tables" VALUES (59,6,'Table 9','branch6_table9',8,'outdoor',1,'Garden area','2025-09-19 14:10:13','2025-09-19 14:10:13',NULL,NULL,'Table 9');
INSERT INTO "Tables" VALUES (60,6,'Table 10','branch6_table10',8,'outdoor',1,'Garden area','2025-09-19 14:10:13','2025-09-19 14:10:13',NULL,NULL,'Table 10');
INSERT INTO "Translations" VALUES ('app_name','en-US','Luna Dine','2025-09-19 14:10:07','2025-09-19 14:10:07');
INSERT INTO "Translations" VALUES ('app_name','bn-BD','লুনা ডাইন','2025-09-19 14:10:07','2025-09-19 14:10:07');
INSERT INTO "Translations" VALUES ('category_appetizers','en-US','Appetizers','2025-09-19 14:10:07','2025-09-19 14:10:07');
INSERT INTO "Translations" VALUES ('category_appetizers','bn-BD','অ্যাপিটাইজার','2025-09-19 14:10:07','2025-09-19 14:10:07');
INSERT INTO "Translations" VALUES ('category_main_course','en-US','Main Course','2025-09-19 14:10:07','2025-09-19 14:10:07');
INSERT INTO "Translations" VALUES ('category_main_course','bn-BD','মূল খাবার','2025-09-19 14:10:07','2025-09-19 14:10:07');
INSERT INTO "Translations" VALUES ('category_beverages','en-US','Beverages','2025-09-19 14:10:07','2025-09-19 14:10:07');
INSERT INTO "Translations" VALUES ('category_beverages','bn-BD','পানীয়','2025-09-19 14:10:07','2025-09-19 14:10:07');
INSERT INTO "Translations" VALUES ('category_desserts','en-US','Desserts','2025-09-19 14:10:07','2025-09-19 14:10:07');
INSERT INTO "Translations" VALUES ('category_desserts','bn-BD','মিষ্টি','2025-09-19 14:10:07','2025-09-19 14:10:07');
INSERT INTO "Translations" VALUES ('category_burgers','en-US','Burgers','2025-09-19 14:10:07','2025-09-19 14:10:07');
INSERT INTO "Translations" VALUES ('category_burgers','bn-BD','বার্গার','2025-09-19 14:10:07','2025-09-19 14:10:07');
INSERT INTO "Translations" VALUES ('category_sandwiches','en-US','Sandwiches','2025-09-19 14:10:07','2025-09-19 14:10:07');
INSERT INTO "Translations" VALUES ('category_sandwiches','bn-BD','স্যান্ডউইচ','2025-09-19 14:10:07','2025-09-19 14:10:07');
INSERT INTO "Translations" VALUES ('category_fries','en-US','Fries & Sides','2025-09-19 14:10:07','2025-09-19 14:10:07');
INSERT INTO "Translations" VALUES ('category_fries','bn-BD','ফ্রাই ও সাইড ডিশ','2025-09-19 14:10:07','2025-09-19 14:10:07');
INSERT INTO "Translations" VALUES ('category_fast_food_desserts','en-US','Desserts','2025-09-19 14:10:07','2025-09-19 14:10:07');
INSERT INTO "Translations" VALUES ('category_fast_food_desserts','bn-BD','মিষ্টি','2025-09-19 14:10:07','2025-09-19 14:10:07');
INSERT INTO "Translations" VALUES ('category_hot_dogs','en-US','Hot Dogs','2025-09-19 14:10:07','2025-09-19 14:10:07');
INSERT INTO "Translations" VALUES ('category_hot_dogs','bn-BD','হট ডগ','2025-09-19 14:10:07','2025-09-19 14:10:07');
INSERT INTO "Translations" VALUES ('category_wraps','en-US','Wraps','2025-09-19 14:10:07','2025-09-19 14:10:07');
INSERT INTO "Translations" VALUES ('category_wraps','bn-BD','র‌্যাপ','2025-09-19 14:10:07','2025-09-19 14:10:07');
INSERT INTO "Translations" VALUES ('category_desi_rice','en-US','Rice Dishes','2025-09-19 14:10:07','2025-09-19 14:10:07');
INSERT INTO "Translations" VALUES ('category_desi_rice','bn-BD','ভাত ভিত্তিক খাবার','2025-09-19 14:10:07','2025-09-19 14:10:07');
INSERT INTO "Translations" VALUES ('category_desi_curry','en-US','Curries','2025-09-19 14:10:07','2025-09-19 14:10:07');
INSERT INTO "Translations" VALUES ('category_desi_curry','bn-BD','ঝোল','2025-09-19 14:10:07','2025-09-19 14:10:07');
INSERT INTO "Translations" VALUES ('category_desi_kabab','en-US','Kebabs & Grills','2025-09-19 14:10:07','2025-09-19 14:10:07');
INSERT INTO "Translations" VALUES ('category_desi_kabab','bn-BD','কাবাব ও গ্রিল','2025-09-19 14:10:07','2025-09-19 14:10:07');
INSERT INTO "Translations" VALUES ('category_desi_bread','en-US','Breads','2025-09-19 14:10:08','2025-09-19 14:10:08');
INSERT INTO "Translations" VALUES ('category_desi_bread','bn-BD','রুটি','2025-09-19 14:10:08','2025-09-19 14:10:08');
INSERT INTO "Translations" VALUES ('category_desi_desserts','en-US','Bengali Sweets','2025-09-19 14:10:08','2025-09-19 14:10:08');
INSERT INTO "Translations" VALUES ('category_desi_desserts','bn-BD','বাংলাদেশী মিষ্টি','2025-09-19 14:10:08','2025-09-19 14:10:08');
INSERT INTO "Translations" VALUES ('category_desi_starters','en-US','Starters','2025-09-19 14:10:08','2025-09-19 14:10:08');
INSERT INTO "Translations" VALUES ('category_desi_starters','bn-BD','স্টার্টার','2025-09-19 14:10:08','2025-09-19 14:10:08');
INSERT INTO "Translations" VALUES ('category_chinese_rice','en-US','Fried Rice','2025-09-19 14:10:08','2025-09-19 14:10:08');
INSERT INTO "Translations" VALUES ('category_chinese_rice','bn-BD','ভাজা ভাত','2025-09-19 14:10:08','2025-09-19 14:10:08');
INSERT INTO "Translations" VALUES ('category_chinese_noodles','en-US','Noodles','2025-09-19 14:10:08','2025-09-19 14:10:08');
INSERT INTO "Translations" VALUES ('category_chinese_noodles','bn-BD','নুডলস','2025-09-19 14:10:08','2025-09-19 14:10:08');
INSERT INTO "Translations" VALUES ('category_chinese_soup','en-US','Soups','2025-09-19 14:10:08','2025-09-19 14:10:08');
INSERT INTO "Translations" VALUES ('category_chinese_soup','bn-BD','স্যুপ','2025-09-19 14:10:08','2025-09-19 14:10:08');
INSERT INTO "Translations" VALUES ('category_chinese_starters','en-US','Appetizers','2025-09-19 14:10:08','2025-09-19 14:10:08');
INSERT INTO "Translations" VALUES ('category_chinese_starters','bn-BD','অ্যাপিটাইজার','2025-09-19 14:10:08','2025-09-19 14:10:08');
INSERT INTO "Translations" VALUES ('category_chinese_main','en-US','Main Dishes','2025-09-19 14:10:08','2025-09-19 14:10:08');
INSERT INTO "Translations" VALUES ('category_chinese_main','bn-BD','মূল খাবার','2025-09-19 14:10:08','2025-09-19 14:10:08');
INSERT INTO "Translations" VALUES ('category_chinese_desserts','en-US','Desserts','2025-09-19 14:10:08','2025-09-19 14:10:08');
INSERT INTO "Translations" VALUES ('category_chinese_desserts','bn-BD','মিষ্টি','2025-09-19 14:10:08','2025-09-19 14:10:08');
INSERT INTO "Translations" VALUES ('category_indian_bread','en-US','Breads','2025-09-19 14:10:08','2025-09-19 14:10:08');
INSERT INTO "Translations" VALUES ('category_indian_bread','bn-BD','রুটি','2025-09-19 14:10:08','2025-09-19 14:10:08');
INSERT INTO "Translations" VALUES ('category_indian_curry','en-US','Indian Curries','2025-09-19 14:10:08','2025-09-19 14:10:08');
INSERT INTO "Translations" VALUES ('category_indian_curry','bn-BD','ভারতীয় কারী','2025-09-19 14:10:08','2025-09-19 14:10:08');
INSERT INTO "Translations" VALUES ('category_indian_tandoor','en-US','Tandoori Special','2025-09-19 14:10:08','2025-09-19 14:10:08');
INSERT INTO "Translations" VALUES ('category_indian_tandoor','bn-BD','তন্দুরি স্পেশাল','2025-09-19 14:10:08','2025-09-19 14:10:08');
INSERT INTO "Translations" VALUES ('category_indian_rice','en-US','Rice Dishes','2025-09-19 14:10:08','2025-09-19 14:10:08');
INSERT INTO "Translations" VALUES ('category_indian_rice','bn-BD','ভাত ভিত্তিক খাবার','2025-09-19 14:10:08','2025-09-19 14:10:08');
INSERT INTO "Translations" VALUES ('category_indian_starters','en-US','Starters','2025-09-19 14:10:08','2025-09-19 14:10:08');
INSERT INTO "Translations" VALUES ('category_indian_starters','bn-BD','স্টার্টার','2025-09-19 14:10:08','2025-09-19 14:10:08');
INSERT INTO "Translations" VALUES ('category_indian_desserts','en-US','Indian Sweets','2025-09-19 14:10:08','2025-09-19 14:10:08');
INSERT INTO "Translations" VALUES ('category_indian_desserts','bn-BD','ভারতীয় মিষ্টি','2025-09-19 14:10:08','2025-09-19 14:10:08');
INSERT INTO "Translations" VALUES ('category_pizza','en-US','Pizza','2025-09-19 14:10:08','2025-09-19 14:10:08');
INSERT INTO "Translations" VALUES ('category_pizza','bn-BD','পিৎজা','2025-09-19 14:10:08','2025-09-19 14:10:08');
INSERT INTO "Translations" VALUES ('category_pasta','en-US','Pasta','2025-09-19 14:10:08','2025-09-19 14:10:08');
INSERT INTO "Translations" VALUES ('category_pasta','bn-BD','পাস্তা','2025-09-19 14:10:08','2025-09-19 14:10:08');
INSERT INTO "Translations" VALUES ('category_salad','en-US','Salads','2025-09-19 14:10:08','2025-09-19 14:10:08');
INSERT INTO "Translations" VALUES ('category_salad','bn-BD','সালাদ','2025-09-19 14:10:08','2025-09-19 14:10:08');
INSERT INTO "Translations" VALUES ('category_italian_starters','en-US','Antipasti','2025-09-19 14:10:08','2025-09-19 14:10:08');
INSERT INTO "Translations" VALUES ('category_italian_starters','bn-BD','অ্যান্টিপাস্টি','2025-09-19 14:10:08','2025-09-19 14:10:08');
INSERT INTO "Translations" VALUES ('category_italian_desserts','en-US','Dolci','2025-09-19 14:10:08','2025-09-19 14:10:08');
INSERT INTO "Translations" VALUES ('category_italian_desserts','bn-BD','ডলচি','2025-09-19 14:10:08','2025-09-19 14:10:08');
INSERT INTO "Translations" VALUES ('category_italian_main','en-US','Main Courses','2025-09-19 14:10:08','2025-09-19 14:10:08');
INSERT INTO "Translations" VALUES ('category_italian_main','bn-BD','মূল খাবার','2025-09-19 14:10:08','2025-09-19 14:10:08');
INSERT INTO "Translations" VALUES ('category_sushi','en-US','Sushi & Sashimi','2025-09-19 14:10:08','2025-09-19 14:10:08');
INSERT INTO "Translations" VALUES ('category_sushi','bn-BD','সুশি ও সাশিমি','2025-09-19 14:10:08','2025-09-19 14:10:08');
INSERT INTO "Translations" VALUES ('category_ramen','en-US','Ramen & Noodles','2025-09-19 14:10:08','2025-09-19 14:10:08');
INSERT INTO "Translations" VALUES ('category_ramen','bn-BD','রামেন ও নুডলস','2025-09-19 14:10:08','2025-09-19 14:10:08');
INSERT INTO "Translations" VALUES ('category_tepanyaki','en-US','Teppanyaki & Tempura','2025-09-19 14:10:08','2025-09-19 14:10:08');
INSERT INTO "Translations" VALUES ('category_tepanyaki','bn-BD','তেপ্পানিয়াকি ও টেম্পুরা','2025-09-19 14:10:08','2025-09-19 14:10:08');
INSERT INTO "Translations" VALUES ('category_japanese_starters','en-US','Appetizers','2025-09-19 14:10:08','2025-09-19 14:10:08');
INSERT INTO "Translations" VALUES ('category_japanese_starters','bn-BD','অ্যাপিটাইজার','2025-09-19 14:10:08','2025-09-19 14:10:08');
INSERT INTO "Translations" VALUES ('category_japanese_bento','en-US','Bento Boxes','2025-09-19 14:10:08','2025-09-19 14:10:08');
INSERT INTO "Translations" VALUES ('category_japanese_bento','bn-BD','বেন্টো বক্স','2025-09-19 14:10:08','2025-09-19 14:10:08');
INSERT INTO "Translations" VALUES ('category_japanese_desserts','en-US','Desserts','2025-09-19 14:10:08','2025-09-19 14:10:08');
INSERT INTO "Translations" VALUES ('category_japanese_desserts','bn-BD','মিষ্টি','2025-09-19 14:10:08','2025-09-19 14:10:08');
INSERT INTO "Translations" VALUES ('category_bengali_sweets','en-US','Bengali Sweets','2025-09-19 14:10:08','2025-09-19 14:10:08');
INSERT INTO "Translations" VALUES ('category_bengali_sweets','bn-BD','বাংলাদেশী মিষ্টি','2025-09-19 14:10:08','2025-09-19 14:10:08');
INSERT INTO "Translations" VALUES ('category_ice_cream','en-US','Ice Cream','2025-09-19 14:10:08','2025-09-19 14:10:08');
INSERT INTO "Translations" VALUES ('category_ice_cream','bn-BD','আইসক্রিম','2025-09-19 14:10:08','2025-09-19 14:10:08');
INSERT INTO "Translations" VALUES ('category_cakes','en-US','Cakes & Pastries','2025-09-19 14:10:08','2025-09-19 14:10:08');
INSERT INTO "Translations" VALUES ('category_cakes','bn-BD','কেক ও পেস্ট্রি','2025-09-19 14:10:08','2025-09-19 14:10:08');
INSERT INTO "Translations" VALUES ('item_beef_burger','en-US','Classic Beef Burger','2025-09-19 14:10:08','2025-09-19 14:10:08');
INSERT INTO "Translations" VALUES ('item_beef_burger','bn-BD','ক্লাসিক বিফ বার্গার','2025-09-19 14:10:08','2025-09-19 14:10:08');
INSERT INTO "Translations" VALUES ('item_beef_burger_desc','en-US','Juicy beef patty with fresh vegetables and sauce','2025-09-19 14:10:08','2025-09-19 14:10:08');
INSERT INTO "Translations" VALUES ('item_beef_burger_desc','bn-BD','রসালো বিফ প্যাটি তাজা সবজি এবং সস দিয়ে','2025-09-19 14:10:08','2025-09-19 14:10:08');
INSERT INTO "Translations" VALUES ('item_chicken_burger','en-US','Crispy Chicken Burger','2025-09-19 14:10:08','2025-09-19 14:10:08');
INSERT INTO "Translations" VALUES ('item_chicken_burger','bn-BD','ক্রিস্পি চিকেন বার্গার','2025-09-19 14:10:08','2025-09-19 14:10:08');
INSERT INTO "Translations" VALUES ('item_chicken_burger_desc','en-US','Crispy fried chicken fillet with mayo and lettuce','2025-09-19 14:10:08','2025-09-19 14:10:08');
INSERT INTO "Translations" VALUES ('item_chicken_burger_desc','bn-BD','ক্রিস্পি ভাজা চিকেন ফিলে মেয়োনেজ এবং লেটুস দিয়ে','2025-09-19 14:10:08','2025-09-19 14:10:08');
INSERT INTO "Translations" VALUES ('item_french_fries','en-US','French Fries','2025-09-19 14:10:08','2025-09-19 14:10:08');
INSERT INTO "Translations" VALUES ('item_french_fries','bn-BD','ফ্রেঞ্চ ফ্রাই','2025-09-19 14:10:08','2025-09-19 14:10:08');
INSERT INTO "Translations" VALUES ('item_french_fries_desc','en-US','Crispy golden potato fries with salt','2025-09-19 14:10:08','2025-09-19 14:10:08');
INSERT INTO "Translations" VALUES ('item_french_fries_desc','bn-BD','লবণ মাখানো সোনালী আলুর কুরকুরে ফ্রাই','2025-09-19 14:10:08','2025-09-19 14:10:08');
INSERT INTO "Translations" VALUES ('item_chicken_sandwich','en-US','Grilled Chicken Sandwich','2025-09-19 14:10:08','2025-09-19 14:10:08');
INSERT INTO "Translations" VALUES ('item_chicken_sandwich','bn-BD','গ্রিলড চিকেন স্যান্ডউইচ','2025-09-19 14:10:08','2025-09-19 14:10:08');
INSERT INTO "Translations" VALUES ('item_chicken_sandwich_desc','en-US','Grilled chicken breast with vegetables and sauce','2025-09-19 14:10:08','2025-09-19 14:10:08');
INSERT INTO "Translations" VALUES ('item_chicken_sandwich_desc','bn-BD','গ্রিলড চিকেন ব্রেস্ট সবজি এবং সস দিয়ে','2025-09-19 14:10:08','2025-09-19 14:10:08');
INSERT INTO "Translations" VALUES ('item_cheese_burger','en-US','Double Cheese Burger','2025-09-19 14:10:08','2025-09-19 14:10:08');
INSERT INTO "Translations" VALUES ('item_cheese_burger','bn-BD','ডাবল চিজ বার্গার','2025-09-19 14:10:08','2025-09-19 14:10:08');
INSERT INTO "Translations" VALUES ('item_cheese_burger_desc','en-US','Double beef patty with melted cheese and special sauce','2025-09-19 14:10:08','2025-09-19 14:10:08');
INSERT INTO "Translations" VALUES ('item_cheese_burger_desc','bn-BD','গলিত পনির এবং বিশেষ সস সহ ডাবল বিফ প্যাটি','2025-09-19 14:10:08','2025-09-19 14:10:08');
INSERT INTO "Translations" VALUES ('item_fish_burger','en-US','Fish Fillet Burger','2025-09-19 14:10:08','2025-09-19 14:10:08');
INSERT INTO "Translations" VALUES ('item_fish_burger','bn-BD','ফিশ ফিলে বার্গার','2025-09-19 14:10:08','2025-09-19 14:10:08');
INSERT INTO "Translations" VALUES ('item_fish_burger_desc','en-US','Crispy fish fillet with tartar sauce and lettuce','2025-09-19 14:10:08','2025-09-19 14:10:08');
INSERT INTO "Translations" VALUES ('item_fish_burger_desc','bn-BD','টার্টার সস এবং লেটুস সহ কুরকুরে মাছের ফিলে','2025-09-19 14:10:08','2025-09-19 14:10:08');
INSERT INTO "Translations" VALUES ('item_veggie_burger','en-US','Veggie Delight Burger','2025-09-19 14:10:08','2025-09-19 14:10:08');
INSERT INTO "Translations" VALUES ('item_veggie_burger','bn-BD','ভেজি ডিলাইট বার্গার','2025-09-19 14:10:08','2025-09-19 14:10:08');
INSERT INTO "Translations" VALUES ('item_veggie_burger_desc','en-US','Plant-based patty with fresh vegetables and special sauce','2025-09-19 14:10:08','2025-09-19 14:10:08');
INSERT INTO "Translations" VALUES ('item_veggie_burger_desc','bn-BD','তাজা সবজি এবং বিশেষ সস সহ উদ্ভিজ্জ-ভিত্তিক প্যাটি','2025-09-19 14:10:08','2025-09-19 14:10:08');
INSERT INTO "Translations" VALUES ('item_club_sandwich','en-US','Club Sandwich','2025-09-19 14:10:08','2025-09-19 14:10:08');
INSERT INTO "Translations" VALUES ('item_club_sandwich','bn-BD','ক্লাব স্যান্ডউইচ','2025-09-19 14:10:08','2025-09-19 14:10:08');
INSERT INTO "Translations" VALUES ('item_club_sandwich_desc','en-US','Triple-decker sandwich with chicken, bacon, lettuce, tomato and mayo','2025-09-19 14:10:08','2025-09-19 14:10:08');
INSERT INTO "Translations" VALUES ('item_club_sandwich_desc','bn-BD','চিকেন, বেকন, লেটুস, টমেটো এবং মেয়োনেজ সহ ট্রিপল-ডেকার স্যান্ডউইচ','2025-09-19 14:10:08','2025-09-19 14:10:08');
INSERT INTO "Translations" VALUES ('item_tuna_sandwich','en-US','Tuna Melt Sandwich','2025-09-19 14:10:08','2025-09-19 14:10:08');
INSERT INTO "Translations" VALUES ('item_tuna_sandwich','bn-BD','টুনা মেল্ট স্যান্ডউইচ','2025-09-19 14:10:08','2025-09-19 14:10:08');
INSERT INTO "Translations" VALUES ('item_tuna_sandwich_desc','en-US','Tuna salad with melted cheese on toasted bread','2025-09-19 14:10:08','2025-09-19 14:10:08');
INSERT INTO "Translations" VALUES ('item_tuna_sandwich_desc','bn-BD','টোস্টেড রুটিতে গলিত পনির সহ টুনা সালাদ','2025-09-19 14:10:08','2025-09-19 14:10:08');
INSERT INTO "Translations" VALUES ('item_crispy_chicken','en-US','Crispy Chicken Wings','2025-09-19 14:10:08','2025-09-19 14:10:08');
INSERT INTO "Translations" VALUES ('item_crispy_chicken','bn-BD','ক্রিস্পি চিকেন উইংস','2025-09-19 14:10:08','2025-09-19 14:10:08');
INSERT INTO "Translations" VALUES ('item_crispy_chicken_desc','en-US','Crispy fried chicken wings with your choice of sauce','2025-09-19 14:10:08','2025-09-19 14:10:08');
INSERT INTO "Translations" VALUES ('item_crispy_chicken_desc','bn-BD','আপনার পছন্দের সস সহ কুরকুরে ভাজা চিকেন উইংস','2025-09-19 14:10:08','2025-09-19 14:10:08');
INSERT INTO "Translations" VALUES ('item_onion_rings','en-US','Onion Rings','2025-09-19 14:10:08','2025-09-19 14:10:08');
INSERT INTO "Translations" VALUES ('item_onion_rings','bn-BD','পেঁয়াজ রিংস','2025-09-19 14:10:08','2025-09-19 14:10:08');
INSERT INTO "Translations" VALUES ('item_onion_rings_desc','en-US','Crispy battered onion rings served with dipping sauce','2025-09-19 14:10:08','2025-09-19 14:10:08');
INSERT INTO "Translations" VALUES ('item_onion_rings_desc','bn-BD','ডিপিং সস সহ পরিবেশিত কুরকুরে ব্যাটারড পেঁয়াজ রিংস','2025-09-19 14:10:08','2025-09-19 14:10:08');
INSERT INTO "Translations" VALUES ('item_mozzarella_sticks','en-US','Mozzarella Sticks','2025-09-19 14:10:08','2025-09-19 14:10:08');
INSERT INTO "Translations" VALUES ('item_mozzarella_sticks','bn-BD','মোজারেলা স্টিকস','2025-09-19 14:10:08','2025-09-19 14:10:08');
INSERT INTO "Translations" VALUES ('item_mozzarella_sticks_desc','en-US','Fried mozzarella cheese sticks with marinara sauce','2025-09-19 14:10:08','2025-09-19 14:10:08');
INSERT INTO "Translations" VALUES ('item_mozzarella_sticks_desc','bn-BD','মেরিনারা সস সহ ভাজা মোজারেলা পনিরের স্টিকস','2025-09-19 14:10:08','2025-09-19 14:10:08');
INSERT INTO "Translations" VALUES ('item_hot_dog','en-US','Classic Hot Dog','2025-09-19 14:10:08','2025-09-19 14:10:08');
INSERT INTO "Translations" VALUES ('item_hot_dog','bn-BD','ক্লাসিক হট ডগ','2025-09-19 14:10:08','2025-09-19 14:10:08');
INSERT INTO "Translations" VALUES ('item_hot_dog_desc','en-US','Beef frankfurter in a soft bun with mustard and ketchup','2025-09-19 14:10:08','2025-09-19 14:10:08');
INSERT INTO "Translations" VALUES ('item_hot_dog_desc','bn-BD','সফট বানে সরিষা এবং কেচাপ সহ বিফ ফ্র্যাঙ্কফুর্টার','2025-09-19 14:10:08','2025-09-19 14:10:08');
INSERT INTO "Translations" VALUES ('item_chili_dog','en-US','Chili Cheese Dog','2025-09-19 14:10:08','2025-09-19 14:10:08');
INSERT INTO "Translations" VALUES ('item_chili_dog','bn-BD','চিলি চিজ ডগ','2025-09-19 14:10:08','2025-09-19 14:10:08');
INSERT INTO "Translations" VALUES ('item_chili_dog_desc','en-US','Hot dog topped with chili con carne and melted cheese','2025-09-19 14:10:08','2025-09-19 14:10:08');
INSERT INTO "Translations" VALUES ('item_chili_dog_desc','bn-BD','চিলি কন কার্নে এবং গলিত পনির দিয়ে টপড হট ডগ','2025-09-19 14:10:08','2025-09-19 14:10:08');
INSERT INTO "Translations" VALUES ('item_chicken_wrap','en-US','Chicken Caesar Wrap','2025-09-19 14:10:08','2025-09-19 14:10:08');
INSERT INTO "Translations" VALUES ('item_chicken_wrap','bn-BD','চিকেন সিজার র‌্যাপ','2025-09-19 14:10:08','2025-09-19 14:10:08');
INSERT INTO "Translations" VALUES ('item_chicken_wrap_desc','en-US','Grilled chicken with Caesar dressing in a tortilla wrap','2025-09-19 14:10:08','2025-09-19 14:10:08');
INSERT INTO "Translations" VALUES ('item_chicken_wrap_desc','bn-BD','টর্টিলা র‌্যাপে সিজার ড্রেসিং সহ গ্রিলড চিকেন','2025-09-19 14:10:08','2025-09-19 14:10:08');
INSERT INTO "Translations" VALUES ('item_veggie_wrap','en-US','Garden Veggie Wrap','2025-09-19 14:10:08','2025-09-19 14:10:08');
INSERT INTO "Translations" VALUES ('item_veggie_wrap','bn-BD','গার্ডেন ভেজি র‌্যাপ','2025-09-19 14:10:08','2025-09-19 14:10:08');
INSERT INTO "Translations" VALUES ('item_veggie_wrap_desc','en-US','Fresh vegetables with hummus in a whole wheat wrap','2025-09-19 14:10:08','2025-09-19 14:10:08');
INSERT INTO "Translations" VALUES ('item_veggie_wrap_desc','bn-BD','গোটা গমের র‌্যাপে হুম্মাস সহ তাজা সবজি','2025-09-19 14:10:08','2025-09-19 14:10:08');
INSERT INTO "Translations" VALUES ('item_chocolate_shake','en-US','Chocolate Milkshake','2025-09-19 14:10:08','2025-09-19 14:10:08');
INSERT INTO "Translations" VALUES ('item_chocolate_shake','bn-BD','চকোলেট মিল্কশেক','2025-09-19 14:10:08','2025-09-19 14:10:08');
INSERT INTO "Translations" VALUES ('item_chocolate_shake_desc','en-US','Creamy chocolate milkshake topped with whipped cream','2025-09-19 14:10:08','2025-09-19 14:10:08');
INSERT INTO "Translations" VALUES ('item_chocolate_shake_desc','bn-BD','হুইপড ক্রিম দিয়ে টপড ক্রিমি চকোলেট মিল্কশেক','2025-09-19 14:10:08','2025-09-19 14:10:08');
INSERT INTO "Translations" VALUES ('item_vanilla_shake','en-US','Vanilla Milkshake','2025-09-19 14:10:08','2025-09-19 14:10:08');
INSERT INTO "Translations" VALUES ('item_vanilla_shake','bn-BD','ভ্যানিলা মিল্কশেক','2025-09-19 14:10:08','2025-09-19 14:10:08');
INSERT INTO "Translations" VALUES ('item_vanilla_shake_desc','en-US','Classic vanilla milkshake with a cherry on top','2025-09-19 14:10:08','2025-09-19 14:10:08');
INSERT INTO "Translations" VALUES ('item_vanilla_shake_desc','bn-BD','উপরে একটি চেরি সহ ক্লাসিক ভ্যানিলা মিল্কশেক','2025-09-19 14:10:08','2025-09-19 14:10:08');
INSERT INTO "Translations" VALUES ('item_biryani','en-US','Kacchi Biryani','2025-09-19 14:10:08','2025-09-19 14:10:08');
INSERT INTO "Translations" VALUES ('item_biryani','bn-BD','কাচ্চি বিরিয়ানি','2025-09-19 14:10:08','2025-09-19 14:10:08');
INSERT INTO "Translations" VALUES ('item_biryani_desc','en-US','Fragrant basmati rice with tender mutton and spices','2025-09-19 14:10:08','2025-09-19 14:10:08');
INSERT INTO "Translations" VALUES ('item_biryani_desc','bn-BD','নরম খাসির মাংস এবং মসলা দিয়ে সুগন্ধি বাসমতি চাল','2025-09-19 14:10:08','2025-09-19 14:10:08');
INSERT INTO "Translations" VALUES ('item_bhuna_khichuri','en-US','Bhuna Khichuri','2025-09-19 14:10:08','2025-09-19 14:10:08');
INSERT INTO "Translations" VALUES ('item_bhuna_khichuri','bn-BD','ভুনা খিচুড়ি','2025-09-19 14:10:08','2025-09-19 14:10:08');
INSERT INTO "Translations" VALUES ('item_bhuna_khichuri_desc','en-US','Spiced rice and lentil dish with beef','2025-09-19 14:10:08','2025-09-19 14:10:08');
INSERT INTO "Translations" VALUES ('item_bhuna_khichuri_desc','bn-BD','মসলাদার চাল এবং ডাল দিয়ে গরুর মাংস সহকারে','2025-09-19 14:10:08','2025-09-19 14:10:08');
INSERT INTO "Translations" VALUES ('item_seekh_kabab','en-US','Seekh Kebab','2025-09-19 14:10:08','2025-09-19 14:10:08');
INSERT INTO "Translations" VALUES ('item_seekh_kabab','bn-BD','সীখ কাবাব','2025-09-19 14:10:08','2025-09-19 14:10:08');
INSERT INTO "Translations" VALUES ('item_seekh_kabab_desc','en-US','Minced meat kebabs grilled with spices','2025-09-19 14:10:08','2025-09-19 14:10:08');
INSERT INTO "Translations" VALUES ('item_seekh_kabab_desc','bn-BD','মসলা দিয়ে গ্রিল করা কিমা মাংসের কাবাব','2025-09-19 14:10:08','2025-09-19 14:10:08');
INSERT INTO "Translations" VALUES ('item_chicken_rezala','en-US','Chicken Rezala','2025-09-19 14:10:08','2025-09-19 14:10:08');
INSERT INTO "Translations" VALUES ('item_chicken_rezala','bn-BD','চিকেন রেজালা','2025-09-19 14:10:08','2025-09-19 14:10:08');
INSERT INTO "Translations" VALUES ('item_chicken_rezala_desc','en-US','Mildly spiced chicken curry in yogurt gravy','2025-09-19 14:10:08','2025-09-19 14:10:08');
INSERT INTO "Translations" VALUES ('item_chicken_rezala_desc','bn-BD','টক দই দিয়ে মৃদু মসলায় রান্না করা চিকেন কারী','2025-09-19 14:10:08','2025-09-19 14:10:08');
INSERT INTO "Translations" VALUES ('item_morog_polao','en-US','Chicken Polao','2025-09-19 14:10:08','2025-09-19 14:10:08');
INSERT INTO "Translations" VALUES ('item_morog_polao','bn-BD','মোরগ পোলাও','2025-09-19 14:10:08','2025-09-19 14:10:08');
INSERT INTO "Translations" VALUES ('item_morog_polao_desc','en-US','Fragrant rice cooked with chicken and aromatic spices','2025-09-19 14:10:08','2025-09-19 14:10:08');
INSERT INTO "Translations" VALUES ('item_morog_polao_desc','bn-BD','চিকেন এবং সুগন্ধি মসলা দিয়ে রান্না করা সুগন্ধি চাল','2025-09-19 14:10:08','2025-09-19 14:10:08');
INSERT INTO "Translations" VALUES ('item_tehari','en-US','Beef Tehari','2025-09-19 14:10:08','2025-09-19 14:10:08');
INSERT INTO "Translations" VALUES ('item_tehari','bn-BD','গরুর মাংসের তেহারি','2025-09-19 14:10:08','2025-09-19 14:10:08');
INSERT INTO "Translations" VALUES ('item_tehari_desc','en-US','Spiced rice dish with tender beef pieces','2025-09-19 14:10:08','2025-09-19 14:10:08');
INSERT INTO "Translations" VALUES ('item_tehari_desc','bn-BD','নরম গরুর মাংসের টুকরা সহ মসলাদার চালের খাবার','2025-09-19 14:10:09','2025-09-19 14:10:09');
INSERT INTO "Translations" VALUES ('item_kacchi_gosht','en-US','Kacchi Gosht','2025-09-19 14:10:09','2025-09-19 14:10:09');
INSERT INTO "Translations" VALUES ('item_kacchi_gosht','bn-BD','কাচ্চি গোশত','2025-09-19 14:10:09','2025-09-19 14:10:09');
INSERT INTO "Translations" VALUES ('item_kacchi_gosht_desc','en-US','Slow-cooked tender meat with aromatic spices','2025-09-19 14:10:09','2025-09-19 14:10:09');
INSERT INTO "Translations" VALUES ('item_kacchi_gosht_desc','bn-BD','সুগন্ধি মসলা দিয়ে ধীরে রান্না করা নরম মাংস','2025-09-19 14:10:09','2025-09-19 14:10:09');
INSERT INTO "Translations" VALUES ('item_chicken_korma','en-US','Chicken Korma','2025-09-19 14:10:09','2025-09-19 14:10:09');
INSERT INTO "Translations" VALUES ('item_chicken_korma','bn-BD','চিকেন কোরমা','2025-09-19 14:10:09','2025-09-19 14:10:09');
INSERT INTO "Translations" VALUES ('item_chicken_korma_desc','en-US','Mild and creamy chicken curry with nuts','2025-09-19 14:10:09','2025-09-19 14:10:09');
INSERT INTO "Translations" VALUES ('item_chicken_korma_desc','bn-BD','বাদাম সহ মৃদু এবং ক্রিমি চিকেন কারী','2025-09-19 14:10:09','2025-09-19 14:10:09');
INSERT INTO "Translations" VALUES ('item_beef_bhuna','en-US','Beef Bhuna','2025-09-19 14:10:09','2025-09-19 14:10:09');
INSERT INTO "Translations" VALUES ('item_beef_bhuna','bn-BD','গরুর মাংসের ভুনা','2025-09-19 14:10:09','2025-09-19 14:10:09');
INSERT INTO "Translations" VALUES ('item_beef_bhuna_desc','en-US','Spiced beef cooked until tender with thick gravy','2025-09-19 14:10:09','2025-09-19 14:10:09');
INSERT INTO "Translations" VALUES ('item_beef_bhuna_desc','bn-BD','ঘন ঝোলে নরম না হওয়া পর্যন্ত মসলা দিয়ে রান্না করা গরুর মাংস','2025-09-19 14:10:09','2025-09-19 14:10:09');
INSERT INTO "Translations" VALUES ('item_mutton_curry','en-US','Mutton Curry','2025-09-19 14:10:09','2025-09-19 14:10:09');
INSERT INTO "Translations" VALUES ('item_mutton_curry','bn-BD','খাসির মাংসের কারী','2025-09-19 14:10:09','2025-09-19 14:10:09');
INSERT INTO "Translations" VALUES ('item_mutton_curry_desc','en-US','Tender mutton pieces in a rich spicy gravy','2025-09-19 14:10:09','2025-09-19 14:10:09');
INSERT INTO "Translations" VALUES ('item_mutton_curry_desc','bn-BD','সমৃদ্ধ ঝাল ঝোলে নরম খাসির মাংসের টুকরা','2025-09-19 14:10:09','2025-09-19 14:10:09');
INSERT INTO "Translations" VALUES ('item_chapli_kabab','en-US','Chapli Kebab','2025-09-19 14:10:09','2025-09-19 14:10:09');
INSERT INTO "Translations" VALUES ('item_chapli_kabab','bn-BD','চাপলি কাবাব','2025-09-19 14:10:09','2025-09-19 14:10:09');
INSERT INTO "Translations" VALUES ('item_chapli_kabab_desc','en-US','Spiced minced meat patties fried to perfection','2025-09-19 14:10:09','2025-09-19 14:10:09');
INSERT INTO "Translations" VALUES ('item_chapli_kabab_desc','bn-BD','নিখুঁতভাবে ভাজা মসলাযুক্ত কিমা মাংসের প্যাটি','2025-09-19 14:10:09','2025-09-19 14:10:09');
INSERT INTO "Translations" VALUES ('item_shami_kabab','en-US','Shami Kebab','2025-09-19 14:10:09','2025-09-19 14:10:09');
INSERT INTO "Translations" VALUES ('item_shami_kabab','bn-BD','শামি কাবাব','2025-09-19 14:10:09','2025-09-19 14:10:09');
INSERT INTO "Translations" VALUES ('item_shami_kabab_desc','en-US','Minced meat and lentil patties with spices','2025-09-19 14:10:09','2025-09-19 14:10:09');
INSERT INTO "Translations" VALUES ('item_shami_kabab_desc','bn-BD','মসলা সহ কিমা মাংস এবং ডালের প্যাটি','2025-09-19 14:10:09','2025-09-19 14:10:09');
INSERT INTO "Translations" VALUES ('item_paratha','en-US','Paratha','2025-09-19 14:10:09','2025-09-19 14:10:09');
INSERT INTO "Translations" VALUES ('item_paratha','bn-BD','পরোটা','2025-09-19 14:10:09','2025-09-19 14:10:09');
INSERT INTO "Translations" VALUES ('item_paratha_desc','en-US','Flaky layered flatbread, perfect with curries','2025-09-19 14:10:09','2025-09-19 14:10:09');
INSERT INTO "Translations" VALUES ('item_paratha_desc','bn-BD','ফ্লেকি স্তরযুক্ত ফ্ল্যাটব্রেড, কারীর সাথে নিখুঁত','2025-09-19 14:10:09','2025-09-19 14:10:09');
INSERT INTO "Translations" VALUES ('item_luchi','en-US','Luchi','2025-09-19 14:10:09','2025-09-19 14:10:09');
INSERT INTO "Translations" VALUES ('item_luchi','bn-BD','লুচি','2025-09-19 14:10:09','2025-09-19 14:10:09');
INSERT INTO "Translations" VALUES ('item_luchi_desc','en-US','Light and fluffy deep-fried bread','2025-09-19 14:10:09','2025-09-19 14:10:09');
INSERT INTO "Translations" VALUES ('item_luchi_desc','bn-BD','হালকা এবং ফুলে যাওয়া ডুবো তেলে ভাজা রুটি','2025-09-19 14:10:09','2025-09-19 14:10:09');
INSERT INTO "Translations" VALUES ('item_ruti','en-US','Ruti','2025-09-19 14:10:09','2025-09-19 14:10:09');
INSERT INTO "Translations" VALUES ('item_ruti','bn-BD','রুটি','2025-09-19 14:10:09','2025-09-19 14:10:09');
INSERT INTO "Translations" VALUES ('item_ruti_desc','en-US','Traditional whole wheat flatbread','2025-09-19 14:10:09','2025-09-19 14:10:09');
INSERT INTO "Translations" VALUES ('item_ruti_desc','bn-BD','ঐতিহ্যবাহী গোটা গমের ফ্ল্যাটব্রেড','2025-09-19 14:10:09','2025-09-19 14:10:09');
INSERT INTO "Translations" VALUES ('item_rasmalai','en-US','Rasmalai','2025-09-19 14:10:09','2025-09-19 14:10:09');
INSERT INTO "Translations" VALUES ('item_rasmalai','bn-BD','রসমালাই','2025-09-19 14:10:09','2025-09-19 14:10:09');
INSERT INTO "Translations" VALUES ('item_rasmalai_desc','en-US','Soft cottage cheese dumplings in sweetened milk','2025-09-19 14:10:09','2025-09-19 14:10:09');
INSERT INTO "Translations" VALUES ('item_rasmalai_desc','bn-BD','মিষ্টি দুধে ছানার পিঠা','2025-09-19 14:10:09','2025-09-19 14:10:09');
INSERT INTO "Translations" VALUES ('item_mishti_doi','en-US','Mishti Doi','2025-09-19 14:10:09','2025-09-19 14:10:09');
INSERT INTO "Translations" VALUES ('item_mishti_doi','bn-BD','মিষ্টি দই','2025-09-19 14:10:09','2025-09-19 14:10:09');
INSERT INTO "Translations" VALUES ('item_mishti_doi_desc','en-US','Sweetened yogurt with caramelized flavor','2025-09-19 14:10:09','2025-09-19 14:10:09');
INSERT INTO "Translations" VALUES ('item_mishti_doi_desc','bn-BD','ক্যারামেলাইজড স্বাদের মিষ্টি দই','2025-09-19 14:10:09','2025-09-19 14:10:09');
INSERT INTO "Translations" VALUES ('item_chomchom','en-US','Chomchom','2025-09-19 14:10:09','2025-09-19 14:10:09');
INSERT INTO "Translations" VALUES ('item_chomchom','bn-BD','চমচম','2025-09-19 14:10:09','2025-09-19 14:10:09');
INSERT INTO "Translations" VALUES ('item_chomchom_desc','en-US','Elongated sweet cottage cheese dessert','2025-09-19 14:10:09','2025-09-19 14:10:09');
INSERT INTO "Translations" VALUES ('item_chomchom_desc','bn-BD','লম্বা মিষ্টি ছানার মিষ্টি','2025-09-19 14:10:09','2025-09-19 14:10:09');
INSERT INTO "Translations" VALUES ('item_shondesh','en-US','Shondesh','2025-09-19 14:10:09','2025-09-19 14:10:09');
INSERT INTO "Translations" VALUES ('item_shondesh','bn-BD','সন্দেশ','2025-09-19 14:10:09','2025-09-19 14:10:09');
INSERT INTO "Translations" VALUES ('item_shondesh_desc','en-US','Traditional Bengali sweet made from cottage cheese','2025-09-19 14:10:09','2025-09-19 14:10:09');
INSERT INTO "Translations" VALUES ('item_shondesh_desc','bn-BD','ছানা থেকে তৈরি ঐতিহ্যবাহী বাঙালি মিষ্টি','2025-09-19 14:10:09','2025-09-19 14:10:09');
INSERT INTO "Translations" VALUES ('item_beguni','en-US','Beguni','2025-09-19 14:10:09','2025-09-19 14:10:09');
INSERT INTO "Translations" VALUES ('item_beguni','bn-BD','বেগুনি','2025-09-19 14:10:09','2025-09-19 14:10:09');
INSERT INTO "Translations" VALUES ('item_beguni_desc','en-US','Sliced eggplant coated in batter and deep-fried','2025-09-19 14:10:09','2025-09-19 14:10:09');
INSERT INTO "Translations" VALUES ('item_beguni_desc','bn-BD','ব্যাটারে ডুবিয়ে ডুবো তেলে ভাজা কাটা বেগুন','2025-09-19 14:10:09','2025-09-19 14:10:09');
INSERT INTO "Translations" VALUES ('item_chop','en-US','Aloor Chop','2025-09-19 14:10:09','2025-09-19 14:10:09');
INSERT INTO "Translations" VALUES ('item_chop','bn-BD','আলুর চপ','2025-09-19 14:10:09','2025-09-19 14:10:09');
INSERT INTO "Translations" VALUES ('item_chop_desc','en-US','Spiced potato mixture coated in batter and fried','2025-09-19 14:10:09','2025-09-19 14:10:09');
INSERT INTO "Translations" VALUES ('item_chop_desc','bn-BD','ব্যাটারে ডুবিয়ে ভাজা মসলাযুক্ত আলুর মিশ্রণ','2025-09-19 14:10:09','2025-09-19 14:10:09');
INSERT INTO "Translations" VALUES ('item_singara','en-US','Singara','2025-09-19 14:10:09','2025-09-19 14:10:09');
INSERT INTO "Translations" VALUES ('item_singara','bn-BD','সিঙাড়া','2025-09-19 14:10:09','2025-09-19 14:10:09');
INSERT INTO "Translations" VALUES ('item_singara_desc','en-US','Triangular pastry filled with spiced potatoes and peas','2025-09-19 14:10:09','2025-09-19 14:10:09');
INSERT INTO "Translations" VALUES ('item_singara_desc','bn-BD','মসলাযুক্ত আলু এবং মটরশুঁটি দিয়ে পূর্ণ ত্রিকোণাকার পেস্ট্রি','2025-09-19 14:10:09','2025-09-19 14:10:09');
INSERT INTO "Translations" VALUES ('item_fuchka','en-US','Fuchka','2025-09-19 14:10:09','2025-09-19 14:10:09');
INSERT INTO "Translations" VALUES ('item_fuchka','bn-BD','ফুচকা','2025-09-19 14:10:09','2025-09-19 14:10:09');
INSERT INTO "Translations" VALUES ('item_fuchka_desc','en-US','Crispy hollow spheres filled with spicy tamarind water','2025-09-19 14:10:09','2025-09-19 14:10:09');
INSERT INTO "Translations" VALUES ('item_fuchka_desc','bn-BD','ঝাল তেতুলের পানি দিয়ে পূর্ণ কুরকুরে ফাঁপা গোলক','2025-09-19 14:10:09','2025-09-19 14:10:09');
INSERT INTO "Translations" VALUES ('item_chicken_fried_rice','en-US','Chicken Fried Rice','2025-09-19 14:10:09','2025-09-19 14:10:09');
INSERT INTO "Translations" VALUES ('item_chicken_fried_rice','bn-BD','চিকেন ফ্রাইড রাইস','2025-09-19 14:10:09','2025-09-19 14:10:09');
INSERT INTO "Translations" VALUES ('item_chicken_fried_rice_desc','en-US','Wok-fried rice with chicken pieces and vegetables','2025-09-19 14:10:09','2025-09-19 14:10:09');
INSERT INTO "Translations" VALUES ('item_chicken_fried_rice_desc','bn-BD','চিকেন এবং সবজি দিয়ে ওকে ভাজা ভাত','2025-09-19 14:10:09','2025-09-19 14:10:09');
INSERT INTO "Translations" VALUES ('item_chowmein','en-US','Chicken Chowmein','2025-09-19 14:10:09','2025-09-19 14:10:09');
INSERT INTO "Translations" VALUES ('item_chowmein','bn-BD','চিকেন চাওমিন','2025-09-19 14:10:09','2025-09-19 14:10:09');
INSERT INTO "Translations" VALUES ('item_chowmein_desc','en-US','Stir-fried noodles with chicken and vegetables','2025-09-19 14:10:09','2025-09-19 14:10:09');
INSERT INTO "Translations" VALUES ('item_chowmein_desc','bn-BD','চিকেন এবং সবজি দিয়ে ভাজা নুডলস','2025-09-19 14:10:09','2025-09-19 14:10:09');
INSERT INTO "Translations" VALUES ('item_hot_and_sour_soup','en-US','Hot and Sour Soup','2025-09-19 14:10:09','2025-09-19 14:10:09');
INSERT INTO "Translations" VALUES ('item_hot_and_sour_soup','bn-BD','হট অ্যান্ড সাওয়ার স্যুপ','2025-09-19 14:10:09','2025-09-19 14:10:09');
INSERT INTO "Translations" VALUES ('item_hot_and_sour_soup_desc','en-US','Spicy and tangy soup with vegetables and chicken','2025-09-19 14:10:09','2025-09-19 14:10:09');
INSERT INTO "Translations" VALUES ('item_hot_and_sour_soup_desc','bn-BD','ঝাল এবং টক স্বাদের সবজি এবং চিকেন দিয়ে তৈরি স্যুপ','2025-09-19 14:10:09','2025-09-19 14:10:09');
INSERT INTO "Translations" VALUES ('item_chili_chicken','en-US','Chili Chicken','2025-09-19 14:10:09','2025-09-19 14:10:09');
INSERT INTO "Translations" VALUES ('item_chili_chicken','bn-BD','চিলি চিকেন','2025-09-19 14:10:09','2025-09-19 14:10:09');
INSERT INTO "Translations" VALUES ('item_chili_chicken_desc','en-US','Spicy chicken stir-fried with capsicum and onions','2025-09-19 14:10:09','2025-09-19 14:10:09');
INSERT INTO "Translations" VALUES ('item_chili_chicken_desc','bn-BD','কাঁচা মরিচ এবং পেঁয়াজ দিয়ে ঝাল চিকেন ভাজা','2025-09-19 14:10:09','2025-09-19 14:10:09');
INSERT INTO "Translations" VALUES ('item_veg_fried_rice','en-US','Vegetable Fried Rice','2025-09-19 14:10:09','2025-09-19 14:10:09');
INSERT INTO "Translations" VALUES ('item_veg_fried_rice','bn-BD','ভেজিটেবল ফ্রাইড রাইস','2025-09-19 14:10:09','2025-09-19 14:10:09');
INSERT INTO "Translations" VALUES ('item_veg_fried_rice_desc','en-US','Wok-fried rice with mixed vegetables','2025-09-19 14:10:09','2025-09-19 14:10:09');
INSERT INTO "Translations" VALUES ('item_veg_fried_rice_desc','bn-BD','মিশ্র সবজি দিয়ে ওকে ভাজা ভাত','2025-09-19 14:10:09','2025-09-19 14:10:09');
INSERT INTO "Translations" VALUES ('item_szechuan_rice','en-US','Szechuan Fried Rice','2025-09-19 14:10:09','2025-09-19 14:10:09');
INSERT INTO "Translations" VALUES ('item_szechuan_rice','bn-BD','সিচুয়ান ফ্রাইড রাইস','2025-09-19 14:10:09','2025-09-19 14:10:09');
INSERT INTO "Translations" VALUES ('item_szechuan_rice_desc','en-US','Spicy Szechuan style fried rice with chili and garlic','2025-09-19 14:10:09','2025-09-19 14:10:09');
INSERT INTO "Translations" VALUES ('item_szechuan_rice_desc','bn-BD','মরিচ এবং রসুন দিয়ে ঝাল সিচুয়ান স্টাইল ফ্রাইড রাইস','2025-09-19 14:10:09','2025-09-19 14:10:09');
INSERT INTO "Translations" VALUES ('item_egg_fried_rice','en-US','Egg Fried Rice','2025-09-19 14:10:09','2025-09-19 14:10:09');
INSERT INTO "Translations" VALUES ('item_egg_fried_rice','bn-BD','ডিম ভাজা ভাত','2025-09-19 14:10:09','2025-09-19 14:10:09');
INSERT INTO "Translations" VALUES ('item_egg_fried_rice_desc','en-US','Simple fried rice with scrambled eggs and vegetables','2025-09-19 14:10:09','2025-09-19 14:10:09');
INSERT INTO "Translations" VALUES ('item_egg_fried_rice_desc','bn-BD','ডিম ভাজা এবং সবজি দিয়ে সাধারণ ভাজা ভাত','2025-09-19 14:10:09','2025-09-19 14:10:09');
INSERT INTO "Translations" VALUES ('item_hakka_noodles','en-US','Hakka Noodles','2025-09-19 14:10:09','2025-09-19 14:10:09');
INSERT INTO "Translations" VALUES ('item_hakka_noodles','bn-BD','হাক্কা নুডলস','2025-09-19 14:10:09','2025-09-19 14:10:09');
INSERT INTO "Translations" VALUES ('item_hakka_noodles_desc','en-US','Stir-fried noodles with vegetables and soy sauce','2025-09-19 14:10:09','2025-09-19 14:10:09');
INSERT INTO "Translations" VALUES ('item_hakka_noodles_desc','bn-BD','সবজি এবং সয়া সস দিয়ে ভাজা নুডলস','2025-09-19 14:10:09','2025-09-19 14:10:09');
INSERT INTO "Translations" VALUES ('item_singapore_noodles','en-US','Singapore Noodles','2025-09-19 14:10:09','2025-09-19 14:10:09');
INSERT INTO "Translations" VALUES ('item_singapore_noodles','bn-BD','সিঙ্গাপুর নুডলস','2025-09-19 14:10:09','2025-09-19 14:10:09');
INSERT INTO "Translations" VALUES ('item_singapore_noodles_desc','en-US','Thin rice noodles with curry powder and vegetables','2025-09-19 14:10:09','2025-09-19 14:10:09');
INSERT INTO "Translations" VALUES ('item_singapore_noodles_desc','bn-BD','কারি পাউডার এবং সবজি দিয়ে পাতলা চালের নুডলস','2025-09-19 14:10:09','2025-09-19 14:10:09');
INSERT INTO "Translations" VALUES ('item_schezwan_noodles','en-US','Schezwan Noodles','2025-09-19 14:10:09','2025-09-19 14:10:09');
INSERT INTO "Translations" VALUES ('item_schezwan_noodles','bn-BD','সেজওয়ান নুডলস','2025-09-19 14:10:09','2025-09-19 14:10:09');
INSERT INTO "Translations" VALUES ('item_schezwan_noodles_desc','en-US','Spicy noodles with Schezwan sauce and vegetables','2025-09-19 14:10:09','2025-09-19 14:10:09');
INSERT INTO "Translations" VALUES ('item_schezwan_noodles_desc','bn-BD','সেজওয়ান সস এবং সবজি দিয়ে ঝাল নুডলস','2025-09-19 14:10:09','2025-09-19 14:10:09');
INSERT INTO "Translations" VALUES ('item_wanton_soup','en-US','Wonton Soup','2025-09-19 14:10:09','2025-09-19 14:10:09');
INSERT INTO "Translations" VALUES ('item_wanton_soup','bn-BD','ওয়াংটন স্যুপ','2025-09-19 14:10:09','2025-09-19 14:10:09');
INSERT INTO "Translations" VALUES ('item_wanton_soup_desc','en-US','Clear broth with dumplings filled with meat and vegetables','2025-09-19 14:10:09','2025-09-19 14:10:09');
INSERT INTO "Translations" VALUES ('item_wanton_soup_desc','bn-BD','মাংস এবং সবজি দিয়ে পূর্ণ ডাম্পলিং সহ পরিষ্কার স্টক','2025-09-19 14:10:09','2025-09-19 14:10:09');
INSERT INTO "Translations" VALUES ('item_sweetcorn_soup','en-US','Sweet Corn Soup','2025-09-19 14:10:09','2025-09-19 14:10:09');
INSERT INTO "Translations" VALUES ('item_sweetcorn_soup','bn-BD','মিষ্টি ভুট্টার স্যুপ','2025-09-19 14:10:09','2025-09-19 14:10:09');
INSERT INTO "Translations" VALUES ('item_sweetcorn_soup_desc','en-US','Creamy soup with sweet corn and chicken','2025-09-19 14:10:09','2025-09-19 14:10:09');
INSERT INTO "Translations" VALUES ('item_sweetcorn_soup_desc','bn-BD','মিষ্টি ভুট্টা এবং চিকেন দিয়ে ক্রিমি স্যুপ','2025-09-19 14:10:09','2025-09-19 14:10:09');
INSERT INTO "Translations" VALUES ('item_tomato_soup','en-US','Tomato Soup','2025-09-19 14:10:09','2025-09-19 14:10:09');
INSERT INTO "Translations" VALUES ('item_tomato_soup','bn-BD','টমেটো স্যুপ','2025-09-19 14:10:09','2025-09-19 14:10:09');
INSERT INTO "Translations" VALUES ('item_tomato_soup_desc','en-US','Rich and tangy tomato soup with herbs','2025-09-19 14:10:09','2025-09-19 14:10:09');
INSERT INTO "Translations" VALUES ('item_tomato_soup_desc','bn-BD','ভেষজ সহ সমৃদ্ধ এবং টক টমেটো স্যুপ','2025-09-19 14:10:09','2025-09-19 14:10:09');
INSERT INTO "Translations" VALUES ('item_spring_rolls','en-US','Spring Rolls','2025-09-19 14:10:09','2025-09-19 14:10:09');
INSERT INTO "Translations" VALUES ('item_spring_rolls','bn-BD','স্প্রিং রোল','2025-09-19 14:10:09','2025-09-19 14:10:09');
INSERT INTO "Translations" VALUES ('item_spring_rolls_desc','en-US','Crispy rolls filled with vegetables and served with sweet chili sauce','2025-09-19 14:10:09','2025-09-19 14:10:09');
INSERT INTO "Translations" VALUES ('item_spring_rolls_desc','bn-BD','সবজি দিয়ে পূর্ণ কুরকুরে রোল, মিষ্টি মরিচের সস সহ পরিবেশিত','2025-09-19 14:10:09','2025-09-19 14:10:09');
INSERT INTO "Translations" VALUES ('item_dumplings','en-US','Steamed Dumplings','2025-09-19 14:10:09','2025-09-19 14:10:09');
INSERT INTO "Translations" VALUES ('item_dumplings','bn-BD','ভাপায় রান্না করা ডাম্পলিংস','2025-09-19 14:10:09','2025-09-19 14:10:09');
INSERT INTO "Translations" VALUES ('item_dumplings_desc','en-US','Delicate dumplings filled with meat and vegetables','2025-09-19 14:10:09','2025-09-19 14:10:09');
INSERT INTO "Translations" VALUES ('item_dumplings_desc','bn-BD','মাংস এবং সবজি দিয়ে পূর্ণ কোমল ডাম্পলিংস','2025-09-19 14:10:09','2025-09-19 14:10:09');
INSERT INTO "Translations" VALUES ('item_crispy_chili_chicken','en-US','Crispy Chilli Chicken','2025-09-19 14:10:09','2025-09-19 14:10:09');
INSERT INTO "Translations" VALUES ('item_crispy_chili_chicken','bn-BD','ক্রিস্পি চিলি চিকেন','2025-09-19 14:10:09','2025-09-19 14:10:09');
INSERT INTO "Translations" VALUES ('item_crispy_chili_chicken_desc','en-US','Crispy fried chicken pieces in spicy chili sauce','2025-09-19 14:10:09','2025-09-19 14:10:09');
INSERT INTO "Translations" VALUES ('item_crispy_chili_chicken_desc','bn-BD','ঝাল মরিচের সসে কুরকুরে ভাজা চিকেনের টুকরা','2025-09-19 14:10:09','2025-09-19 14:10:09');
INSERT INTO "Translations" VALUES ('item_garlic_chicken','en-US','Garlic Chicken','2025-09-19 14:10:09','2025-09-19 14:10:09');
INSERT INTO "Translations" VALUES ('item_garlic_chicken','bn-BD','রসুন চিকেন','2025-09-19 14:10:09','2025-09-19 14:10:09');
INSERT INTO "Translations" VALUES ('item_garlic_chicken_desc','en-US','Chicken stir-fried with garlic and chili','2025-09-19 14:10:09','2025-09-19 14:10:09');
INSERT INTO "Translations" VALUES ('item_garlic_chicken_desc','bn-BD','রসুন এবং মরিচ দিয়ে ভাজা চিকেন','2025-09-19 14:10:09','2025-09-19 14:10:09');
INSERT INTO "Translations" VALUES ('item_manchurian','en-US','Gobi Manchurian','2025-09-19 14:10:09','2025-09-19 14:10:09');
INSERT INTO "Translations" VALUES ('item_manchurian','bn-BD','গোবি মাঞ্চুরিয়ান','2025-09-19 14:10:09','2025-09-19 14:10:09');
INSERT INTO "Translations" VALUES ('item_manchurian_desc','en-US','Cauliflower florets in spicy Manchurian sauce','2025-09-19 14:10:09','2025-09-19 14:10:09');
INSERT INTO "Translations" VALUES ('item_manchurian_desc','bn-BD','ঝাল মাঞ্চুরিয়ান সসে ফুলকপি','2025-09-19 14:10:09','2025-09-19 14:10:09');
INSERT INTO "Translations" VALUES ('item_paneer_chilli','en-US','Chilli Paneer','2025-09-19 14:10:09','2025-09-19 14:10:09');
INSERT INTO "Translations" VALUES ('item_paneer_chilli','bn-BD','চিলি পনির','2025-09-19 14:10:09','2025-09-19 14:10:09');
INSERT INTO "Translations" VALUES ('item_paneer_chilli_desc','en-US','Cottage cheese cubes in spicy chili sauce','2025-09-19 14:10:09','2025-09-19 14:10:09');
INSERT INTO "Translations" VALUES ('item_paneer_chilli_desc','bn-BD','ঝাল মরিচের সসে পনিরের কিউব','2025-09-19 14:10:09','2025-09-19 14:10:09');
INSERT INTO "Translations" VALUES ('item_fried_ice_cream','en-US','Fried Ice Cream','2025-09-19 14:10:09','2025-09-19 14:10:09');
INSERT INTO "Translations" VALUES ('item_fried_ice_cream','bn-BD','ভাজা আইসক্রিম','2025-09-19 14:10:09','2025-09-19 14:10:09');
INSERT INTO "Translations" VALUES ('item_fried_ice_cream_desc','en-US','Ice cream coated in batter and quickly fried, served warm','2025-09-19 14:10:09','2025-09-19 14:10:09');
INSERT INTO "Translations" VALUES ('item_fried_ice_cream_desc','bn-BD','ব্যাটারে আবৃত আইসক্রিম দ্রুত ভাজা, উষ্ণ পরিবেশিত','2025-09-19 14:10:09','2025-09-19 14:10:09');
INSERT INTO "Translations" VALUES ('item_darsaan','en-US','Darsaan','2025-09-19 14:10:09','2025-09-19 14:10:09');
INSERT INTO "Translations" VALUES ('item_darsaan','bn-BD','দরসান','2025-09-19 14:10:09','2025-09-19 14:10:09');
INSERT INTO "Translations" VALUES ('item_darsaan_desc','en-US','Honey-glazed fried noodles with ice cream','2025-09-19 14:10:09','2025-09-19 14:10:09');
INSERT INTO "Translations" VALUES ('item_darsaan_desc','bn-BD','মধু-গ্লেজড ভাজা নুডলস আইসক্রিম সহ','2025-09-19 14:10:09','2025-09-19 14:10:09');
INSERT INTO "Translations" VALUES ('item_butter_chicken','en-US','Butter Chicken','2025-09-19 14:10:09','2025-09-19 14:10:09');
INSERT INTO "Translations" VALUES ('item_butter_chicken','bn-BD','বাটার চিকেন','2025-09-19 14:10:09','2025-09-19 14:10:09');
INSERT INTO "Translations" VALUES ('item_butter_chicken_desc','en-US','Tender chicken in creamy tomato sauce','2025-09-19 14:10:09','2025-09-19 14:10:09');
INSERT INTO "Translations" VALUES ('item_butter_chicken_desc','bn-BD','ক্রিমি টমেটো সসে নরম চিকেন','2025-09-19 14:10:09','2025-09-19 14:10:09');
INSERT INTO "Translations" VALUES ('item_naan','en-US','Butter Naan','2025-09-19 14:10:09','2025-09-19 14:10:09');
INSERT INTO "Translations" VALUES ('item_naan','bn-BD','বাটার নান','2025-09-19 14:10:09','2025-09-19 14:10:09');
INSERT INTO "Translations" VALUES ('item_naan_desc','en-US','Soft flatbread brushed with butter','2025-09-19 14:10:09','2025-09-19 14:10:09');
INSERT INTO "Translations" VALUES ('item_naan_desc','bn-BD','মাখন মাখানো নরম ফ্ল্যাটব্রেড','2025-09-19 14:10:09','2025-09-19 14:10:09');
INSERT INTO "Translations" VALUES ('item_tandoori_chicken','en-US','Tandoori Chicken','2025-09-19 14:10:09','2025-09-19 14:10:09');
INSERT INTO "Translations" VALUES ('item_tandoori_chicken','bn-BD','তন্দুরি চিকেন','2025-09-19 14:10:09','2025-09-19 14:10:09');
INSERT INTO "Translations" VALUES ('item_tandoori_chicken_desc','en-US','Chicken marinated in yogurt and spices, cooked in tandoor','2025-09-19 14:10:09','2025-09-19 14:10:09');
INSERT INTO "Translations" VALUES ('item_tandoori_chicken_desc','bn-BD','দই এবং মসলায় মেরিনেট করা চিকেন, তন্দুরে রান্না','2025-09-19 14:10:09','2025-09-19 14:10:09');
INSERT INTO "Translations" VALUES ('item_palak_paneer','en-US','Palak Paneer','2025-09-19 14:10:09','2025-09-19 14:10:09');
INSERT INTO "Translations" VALUES ('item_palak_paneer','bn-BD','পালাক পনির','2025-09-19 14:10:09','2025-09-19 14:10:09');
INSERT INTO "Translations" VALUES ('item_palak_paneer_desc','en-US','Spinach curry with cottage cheese cubes','2025-09-19 14:10:09','2025-09-19 14:10:09');
INSERT INTO "Translations" VALUES ('item_palak_paneer_desc','bn-BD','পালং শাক এবং পনির দিয়ে তৈরি কারী','2025-09-19 14:10:09','2025-09-19 14:10:09');
INSERT INTO "Translations" VALUES ('item_chicken_tikka_masala','en-US','Chicken Tikka Masala','2025-09-19 14:10:09','2025-09-19 14:10:09');
INSERT INTO "Translations" VALUES ('item_chicken_tikka_masala','bn-BD','চিকেন টিক্কা মসলা','2025-09-19 14:10:09','2025-09-19 14:10:09');
INSERT INTO "Translations" VALUES ('item_chicken_tikka_masala_desc','en-US','Grilled chicken pieces in creamy tomato and cashew sauce','2025-09-19 14:10:09','2025-09-19 14:10:09');
INSERT INTO "Translations" VALUES ('item_chicken_tikka_masala_desc','bn-BD','ক্রিমি টমেটো এবং কাজু সসে গ্রিলড চিকেনের টুকরা','2025-09-19 14:10:09','2025-09-19 14:10:09');
INSERT INTO "Translations" VALUES ('item_rogan_josh','en-US','Rogan Josh','2025-09-19 14:10:09','2025-09-19 14:10:09');
INSERT INTO "Translations" VALUES ('item_rogan_josh','bn-BD','রোগন জোশ','2025-09-19 14:10:10','2025-09-19 14:10:10');
INSERT INTO "Translations" VALUES ('item_rogan_josh_desc','en-US','Aromatic lamb curry cooked with Kashmiri spices','2025-09-19 14:10:10','2025-09-19 14:10:10');
INSERT INTO "Translations" VALUES ('item_rogan_josh_desc','bn-BD','কাশ্মীরি মসলা দিয়ে রান্না করা সুগন্ধি ভেড়ার মাংসের কারী','2025-09-19 14:10:10','2025-09-19 14:10:10');
INSERT INTO "Translations" VALUES ('item_dal_makhani','en-US','Dal Makhani','2025-09-19 14:10:10','2025-09-19 14:10:10');
INSERT INTO "Translations" VALUES ('item_dal_makhani','bn-BD','দাল মাখানি','2025-09-19 14:10:10','2025-09-19 14:10:10');
INSERT INTO "Translations" VALUES ('item_dal_makhani_desc','en-US','Creamy lentil dish slow-cooked with butter and cream','2025-09-19 14:10:10','2025-09-19 14:10:10');
INSERT INTO "Translations" VALUES ('item_dal_makhani_desc','bn-BD','মাখন এবং ক্রিম দিয়ে ধীরে রান্না করা ক্রিমি ডালের খাবার','2025-09-19 14:10:10','2025-09-19 14:10:10');
INSERT INTO "Translations" VALUES ('item_chana_masala','en-US','Chana Masala','2025-09-19 14:10:10','2025-09-19 14:10:10');
INSERT INTO "Translations" VALUES ('item_chana_masala','bn-BD','ছানা মসলা','2025-09-19 14:10:10','2025-09-19 14:10:10');
INSERT INTO "Translations" VALUES ('item_chana_masala_desc','en-US','Spiced chickpea curry with onions and tomatoes','2025-09-19 14:10:10','2025-09-19 14:10:10');
INSERT INTO "Translations" VALUES ('item_chana_masala_desc','bn-BD','পেঁয়াজ এবং টমেটো সহ মসলাযুক্ত ছোলার কারী','2025-09-19 14:10:10','2025-09-19 14:10:10');
INSERT INTO "Translations" VALUES ('item_malai_kofta','en-US','Malai Kofta','2025-09-19 14:10:10','2025-09-19 14:10:10');
INSERT INTO "Translations" VALUES ('item_malai_kofta','bn-BD','মালাই কোফতা','2025-09-19 14:10:10','2025-09-19 14:10:10');
INSERT INTO "Translations" VALUES ('item_malai_kofta_desc','en-US','Vegetable dumplings in creamy cashew sauce','2025-09-19 14:10:10','2025-09-19 14:10:10');
INSERT INTO "Translations" VALUES ('item_malai_kofta_desc','bn-BD','ক্রিমি কাজু সসে সবজির কোফতা','2025-09-19 14:10:10','2025-09-19 14:10:10');
INSERT INTO "Translations" VALUES ('item_aloo_gobi','en-US','Aloo Gobi','2025-09-19 14:10:10','2025-09-19 14:10:10');
INSERT INTO "Translations" VALUES ('item_aloo_gobi','bn-BD','আলু গোবি','2025-09-19 14:10:10','2025-09-19 14:10:10');
INSERT INTO "Translations" VALUES ('item_aloo_gobi_desc','en-US','Potato and cauliflower curry with turmeric and spices','2025-09-19 14:10:10','2025-09-19 14:10:10');
INSERT INTO "Translations" VALUES ('item_aloo_gobi_desc','bn-BD','হলুদ এবং মসলা দিয়ে আলু এবং ফুলকপির কারী','2025-09-19 14:10:10','2025-09-19 14:10:10');
INSERT INTO "Translations" VALUES ('item_baingan_bharta','en-US','Baingan Bharta','2025-09-19 14:10:10','2025-09-19 14:10:10');
INSERT INTO "Translations" VALUES ('item_baingan_bharta','bn-BD','বেগুন ভর্তা','2025-09-19 14:10:10','2025-09-19 14:10:10');
INSERT INTO "Translations" VALUES ('item_baingan_bharta_desc','en-US','Smoked eggplant mashed with tomatoes and spices','2025-09-19 14:10:10','2025-09-19 14:10:10');
INSERT INTO "Translations" VALUES ('item_baingan_bharta_desc','bn-BD','ধূমপান করা বেগুন টমেটো এবং মসলা দিয়ে মেশানো','2025-09-19 14:10:10','2025-09-19 14:10:10');
INSERT INTO "Translations" VALUES ('item_tandoori_roti','en-US','Tandoori Roti','2025-09-19 14:10:10','2025-09-19 14:10:10');
INSERT INTO "Translations" VALUES ('item_tandoori_roti','bn-BD','তন্দুরি রুটি','2025-09-19 14:10:10','2025-09-19 14:10:10');
INSERT INTO "Translations" VALUES ('item_tandoori_roti_desc','en-US','Whole wheat flatbread baked in tandoor','2025-09-19 14:10:10','2025-09-19 14:10:10');
INSERT INTO "Translations" VALUES ('item_tandoori_roti_desc','bn-BD','তন্দুরে বেক করা গোটা গমের ফ্ল্যাটব্রেড','2025-09-19 14:10:10','2025-09-19 14:10:10');
INSERT INTO "Translations" VALUES ('item_garlic_naan','en-US','Garlic Naan','2025-09-19 14:10:10','2025-09-19 14:10:10');
INSERT INTO "Translations" VALUES ('item_garlic_naan','bn-BD','রসুন নান','2025-09-19 14:10:10','2025-09-19 14:10:10');
INSERT INTO "Translations" VALUES ('item_garlic_naan_desc','en-US','Soft naan bread topped with garlic and butter','2025-09-19 14:10:10','2025-09-19 14:10:10');
INSERT INTO "Translations" VALUES ('item_garlic_naan_desc','bn-BD','রসুন এবং মাখন দিয়ে টপড নরম নান রুটি','2025-09-19 14:10:10','2025-09-19 14:10:10');
INSERT INTO "Translations" VALUES ('item_lachha_paratha','en-US','Lachha Paratha','2025-09-19 14:10:10','2025-09-19 14:10:10');
INSERT INTO "Translations" VALUES ('item_lachha_paratha','bn-BD','লাচ্ছা পরোটা','2025-09-19 14:10:10','2025-09-19 14:10:10');
INSERT INTO "Translations" VALUES ('item_lachha_paratha_desc','en-US','Multi-layered flaky paratha with crispy layers','2025-09-19 14:10:10','2025-09-19 14:10:10');
INSERT INTO "Translations" VALUES ('item_lachha_paratha_desc','bn-BD','কুরকুরে স্তর সহ বহু-স্তরযুক্ত ফ্লেকি পরোটা','2025-09-19 14:10:10','2025-09-19 14:10:10');
INSERT INTO "Translations" VALUES ('item_pulao','en-US','Vegetable Pulao','2025-09-19 14:10:10','2025-09-19 14:10:10');
INSERT INTO "Translations" VALUES ('item_pulao','bn-BD','ভেজিটেবল পোলাও','2025-09-19 14:10:10','2025-09-19 14:10:10');
INSERT INTO "Translations" VALUES ('item_pulao_desc','en-US','Fragrant basmati rice cooked with mixed vegetables','2025-09-19 14:10:10','2025-09-19 14:10:10');
INSERT INTO "Translations" VALUES ('item_pulao_desc','bn-BD','মিশ্র সবজি দিয়ে রান্না করা সুগন্ধি বাসমতি চাল','2025-09-19 14:10:10','2025-09-19 14:10:10');
INSERT INTO "Translations" VALUES ('item_jeera_rice','en-US','Jeera Rice','2025-09-19 14:10:10','2025-09-19 14:10:10');
INSERT INTO "Translations" VALUES ('item_jeera_rice','bn-BD','জিরা ভাত','2025-09-19 14:10:10','2025-09-19 14:10:10');
INSERT INTO "Translations" VALUES ('item_jeera_rice_desc','en-US','Basmati rice flavored with cumin seeds','2025-09-19 14:10:10','2025-09-19 14:10:10');
INSERT INTO "Translations" VALUES ('item_jeera_rice_desc','bn-BD','জিরা বীজ দিয়ে স্বাদযুক্ত বাসমতি চাল','2025-09-19 14:10:10','2025-09-19 14:10:10');
INSERT INTO "Translations" VALUES ('item_biryani_rice','en-US','Hyderabadi Biryani','2025-09-19 14:10:10','2025-09-19 14:10:10');
INSERT INTO "Translations" VALUES ('item_biryani_rice','bn-BD','হায়দ্রাবাদী বিরিয়ানি','2025-09-19 14:10:10','2025-09-19 14:10:10');
INSERT INTO "Translations" VALUES ('item_biryani_rice_desc','en-US','Fragrant rice layered with marinated meat and spices','2025-09-19 14:10:10','2025-09-19 14:10:10');
INSERT INTO "Translations" VALUES ('item_biryani_rice_desc','bn-BD','মেরিনেট করা মাংস এবং মসলা দিয়ে স্তরযুক্ত সুগন্ধি চাল','2025-09-19 14:10:10','2025-09-19 14:10:10');
INSERT INTO "Translations" VALUES ('item_samosa','en-US','Samosa','2025-09-19 14:10:10','2025-09-19 14:10:10');
INSERT INTO "Translations" VALUES ('item_samosa','bn-BD','সমোসা','2025-09-19 14:10:10','2025-09-19 14:10:10');
INSERT INTO "Translations" VALUES ('item_samosa_desc','en-US','Crispy triangular pastry filled with spiced potatoes and peas','2025-09-19 14:10:10','2025-09-19 14:10:10');
INSERT INTO "Translations" VALUES ('item_samosa_desc','bn-BD','মসলাযুক্ত আলু এবং মটরশুঁটি দিয়ে পূর্ণ কুরকুরে ত্রিকোণাকার পেস্ট্রি','2025-09-19 14:10:10','2025-09-19 14:10:10');
INSERT INTO "Translations" VALUES ('item_pakora','en-US','Vegetable Pakora','2025-09-19 14:10:10','2025-09-19 14:10:10');
INSERT INTO "Translations" VALUES ('item_pakora','bn-BD','ভেজিটেবল পাকোড়া','2025-09-19 14:10:10','2025-09-19 14:10:10');
INSERT INTO "Translations" VALUES ('item_pakora_desc','en-US','Mixed vegetables coated in gram flour batter and deep-fried','2025-09-19 14:10:10','2025-09-19 14:10:10');
INSERT INTO "Translations" VALUES ('item_pakora_desc','bn-BD','বেসন ব্যাটারে আবৃত মিশ্র সবজি ডুবো তেলে ভাজা','2025-09-19 14:10:10','2025-09-19 14:10:10');
INSERT INTO "Translations" VALUES ('item_papad','en-US','Papad','2025-09-19 14:10:10','2025-09-19 14:10:10');
INSERT INTO "Translations" VALUES ('item_papad','bn-BD','পাপড়','2025-09-19 14:10:10','2025-09-19 14:10:10');
INSERT INTO "Translations" VALUES ('item_papad_desc','en-US','Thin and crispy lentil wafers, roasted or fried','2025-09-19 14:10:10','2025-09-19 14:10:10');
INSERT INTO "Translations" VALUES ('item_papad_desc','bn-BD','পাতলা এবং কুরকুরে ডালের ওয়েফার, ভাজা বা রোস্টেড','2025-09-19 14:10:10','2025-09-19 14:10:10');
INSERT INTO "Translations" VALUES ('item_gulab_jamun','en-US','Gulab Jamun','2025-09-19 14:10:10','2025-09-19 14:10:10');
INSERT INTO "Translations" VALUES ('item_gulab_jamun','bn-BD','গোলাপ জামুন','2025-09-19 14:10:10','2025-09-19 14:10:10');
INSERT INTO "Translations" VALUES ('item_gulab_jamun_desc','en-US','Soft milk solids dumplings soaked in rose-flavored sugar syrup','2025-09-19 14:10:10','2025-09-19 14:10:10');
INSERT INTO "Translations" VALUES ('item_gulab_jamun_desc','bn-BD','গোলাপ-স্বাদযুক্ত চিনির সিরায় ভেজানো নরম দুধের কঠিন পদার্থের ডাম্পলিং','2025-09-19 14:10:10','2025-09-19 14:10:10');
INSERT INTO "Translations" VALUES ('item_kheer','en-US','Rice Kheer','2025-09-19 14:10:10','2025-09-19 14:10:10');
INSERT INTO "Translations" VALUES ('item_kheer','bn-BD','চালের ক্ষীর','2025-09-19 14:10:10','2025-09-19 14:10:10');
INSERT INTO "Translations" VALUES ('item_kheer_desc','en-US','Creamy rice pudding with nuts and cardamom','2025-09-19 14:10:10','2025-09-19 14:10:10');
INSERT INTO "Translations" VALUES ('item_kheer_desc','bn-BD','বাদাম এবং এলাচ সহ ক্রিমি চালের পুডিং','2025-09-19 14:10:10','2025-09-19 14:10:10');
INSERT INTO "Translations" VALUES ('item_jalebi','en-US','Jalebi','2025-09-19 14:10:10','2025-09-19 14:10:10');
INSERT INTO "Translations" VALUES ('item_jalebi','bn-BD','জিলাপি','2025-09-19 14:10:10','2025-09-19 14:10:10');
INSERT INTO "Translations" VALUES ('item_jalebi_desc','en-US','Crispy pretzel-shaped sweets soaked in sugar syrup','2025-09-19 14:10:10','2025-09-19 14:10:10');
INSERT INTO "Translations" VALUES ('item_jalebi_desc','bn-BD','চিনির সিরায় ভেজানো কুরকুরে প্রেটজেল-আকৃতির মিষ্টি','2025-09-19 14:10:10','2025-09-19 14:10:10');
INSERT INTO "Translations" VALUES ('item_margherita_pizza','en-US','Margherita Pizza','2025-09-19 14:10:10','2025-09-19 14:10:10');
INSERT INTO "Translations" VALUES ('item_margherita_pizza','bn-BD','মার্গারিটা পিৎজা','2025-09-19 14:10:10','2025-09-19 14:10:10');
INSERT INTO "Translations" VALUES ('item_margherita_pizza_desc','en-US','Classic pizza with tomato sauce, mozzarella and basil','2025-09-19 14:10:10','2025-09-19 14:10:10');
INSERT INTO "Translations" VALUES ('item_margherita_pizza_desc','bn-BD','টমেটো সস, মোজারেলা এবং তুলসী পাতা দিয়ে ক্লাসিক পিৎজা','2025-09-19 14:10:10','2025-09-19 14:10:10');
INSERT INTO "Translations" VALUES ('item_spaghetti_pasta','en-US','Spaghetti Bolognese','2025-09-19 14:10:10','2025-09-19 14:10:10');
INSERT INTO "Translations" VALUES ('item_spaghetti_pasta','bn-BD','স্প্যাগেটি বোলোনিজ','2025-09-19 14:10:10','2025-09-19 14:10:10');
INSERT INTO "Translations" VALUES ('item_spaghetti_pasta_desc','en-US','Spaghetti pasta with meat sauce','2025-09-19 14:10:10','2025-09-19 14:10:10');
INSERT INTO "Translations" VALUES ('item_spaghetti_pasta_desc','bn-BD','মাংসের সস দিয়ে স্প্যাগেটি পাস্তা','2025-09-19 14:10:10','2025-09-19 14:10:10');
INSERT INTO "Translations" VALUES ('item_caesar_salad','en-US','Caesar Salad','2025-09-19 14:10:10','2025-09-19 14:10:10');
INSERT INTO "Translations" VALUES ('item_caesar_salad','bn-BD','সিজার সালাদ','2025-09-19 14:10:10','2025-09-19 14:10:10');
INSERT INTO "Translations" VALUES ('item_caesar_salad_desc','en-US','Romaine lettuce with croutons, parmesan and Caesar dressing','2025-09-19 14:10:10','2025-09-19 14:10:10');
INSERT INTO "Translations" VALUES ('item_caesar_salad_desc','bn-BD','ক্রুটন, পারমেসান এবং সিজার ড্রেসিং সহ রোমাইন লেটুস','2025-09-19 14:10:10','2025-09-19 14:10:10');
INSERT INTO "Translations" VALUES ('item_garlic_bread','en-US','Garlic Bread','2025-09-19 14:10:10','2025-09-19 14:10:10');
INSERT INTO "Translations" VALUES ('item_garlic_bread','bn-BD','রসুন রুটি','2025-09-19 14:10:10','2025-09-19 14:10:10');
INSERT INTO "Translations" VALUES ('item_garlic_bread_desc','en-US','Toasted bread with garlic butter and herbs','2025-09-19 14:10:10','2025-09-19 14:10:10');
INSERT INTO "Translations" VALUES ('item_garlic_bread_desc','bn-BD','রসুন মাখানো মাখন এবং গার্নিশ দিয়ে টোস্টেড রুটি','2025-09-19 14:10:10','2025-09-19 14:10:10');
INSERT INTO "Translations" VALUES ('item_pepperoni_pizza','en-US','Pepperoni Pizza','2025-09-19 14:10:10','2025-09-19 14:10:10');
INSERT INTO "Translations" VALUES ('item_pepperoni_pizza','bn-BD','পেপেরোনি পিৎজা','2025-09-19 14:10:10','2025-09-19 14:10:10');
INSERT INTO "Translations" VALUES ('item_pepperoni_pizza_desc','en-US','Classic pizza topped with pepperoni slices and mozzarella cheese','2025-09-19 14:10:10','2025-09-19 14:10:10');
INSERT INTO "Translations" VALUES ('item_pepperoni_pizza_desc','bn-BD','পেপেরোনি স্লাইস এবং মোজারেলা পনির দিয়ে টপড ক্লাসিক পিৎজা','2025-09-19 14:10:10','2025-09-19 14:10:10');
INSERT INTO "Translations" VALUES ('item_hawaiian_pizza','en-US','Hawaiian Pizza','2025-09-19 14:10:10','2025-09-19 14:10:10');
INSERT INTO "Translations" VALUES ('item_hawaiian_pizza','bn-BD','হাওয়াইয়ান পিৎজা','2025-09-19 14:10:10','2025-09-19 14:10:10');
INSERT INTO "Translations" VALUES ('item_hawaiian_pizza_desc','en-US','Pizza topped with ham, pineapple, and mozzarella cheese','2025-09-19 14:10:10','2025-09-19 14:10:10');
INSERT INTO "Translations" VALUES ('item_hawaiian_pizza_desc','bn-BD','হ্যাম, আনারস, এবং মোজারেলা পনির দিয়ে টপড পিৎজা','2025-09-19 14:10:10','2025-09-19 14:10:10');
INSERT INTO "Translations" VALUES ('item_veggie_pizza','en-US','Vegetarian Pizza','2025-09-19 14:10:10','2025-09-19 14:10:10');
INSERT INTO "Translations" VALUES ('item_veggie_pizza','bn-BD','ভেজিটেরিয়ান পিৎজা','2025-09-19 14:10:10','2025-09-19 14:10:10');
INSERT INTO "Translations" VALUES ('item_veggie_pizza_desc','en-US','Pizza topped with bell peppers, mushrooms, onions, and olives','2025-09-19 14:10:10','2025-09-19 14:10:10');
INSERT INTO "Translations" VALUES ('item_veggie_pizza_desc','bn-BD','বেল পেপার, মাশরুম, পেঁয়াজ, এবং জলপাই দিয়ে টপড পিৎজা','2025-09-19 14:10:10','2025-09-19 14:10:10');
INSERT INTO "Translations" VALUES ('item_bbq_chicken_pizza','en-US','BBQ Chicken Pizza','2025-09-19 14:10:10','2025-09-19 14:10:10');
INSERT INTO "Translations" VALUES ('item_bbq_chicken_pizza','bn-BD','বিবিকিউ চিকেন পিৎজা','2025-09-19 14:10:10','2025-09-19 14:10:10');
INSERT INTO "Translations" VALUES ('item_bbq_chicken_pizza_desc','en-US','Pizza with BBQ sauce, grilled chicken, red onions, and cilantro','2025-09-19 14:10:10','2025-09-19 14:10:10');
INSERT INTO "Translations" VALUES ('item_bbq_chicken_pizza_desc','bn-BD','বিবিকিউ সস, গ্রিলড চিকেন, লাল পেঁয়াজ, এবং ধনিয়া সহ পিৎজা','2025-09-19 14:10:10','2025-09-19 14:10:10');
INSERT INTO "Translations" VALUES ('item_fettuccine_alfredo','en-US','Fettuccine Alfredo','2025-09-19 14:10:10','2025-09-19 14:10:10');
INSERT INTO "Translations" VALUES ('item_fettuccine_alfredo','bn-BD','ফেটুচিনি আলফ্রেডো','2025-09-19 14:10:10','2025-09-19 14:10:10');
INSERT INTO "Translations" VALUES ('item_fettuccine_alfredo_desc','en-US','Fettuccine pasta in creamy Parmesan sauce','2025-09-19 14:10:10','2025-09-19 14:10:10');
INSERT INTO "Translations" VALUES ('item_fettuccine_alfredo_desc','bn-BD','ক্রিমি পারমেসান সসে ফেটুচিনি পাস্তা','2025-09-19 14:10:10','2025-09-19 14:10:10');
INSERT INTO "Translations" VALUES ('item_penne_arrabbiata','en-US','Penne Arrabbiata','2025-09-19 14:10:10','2025-09-19 14:10:10');
INSERT INTO "Translations" VALUES ('item_penne_arrabbiata','bn-BD','পেনে আরাবিয়াতা','2025-09-19 14:10:10','2025-09-19 14:10:10');
INSERT INTO "Translations" VALUES ('item_penne_arrabbiata_desc','en-US','Penne pasta in spicy tomato sauce with garlic and herbs','2025-09-19 14:10:10','2025-09-19 14:10:10');
INSERT INTO "Translations" VALUES ('item_penne_arrabbiata_desc','bn-BD','রসুন এবং ভেষজ সহ ঝাল টমেটো সসে পেনে পাস্তা','2025-09-19 14:10:10','2025-09-19 14:10:10');
INSERT INTO "Translations" VALUES ('item_lasagna','en-US','Lasagna','2025-09-19 14:10:10','2025-09-19 14:10:10');
INSERT INTO "Translations" VALUES ('item_lasagna','bn-BD','লাসানিয়া','2025-09-19 14:10:10','2025-09-19 14:10:10');
INSERT INTO "Translations" VALUES ('item_lasagna_desc','en-US','Layers of pasta with meat sauce, béchamel, and cheese','2025-09-19 14:10:10','2025-09-19 14:10:10');
INSERT INTO "Translations" VALUES ('item_lasagna_desc','bn-BD','মাংসের সস, বেচামেল এবং পনির সহ পাস্তার স্তর','2025-09-19 14:10:10','2025-09-19 14:10:10');
INSERT INTO "Translations" VALUES ('item_ravioli','en-US','Cheese Ravioli','2025-09-19 14:10:10','2025-09-19 14:10:10');
INSERT INTO "Translations" VALUES ('item_ravioli','bn-BD','চিজ রাভিওলি','2025-09-19 14:10:10','2025-09-19 14:10:10');
INSERT INTO "Translations" VALUES ('item_ravioli_desc','en-US','Pasta pillows filled with cheese and served in tomato sauce','2025-09-19 14:10:10','2025-09-19 14:10:10');
INSERT INTO "Translations" VALUES ('item_ravioli_desc','bn-BD','পনির দিয়ে পূর্ণ পাস্তা পিলো, টমেটো সসে পরিবেশিত','2025-09-19 14:10:10','2025-09-19 14:10:10');
INSERT INTO "Translations" VALUES ('item_greek_salad','en-US','Greek Salad','2025-09-19 14:10:10','2025-09-19 14:10:10');
INSERT INTO "Translations" VALUES ('item_greek_salad','bn-BD','গ্রীক সালাদ','2025-09-19 14:10:10','2025-09-19 14:10:10');
INSERT INTO "Translations" VALUES ('item_greek_salad_desc','en-US','Fresh vegetables with feta cheese, olives, and Greek dressing','2025-09-19 14:10:10','2025-09-19 14:10:10');
INSERT INTO "Translations" VALUES ('item_greek_salad_desc','bn-BD','ফেটা পনির, জলপাই এবং গ্রীক ড্রেসিং সহ তাজা সবজি','2025-09-19 14:10:10','2025-09-19 14:10:10');
INSERT INTO "Translations" VALUES ('item_caprese_salad','en-US','Caprese Salad','2025-09-19 14:10:10','2025-09-19 14:10:10');
INSERT INTO "Translations" VALUES ('item_caprese_salad','bn-BD','কাপ্রেসে সালাদ','2025-09-19 14:10:10','2025-09-19 14:10:10');
INSERT INTO "Translations" VALUES ('item_caprese_salad_desc','en-US','Fresh mozzarella, tomatoes, and basil with balsamic glaze','2025-09-19 14:10:10','2025-09-19 14:10:10');
INSERT INTO "Translations" VALUES ('item_caprese_salad_desc','bn-BD','তাজা মোজারেলা, টমেটো, এবং বালসামিক গ্লেজ সহ তুলসী','2025-09-19 14:10:10','2025-09-19 14:10:10');
INSERT INTO "Translations" VALUES ('item_antonio_salad','en-US','Antonio Salad','2025-09-19 14:10:10','2025-09-19 14:10:10');
INSERT INTO "Translations" VALUES ('item_antonio_salad','bn-BD','অ্যান্টোনিও সালাদ','2025-09-19 14:10:10','2025-09-19 14:10:10');
INSERT INTO "Translations" VALUES ('item_antonio_salad_desc','en-US','Mixed greens with grilled chicken, avocado, and Caesar dressing','2025-09-19 14:10:10','2025-09-19 14:10:10');
INSERT INTO "Translations" VALUES ('item_antonio_salad_desc','bn-BD','গ্রিলড চিকেন, আভোকাডো, এবং সিজার ড্রেসিং সহ মিশ্র সবুজ','2025-09-19 14:10:10','2025-09-19 14:10:10');
INSERT INTO "Translations" VALUES ('item_bruschetta','en-US','Bruschetta','2025-09-19 14:10:10','2025-09-19 14:10:10');
INSERT INTO "Translations" VALUES ('item_bruschetta','bn-BD','ব্রুসকেটা','2025-09-19 14:10:10','2025-09-19 14:10:10');
INSERT INTO "Translations" VALUES ('item_bruschetta_desc','en-US','Toasted bread topped with tomatoes, garlic, and fresh basil','2025-09-19 14:10:10','2025-09-19 14:10:10');
INSERT INTO "Translations" VALUES ('item_bruschetta_desc','bn-BD','টমেটো, রসুন, এবং তাজা তুলসী দিয়ে টপড টোস্টেড রুটি','2025-09-19 14:10:10','2025-09-19 14:10:10');
INSERT INTO "Translations" VALUES ('item_calamari','en-US','Calamari','2025-09-19 14:10:10','2025-09-19 14:10:10');
INSERT INTO "Translations" VALUES ('item_calamari','bn-BD','ক্যালামারি','2025-09-19 14:10:10','2025-09-19 14:10:10');
INSERT INTO "Translations" VALUES ('item_calamari_desc','en-US','Crispy fried squid rings served with marinara sauce','2025-09-19 14:10:10','2025-09-19 14:10:10');
INSERT INTO "Translations" VALUES ('item_calamari_desc','bn-BD','মেরিনারা সস সহ পরিবেশিত কুরকুরে ভাজা স্কুইড রিংস','2025-09-19 14:10:10','2025-09-19 14:10:10');
INSERT INTO "Translations" VALUES ('item_arancini','en-US','Arancini','2025-09-19 14:10:10','2025-09-19 14:10:10');
INSERT INTO "Translations" VALUES ('item_arancini','bn-BD','আরানচিনি','2025-09-19 14:10:10','2025-09-19 14:10:10');
INSERT INTO "Translations" VALUES ('item_arancini_desc','en-US','Crispy risotto balls filled with cheese and deep-fried','2025-09-19 14:10:10','2025-09-19 14:10:10');
INSERT INTO "Translations" VALUES ('item_arancini_desc','bn-BD','পনির দিয়ে পূর্ণ কুরকুরে রিসোট্টো বল ডুবো তেলে ভাজা','2025-09-19 14:10:10','2025-09-19 14:10:10');
INSERT INTO "Translations" VALUES ('item_tiramisu','en-US','Tiramisu','2025-09-19 14:10:10','2025-09-19 14:10:10');
INSERT INTO "Translations" VALUES ('item_tiramisu','bn-BD','টিরামিসু','2025-09-19 14:10:10','2025-09-19 14:10:10');
INSERT INTO "Translations" VALUES ('item_tiramisu_desc','en-US','Classic Italian dessert with coffee-soaked ladyfingers and mascarpone','2025-09-19 14:10:10','2025-09-19 14:10:10');
INSERT INTO "Translations" VALUES ('item_tiramisu_desc','bn-BD','কফি-সোকড লেডিফিঙ্গার এবং মাসকারপোন সহ ক্লাসিক ইতালীয় ডেজার্ট','2025-09-19 14:10:10','2025-09-19 14:10:10');
INSERT INTO "Translations" VALUES ('item_panna_cotta','en-US','Panna Cotta','2025-09-19 14:10:10','2025-09-19 14:10:10');
INSERT INTO "Translations" VALUES ('item_panna_cotta','bn-BD','পান্না কোটা','2025-09-19 14:10:10','2025-09-19 14:10:10');
INSERT INTO "Translations" VALUES ('item_panna_cotta_desc','en-US','Silky smooth vanilla pudding topped with berry sauce','2025-09-19 14:10:10','2025-09-19 14:10:10');
INSERT INTO "Translations" VALUES ('item_panna_cotta_desc','bn-BD','বেরি সস দিয়ে টপড রেশমী মসৃণ ভ্যানিলা পুডিং','2025-09-19 14:10:10','2025-09-19 14:10:10');
INSERT INTO "Translations" VALUES ('item_cannoli','en-US','Cannoli','2025-09-19 14:10:10','2025-09-19 14:10:10');
INSERT INTO "Translations" VALUES ('item_cannoli','bn-BD','কানোলি','2025-09-19 14:10:10','2025-09-19 14:10:10');
INSERT INTO "Translations" VALUES ('item_cannoli_desc','en-US','Crispy pastry shells filled with sweet ricotta cheese','2025-09-19 14:10:10','2025-09-19 14:10:10');
INSERT INTO "Translations" VALUES ('item_cannoli_desc','bn-BD','মিষ্টি রিকোটা পনির দিয়ে পূর্ণ কুরকুরে পেস্ট্রি শেল','2025-09-19 14:10:10','2025-09-19 14:10:10');
INSERT INTO "Translations" VALUES ('item_gelato','en-US','Gelato','2025-09-19 14:10:11','2025-09-19 14:10:11');
INSERT INTO "Translations" VALUES ('item_gelato','bn-BD','জেলাতো','2025-09-19 14:10:11','2025-09-19 14:10:11');
INSERT INTO "Translations" VALUES ('item_gelato_desc','en-US','Italian ice cream with intense flavor and creamy texture','2025-09-19 14:10:11','2025-09-19 14:10:11');
INSERT INTO "Translations" VALUES ('item_gelato_desc','bn-BD','তীব্র স্বাদ এবং ক্রিমি টেক্সচার সহ ইতালীয় আইসক্রিম','2025-09-19 14:10:11','2025-09-19 14:10:11');
INSERT INTO "Translations" VALUES ('item_chicken_marsala','en-US','Chicken Marsala','2025-09-19 14:10:11','2025-09-19 14:10:11');
INSERT INTO "Translations" VALUES ('item_chicken_marsala','bn-BD','চিকেন মারসালা','2025-09-19 14:10:11','2025-09-19 14:10:11');
INSERT INTO "Translations" VALUES ('item_chicken_marsala_desc','en-US','Chicken cutlets in a rich Marsala wine and mushroom sauce','2025-09-19 14:10:11','2025-09-19 14:10:11');
INSERT INTO "Translations" VALUES ('item_chicken_marsala_desc','bn-BD','সমৃদ্ধ মারসালা ওয়াইন এবং মাশরুম সসে চিকেন কাটলেট','2025-09-19 14:10:11','2025-09-19 14:10:11');
INSERT INTO "Translations" VALUES ('item_veal_scaloppine','en-US','Veal Scaloppine','2025-09-19 14:10:11','2025-09-19 14:10:11');
INSERT INTO "Translations" VALUES ('item_veal_scaloppine','bn-BD','ভিল স্কালোপিন','2025-09-19 14:10:11','2025-09-19 14:10:11');
INSERT INTO "Translations" VALUES ('item_veal_scaloppine_desc','en-US','Thin veal cutlets sautéed in lemon and white wine sauce','2025-09-19 14:10:11','2025-09-19 14:10:11');
INSERT INTO "Translations" VALUES ('item_veal_scaloppine_desc','bn-BD','লেবু এবং সাদা ওয়াইন সসে সটেড পাতলা গরুর মাংসের কাটলেট','2025-09-19 14:10:11','2025-09-19 14:10:11');
INSERT INTO "Translations" VALUES ('item_california_roll','en-US','California Roll','2025-09-19 14:10:11','2025-09-19 14:10:11');
INSERT INTO "Translations" VALUES ('item_california_roll','bn-BD','ক্যালিফোর্নিয়া রোল','2025-09-19 14:10:11','2025-09-19 14:10:11');
INSERT INTO "Translations" VALUES ('item_california_roll_desc','en-US','Sushi roll with crab, avocado and cucumber','2025-09-19 14:10:11','2025-09-19 14:10:11');
INSERT INTO "Translations" VALUES ('item_california_roll_desc','bn-BD','কাঁকড়া, আভোকাডো এবং কাকুম্বার দিয়ে তৈরি সুশি রোল','2025-09-19 14:10:11','2025-09-19 14:10:11');
INSERT INTO "Translations" VALUES ('item_chicken_ramen','en-US','Chicken Ramen','2025-09-19 14:10:11','2025-09-19 14:10:11');
INSERT INTO "Translations" VALUES ('item_chicken_ramen','bn-BD','চিকেন রামেন','2025-09-19 14:10:11','2025-09-19 14:10:11');
INSERT INTO "Translations" VALUES ('item_chicken_ramen_desc','en-US','Noodle soup with chicken, vegetables and miso broth','2025-09-19 14:10:11','2025-09-19 14:10:11');
INSERT INTO "Translations" VALUES ('item_chicken_ramen_desc','bn-BD','চিকেন, সবজি এবং মিসো স্টক দিয়ে তৈরি নুডলস স্যুপ','2025-09-19 14:10:11','2025-09-19 14:10:11');
INSERT INTO "Translations" VALUES ('item_tempura','en-US','Vegetable Tempura','2025-09-19 14:10:11','2025-09-19 14:10:11');
INSERT INTO "Translations" VALUES ('item_tempura','bn-BD','সবজি টেম্পুরা','2025-09-19 14:10:11','2025-09-19 14:10:11');
INSERT INTO "Translations" VALUES ('item_tempura_desc','en-US','Lightly battered and fried vegetables','2025-09-19 14:10:11','2025-09-19 14:10:11');
INSERT INTO "Translations" VALUES ('item_tempura_desc','bn-BD','হালকা ব্যাটারে ডুবিয়ে ভাজা সবজি','2025-09-19 14:10:11','2025-09-19 14:10:11');
INSERT INTO "Translations" VALUES ('item_tepanyaki_chicken','en-US','Teppanyaki Chicken','2025-09-19 14:10:11','2025-09-19 14:10:11');
INSERT INTO "Translations" VALUES ('item_tepanyaki_chicken','bn-BD','তেপ্পানিয়াকি চিকেন','2025-09-19 14:10:11','2025-09-19 14:10:11');
INSERT INTO "Translations" VALUES ('item_tepanyaki_chicken_desc','en-US','Grilled chicken with vegetables on iron griddle','2025-09-19 14:10:11','2025-09-19 14:10:11');
INSERT INTO "Translations" VALUES ('item_tepanyaki_chicken_desc','bn-BD','লোহার গ্রিডলে সবজি সহকারে গ্রিল করা চিকেন','2025-09-19 14:10:11','2025-09-19 14:10:11');
INSERT INTO "Translations" VALUES ('item_salmon_roll','en-US','Salmon Roll','2025-09-19 14:10:11','2025-09-19 14:10:11');
INSERT INTO "Translations" VALUES ('item_salmon_roll','bn-BD','স্যামন রোল','2025-09-19 14:10:11','2025-09-19 14:10:11');
INSERT INTO "Translations" VALUES ('item_salmon_roll_desc','en-US','Fresh salmon with avocado and cucumber in nori','2025-09-19 14:10:11','2025-09-19 14:10:11');
INSERT INTO "Translations" VALUES ('item_salmon_roll_desc','bn-BD','নোরিতে আভোকাডো এবং কাকুম্বার সহ তাজা স্যামন','2025-09-19 14:10:11','2025-09-19 14:10:11');
INSERT INTO "Translations" VALUES ('item_tuna_roll','en-US','Tuna Roll','2025-09-19 14:10:11','2025-09-19 14:10:11');
INSERT INTO "Translations" VALUES ('item_tuna_roll','bn-BD','টুনা রোল','2025-09-19 14:10:11','2025-09-19 14:10:11');
INSERT INTO "Translations" VALUES ('item_tuna_roll_desc','en-US','Fresh tuna with spicy mayo and cucumber','2025-09-19 14:10:11','2025-09-19 14:10:11');
INSERT INTO "Translations" VALUES ('item_tuna_roll_desc','bn-BD','ঝাল মেয়োনেজ এবং কাকুম্বার সহ তাজা টুনা','2025-09-19 14:10:11','2025-09-19 14:10:11');
INSERT INTO "Translations" VALUES ('item_rainbow_roll','en-US','Rainbow Roll','2025-09-19 14:10:11','2025-09-19 14:10:11');
INSERT INTO "Translations" VALUES ('item_rainbow_roll','bn-BD','রেইনবো রোল','2025-09-19 14:10:11','2025-09-19 14:10:11');
INSERT INTO "Translations" VALUES ('item_rainbow_roll_desc','en-US','California roll topped with assorted sashimi','2025-09-19 14:10:11','2025-09-19 14:10:11');
INSERT INTO "Translations" VALUES ('item_rainbow_roll_desc','bn-BD','বিভিন্ন সাশিমি দিয়ে টপড ক্যালিফোর্নিয়া রোল','2025-09-19 14:10:11','2025-09-19 14:10:11');
INSERT INTO "Translations" VALUES ('item_dragon_roll','en-US','Dragon Roll','2025-09-19 14:10:11','2025-09-19 14:10:11');
INSERT INTO "Translations" VALUES ('item_dragon_roll','bn-BD','ড্রাগন রোল','2025-09-19 14:10:11','2025-09-19 14:10:11');
INSERT INTO "Translations" VALUES ('item_dragon_roll_desc','en-US','Eel and cucumber roll topped with avocado','2025-09-19 14:10:11','2025-09-19 14:10:11');
INSERT INTO "Translations" VALUES ('item_dragon_roll_desc','bn-BD','আভোকাডো দিয়ে টপড ইল এবং কাকুম্বার রোল','2025-09-19 14:10:11','2025-09-19 14:10:11');
INSERT INTO "Translations" VALUES ('item_sashimi_platter','en-US','Sashimi Platter','2025-09-19 14:10:11','2025-09-19 14:10:11');
INSERT INTO "Translations" VALUES ('item_sashimi_platter','bn-BD','সাশিমি প্ল্যাটার','2025-09-19 14:10:11','2025-09-19 14:10:11');
INSERT INTO "Translations" VALUES ('item_sashimi_platter_desc','en-US','Assorted fresh sashimi with wasabi and pickled ginger','2025-09-19 14:10:11','2025-09-19 14:10:11');
INSERT INTO "Translations" VALUES ('item_sashimi_platter_desc','bn-BD','ওয়াসাবি এবং আচার আদা সহ বিভিন্ন তাজা সাশিমি','2025-09-19 14:10:11','2025-09-19 14:10:11');
INSERT INTO "Translations" VALUES ('item_edamame','en-US','Edamame','2025-09-19 14:10:11','2025-09-19 14:10:11');
INSERT INTO "Translations" VALUES ('item_edamame','bn-BD','এডামেম','2025-09-19 14:10:11','2025-09-19 14:10:11');
INSERT INTO "Translations" VALUES ('item_edamame_desc','en-US','Steamed young soybeans with sea salt','2025-09-19 14:10:11','2025-09-19 14:10:11');
INSERT INTO "Translations" VALUES ('item_edamame_desc','bn-BD','সমুদ্রের লবণ সহ ভাপায় রান্না করা তরুণ সয়াবিন','2025-09-19 14:10:11','2025-09-19 14:10:11');
INSERT INTO "Translations" VALUES ('item_miso_soup','en-US','Miso Soup','2025-09-19 14:10:11','2025-09-19 14:10:11');
INSERT INTO "Translations" VALUES ('item_miso_soup','bn-BD','মিসো স্যুপ','2025-09-19 14:10:11','2025-09-19 14:10:11');
INSERT INTO "Translations" VALUES ('item_miso_soup_desc','en-US','Traditional soup with tofu, seaweed and green onions','2025-09-19 14:10:11','2025-09-19 14:10:11');
INSERT INTO "Translations" VALUES ('item_miso_soup_desc','bn-BD','টোফু, সামুদ্রিক শৈবাল এবং সবুজ পেঁয়াজ সহ ঐতিহ্যবাহী স্যুপ','2025-09-19 14:10:11','2025-09-19 14:10:11');
INSERT INTO "Translations" VALUES ('item_tonkotsu_ramen','en-US','Tonkotsu Ramen','2025-09-19 14:10:11','2025-09-19 14:10:11');
INSERT INTO "Translations" VALUES ('item_tonkotsu_ramen','bn-BD','টনকোটসু রামেন','2025-09-19 14:10:11','2025-09-19 14:10:11');
INSERT INTO "Translations" VALUES ('item_tonkotsu_ramen_desc','en-US','Rich pork bone broth with ramen noodles, chashu pork and egg','2025-09-19 14:10:11','2025-09-19 14:10:11');
INSERT INTO "Translations" VALUES ('item_tonkotsu_ramen_desc','bn-BD','রামেন নুডলস, চাশু পোর্ক এবং ডিম সহ সমৃদ্ধ শূকরের হাড়ের স্টক','2025-09-19 14:10:11','2025-09-19 14:10:11');
INSERT INTO "Translations" VALUES ('item_udon_noodles','en-US','Beef Udon','2025-09-19 14:10:11','2025-09-19 14:10:11');
INSERT INTO "Translations" VALUES ('item_udon_noodles','bn-BD','বিফ উডন','2025-09-19 14:10:11','2025-09-19 14:10:11');
INSERT INTO "Translations" VALUES ('item_udon_noodles_desc','en-US','Thick wheat noodles in savory broth with beef and vegetables','2025-09-19 14:10:11','2025-09-19 14:10:11');
INSERT INTO "Translations" VALUES ('item_udon_noodles_desc','bn-BD','গরুর মাংস এবং সবজি সহ সুস্বাদু স্টকে পুরু গমের নুডলস','2025-09-19 14:10:11','2025-09-19 14:10:11');
INSERT INTO "Translations" VALUES ('item_yakisoba','en-US','Yakisoba','2025-09-19 14:10:11','2025-09-19 14:10:11');
INSERT INTO "Translations" VALUES ('item_yakisoba','bn-BD','ইয়াকিসোবা','2025-09-19 14:10:11','2025-09-19 14:10:11');
INSERT INTO "Translations" VALUES ('item_yakisoba_desc','en-US','Stir-fried noodles with pork and vegetables in sweet sauce','2025-09-19 14:10:11','2025-09-19 14:10:11');
INSERT INTO "Translations" VALUES ('item_yakisoba_desc','bn-BD','মিষ্টি সসে শূকরের মাংস এবং সবজি দিয়ে ভাজা নুডলস','2025-09-19 14:10:11','2025-09-19 14:10:11');
INSERT INTO "Translations" VALUES ('item_shrimp_tempura','en-US','Shrimp Tempura','2025-09-19 14:10:11','2025-09-19 14:10:11');
INSERT INTO "Translations" VALUES ('item_shrimp_tempura','bn-BD','চিংড়ি টেম্পুরা','2025-09-19 14:10:11','2025-09-19 14:10:11');
INSERT INTO "Translations" VALUES ('item_shrimp_tempura_desc','en-US','Lightly battered and fried shrimp with dipping sauce','2025-09-19 14:10:11','2025-09-19 14:10:11');
INSERT INTO "Translations" VALUES ('item_shrimp_tempura_desc','bn-BD','ডিপিং সস সহ হালকা ব্যাটারে ডুবিয়ে ভাজা চিংড়ি','2025-09-19 14:10:11','2025-09-19 14:10:11');
INSERT INTO "Translations" VALUES ('item_chicken_katsu','en-US','Chicken Katsu','2025-09-19 14:10:11','2025-09-19 14:10:11');
INSERT INTO "Translations" VALUES ('item_chicken_katsu','bn-BD','চিকেন কাটসু','2025-09-19 14:10:11','2025-09-19 14:10:11');
INSERT INTO "Translations" VALUES ('item_chicken_katsu_desc','en-US','Breaded and fried chicken cutlet served with tonkatsu sauce','2025-09-19 14:10:11','2025-09-19 14:10:11');
INSERT INTO "Translations" VALUES ('item_chicken_katsu_desc','bn-BD','টনকাটসু সস সহ পরিবেশিত ব্রেডেড এবং ভাজা চিকেন কাটলেট','2025-09-19 14:10:11','2025-09-19 14:10:11');
INSERT INTO "Translations" VALUES ('item_beef_teriyaki','en-US','Beef Teriyaki','2025-09-19 14:10:11','2025-09-19 14:10:11');
INSERT INTO "Translations" VALUES ('item_beef_teriyaki','bn-BD','বিফ টেরিয়াকি','2025-09-19 14:10:11','2025-09-19 14:10:11');
INSERT INTO "Translations" VALUES ('item_beef_teriyaki_desc','en-US','Grilled beef glazed with sweet teriyaki sauce','2025-09-19 14:10:11','2025-09-19 14:10:11');
INSERT INTO "Translations" VALUES ('item_beef_teriyaki_desc','bn-BD','মিষ্টি টেরিয়াকি সস দিয়ে গ্লেজড গ্রিলড বিফ','2025-09-19 14:10:11','2025-09-19 14:10:11');
INSERT INTO "Translations" VALUES ('item_salmon_teriyaki','en-US','Salmon Teriyaki','2025-09-19 14:10:11','2025-09-19 14:10:11');
INSERT INTO "Translations" VALUES ('item_salmon_teriyaki','bn-BD','স্যামন টেরিয়াকি','2025-09-19 14:10:11','2025-09-19 14:10:11');
INSERT INTO "Translations" VALUES ('item_salmon_teriyaki_desc','en-US','Grilled salmon glazed with teriyaki sauce','2025-09-19 14:10:11','2025-09-19 14:10:11');
INSERT INTO "Translations" VALUES ('item_salmon_teriyaki_desc','bn-BD','টেরিয়াকি সস দিয়ে গ্লেজড গ্রিলড স্যামন','2025-09-19 14:10:11','2025-09-19 14:10:11');
INSERT INTO "Translations" VALUES ('item_tofu_steak','en-US','Tofu Steak','2025-09-19 14:10:11','2025-09-19 14:10:11');
INSERT INTO "Translations" VALUES ('item_tofu_steak','bn-BD','টোফু স্টেক','2025-09-19 14:10:11','2025-09-19 14:10:11');
INSERT INTO "Translations" VALUES ('item_tofu_steak_desc','en-US','Pan-fried tofu steak with ginger sauce','2025-09-19 14:10:11','2025-09-19 14:10:11');
INSERT INTO "Translations" VALUES ('item_tofu_steak_desc','bn-BD','আদা সস সহ প্যান-ফ্রাইড টোফু স্টেক','2025-09-19 14:10:11','2025-09-19 14:10:11');
INSERT INTO "Translations" VALUES ('item_chicken_bento','en-US','Chicken Bento','2025-09-19 14:10:11','2025-09-19 14:10:11');
INSERT INTO "Translations" VALUES ('item_chicken_bento','bn-BD','চিকেন বেন্টো','2025-09-19 14:10:11','2025-09-19 14:10:11');
INSERT INTO "Translations" VALUES ('item_chicken_bento_desc','en-US','Complete meal with grilled chicken, rice, vegetables and miso soup','2025-09-19 14:10:11','2025-09-19 14:10:11');
INSERT INTO "Translations" VALUES ('item_chicken_bento_desc','bn-BD','গ্রিলড চিকেন, ভাত, সবজি এবং মিসো স্যুপ সহ সম্পূর্ণ খাবার','2025-09-19 14:10:11','2025-09-19 14:10:11');
INSERT INTO "Translations" VALUES ('item_salmon_bento','en-US','Salmon Bento','2025-09-19 14:10:11','2025-09-19 14:10:11');
INSERT INTO "Translations" VALUES ('item_salmon_bento','bn-BD','স্যামন বেন্টো','2025-09-19 14:10:11','2025-09-19 14:10:11');
INSERT INTO "Translations" VALUES ('item_salmon_bento_desc','en-US','Complete meal with grilled salmon, rice, vegetables and miso soup','2025-09-19 14:10:11','2025-09-19 14:10:11');
INSERT INTO "Translations" VALUES ('item_salmon_bento_desc','bn-BD','গ্রিলড স্যামন, ভাত, সবজি এবং মিসো স্যুপ সহ সম্পূর্ণ খাবার','2025-09-19 14:10:11','2025-09-19 14:10:11');
INSERT INTO "Translations" VALUES ('item_vegetable_bento','en-US','Vegetable Bento','2025-09-19 14:10:11','2025-09-19 14:10:11');
INSERT INTO "Translations" VALUES ('item_vegetable_bento','bn-BD','ভেজিটেবল বেন্টো','2025-09-19 14:10:11','2025-09-19 14:10:11');
INSERT INTO "Translations" VALUES ('item_vegetable_bento_desc','en-US','Complete meal with assorted vegetables, tofu, rice and miso soup','2025-09-19 14:10:11','2025-09-19 14:10:11');
INSERT INTO "Translations" VALUES ('item_vegetable_bento_desc','bn-BD','বিভিন্ন সবজি, টোফু, ভাত এবং মিসো স্যুপ সহ সম্পূর্ণ খাবার','2025-09-19 14:10:11','2025-09-19 14:10:11');
INSERT INTO "Translations" VALUES ('item_mochi_ice_cream','en-US','Mochi Ice Cream','2025-09-19 14:10:11','2025-09-19 14:10:11');
INSERT INTO "Translations" VALUES ('item_mochi_ice_cream','bn-BD','মোচি আইসক্রিম','2025-09-19 14:10:11','2025-09-19 14:10:11');
INSERT INTO "Translations" VALUES ('item_mochi_ice_cream_desc','en-US','Sweet rice cake filled with ice cream','2025-09-19 14:10:11','2025-09-19 14:10:11');
INSERT INTO "Translations" VALUES ('item_mochi_ice_cream_desc','bn-BD','আইসক্রিম দিয়ে পূর্ণ মিষ্টি চালের কেক','2025-09-19 14:10:11','2025-09-19 14:10:11');
INSERT INTO "Translations" VALUES ('item_dorayaki','en-US','Dorayaki','2025-09-19 14:10:11','2025-09-19 14:10:11');
INSERT INTO "Translations" VALUES ('item_dorayaki','bn-BD','ডোরায়াকি','2025-09-19 14:10:11','2025-09-19 14:10:11');
INSERT INTO "Translations" VALUES ('item_dorayaki_desc','en-US','Sweet pancake sandwich with red bean paste filling','2025-09-19 14:10:11','2025-09-19 14:10:11');
INSERT INTO "Translations" VALUES ('item_dorayaki_desc','bn-BD','লাল মটর পেস্ট দিয়ে পূর্ণ মিষ্টি প্যানকেক স্যান্ডউইচ','2025-09-19 14:10:11','2025-09-19 14:10:11');
INSERT INTO "Translations" VALUES ('item_matcha_cake','en-US','Matcha Cake','2025-09-19 14:10:11','2025-09-19 14:10:11');
INSERT INTO "Translations" VALUES ('item_matcha_cake','bn-BD','মাচা কেক','2025-09-19 14:10:11','2025-09-19 14:10:11');
INSERT INTO "Translations" VALUES ('item_matcha_cake_desc','en-US','Green tea flavored sponge cake with red bean filling','2025-09-19 14:10:11','2025-09-19 14:10:11');
INSERT INTO "Translations" VALUES ('item_matcha_cake_desc','bn-BD','লাল মটর পূরণ সহ সবুজ চা স্বাদযুক্ত স্পঞ্জ কেক','2025-09-19 14:10:11','2025-09-19 14:10:11');
INSERT INTO "Translations" VALUES ('item_coke','en-US','Coca-Cola','2025-09-19 14:10:11','2025-09-19 14:10:11');
INSERT INTO "Translations" VALUES ('item_coke','bn-BD','কোকা-কোলা','2025-09-19 14:10:11','2025-09-19 14:10:11');
INSERT INTO "Translations" VALUES ('item_coke_desc','en-US','Refreshing carbonated soft drink','2025-09-19 14:10:11','2025-09-19 14:10:11');
INSERT INTO "Translations" VALUES ('item_coke_desc','bn-BD','সতেজ কার্বনেটেড সফট ড্রিংক','2025-09-19 14:10:11','2025-09-19 14:10:11');
INSERT INTO "Translations" VALUES ('item_mango_lassi','en-US','Mango Lassi','2025-09-19 14:10:11','2025-09-19 14:10:11');
INSERT INTO "Translations" VALUES ('item_mango_lassi','bn-BD','আমের লস্যি','2025-09-19 14:10:11','2025-09-19 14:10:11');
INSERT INTO "Translations" VALUES ('item_mango_lassi_desc','en-US','Sweet mango yogurt drink','2025-09-19 14:10:11','2025-09-19 14:10:11');
INSERT INTO "Translations" VALUES ('item_mango_lassi_desc','bn-BD','মিষ্টি আমের দই পানীয়','2025-09-19 14:10:11','2025-09-19 14:10:11');
INSERT INTO "Translations" VALUES ('item_tea','en-US','Deshi Tea','2025-09-19 14:10:11','2025-09-19 14:10:11');
INSERT INTO "Translations" VALUES ('item_tea','bn-BD','দেশি চা','2025-09-19 14:10:11','2025-09-19 14:10:11');
INSERT INTO "Translations" VALUES ('item_tea_desc','en-US','Traditional Bangladeshi milk tea','2025-09-19 14:10:11','2025-09-19 14:10:11');
INSERT INTO "Translations" VALUES ('item_tea_desc','bn-BD','ঐতিহ্যবাহী বাংলাদেশী দুধ চা','2025-09-19 14:10:11','2025-09-19 14:10:11');
INSERT INTO "Translations" VALUES ('item_borhani','en-US','Borhani','2025-09-19 14:10:11','2025-09-19 14:10:11');
INSERT INTO "Translations" VALUES ('item_borhani','bn-BD','বোরহানী','2025-09-19 14:10:11','2025-09-19 14:10:11');
INSERT INTO "Translations" VALUES ('item_borhani_desc','en-US','Spicy yogurt drink with mint','2025-09-19 14:10:11','2025-09-19 14:10:11');
INSERT INTO "Translations" VALUES ('item_borhani_desc','bn-BD','পুদিনা দিয়ে ঝাল দই পানীয়','2025-09-19 14:10:11','2025-09-19 14:10:11');
INSERT INTO "Translations" VALUES ('branch_fast_food_name','en-US','Luna Dine Fast Food','2025-09-19 14:10:11','2025-09-19 14:10:11');
INSERT INTO "Translations" VALUES ('branch_fast_food_name','bn-BD','লুনা ডাইন ফাস্ট ফুড','2025-09-19 14:10:11','2025-09-19 14:10:11');
INSERT INTO "Translations" VALUES ('branch_desi_name','en-US','Luna Dine Desi Food','2025-09-19 14:10:11','2025-09-19 14:10:11');
INSERT INTO "Translations" VALUES ('branch_desi_name','bn-BD','লুনা ডাইন দেশি খাবার','2025-09-19 14:10:11','2025-09-19 14:10:11');
INSERT INTO "Translations" VALUES ('branch_chinese_name','en-US','Luna Dine Chinese Food','2025-09-19 14:10:11','2025-09-19 14:10:11');
INSERT INTO "Translations" VALUES ('branch_chinese_name','bn-BD','লুনা ডাইন চাইনিজ খাবার','2025-09-19 14:10:11','2025-09-19 14:10:11');
INSERT INTO "Translations" VALUES ('branch_indian_name','en-US','Luna Dine Indian Food','2025-09-19 14:10:11','2025-09-19 14:10:11');
INSERT INTO "Translations" VALUES ('branch_indian_name','bn-BD','লুনা ডাইন ভারতীয় খাবার','2025-09-19 14:10:11','2025-09-19 14:10:11');
INSERT INTO "Translations" VALUES ('branch_italian_name','en-US','Luna Dine Italian Food','2025-09-19 14:10:11','2025-09-19 14:10:11');
INSERT INTO "Translations" VALUES ('branch_italian_name','bn-BD','লুনা ডাইন ইতালিয়ান খাবার','2025-09-19 14:10:11','2025-09-19 14:10:11');
INSERT INTO "Translations" VALUES ('branch_japanese_name','en-US','Luna Dine Japanese Food','2025-09-19 14:10:11','2025-09-19 14:10:11');
INSERT INTO "Translations" VALUES ('branch_japanese_name','bn-BD','লুনা ডাইন জাপানি খাবার','2025-09-19 14:10:11','2025-09-19 14:10:11');
INSERT INTO "Translations" VALUES ('promo_weekend_discount','en-US','Weekend Special Discount','2025-09-19 14:10:11','2025-09-19 14:10:11');
INSERT INTO "Translations" VALUES ('promo_weekend_discount','bn-BD','সাপ্তাহিক বিশেষ ছাড়','2025-09-19 14:10:11','2025-09-19 14:10:11');
INSERT INTO "Translations" VALUES ('promo_weekend_discount_desc','en-US','15% off on all items during weekends','2025-09-19 14:10:11','2025-09-19 14:10:11');
INSERT INTO "Translations" VALUES ('promo_weekend_discount_desc','bn-BD','সাপ্তাহিক ছুটিতে সমস্ত আইটেমে 15% ছাড়','2025-09-19 14:10:11','2025-09-19 14:10:11');
INSERT INTO "Translations" VALUES ('promo_first_order','en-US','First Order Discount','2025-09-19 14:10:11','2025-09-19 14:10:11');
INSERT INTO "Translations" VALUES ('promo_first_order','bn-BD','প্রথম অর্ডার ছাড়','2025-09-19 14:10:11','2025-09-19 14:10:11');
INSERT INTO "Translations" VALUES ('promo_first_order_desc','en-US','Get 100 Taka off on your first order','2025-09-19 14:10:11','2025-09-19 14:10:11');
INSERT INTO "Translations" VALUES ('promo_first_order_desc','bn-BD','আপনার প্রথম অর্ডারে 100 টাকা ছাড় পান','2025-09-19 14:10:11','2025-09-19 14:10:11');
INSERT INTO "Translations" VALUES ('banner_new_menu','en-US','Try Our New Menu','2025-09-19 14:10:11','2025-09-19 14:10:11');
INSERT INTO "Translations" VALUES ('banner_new_menu','bn-BD','আমাদের নতুন মেনু চেষ্টা করুন','2025-09-19 14:10:11','2025-09-19 14:10:11');
INSERT INTO "Translations" VALUES ('banner_new_menu_desc','en-US','Exciting new dishes now available','2025-09-19 14:10:11','2025-09-19 14:10:11');
INSERT INTO "Translations" VALUES ('banner_new_menu_desc','bn-BD','এখন উত্তেজনাপূর্ণ নতুন খাবার পাওয়া যাচ্ছে','2025-09-19 14:10:11','2025-09-19 14:10:11');
INSERT INTO "Translations" VALUES ('banner_weekend_special','en-US','Weekend Special','2025-09-19 14:10:11','2025-09-19 14:10:11');
INSERT INTO "Translations" VALUES ('banner_weekend_special','bn-BD','সাপ্তাহিক বিশেষ','2025-09-19 14:10:11','2025-09-19 14:10:11');
INSERT INTO "Translations" VALUES ('banner_weekend_special_desc','en-US','Special dishes every weekend','2025-09-19 14:10:11','2025-09-19 14:10:11');
INSERT INTO "Translations" VALUES ('banner_weekend_special_desc','bn-BD','প্রতি সপ্তাহান্তে বিশেষ খাবার','2025-09-19 14:10:11','2025-09-19 14:10:11');
INSERT INTO "Translations" VALUES ('banner_new_branch','en-US','New Branch Opening','2025-09-19 14:10:11','2025-09-19 14:10:11');
INSERT INTO "Translations" VALUES ('banner_new_branch','bn-BD','নতুন শাখা উদ্বোধন','2025-09-19 14:10:11','2025-09-19 14:10:11');
INSERT INTO "Translations" VALUES ('banner_new_branch_desc','en-US','Visit our newly opened branch','2025-09-19 14:10:11','2025-09-19 14:10:11');
INSERT INTO "Translations" VALUES ('banner_new_branch_desc','bn-BD','আমাদের নতুন উদ্বোধনকৃত শাখায় ভিজিট করুন','2025-09-19 14:10:11','2025-09-19 14:10:11');
INSERT INTO "Translations" VALUES ('banner_delivery_offer','en-US','Free Delivery Offer','2025-09-19 14:10:11','2025-09-19 14:10:11');
INSERT INTO "Translations" VALUES ('banner_delivery_offer','bn-BD','ফ্রি ডেলিভারি অফার','2025-09-19 14:10:11','2025-09-19 14:10:11');
INSERT INTO "Translations" VALUES ('banner_delivery_offer_desc','en-US','Free delivery on orders above 500 Taka','2025-09-19 14:10:11','2025-09-19 14:10:11');
INSERT INTO "Translations" VALUES ('banner_delivery_offer_desc','bn-BD','500 টাকার উপরে অর্ডারে ফ্রি ডেলিভারি','2025-09-19 14:10:11','2025-09-19 14:10:11');
INSERT INTO "Users" VALUES (1,1,NULL,'System Administrator','admin','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','admin@lunadine.com','en-US','2025-09-20 08:12:23',NULL,NULL,0,NULL,1,'2025-09-19 14:10:07','2025-09-19 14:10:07');
INSERT INTO "Users" VALUES (2,3,1,'Fast Food Manager','fastfood_mgr','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','manager.fastfood@restaurant.com','en-US',NULL,NULL,NULL,0,NULL,1,'2025-09-19 14:10:13','2025-09-20 10:18:51');
INSERT INTO "Users" VALUES (3,3,2,'Desi Manager','desi_mgr','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','manager.desi@restaurant.com','en-US',NULL,NULL,NULL,0,NULL,1,'2025-09-19 14:10:13','2025-09-19 14:10:13');
INSERT INTO "Users" VALUES (4,3,3,'Chinese Manager','chinese_mgr','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','manager.chinese@restaurant.com','en-US',NULL,NULL,NULL,0,NULL,1,'2025-09-19 14:10:13','2025-09-19 14:10:13');
INSERT INTO "Users" VALUES (5,3,4,'Indian Manager','indian_mgr','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','manager.indian@restaurant.com','en-US',NULL,NULL,NULL,0,NULL,1,'2025-09-19 14:10:13','2025-09-19 14:10:13');
INSERT INTO "Users" VALUES (6,3,5,'Italian Manager','italian_mgr','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','manager.italian@restaurant.com','en-US',NULL,NULL,NULL,0,NULL,1,'2025-09-19 14:10:13','2025-09-19 14:10:13');
INSERT INTO "Users" VALUES (7,3,6,'Japanese Manager','japanese_mgr','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','manager.japanese@restaurant.com','en-US',NULL,NULL,NULL,0,NULL,1,'2025-09-19 14:10:13','2025-09-19 14:10:13');
INSERT INTO "Users" VALUES (8,5,1,'Fast Food Chef','fastfood_chef','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','chef.fastfood@restaurant.com','en-US',NULL,NULL,NULL,0,NULL,1,'2025-09-19 14:10:13','2025-09-19 14:10:13');
INSERT INTO "Users" VALUES (9,5,2,'Desi Chef','desi_chef','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','chef.desi@restaurant.com','en-US','2025-09-19 16:41:37',NULL,NULL,0,NULL,1,'2025-09-19 14:10:13','2025-09-19 14:10:13');
INSERT INTO "Users" VALUES (10,5,3,'Chinese Chef','chinese_chef','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','chef.chinese@restaurant.com','en-US',NULL,NULL,NULL,0,NULL,1,'2025-09-19 14:10:13','2025-09-19 14:10:13');
INSERT INTO "Users" VALUES (11,5,4,'Indian Chef','indian_chef','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','chef.indian@restaurant.com','en-US',NULL,NULL,NULL,0,NULL,1,'2025-09-19 14:10:13','2025-09-19 14:10:13');
INSERT INTO "Users" VALUES (12,5,5,'Italian Chef','italian_chef','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','chef.italian@restaurant.com','en-US',NULL,NULL,NULL,0,NULL,1,'2025-09-19 14:10:13','2025-09-19 14:10:13');
INSERT INTO "Users" VALUES (13,5,6,'Japanese Chef','japanese_chef','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','chef.japanese@restaurant.com','en-US',NULL,NULL,NULL,0,NULL,1,'2025-09-19 14:10:13','2025-09-19 14:10:13');
INSERT INTO "Users" VALUES (14,8,1,'Fast Food Cashier','fastfood_cashier','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','cashier.fastfood@restaurant.com','en-US',NULL,NULL,NULL,0,NULL,1,'2025-09-19 14:10:13','2025-09-19 14:10:13');
INSERT INTO "Users" VALUES (15,8,2,'Desi Cashier','desi_cashier','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','cashier.desi@restaurant.com','en-US',NULL,NULL,NULL,0,NULL,1,'2025-09-19 14:10:13','2025-09-19 14:10:13');
INSERT INTO "Users" VALUES (16,8,3,'Chinese Cashier','chinese_cashier','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','cashier.chinese@restaurant.com','en-US',NULL,NULL,NULL,0,NULL,1,'2025-09-19 14:10:13','2025-09-19 14:10:13');
INSERT INTO "Users" VALUES (17,8,4,'Indian Cashier','indian_cashier','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','cashier.indian@restaurant.com','en-US',NULL,NULL,NULL,0,NULL,1,'2025-09-19 14:10:13','2025-09-19 14:10:13');
INSERT INTO "Users" VALUES (18,8,5,'Italian Cashier','italian_cashier','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','cashier.italian@restaurant.com','en-US',NULL,NULL,NULL,0,NULL,1,'2025-09-19 14:10:13','2025-09-19 14:10:13');
INSERT INTO "Users" VALUES (19,8,6,'Japanese Cashier','japanese_cashier','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','cashier.japanese@restaurant.com','en-US',NULL,NULL,NULL,0,NULL,1,'2025-09-19 14:10:13','2025-09-19 14:10:13');
INSERT INTO "Users" VALUES (20,6,1,'Fast Food Waiter 1','fastfood_waiter1','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','waiter1.fastfood@restaurant.com','en-US',NULL,NULL,NULL,0,NULL,1,'2025-09-19 14:10:13','2025-09-19 14:10:13');
INSERT INTO "Users" VALUES (21,6,1,'Fast Food Waiter 2','fastfood_waiter2','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','waiter2.fastfood@restaurant.com','en-US',NULL,NULL,NULL,0,NULL,1,'2025-09-19 14:10:13','2025-09-19 14:10:13');
INSERT INTO "Users" VALUES (22,6,2,'Desi Waiter 1','desi_waiter1','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','waiter1.desi@restaurant.com','en-US','2025-09-19 16:21:29',NULL,NULL,0,NULL,1,'2025-09-19 14:10:13','2025-09-19 14:10:13');
INSERT INTO "Users" VALUES (23,6,2,'Desi Waiter 2','desi_waiter2','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','waiter2.desi@restaurant.com','en-US',NULL,NULL,NULL,0,NULL,1,'2025-09-19 14:10:13','2025-09-19 14:10:13');
INSERT INTO "Users" VALUES (24,6,3,'Chinese Waiter 1','chinese_waiter1','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','waiter1.chinese@restaurant.com','en-US',NULL,NULL,NULL,0,NULL,1,'2025-09-19 14:10:13','2025-09-19 14:10:13');
INSERT INTO "Users" VALUES (25,6,3,'Chinese Waiter 2','chinese_waiter2','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','waiter2.chinese@restaurant.com','en-US',NULL,NULL,NULL,0,NULL,1,'2025-09-19 14:10:13','2025-09-19 14:10:13');
INSERT INTO "Users" VALUES (26,6,4,'Indian Waiter 1','indian_waiter1','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','waiter1.indian@restaurant.com','en-US',NULL,NULL,NULL,0,NULL,1,'2025-09-19 14:10:13','2025-09-19 14:10:13');
INSERT INTO "Users" VALUES (27,6,4,'Indian Waiter 2','indian_waiter2','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','waiter2.indian@restaurant.com','en-US',NULL,NULL,NULL,0,NULL,1,'2025-09-19 14:10:13','2025-09-19 14:10:13');
INSERT INTO "Users" VALUES (28,6,5,'Italian Waiter 1','italian_waiter1','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','waiter1.italian@restaurant.com','en-US',NULL,NULL,NULL,0,NULL,1,'2025-09-19 14:10:13','2025-09-19 14:10:13');
INSERT INTO "Users" VALUES (29,6,5,'Italian Waiter 2','italian_waiter2','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','waiter2.italian@restaurant.com','en-US',NULL,NULL,NULL,0,NULL,1,'2025-09-19 14:10:13','2025-09-19 14:10:13');
INSERT INTO "Users" VALUES (30,6,6,'Japanese Waiter 1','japanese_waiter1','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','waiter1.japanese@restaurant.com','en-US',NULL,NULL,NULL,0,NULL,1,'2025-09-19 14:10:13','2025-09-19 14:10:13');
INSERT INTO "Users" VALUES (31,6,6,'Japanese Waiter 2','japanese_waiter2','$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi','waiter2.japanese@restaurant.com','en-US',NULL,NULL,NULL,0,NULL,1,'2025-09-19 14:10:13','2025-09-19 14:10:13');
CREATE INDEX IF NOT EXISTS "idx_admin_logs_action" ON "AdminLogs" (
	"action"
);
CREATE INDEX IF NOT EXISTS "idx_admin_logs_created" ON "AdminLogs" (
	"created_at"
);
CREATE INDEX IF NOT EXISTS "idx_admin_logs_ip" ON "AdminLogs" (
	"ip_address"
);
CREATE INDEX IF NOT EXISTS "idx_admin_logs_user" ON "AdminLogs" (
	"user_id"
);
CREATE INDEX IF NOT EXISTS "idx_admin_sessions_expires" ON "AdminSessions" (
	"expires_at"
);
CREATE INDEX IF NOT EXISTS "idx_admin_sessions_user" ON "AdminSessions" (
	"user_id"
);
CREATE INDEX IF NOT EXISTS "idx_branch_banners_branch" ON "BranchBanners" (
	"branch_id"
);
CREATE INDEX IF NOT EXISTS "idx_branch_banners_type" ON "BranchBanners" (
	"banner_type"
);
CREATE INDEX IF NOT EXISTS "idx_branch_menu_available" ON "BranchMenu" (
	"branch_id",
	"is_available"
);
CREATE INDEX IF NOT EXISTS "idx_branch_menu_item" ON "BranchMenu" (
	"item_id"
);
CREATE INDEX IF NOT EXISTS "idx_branches_active" ON "Branches" (
	"is_active"
);
CREATE INDEX IF NOT EXISTS "idx_branches_created_by" ON "Branches" (
	"created_by"
);
CREATE INDEX IF NOT EXISTS "idx_deliverytracking_driver" ON "DeliveryTracking" (
	"driver_name"
);
CREATE INDEX IF NOT EXISTS "idx_deliverytracking_estimated" ON "DeliveryTracking" (
	"estimated_arrival_time"
);
CREATE INDEX IF NOT EXISTS "idx_deliverytracking_order" ON "DeliveryTracking" (
	"order_id"
);
CREATE INDEX IF NOT EXISTS "idx_deliverytracking_status" ON "DeliveryTracking" (
	"delivery_status"
);
CREATE INDEX IF NOT EXISTS "idx_feature_flags_audience" ON "FeatureFlags" (
	"target_audience"
);
CREATE INDEX IF NOT EXISTS "idx_feature_flags_dates" ON "FeatureFlags" (
	"start_date",
	"end_date"
);
CREATE INDEX IF NOT EXISTS "idx_feature_flags_enabled" ON "FeatureFlags" (
	"is_enabled"
);
CREATE INDEX IF NOT EXISTS "idx_feature_flags_key" ON "FeatureFlags" (
	"flag_key"
);
CREATE INDEX IF NOT EXISTS "idx_feedback_branch" ON "Feedback" (
	"branch_id"
);
CREATE INDEX IF NOT EXISTS "idx_feedback_created_at" ON "Feedback" (
	"created_at"
);
CREATE INDEX IF NOT EXISTS "idx_feedback_order" ON "Feedback" (
	"order_id"
);
CREATE INDEX IF NOT EXISTS "idx_feedback_rating" ON "Feedback" (
	"rating"
);
CREATE INDEX IF NOT EXISTS "idx_feedback_status" ON "Feedback" (
	"status"
);
CREATE INDEX IF NOT EXISTS "idx_menu_categories_created_by" ON "MenuCategories" (
	"created_by"
);
CREATE INDEX IF NOT EXISTS "idx_menu_categories_parent" ON "MenuCategories" (
	"parent_category_id"
);
CREATE INDEX IF NOT EXISTS "idx_menu_items_active" ON "MenuItems_Global" (
	"is_active"
);
CREATE INDEX IF NOT EXISTS "idx_menu_items_category" ON "MenuItems_Global" (
	"category_id"
);
CREATE INDEX IF NOT EXISTS "idx_menu_items_created_by" ON "MenuItems_Global" (
	"created_by"
);
CREATE INDEX IF NOT EXISTS "idx_notification_templates_category" ON "NotificationTemplates" (
	"category"
);
CREATE INDEX IF NOT EXISTS "idx_notifications_created" ON "Notifications" (
	"created_at"
);
CREATE INDEX IF NOT EXISTS "idx_notifications_read" ON "Notifications" (
	"is_read"
);
CREATE INDEX IF NOT EXISTS "idx_notifications_type" ON "Notifications" (
	"type"
);
CREATE INDEX IF NOT EXISTS "idx_notifications_user" ON "Notifications" (
	"user_id"
);
CREATE INDEX IF NOT EXISTS "idx_order_items_branch_menu" ON "OrderItems" (
	"branch_menu_id"
);
CREATE INDEX IF NOT EXISTS "idx_order_items_order" ON "OrderItems" (
	"order_id"
);
CREATE INDEX IF NOT EXISTS "idx_orderanalytics_order" ON "OrderTrackingAnalytics" (
	"order_id"
);
CREATE INDEX IF NOT EXISTS "idx_orderanalytics_session" ON "OrderTrackingAnalytics" (
	"tracking_session_id"
);
CREATE INDEX IF NOT EXISTS "idx_ordernotifications_order" ON "OrderNotifications" (
	"order_id"
);
CREATE INDEX IF NOT EXISTS "idx_ordernotifications_scheduled" ON "OrderNotifications" (
	"scheduled_time"
);
CREATE INDEX IF NOT EXISTS "idx_ordernotifications_status" ON "OrderNotifications" (
	"status"
);
CREATE INDEX IF NOT EXISTS "idx_ordernotifications_type" ON "OrderNotifications" (
	"notification_type"
);
CREATE INDEX IF NOT EXISTS "idx_orders_created" ON "Orders" (
	"created_at"
);
CREATE INDEX IF NOT EXISTS "idx_orders_customer" ON "Orders" (
	"customer_id"
);
CREATE INDEX IF NOT EXISTS "idx_orders_status" ON "Orders" (
	"status"
);
CREATE INDEX IF NOT EXISTS "idx_ordertimeline_order" ON "OrderTimeline" (
	"order_id"
);
CREATE INDEX IF NOT EXISTS "idx_ordertimeline_staff" ON "OrderTimeline" (
	"staff_id"
);
CREATE INDEX IF NOT EXISTS "idx_ordertimeline_timestamp" ON "OrderTimeline" (
	"timestamp"
);
CREATE INDEX IF NOT EXISTS "idx_ordertimeline_type" ON "OrderTimeline" (
	"event_type"
);
CREATE INDEX IF NOT EXISTS "idx_pickupqueue_order" ON "PickupQueue" (
	"order_id"
);
CREATE INDEX IF NOT EXISTS "idx_pickupqueue_position" ON "PickupQueue" (
	"queue_position"
);
CREATE INDEX IF NOT EXISTS "idx_pickupqueue_ready" ON "PickupQueue" (
	"estimated_ready_time"
);
CREATE INDEX IF NOT EXISTS "idx_pickupqueue_status" ON "PickupQueue" (
	"pickup_status"
);
CREATE INDEX IF NOT EXISTS "idx_promotion_branches_branch" ON "Promotion_Branches" (
	"branch_id"
);
CREATE INDEX IF NOT EXISTS "idx_promotion_items_item" ON "Promotion_Items" (
	"item_id"
);
CREATE INDEX IF NOT EXISTS "idx_promotions_active" ON "Promotions" (
	"is_active"
);
CREATE INDEX IF NOT EXISTS "idx_promotions_created_by" ON "Promotions" (
	"created_by"
);
CREATE INDEX IF NOT EXISTS "idx_restaurant_active" ON "RestaurantDetails" (
	"is_active"
);
CREATE INDEX IF NOT EXISTS "idx_scheduled_notifications_scheduled" ON "ScheduledNotifications" (
	"scheduled_at"
);
CREATE INDEX IF NOT EXISTS "idx_scheduled_notifications_status" ON "ScheduledNotifications" (
	"status"
);
CREATE INDEX IF NOT EXISTS "idx_service_requests_branch" ON "ServiceRequests" (
	"branch_id"
);
CREATE INDEX IF NOT EXISTS "idx_service_requests_requested_at" ON "ServiceRequests" (
	"requested_at"
);
CREATE INDEX IF NOT EXISTS "idx_service_requests_resolved_by" ON "ServiceRequests" (
	"resolved_by_user_id"
);
CREATE INDEX IF NOT EXISTS "idx_service_requests_status" ON "ServiceRequests" (
	"status"
);
CREATE INDEX IF NOT EXISTS "idx_service_requests_table" ON "ServiceRequests" (
	"table_id"
);
CREATE INDEX IF NOT EXISTS "idx_settings_category" ON "Settings" (
	"category"
);
CREATE INDEX IF NOT EXISTS "idx_settings_key" ON "Settings" (
	"setting_key"
);
CREATE INDEX IF NOT EXISTS "idx_settings_public" ON "Settings" (
	"is_public"
);
CREATE INDEX IF NOT EXISTS "idx_settings_type" ON "Settings" (
	"setting_type"
);
CREATE INDEX IF NOT EXISTS "idx_tables_created_by" ON "Tables" (
	"created_by"
);
CREATE INDEX IF NOT EXISTS "idx_tableservice_order" ON "TableServiceStatus" (
	"order_id"
);
CREATE INDEX IF NOT EXISTS "idx_tableservice_server" ON "TableServiceStatus" (
	"server_id"
);
CREATE INDEX IF NOT EXISTS "idx_tableservice_status" ON "TableServiceStatus" (
	"service_status"
);
CREATE INDEX IF NOT EXISTS "idx_tableservice_table" ON "TableServiceStatus" (
	"table_id"
);
CREATE INDEX IF NOT EXISTS "idx_translations_key" ON "Translations" (
	"translation_key"
);
CREATE INDEX IF NOT EXISTS "idx_translations_language" ON "Translations" (
	"language_code"
);
CREATE INDEX IF NOT EXISTS "idx_user_devices_active" ON "UserDevices" (
	"is_active"
);
CREATE INDEX IF NOT EXISTS "idx_user_devices_token" ON "UserDevices" (
	"device_token"
);
CREATE INDEX IF NOT EXISTS "idx_user_devices_user" ON "UserDevices" (
	"user_id"
);
CREATE INDEX IF NOT EXISTS "idx_users_active" ON "Users" (
	"is_active"
);
CREATE INDEX IF NOT EXISTS "idx_users_branch" ON "Users" (
	"branch_id"
);
CREATE INDEX IF NOT EXISTS "idx_users_role" ON "Users" (
	"role_id"
);
CREATE TRIGGER delivery_order_trigger
AFTER INSERT ON Orders
FOR EACH ROW
WHEN NEW.order_type = 'delivery'
BEGIN
    INSERT INTO DeliveryTracking (order_id, delivery_status)
    VALUES (NEW.order_id, 'assigned');
END;
CREATE TRIGGER dinein_order_trigger
AFTER INSERT ON Orders
FOR EACH ROW
WHEN NEW.order_type = 'dine-in' AND NEW.table_id IS NOT NULL
BEGIN
    INSERT INTO TableServiceStatus (order_id, table_id, service_status)
    VALUES (NEW.order_id, NEW.table_id, 'assigned');
END;
CREATE TRIGGER order_placed_trigger
AFTER INSERT ON Orders
FOR EACH ROW
BEGIN
    INSERT INTO OrderTimeline (order_id, event_type, event_description)
    VALUES (NEW.order_id, 'ORDER_PLACED', 'Order was placed by customer');
END;
CREATE TRIGGER order_status_change_trigger
AFTER UPDATE OF status ON Orders
FOR EACH ROW
WHEN OLD.status != NEW.status
BEGIN
    INSERT INTO OrderTimeline (order_id, event_type, event_description, metadata)
    VALUES (
        NEW.order_id, 
        'ORDER_' || UPPER(NEW.status),
        'Order status changed from ' || OLD.status || ' to ' || NEW.status,
        json_object('old_status', OLD.status, 'new_status', NEW.status)
    );
END;
CREATE TRIGGER takeaway_order_trigger
AFTER INSERT ON Orders
FOR EACH ROW
WHEN NEW.order_type = 'takeaway'
BEGIN
    INSERT INTO PickupQueue (order_id, pickup_status)
    VALUES (NEW.order_id, 'waiting');
END;
COMMIT;
