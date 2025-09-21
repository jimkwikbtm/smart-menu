
        // Main application module
        const LunaDineApp = (() => {
            // State management
            const state = {
                currentView: 'home',
                currentBranch: null,
                currentTable: null,
                cart: [],
                branchCarts: {}, // Store separate carts for different branches
                favorites: [],
                orderHistory: [],
                userOrderIds: [], // Track order UIDs for this user session
                language: 'en-US',
                userInfo: null,
                serviceRequests: [],
                menuData: null,
                branches: [],
                categories: [],
                promotions: [],
                currentOrder: null,
                currentItem: null,
                currentQuantity: 1,
                currentCustomizations: {},
                currentRating: 0,
                appliedPromo: null, // { code, type, value, discount_amount }
                restaurantDetails: null, // Restaurant details for footer
                pendingCartItem: null, // For branch conflict resolution
                translations: {
                    'en-US': {
                        'app_name': 'Luna Dine',
                        'nav_home': 'Home',
                        'nav_menu': 'Menu',
                        'nav_favorites': 'Favorites',
                        'nav_orders': 'My Orders',
                        'welcome': 'Welcome to Luna Dine',
                        'hero_subtitle': 'Experience culinary excellence under the moonlight. Enjoy carefully crafted dishes that blend tradition and innovation.',
                        'view_menu': 'View Menu',
                        'our_branches': 'Our Branches',
                        'menu': 'Menu',
                        'your_cart': 'Your Cart',
                        'checkout': 'Checkout',
                        'your_favorites': 'Your Favorites',
                        'order_tracking': 'Order Tracking',
                        'order_history': 'Order History',
                        'add_to_cart': 'Add to Cart',
                        'proceed_to_checkout': 'Proceed to Checkout',
                        'place_order': 'Place Order',
                        'promo_code': 'Promo Code',
                        'apply_promo': 'Apply',
                        'remove': 'Remove',
                        'promo_applied': 'Promo code applied successfully!',
                        'promo_invalid': 'Invalid promo code',
                        'promo_expired': 'Promo code has expired',
                        'promo_usage_limit': 'Promo code usage limit exceeded',
                        'promo_not_active': 'Promo code is not yet active',
                        'min_order_not_met': 'Minimum order value not met',
                        'please_select_branch': 'Please select a branch first',
                        'discount': 'Discount',
                        'order_summary': 'Order Summary',
                        'empty_cart': 'Your cart is empty',
                        'empty_favorites': 'Your favorites will appear here',
                        'remove_from_favorites': 'Remove from favorites',
                        'browse_menu': 'Browse Menu',
                        'item_added': 'Item added to cart',
                        'language_changed': 'Language changed to English',
                        'item_details': 'Item Details',
                        'request_service': 'Request Service',
                        'request_type': 'Request Type',
                        'call_waiter': 'Call Waiter',
                        'request_bill': 'Request Bill',
                        'cleaning_assistance': 'Cleaning Assistance',
                        'other': 'Other',
                        'please_specify': 'Please specify',
                        'specify_request': 'Please specify your request',
                        'submit_request': 'Submit Request',
                        'order_type': 'Order Type',
                        'details': 'Details',
                        'payment': 'Payment',
                        'branch': 'Branch',
                        'dine_in': 'Dine In',
                        'takeaway': 'Takeaway',
                        'delivery': 'Delivery',
                        'table_number': 'Table Number',
                        'select_table': 'Select a table',
                        'guests_count': 'Number of Guests',
                        'pickup_time': 'Pickup Time',
                        'your_name': 'Your Name',
                        'phone_number': 'Phone Number',
                        'delivery_address': 'Delivery Address',
                        'payment_method': 'Payment Method',
                        'cash': 'Cash',
                        'card': 'Card',
                        'mobile_payment': 'Mobile Payment',
                        'special_instructions': 'Special Instructions',
                        'any_requests': 'Any special requests?',
                        'search_menu': 'Search menu items...',
                        'order_not_found': 'Order Not Found',
                        'order_not_found_message': 'The order you are looking for could not be found.',
                        'view_order_history': 'View Order History',
                        'no_orders': 'No Orders Yet',
                        'no_orders_message': 'You haven\'t placed any orders yet.',
                        'error_loading_orders': 'Error Loading Orders',
                        'error_loading_orders_message': 'Unable to load your order history. Please try again later.',
                        'placed_at': 'Placed At',
                        'order_items': 'Order Items',
                        'view_details': 'View Details',
                        'cancel_order': 'Cancel Order',
                        'confirm_action': 'Confirm Action',
                        'confirm': 'Confirm',
                        'cancel': 'Cancel',
                        'delivery_charge': 'Delivery Charge',
                        'pending': 'Pending',
                        'confirmed': 'Confirmed',
                        'preparing': 'Preparing',
                        'ready': 'Ready',
                        'served': 'Served',
                        'picked_up': 'Picked Up',
                        'out_for_delivery': 'Out for Delivery',
                        'delivered': 'Delivered',
                        'completed': 'Completed',
                        'cancelled': 'Cancelled',
                        'order_cancelled': 'Order Cancelled',
                        'back_to_menu': 'Back to Menu',
                        'add_some_delicious_items': 'Add some delicious items to your cart.',
                        'delicious_menu_item': 'Delicious menu item',
                        'delicious_menu_item_description': 'A delicious menu item prepared with care.',
                        'start_adding_favorites': 'Start adding your favorite items to see them here.',
                        'about_us': 'About Us',
                        'contact_us': 'Contact Us',
                        'business_hours': 'Business Hours',
                        'quick_links': 'Quick Links',
                        'privacy_policy': 'Privacy Policy',
                        'terms_of_service': 'Terms of Service',
                        'footer_default_description': 'Experience culinary excellence under the moonlight. Luna Dine offers a unique dining experience with carefully crafted dishes that blend tradition and innovation.',
                        'footer_default_tagline': 'Dine Under the Stars',
                        'footer_default_address': 'House 15, Road 7, Dhanmondi, Dhaka-1205, Bangladesh',
                        'footer_default_phone': '+8801234567890',
                        'footer_default_email': 'hello@lunadine.com',
                        'monday': 'Monday',
                        'tuesday': 'Tuesday',
                        'wednesday': 'Wednesday',
                        'thursday': 'Thursday',
                        'friday': 'Friday',
                        'saturday': 'Saturday',
                        'sunday': 'Sunday',
                        'branch_conflict': 'Branch Conflict',
                        'branch_conflict_message': 'You have items in the cart from another branch. Adding this item will clear the existing items in the cart.',
                        'current_cart_branch': 'Current Cart Branch:',
                        'new_item_branch': 'New Item Branch:',
                        'clear_and_add': 'Clear & Add',
                        'item_branch_not_available': 'Item branch information not available',
                        'branch_not_found': 'Branch not found for this item',
                        'order_placed_success': 'Order placed successfully!',
                        'order_failed': 'Failed to place order. Please try again.',
                        'service_request_submitted': 'Service request submitted successfully.',
                        'customized': 'Customized',
                        'confirm_cancel_order': 'Are you sure you want to cancel this order?',
                        'order_cancelled_success': 'Order cancelled successfully',
                        'cancel_order_failed': 'Failed to cancel order. Please try again.',
                        'mins': 'mins',
                        'table': 'Table',
                        'special_offers': 'Special Offers',
                        'scan_table_qr': 'Scan Table QR Code',
                        'scan_qr_instruction': 'Point your camera at the QR code on your table',
                        'enter_qr_code': 'Or enter QR code manually',
                        'submit': 'Submit',
                        'invalid_qr_code': 'Invalid QR code. Please try again.',
                        'table_selected': 'Table selected: {table}',
                        'rate_your_experience': 'Rate Your Experience',
                        'share_your_experience': 'Share your experience with us',
                        'submit_feedback': 'Submit Feedback',
                        'please_select_rating': 'Please select a rating',
                        'feedback_submitted': 'Feedback submitted successfully',
                        'feedback_submission_failed': 'Failed to submit feedback. Please try again.',
                        'service_quality': 'Service Quality',
                        'food_quality': 'Food Quality',
                        'ambiance': 'Ambiance',
                        'value_for_money': 'Value for Money',
                        'would_recommend': 'Would you recommend us to others?',
                        'yes': 'Yes',
                        'no': 'No',
                        'branch_settings': 'Branch Settings',
                        'vat_percentage': 'VAT Percentage',
                        'service_charge_percentage': 'Service Charge Percentage',
                        'loading_branches': 'Loading branches...',
                        'loading_menu': 'Loading menu...',
                        'loading_promotions': 'Loading promotions...',
                        'loading_order': 'Loading order...',
                        'loading_tables': 'Loading tables...',
                        'loading_feedback': 'Loading feedback...',
                        'unknown_branch': 'Unknown Branch',
                        'all_items': 'All Items',
                        'no_items_found': 'No items found',
                        'try_different_category': 'Try selecting a different category',
                        'view_all_items': 'View All Items',
                        'items': 'items',
                        'retry': 'Retry',
                        'order': 'Order'
                    },
                    'bn-BD': {
                        'app_name': 'লুনা ডাইন',
                        'nav_home': 'হোম',
                        'nav_menu': 'মেনু',
                        'nav_favorites': 'পছন্দসমূহ',
                        'nav_orders': 'আমার অর্ডারসমূহ',
                        'welcome': 'লুনা ডাইনেতে স্বাগতম',
                        'hero_subtitle': 'চাঁদের আলোয় রন্ধন শৈলীর অভিজ্ঞতা উপভোগ করুন। ঐতিহ্য এবং উদ্ভাবনার মিশ্রণে তৈরি সাবধানভাবে প্রস্তুত খাবার উপভোগ করুন।',
                        'view_menu': 'মেনু দেখুন',
                        'our_branches': 'আমাদের শাখাসমূহ',
                        'menu': 'মেনু',
                        'your_cart': 'আপনার কার্ট',
                        'checkout': 'চেকআউট',
                        'your_favorites': 'আপনার পছন্দসমূহ',
                        'order_tracking': 'অর্ডার ট্র্যাকিং',
                        'order_history': 'অর্ডার ইতিহাস',
                        'add_to_cart': 'কার্টে যোগ করুন',
                        'proceed_to_checkout': 'চেকআউট করতে এগিয়ান',
                        'place_order': 'অর্ডার দিন',
                        'promo_code': 'প্রমো কোড',
                        'apply_promo': 'প্রয়োগ করুন',
                        'remove': 'সরান',
                        'promo_applied': 'প্রমো কোড সফলভাবে প্রয়োগ করা হয়েছে!',
                        'promo_invalid': 'অবৈধ প্রমো কোড',
                        'promo_expired': 'প্রমো কোডের মেয়াদ শেষ হয়েছে',
                        'promo_usage_limit': 'প্রমো কোড ব্যবহারের সীমা অতিক্রান্ত হয়েছে',
                        'promo_not_active': 'প্রমো কোড এখনও সক্রিয় নয়',
                        'min_order_not_met': 'ন্যূনতম অর্ডার মান পূরণ হয়নি',
                        'please_select_branch': 'অনুগ্রহ করে প্রথমে একটি শাখা নির্বাচন করুন',
                        'discount': 'ছাড়',
                        'order_summary': 'অর্ডার সারাংশ',
                        'empty_cart': 'আপনার কার্ট খালি',
                        'empty_favorites': 'আপনার পছন্দসমূহ এখানে প্রদর্শিত হবে',
                        'remove_from_favorites': 'পছন্দ তালিকা থেকে সরান',
                        'browse_menu': 'মেনু ব্রাউজ করুন',
                        'item_added': 'আইটেম কার্টে যোগ করা হয়েছে',
                        'language_changed': 'ভাষা বাংলায় পরিবর্তন করা হয়েছে',
                        'item_details': 'আইটেমের বিবরণ',
                        'request_service': 'পরিষেবা অনুরোধ করুন',
                        'request_type': 'অনুরোধের ধরণ',
                        'call_waiter': 'ওয়েটার ডাকুন',
                        'request_bill': 'বিল চাই',
                        'cleaning_assistance': 'পরিষ্কার সহায়তা',
                        'other': 'অন্যান্য',
                        'please_specify': 'অনুগ্রহ করে উল্লেখ করুন',
                        'specify_request': 'আপনার অনুরোধটি অনুগ্রহ করে উল্লেখ করুন',
                        'submit_request': 'অনুরোধ জমা দিন',
                        'order_type': 'অর্ডারের ধরণ',
                        'details': 'বিবরণ',
                        'payment': 'পেমেন্ট',
                        'branch': 'শাখা',
                        'dine_in': 'ডাইন ইন',
                        'takeaway': 'টেকঅওয়ে',
                        'delivery': 'ডেলিভারি',
                        'table_number': 'টেবিল নম্বর',
                        'select_table': 'একটি টেবিল নির্বাচন করুন',
                        'guests_count': 'অতিথির সংখ্যা',
                        'pickup_time': 'পিকআপ সময়',
                        'your_name': 'আপনার নাম',
                        'phone_number': 'ফোন নম্বর',
                        'delivery_address': 'ডেলিভারি ঠিকানা',
                        'payment_method': 'পেমেন্ট পদ্ধতি',
                        'cash': 'নগদ',
                        'card': 'কার্ড',
                        'mobile_payment': 'মোবাইল পেমেন্ট',
                        'special_instructions': 'বিশেষ নির্দেশাবলী',
                        'any_requests': 'কোনো বিশেষ অনুরোধ?',
                        'search_menu': 'মেনু আইটেম খুঁজুন...',
                        'order_not_found': 'অর্ডার পাওয়া যায়নি',
                        'order_not_found_message': 'আপনি যে অর্ডারটি খুঁজছেন তা পাওয়া যায়নি।',
                        'view_order_history': 'অর্ডার ইতিহাস দেখুন',
                        'no_orders': 'এখনও কোনো অর্ডার নেই',
                        'no_orders_message': 'আপনি এখনও কোনো অর্ডার করেননি।',
                        'error_loading_orders': 'অর্ডার লোড করতে ত্রুটি',
                        'error_loading_orders_message': 'আপনার অর্ডার ইতিহাস লোড করতে অক্ষম। দয়া করে পরে আবার চেষ্টা করুন।',
                        'placed_at': 'স্থাপন করা হয়েছে',
                        'order_items': 'অর্ডার আইটেম',
                        'view_details': 'বিবরণ দেখুন',
                        'cancel_order': 'অর্ডার বাতিল করুন',
                        'confirm_action': 'ক্রিয়া নিশ্চিত করুন',
                        'confirm': 'নিশ্চিত করুন',
                        'cancel': 'বাতিল করুন',
                        'delivery_charge': 'ডেলিভারি চার্জ',
                        'pending': 'মুলতুবি',
                        'confirmed': 'নিশ্চিত',
                        'preparing': 'প্রস্তুত হচ্ছে',
                        'ready': 'প্রস্তুত',
                        'served': 'পরিবেশিত',
                        'picked_up': 'সংগ্রহ করা হয়েছে',
                        'out_for_delivery': 'ডেলিভারিতে বের হয়েছে',
                        'delivered': 'ডেলিভার করা হয়েছে',
                        'completed': 'সম্পন্ন',
                        'cancelled': 'বাতিল',
                        'order_cancelled': 'অর্ডার বাতিল হয়েছে',
                        'back_to_menu': 'মেনুতে ফিরে যান',
                        'add_some_delicious_items': 'আপনার কার্টে কিছু সুস্বাদু আইটেম যোগ করুন।',
                        'delicious_menu_item': 'সুস্বাদু মেনু আইটেম',
                        'delicious_menu_item_description': 'যত্ন সহকারে প্রস্তুত একটি সুস্বাদু মেনু আইটেম।',
                        'start_adding_favorites': 'আপনার পছন্দের আইটেমগুলি এখানে দেখতে শুরু করুন।',
                        'about_us': 'আমাদের সম্পর্কে',
                        'contact_us': 'যোগাযোগ করুন',
                        'business_hours': 'ব্যবসায়িক সময়',
                        'quick_links': 'দ্রুত লিঙ্ক',
                        'privacy_policy': 'গোপনীয়তা নীতি',
                        'terms_of_service': 'সেবার শর্তাবলী',
                        'footer_default_description': 'চাঁদের আলোয় রন্ধন শৈলীর অভিজ্ঞতা উপভোগ করুন। লুনা ডাইন ঐতিহ্য এবং উদ্ভাবনার মিশ্রণে তৈরি সাবধানভাবে প্রস্তুত খাবারের অনন্য ডাইনিং অভিজ্ঞতা অফার করে।',
                        'footer_default_tagline': 'নক্ষত্রের নিচে ডাইন করুন',
                        'footer_default_address': 'বাড়ি ১৫, রোড ৭, ধানমন্ডি, ঢাকা-১২০৫, বাংলাদেশ',
                        'footer_default_phone': '+৮৮০১২৩৪৫৬৭৮৯০',
                        'footer_default_email': 'hello@lunadine.com',
                        'monday': 'সোমবার',
                        'tuesday': 'মঙ্গলবার',
                        'wednesday': 'বুধবার',
                        'thursday': 'বৃহস্পতিবার',
                        'friday': 'শুক্রবার',
                        'saturday': 'শনিবার',
                        'sunday': 'রবিবার',
                        'branch_conflict': 'শাখা দ্বন্দ্ব',
                        'branch_conflict_message': 'আপনার কার্টে অন্য শাখা থেকে আইটেম রয়েছে। এই আইটেমটি যোগ করলে বিদ্যমান আইটেমগুলি কার্ট থেকে সরানো হবে।',
                        'current_cart_branch': 'বর্তমান কার্ট শাখা:',
                        'new_item_branch': 'নতুন আইটেম শাখা:',
                        'clear_and_add': 'সাফ করে যোগ করুন',
                        'item_branch_not_available': 'আইটেম শাখার তথ্য পাওয়া যায়নি',
                        'branch_not_found': 'এই আইটেমের শাখা পাওয়া যায়নি',
                        'order_placed_success': 'অর্ডার সফলভাবে স্থাপন করা হয়েছে!',
                        'order_failed': 'অর্ডার স্থাপন করতে ব্যর্থ হয়েছে। আবার চেষ্টা করুন।',
                        'service_request_submitted': 'পরিষেবা অনুরোধ সফলভাবে জমা দেওয়া হয়েছে।',
                        'customized': 'কাস্টমাইজড',
                        'confirm_cancel_order': 'আপনি কি নিশ্চিত যে আপনি এই অর্ডারটি বাতিল করতে চান?',
                        'order_cancelled_success': 'অর্ডার সফলভাবে বাতিল করা হয়েছে',
                        'cancel_order_failed': 'অর্ডার বাতিল করতে ব্যর্থ হয়েছে। আবার চেষ্টা করুন।',
                        'mins': 'মিনিট',
                        'table': 'টেবিল',
                        'special_offers': 'বিশেষ অফার',
                        'scan_table_qr': 'টেবিল QR কোড স্ক্যান করুন',
                        'scan_qr_instruction': 'আপনার টেবিলে QR কোডে ক্যামেরা নির্দেশ করুন',
                        'enter_qr_code': 'অথবা QR কোড ম্যানুয়ালি লিখুন',
                        'submit': 'জমা দিন',
                        'invalid_qr_code': 'অবৈধ QR কোড। আবার চেষ্টা করুন।',
                        'table_selected': 'টেবিল নির্বাচিত: {table}',
                        'rate_your_experience': 'আপনার অভিজ্ঞতা রেটিং দিন',
                        'share_your_experience': 'আমাদের সাথে আপনার অভিজ্ঞতা শেয়ার করুন',
                        'submit_feedback': 'মতামত জমা দিন',
                        'please_select_rating': 'অনুগ্রহ করে একটি রেটিং নির্বাচন করুন',
                        'feedback_submitted': 'মতামত সফলভাবে জমা দেওয়া হয়েছে',
                        'feedback_submission_failed': 'মতামত জমা দিতে ব্যর্থ হয়েছে। আবার চেষ্টা করুন।',
                        'service_quality': 'পরিষেবার গুণমান',
                        'food_quality': 'খাবারের গুণমান',
                        'ambiance': 'পরিবেশ',
                        'value_for_money': 'মূল্যের জন্য মান',
                        'would_recommend': 'আপনি কি অন্যদের আমাদের কাছে সুপারিশ করবেন?',
                        'yes': 'হ্যাঁ',
                        'no': 'না',
                        'branch_settings': 'শাখা সেটিংস',
                        'vat_percentage': 'ভ্যাট শতাংশ',
                        'service_charge_percentage': 'সার্ভিস চার্জ শতাংশ',
                        'loading_branches': 'শাখাগুলি লোড হচ্ছে...',
                        'loading_menu': 'মেনু লোড হচ্ছে...',
                        'loading_promotions': 'প্রচারগুলি লোড হচ্ছে...',
                        'loading_order': 'অর্ডার লোড হচ্ছে...',
                        'loading_tables': 'টেবিলগুলি লোড হচ্ছে...',
                        'loading_feedback': 'মতামত লোড হচ্ছে...',
                        'unknown_branch': 'অজানা শাখা',
                        'all_items': 'সমস্ত আইটেম',
                        'no_items_found': 'কোন আইটেম পাওয়া যায়নি',
                        'try_different_category': 'অন্য ক্যাটাগরি নির্বাচন করুন',
                        'view_all_items': 'সমস্ত আইটেম দেখুন',
                        'items': 'আইটেম',
                        'retry': 'পুনরায় চেষ্টা করুন',
                        'order': 'অর্ডার'
                    }
                }
            };
            
            // DOM Elements
            const elements = {
                mainContent: document.getElementById('main-content'),
                views: document.querySelectorAll('.view'),
                navLinks: document.querySelectorAll('.nav-link'),
                branchesContainer: document.getElementById('branches-container'),
                menuItemsContainer: document.getElementById('menu-items-container'),
                cartContainer: document.getElementById('cart-container'),
                cartToggle: document.getElementById('cart-toggle'),
                cartFab: document.getElementById('cart-fab'),
                cartCounts: document.querySelectorAll('.cart-count'),
                itemDetailModal: document.getElementById('item-detail-modal'),
                serviceModal: document.getElementById('service-modal'),
                itemDetailContent: document.getElementById('item-detail-content'),
                addToCartDetailBtn: document.getElementById('add-to-cart-detail-btn'),
                serviceRequestBtn: document.getElementById('service-request-btn'),
                submitRequestBtn: document.getElementById('submit-request-btn'),
                requestType: document.getElementById('request-type'),
                otherRequestContainer: document.getElementById('other-request-container'),
                otherRequest: document.getElementById('other-request'),
                loadingOverlay: document.getElementById('loading-overlay'),
                menuSearch: document.getElementById('menu-search'),
                menuSearchClear: document.getElementById('menu-search-clear'),
                menuSearchFilterToggle: document.getElementById('menu-search-filter-toggle'),
                menuSearchFiltersPanel: document.getElementById('menu-search-filters-panel'),
                priceMin: document.getElementById('price-min'),
                priceMax: document.getElementById('price-max'),
                applyFiltersBtn: document.getElementById('apply-filters'),
                clearFiltersBtn: document.getElementById('clear-filters'),
                compactPromotions: document.getElementById('compact-promotions'),
                menuBranchName: document.getElementById('menu-branch-name'),
                cartBranchName: document.getElementById('cart-branch-name'),
                checkoutBranchName: document.getElementById('checkout-branch-name'),
                favoritesContainer: document.getElementById('favorites-container'),
                languageDropdown: document.getElementById('language-dropdown'),
                checkoutForm: document.getElementById('checkout-form'),
                orderTrackingContainer: document.getElementById('order-tracking-container'),
                orderHistoryContainer: document.getElementById('order-history-container'),
                promotionsContainer: document.getElementById('promotions-container'),
                promotionsGrid: document.getElementById('promotions-grid'),
                qrScannerBtn: document.getElementById('qr-scanner-btn'),
                qrScannerContainer: document.getElementById('qr-scanner-container'),
                qrScannerClose: document.getElementById('qr-scanner-close'),
                qrCodeInput: document.getElementById('qr-code-input'),
                qrCodeSubmit: document.getElementById('qr-code-submit'),
                footer: document.getElementById('footer'),
                footerContent: document.getElementById('footer-content'),
                footerRestaurantName: document.getElementById('footer-restaurant-name'),
                branchConflictModal: document.getElementById('branch-conflict-modal'),
                branchConflictMessage: document.getElementById('branch-conflict-message'),
                currentBranchName: document.getElementById('current-branch-name'),
                categoryTabsContainer: document.getElementById('category-tabs-container'),
                categoryTabs: document.getElementById('category-tabs'),
                menuContentArea: document.getElementById('menu-content-area'),
                newBranchName: document.getElementById('new-branch-name'),
                branchConflictCancelBtn: document.getElementById('branch-conflict-cancel-btn'),
                branchConflictConfirmBtn: document.getElementById('branch-conflict-confirm-btn')
            };
            
            // Initialize the application
            async function init() {
                setupEventListeners();
                loadUserData();
                
                // Synchronize cart state to ensure everything is properly loaded
                synchronizeCartState();
                
                // Synchronize favorites state to ensure everything is properly loaded
                synchronizeFavoritesState();
                
                // Detect language from URL BEFORE loading translations
                const detectedLanguage = detectLanguageFromUrl();
                if (detectedLanguage !== state.language) {
                    console.log('Setting language based on URL:', detectedLanguage); // Debug log
                    state.language = detectedLanguage;
                    saveUserData();
                    
                    // Update HTML lang attribute for proper language setting
                    document.documentElement.lang = detectedLanguage;
                    document.documentElement.dir = detectedLanguage === 'bn-BD' ? 'ltr' : 'ltr';
                }
                
                // Load translations from API FIRST before loading any data that requires translations
                await loadTranslationsFromAPI();
                
                // Update branch name displays after loading user data and translations
                updateBranchNameDisplays();
                
                // Load branches data BEFORE setting up router
                await loadBranches();
                
                // Load restaurant details for footer
                await loadRestaurantDetails();
                
                // Setup router AFTER all data is loaded and handle initial route immediately
                setupRouter();
                
                updateCartUI();
                
                // Initialize hero section enhancements
                heroEnhancements.init();
            }
            
            // Language detection from URL
            function detectLanguageFromUrl() {
                const hash = window.location.hash.substring(1);
                
                // Handle new URL format: /BranchName/page
                if (hash.startsWith('/')) {
                    const parts = hash.split('/').filter(part => part.length > 0);
                    
                    if (parts.length >= 2) {
                        let branchUrlName = parts[0];
                        
                        // Try to decode the branch URL name
                        try {
                            branchUrlName = decodeUrlName(branchUrlName);
                        } catch (e) {
                            // Ignore decoding errors
                        }
                        
                        // Check if the URL contains Bengali characters
                        // Bengali Unicode range: \u0980-\u09FF
                        if (/[\u0980-\u09FF]/.test(branchUrlName)) {
                            console.log('Detected Bengali characters in URL, setting language to bn-BD'); // Debug log
                            return 'bn-BD';
                        }
                    }
                }
                
                // Default to English if no Bengali characters found
                return 'en-US';
            }
            
            // URL helper functions
            function normalizeString(str) {
                // Normalize Unicode strings for consistent comparison
                // Special handling for Bengali characters to ensure proper normalization
                if (!str) return '';
                
                // First, decode if it's already encoded (for URLs coming from browser)
                try {
                    str = decodeUrlName(str);
                } catch (e) {
                    // If decoding fails, continue with original string
                }
                
                // Normalize Unicode and trim
                let normalized = str.normalize('NFC').trim();
                
                // Remove extra spaces and normalize spacing for Bengali text
                normalized = normalized.replace(/\s+/g, ' ');
                
                return normalized;
            }
            
            // Input validation utilities
            const validationUtils = {
                validateName(name) {
                    if (!name || name.trim().length < 2) {
                        return { valid: false, message: 'Name must be at least 2 characters long' };
                    }
                    if (name.trim().length > 50) {
                        return { valid: false, message: 'Name must be less than 50 characters' };
                    }
                    return { valid: true };
                },
                
                validatePhone(phone) {
                    if (!phone || phone.trim().length === 0) {
                        return { valid: false, message: 'Phone number is required' };
                    }
                    
                    // Remove spaces and special characters for validation
                    const cleanPhone = phone.replace(/[^\d+]/g, '');
                    
                    if (cleanPhone.length < 10) {
                        return { valid: false, message: 'Phone number must be at least 10 digits' };
                    }
                    if (cleanPhone.length > 15) {
                        return { valid: false, message: 'Phone number must be less than 15 digits' };
                    }
                    
                    return { valid: true };
                },
                
                validateEmail(email) {
                    if (!email) return { valid: true }; // Email is optional
                    
                    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
                    if (!emailRegex.test(email)) {
                        return { valid: false, message: 'Please enter a valid email address' };
                    }
                    
                    return { valid: true };
                },
                
                validatePromoCode(code) {
                    if (!code) return { valid: true }; // Promo code is optional
                    
                    if (code.length < 3 || code.length > 20) {
                        return { valid: false, message: 'Promo code must be between 3 and 20 characters' };
                    }
                    
                    return { valid: true };
                },
                
                showFieldError(fieldId, message) {
                    const field = document.getElementById(fieldId);
                    if (!field) return;
                    
                    // Remove existing error
                    this.clearFieldError(fieldId);
                    
                    // Add error styling
                    field.classList.add('error');
                    
                    // Create error message element
                    const errorElement = document.createElement('div');
                    errorElement.className = 'field-error';
                    errorElement.textContent = message;
                    errorElement.id = `${fieldId}-error`;
                    
                    // Insert error after the field
                    field.parentNode.insertBefore(errorElement, field.nextSibling);
                },
                
                clearFieldError(fieldId) {
                    const field = document.getElementById(fieldId);
                    if (field) {
                        field.classList.remove('error');
                    }
                    
                    const errorElement = document.getElementById(`${fieldId}-error`);
                    if (errorElement) {
                        errorElement.remove();
                    }
                },
                
                clearAllErrors() {
                    document.querySelectorAll('.field-error').forEach(el => el.remove());
                    document.querySelectorAll('.error').forEach(el => el.classList.remove('error'));
                }
            };

            // Security utilities for XSS protection and content sanitization
            const securityUtils = {
                // Basic HTML sanitization - removes potentially dangerous tags and attributes
                sanitizeHTML(html) {
                    if (!html) return '';
                    
                    // Create a temporary div to parse HTML
                    const tempDiv = document.createElement('div');
                    tempDiv.textContent = html; // This escapes HTML entities
                    
                    // For trusted HTML content, we can allow specific tags
                    return tempDiv.innerHTML;
                },
                
                // Safe innerHTML replacement that sanitizes content
                safeSetHTML(element, content) {
                    if (!element || !content) return;
                    
                    // For now, escape all HTML content
                    element.textContent = content;
                },
                
                // Create element with safe content
                createElement(tag, content = '', className = '', attributes = {}) {
                    const element = document.createElement(tag);
                    
                    if (className) {
                        element.className = className;
                    }
                    
                    // Set attributes safely
                    Object.entries(attributes).forEach(([key, value]) => {
                        if (this.isAllowedAttribute(key)) {
                            element.setAttribute(key, this.sanitizeAttribute(value));
                        }
                    });
                    
                    // Set content safely
                    if (content) {
                        element.textContent = content;
                    }
                    
                    return element;
                },
                
                // Build complex HTML structures safely using DOM methods
                createComplexElement(config) {
                    const { tag, content, className, children = [], attributes = {} } = config;
                    
                    const element = this.createElement(tag, content, className, attributes);
                    
                    // Add children recursively
                    children.forEach(childConfig => {
                        if (typeof childConfig === 'string') {
                            element.appendChild(document.createTextNode(childConfig));
                        } else {
                            element.appendChild(this.createComplexElement(childConfig));
                        }
                    });
                    
                    return element;
                },
                
                // Whitelist of allowed attributes
                isAllowedAttribute(attr) {
                    const allowed = [
                        'id', 'class', 'data-*', 'aria-*', 'role', 'tabindex',
                        'alt', 'title', 'href', 'target', 'rel', 'src',
                        'width', 'height', 'type', 'value', 'placeholder',
                        'min', 'max', 'step', 'required', 'disabled'
                    ];
                    
                    return allowed.some(pattern => {
                        if (pattern.includes('*')) {
                            const prefix = pattern.replace('*', '');
                            return attr.startsWith(prefix);
                        }
                        return attr === pattern;
                    });
                },
                
                // Sanitize attribute values
                sanitizeAttribute(value) {
                    if (typeof value !== 'string') return value;
                    
                    // Remove potentially dangerous content
                    return value
                        .replace(/javascript:/gi, '')
                        .replace(/data:/gi, '')
                        .replace(/vbscript:/gi, '')
                        .replace(/on\w+=/gi, '');
                },
                
                // Safe URL validation
                isSafeURL(url) {
                    if (!url) return false;
                    
                    try {
                        const urlObj = new URL(url, window.location.origin);
                        return ['http:', 'https:', 'mailto:', 'tel:'].includes(urlObj.protocol);
                    } catch {
                        return false;
                    }
                },
                
                // Generate CSP nonce for inline styles/scripts (if needed)
                generateNonce() {
                    const array = new Uint8Array(16);
                    crypto.getRandomValues(array);
                    return btoa(String.fromCharCode.apply(null, array));
                },
                
                // Input validation utilities
                validateInput: {
                    // Promo code validation
                    promoCode(code) {
                        if (!code || typeof code !== 'string') return { isValid: false, error: 'Invalid promo code format' };
                        
                        const sanitized = code.trim().toUpperCase();
                        
                        // Check length (reasonable limits)
                        if (sanitized.length < 2 || sanitized.length > 20) {
                            return { isValid: false, error: 'Promo code must be 2-20 characters' };
                        }
                        
                        // Only allow alphanumeric characters and common symbols
                        const validPattern = /^[A-Z0-9_-]+$/;
                        if (!validPattern.test(sanitized)) {
                            return { isValid: false, error: 'Promo code contains invalid characters' };
                        }
                        
                        return { isValid: true, value: sanitized };
                    },
                    
                    // Email validation
                    email(email) {
                        if (!email || typeof email !== 'string') return { isValid: false, error: 'Invalid email format' };
                        
                        const sanitized = email.trim().toLowerCase();
                        
                        // Basic email regex
                        const emailPattern = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
                        if (!emailPattern.test(sanitized)) {
                            return { isValid: false, error: 'Invalid email format' };
                        }
                        
                        return { isValid: true, value: sanitized };
                    },
                    
                    // Phone number validation
                    phone(phone) {
                        if (!phone || typeof phone !== 'string') return { isValid: false, error: 'Invalid phone format' };
                        
                        const sanitized = phone.replace(/\D/g, ''); // Remove non-digits
                        
                        // Check length (adjust based on your region)
                        if (sanitized.length < 10 || sanitized.length > 15) {
                            return { isValid: false, error: 'Phone number must be 10-15 digits' };
                        }
                        
                        return { isValid: true, value: sanitized };
                    },
                    
                    // Text input validation (for feedback, comments, etc.)
                    text(text, maxLength = 1000) {
                        if (text && typeof text !== 'string') return { isValid: false, error: 'Invalid text format' };
                        
                        const sanitized = text ? text.trim() : '';
                        
                        if (sanitized.length > maxLength) {
                            return { isValid: false, error: `Text must be less than ${maxLength} characters` };
                        }
                        
                        // Remove potentially dangerous characters
                        const cleanText = sanitized
                            .replace(/<script\b[^<]*(?:(?!<\/script>)<[^<]*)*<\/script>/gi, '')
                            .replace(/<[^>]*>/g, ''); // Remove HTML tags
                            
                        return { isValid: true, value: cleanText };
                    },
                    
                    // Numeric validation
                    number(value, min = null, max = null) {
                        const num = parseFloat(value);
                        
                        if (isNaN(num)) {
                            return { isValid: false, error: 'Invalid number format' };
                        }
                        
                        if (min !== null && num < min) {
                            return { isValid: false, error: `Number must be at least ${min}` };
                        }
                        
                        if (max !== null && num > max) {
                            return { isValid: false, error: `Number must be at most ${max}` };
                        }
                        
                        return { isValid: true, value: num };
                    },
                    
                    // Rating validation (1-5)
                    rating(rating) {
                        const num = parseInt(rating);
                        
                        if (isNaN(num) || num < 1 || num > 5) {
                            return { isValid: false, error: 'Rating must be between 1 and 5' };
                        }
                        
                        return { isValid: true, value: num };
                    }
                },
                
                // Secure form data collection
                collectFormData(formElement, validationRules = {}) {
                    const formData = new FormData(formElement);
                    const result = { isValid: true, data: {}, errors: {} };
                    
                    for (const [key, value] of formData.entries()) {
                        if (validationRules[key]) {
                            const validation = validationRules[key](value);
                            if (validation.isValid) {
                                result.data[key] = validation.value;
                            } else {
                                result.isValid = false;
                                result.errors[key] = validation.error;
                            }
                        } else {
                            // Basic sanitization for unvalidated fields
                            result.data[key] = this.validateInput.text(value, 500).value;
                        }
                    }
                    
                    return result;
                }
            };
            
            // Performance optimization utilities
            const performanceUtils = {
                // Image lazy loading observer
                imageObserver: null,
                
                // Performance monitoring
                performanceMetrics: {
                    imageLoadTimes: [],
                    apiResponseTimes: [],
                    renderTimes: []
                },
                
                // Cache for frequently accessed data
                cache: {
                    branches: new Map(),
                    menuItems: new Map(),
                    translations: new Map()
                },
                
                // Branch lookup cache methods
                findBranchById(branchId) {
                    if (this.cache.branches.has(branchId)) {
                        return this.cache.branches.get(branchId);
                    }
                    
                    const branch = state.branches.find(b => b.branch_id == branchId);
                    if (branch) {
                        this.cache.branches.set(branchId, branch);
                    }
                    return branch;
                },
                
                // Cached category data finder
                findCategoryById(categoryId) {
                    if (this.cache.menuItems.has(categoryId)) {
                        return this.cache.menuItems.get(categoryId);
                    }
                    
                    const category = state.menuData ? state.menuData.find(cat => cat.category_id == categoryId) : null;
                    if (category) {
                        this.cache.menuItems.set(categoryId, category);
                    }
                    return category;
                },
                
                // Clear caches when data changes
                clearCaches() {
                    this.cache.branches.clear();
                    this.cache.menuItems.clear();
                    this.cache.translations.clear();
                },
                
                // Initialize performance optimizations
                init() {
                    this.setupLazyLoading();
                    this.setupImageOptimization();
                    this.preloadCriticalResources();
                },
                
                // Setup intersection observer for lazy loading
                setupLazyLoading() {
                    if ('IntersectionObserver' in window) {
                        this.imageObserver = new IntersectionObserver((entries) => {
                            entries.forEach(entry => {
                                if (entry.isIntersecting) {
                                    const img = entry.target;
                                    if (img.dataset.src) {
                                        const startTime = performance.now();
                                        
                                        img.src = img.dataset.src;
                                        img.onload = () => {
                                            const loadTime = performance.now() - startTime;
                                            this.performanceMetrics.imageLoadTimes.push(loadTime);
                                            img.classList.add('loaded');
                                        };
                                        img.onerror = () => {
                                            img.src = '/images/food-default.jpg'; // Fallback
                                        };
                                        
                                        this.imageObserver.unobserve(img);
                                    }
                                }
                            });
                        }, {
                            rootMargin: '50px' // Start loading 50px before entering viewport
                        });
                    }
                },
                
                // Create optimized image element
                createLazyImage(src, alt, className = '', attributes = {}) {
                    const img = securityUtils.createElement('img', '', className, {
                        alt: alt || 'Image',
                        'data-src': src,
                        src: 'data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iMjAwIiBoZWlnaHQ9IjEyMCIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj48cmVjdCB3aWR0aD0iMjAwIiBoZWlnaHQ9IjEyMCIgZmlsbD0iI2Y0ZjRmNCIvPjx0ZXh0IHg9IjUwJSIgeT0iNTAlIiBkb21pbmFudC1iYXNlbGluZT0ibWlkZGxlIiB0ZXh0LWFuY2hvcj0ibWlkZGxlIiBmaWxsPSIjOTk5Ij5Mb2FkaW5nLi4uPC90ZXh0Pjwvc3ZnPg==', // Loading placeholder
                        ...attributes
                    });
                    
                    // Add to lazy loading observer
                    if (this.imageObserver) {
                        this.imageObserver.observe(img);
                    } else {
                        // Fallback for browsers without intersection observer
                        img.src = src;
                    }
                    
                    return img;
                },
                
                // Setup image optimization
                setupImageOptimization() {
                    // Add loading states to images
                    const style = document.createElement('style');
                    style.textContent = `
                        img[data-src] {
                            filter: blur(2px);
                            transition: filter 0.3s ease;
                        }
                        img.loaded {
                            filter: none;
                        }
                        .image-skeleton {
                            background: linear-gradient(90deg, #f0f0f0 25%, #e0e0e0 50%, #f0f0f0 75%);
                            background-size: 200% 100%;
                            animation: loading 1.5s infinite;
                        }
                        @keyframes loading {
                            0% { background-position: 200% 0; }
                            100% { background-position: -200% 0; }
                        }
                    `;
                    document.head.appendChild(style);
                },
                
                // Preload critical resources
                preloadCriticalResources() {
                    const criticalImages = [
                        '/images/food-default.jpg',
                        '/images/logo.png'
                    ];
                    
                    criticalImages.forEach(src => {
                        const link = document.createElement('link');
                        link.rel = 'preload';
                        link.as = 'image';
                        link.href = src;
                        document.head.appendChild(link);
                    });
                },
                
                // Debounce function for performance
                debounce(func, wait) {
                    let timeout;
                    return function executedFunction(...args) {
                        const later = () => {
                            clearTimeout(timeout);
                            func(...args);
                        };
                        clearTimeout(timeout);
                        timeout = setTimeout(later, wait);
                    };
                },
                
                // Throttle function for scroll events
                throttle(func, limit) {
                    let lastFunc;
                    let lastRan;
                    return function(...args) {
                        if (!lastRan) {
                            func.apply(this, args);
                            lastRan = Date.now();
                        } else {
                            clearTimeout(lastFunc);
                            lastFunc = setTimeout(() => {
                                if ((Date.now() - lastRan) >= limit) {
                                    func.apply(this, args);
                                    lastRan = Date.now();
                                }
                            }, limit - (Date.now() - lastRan));
                        }
                    };
                },
                
                // Get performance metrics
                getMetrics() {
                    return {
                        avgImageLoadTime: this.performanceMetrics.imageLoadTimes.length > 0 
                            ? this.performanceMetrics.imageLoadTimes.reduce((a, b) => a + b, 0) / this.performanceMetrics.imageLoadTimes.length 
                            : 0,
                        avgApiResponseTime: this.performanceMetrics.apiResponseTimes.length > 0
                            ? this.performanceMetrics.apiResponseTimes.reduce((a, b) => a + b, 0) / this.performanceMetrics.apiResponseTimes.length
                            : 0,
                        totalImages: this.performanceMetrics.imageLoadTimes.length,
                        totalApiCalls: this.performanceMetrics.apiResponseTimes.length
                    };
                }
            };
            
            // Modern JavaScript improvements and error handling
            const modernJS = {
                // Error boundary system
                errorBoundary: {
                    errorCount: 0,
                    maxErrors: 10,
                    errors: [],
                    
                    // Global error handler
                    setupGlobalErrorHandling() {
                        // Handle unhandled promise rejections
                        window.addEventListener('unhandledrejection', (event) => {
                            console.error('Unhandled promise rejection:', event.reason);
                            this.logError(event.reason, 'Unhandled Promise');
                            event.preventDefault(); // Prevent default browser error handling
                        });
                        
                        // Handle JavaScript errors
                        window.addEventListener('error', (event) => {
                            console.error('JavaScript error:', event.error);
                            this.logError(event.error, 'JavaScript Error');
                        });
                        
                        // Handle API errors specifically
                        this.setupAPIErrorHandling();
                    },
                    
                    // Log and track errors
                    logError(error, context = 'General') {
                        this.errorCount++;
                        const errorInfo = {
                            message: error.message || error,
                            stack: error.stack,
                            context,
                            timestamp: new Date().toISOString(),
                            url: window.location.href,
                            userAgent: navigator.userAgent
                        };
                        
                        this.errors.push(errorInfo);
                        
                        // Keep only last 50 errors
                        if (this.errors.length > 50) {
                            this.errors = this.errors.slice(-50);
                        }
                        
                        // Show user-friendly error if too many errors
                        if (this.errorCount > this.maxErrors) {
                            this.showCriticalError();
                        }
                        
                        // Report to console in development
                        if (window.location.hostname === 'localhost') {
                            console.table(errorInfo);
                        }
                    },
                    
                    // API-specific error handling
                    setupAPIErrorHandling() {
                        const originalFetch = window.fetch;
                        window.fetch = async (...args) => {
                            try {
                                const response = await originalFetch(...args);
                                
                                if (!response.ok) {
                                    this.logError(
                                        new Error(`API Error: ${response.status} ${response.statusText}`),
                                        'API'
                                    );
                                }
                                
                                return response;
                            } catch (error) {
                                this.logError(error, 'Network');
                                throw error;
                            }
                        };
                    },
                    
                    // Show critical error message
                    showCriticalError() {
                        const errorModal = securityUtils.createElement('div', '', 'critical-error-modal');
                        const errorContent = securityUtils.createElement('div', '', 'critical-error-content');
                        
                        const title = securityUtils.createElement('h2', 'Application Error');
                        const message = securityUtils.createElement('p', 'The application has encountered multiple errors. Please refresh the page to continue.');
                        const refreshBtn = securityUtils.createElement('button', 'Refresh Page', 'btn btn-primary');
                        const continueBtn = securityUtils.createElement('button', 'Continue Anyway', 'btn btn-secondary');
                        
                        refreshBtn.onclick = () => window.location.reload();
                        continueBtn.onclick = () => errorModal.remove();
                        
                        errorContent.appendChild(title);
                        errorContent.appendChild(message);
                        errorContent.appendChild(refreshBtn);
                        errorContent.appendChild(continueBtn);
                        errorModal.appendChild(errorContent);
                        
                        document.body.appendChild(errorModal);
                    }
                },
                
                // Async utilities
                asyncUtils: {
                    // Safe async wrapper
                    async safeAsync(asyncFn, fallbackValue = null) {
                        try {
                            return await asyncFn();
                        } catch (error) {
                            modernJS.errorBoundary.logError(error, 'Async Operation');
                            return fallbackValue;
                        }
                    },
                    
                    // Retry mechanism
                    async retryAsync(asyncFn, maxRetries = 3, delay = 1000) {
                        for (let i = 0; i < maxRetries; i++) {
                            try {
                                return await asyncFn();
                            } catch (error) {
                                if (i === maxRetries - 1) {
                                    throw error;
                                }
                                await this.delay(delay * (i + 1)); // Exponential backoff
                            }
                        }
                    },
                    
                    // Promise delay utility
                    delay(ms) {
                        return new Promise(resolve => setTimeout(resolve, ms));
                    },
                    
                    // Timeout wrapper
                    withTimeout(promise, timeoutMs) {
                        return Promise.race([
                            promise,
                            this.delay(timeoutMs).then(() => {
                                throw new Error(`Operation timed out after ${timeoutMs}ms`);
                            })
                        ]);
                    }
                },
                
                // State management improvements
                stateManager: {
                    // Deep clone utility
                    deepClone(obj) {
                        if (obj === null || typeof obj !== 'object') return obj;
                        if (obj instanceof Date) return new Date(obj.getTime());
                        if (obj instanceof Array) return obj.map(item => this.deepClone(item));
                        if (typeof obj === 'object') {
                            const cloned = {};
                            Object.keys(obj).forEach(key => {
                                cloned[key] = this.deepClone(obj[key]);
                            });
                            return cloned;
                        }
                    },
                    
                    // State history for undo functionality
                    stateHistory: [],
                    maxHistorySize: 10,
                    
                    // Save state snapshot
                    saveState(stateName = 'auto') {
                        const snapshot = {
                            timestamp: Date.now(),
                            name: stateName,
                            state: this.deepClone(state)
                        };
                        
                        this.stateHistory.push(snapshot);
                        
                        // Keep only recent history
                        if (this.stateHistory.length > this.maxHistorySize) {
                            this.stateHistory = this.stateHistory.slice(-this.maxHistorySize);
                        }
                    },
                    
                    // Restore previous state
                    restoreState(index = -1) {
                        if (this.stateHistory.length === 0) return false;
                        
                        const snapshot = index >= 0 
                            ? this.stateHistory[index]
                            : this.stateHistory[this.stateHistory.length + index];
                            
                        if (snapshot) {
                            Object.assign(state, this.deepClone(snapshot.state));
                            return true;
                        }
                        return false;
                    }
                },
                
                // Initialize all modern JS features
                init() {
                    this.errorBoundary.setupGlobalErrorHandling();
                    this.stateManager.saveState('initial');
                    
                    // Add development helpers
                    if (window.location.hostname === 'localhost') {
                        window.modernJS = this;
                        window.performanceUtils = performanceUtils;
                        window.securityUtils = securityUtils;
                        console.log('Development utilities available:', { modernJS: this, performanceUtils, securityUtils });
                    }
                }
            };
            
            // Accessibility and UX enhancement utilities
            const accessibilityUtils = {
                // ARIA utilities
                aria: {
                    // Announce to screen readers
                    announce(message, priority = 'polite') {
                        const announcer = document.getElementById('aria-announcer') || 
                            this.createAnnouncer();
                        announcer.setAttribute('aria-live', priority);
                        announcer.textContent = message;
                        
                        // Clear after announcement
                        setTimeout(() => {
                            announcer.textContent = '';
                        }, 1000);
                    },
                    
                    // Create ARIA live region for announcements
                    createAnnouncer() {
                        const announcer = securityUtils.createElement('div', '', 'sr-only', {
                            id: 'aria-announcer',
                            'aria-live': 'polite',
                            'aria-atomic': 'true'
                        });
                        document.body.appendChild(announcer);
                        return announcer;
                    }
                },
                
                // Initialize accessibility features
                init() {
                    // Create ARIA announcer
                    this.aria.createAnnouncer();
                    
                    // Add CSS for accessibility
                    this.addAccessibilityCSS();
                },
                
                // Add accessibility CSS
                addAccessibilityCSS() {
                    const style = document.createElement('style');
                    style.textContent = `
                        .sr-only {
                            position: absolute !important;
                            width: 1px !important;
                            height: 1px !important;
                            padding: 0 !important;
                            margin: -1px !important;
                            overflow: hidden !important;
                            clip: rect(0, 0, 0, 0) !important;
                            border: 0 !important;
                        }
                        
                        *:focus {
                            outline: 2px solid #007bff;
                            outline-offset: 2px;
                        }
                    `;
                    document.head.appendChild(style);
                },
                
                // Security utils for element creation
            };
            
            function getBranchUrlName(branch) {
                const displayName = getTranslation(branch.internal_name, branch.name_translation_key) || branch.internal_name || 'Branch';
                return normalizeString(displayName).replace(/\s+/g, ''); // Remove spaces
            }
            
            function encodeUrlName(name) {
                // Properly encode URL components while preserving Unicode characters
                return encodeURIComponent(name);
            }
            
            function decodeUrlName(encodedName) {
                // Decode URL components back to original string
                return decodeURIComponent(encodedName);
            }
            
            function findBranchByUrlName(urlName) {
                // Try to find branch by comparing URL names
                // Handle both encoded and decoded versions for Bengali characters
                const normalizedUrlName = normalizeString(urlName);
                
                console.log('Searching for branch with URL name:', urlName, 'normalized:', normalizedUrlName); // Debug log
                
                // Use cached lookup for better performance
                const cacheKey = `url_${normalizedUrlName}`;
                if (performanceUtils && performanceUtils.cache.branches.has(cacheKey)) {
                    return performanceUtils.cache.branches.get(cacheKey);
                }
                
                const branch = state.branches.find(branch => {
                    const branchUrlName = getBranchUrlName(branch);
                    const normalizedBranchName = normalizeString(branchUrlName);
                    
                    console.log('Comparing:', {
                        urlName: normalizedUrlName,
                        branchName: normalizedBranchName,
                        exactMatch: normalizedBranchName === normalizedUrlName
                    }); // Debug log
                    
                    // Try exact match first
                    if (normalizedBranchName === normalizedUrlName) {
                        console.log('Found exact match for:', branchUrlName); // Debug log
                        return true;
                    }
                    
                    // Try decoded match (for URLs that were encoded by browser)
                    try {
                        const decodedUrlName = normalizeString(decodeUrlName(urlName));
                        if (normalizedBranchName === decodedUrlName) {
                            console.log('Found match via decoding:', decodedUrlName); // Debug log
                            return true;
                        }
                    } catch (e) {
                        // Ignore decoding errors
                    }
                    
                    // Try encoded match (for comparison with encoded URLs)
                    try {
                        const encodedBranchName = encodeUrlName(branchUrlName);
                        if (encodedBranchName === urlName) {
                            console.log('Found match via encoding:', encodedBranchName); // Debug log
                            return true;
                        }
                    } catch (e) {
                        // Ignore encoding errors
                    }
                    
                    // Special handling for Bengali: try comparing with and without spaces
                    // Sometimes Bengali URLs might have different spacing
                    const branchNameNoSpaces = normalizedBranchName.replace(/\s+/g, '');
                    const urlNameNoSpaces = normalizedUrlName.replace(/\s+/g, '');
                    
                    if (branchNameNoSpaces === urlNameNoSpaces) {
                        console.log('Found match via space removal:', branchNameNoSpaces); // Debug log
                        return true;
                    }
                    
                    // Try partial matching for Bengali characters (in case of normalization differences)
                    if (normalizedBranchName.includes(normalizedUrlName) || normalizedUrlName.includes(normalizedBranchName)) {
                        console.log('Found partial match between:', normalizedBranchName, 'and', normalizedUrlName); // Debug log
                        return true;
                    }
                    
                    return false;
                });
                
                // Cache the result if found
                if (branch) {
                    performanceUtils.cache.branches.set(cacheKey, branch);
                }
                
                return branch;
            }
            
            function createBranchUrl(branch, page) {
                const branchUrlName = getBranchUrlName(branch);
                console.log('Creating URL for branch:', {
                    branchName: branch.internal_name,
                    urlName: branchUrlName,
                    hasUnicode: /[\u0980-\u09FF\u0800-\uFFFF]/.test(branchUrlName) // Added Bengali range
                }); // Debug log
                
                // For URLs with Unicode characters, we should encode them
                // Bengali Unicode range: \u0980-\u09FF, Other Unicode: \u0800-\uFFFF
                if (/[\u0980-\u09FF\u0800-\uFFFF]/.test(branchUrlName)) {
                    // Contains Bengali or other Unicode characters
                    const encodedName = encodeUrlName(branchUrlName);
                    console.log('Encoded URL name:', encodedName); // Debug log
                    return `#/${encodedName}/${page}`;
                }
                return `#/${branchUrlName}/${page}`;
            }
            
            // Test function for URL handling (can be called from browser console)
            window.testUrlHandling = function() {
                console.log('=== URL Handling Test ===');
                console.log('Current branches:', state.branches);
                console.log('Current language:', state.language);
                
                state.branches.forEach(branch => {
                    const urlName = getBranchUrlName(branch);
                    const url = createBranchUrl(branch, 'menu');
                    const found = findBranchByUrlName(urlName);
                    
                    console.log('Branch test:', {
                        branchName: branch.internal_name,
                        urlName: urlName,
                        generatedUrl: url,
                        found: !!found,
                        translations: {
                            internal: branch.internal_name,
                            translated: getTranslation(branch.internal_name, branch.name_translation_key),
                            key: branch.name_translation_key
                        }
                    });
                });
            };
            
            function redirectToNewFormat() {
                const hash = window.location.hash.substring(1);
                
                // Check if it's a legacy format that needs redirection
                if (!hash.startsWith('/') && hash.includes('/')) {
                    const [route, param] = hash.split('/');
                    
                    // Handle legacy menu URLs with branch ID
                    if (route === 'menu' && param && !isNaN(param)) {
                        const branch = performanceUtils.findBranchById(param) || state.branches.find(b => b.branch_id == param);
                        if (branch) {
                            window.location.hash = createBranchUrl(branch, 'menu');
                            return true;
                        }
                    }
                }
                
                return false;
            }
            
            // Router setup for SPA navigation
            function setupRouter() {
                window.addEventListener('hashchange', handleRouteChange);
                // Handle initial route immediately
                handleRouteChange(true); // true indicates initial load
            }
            
            async function handleRouteChange(isInitialLoad = false) {
                // First, check if we need to redirect from legacy format
                if (redirectToNewFormat()) {
                    return; // Stop processing if redirection occurred
                }
                
                // Safety check: if branches are not loaded yet, wait and try again
                if (state.branches.length === 0) {
                    console.log('Branches not loaded yet, delaying route handling...');
                    setTimeout(() => handleRouteChange(isInitialLoad), 100);
                    return;
                }
                
                const hash = window.location.hash.substring(1);
                
                // Handle new URL format: /BranchName/page
                if (hash.startsWith('/')) {
                    const parts = hash.split('/').filter(part => part.length > 0);
                    
                    if (parts.length >= 2) {
                        let branchUrlName = parts[0];
                        const page = parts[1];
                        
                        console.log('Processing URL parts:', parts); // Debug log
                        console.log('Original branch URL name:', branchUrlName); // Debug log
                        
                        // Try to decode the branch URL name (for Bengali characters)
                        try {
                            const decodedName = decodeUrlName(branchUrlName);
                            console.log('Decoded branch URL name:', decodedName); // Debug log
                            branchUrlName = decodedName;
                        } catch (e) {
                            console.warn('Failed to decode branch URL name:', branchUrlName, e);
                        }
                        
                        // Additional normalization for Bengali text
                        branchUrlName = normalizeString(branchUrlName);
                        console.log('Normalized branch URL name:', branchUrlName); // Debug log
                        
                        console.log('Looking for branch with URL name:', branchUrlName); // Debug log
                        console.log('Available branches:', state.branches.map(b => ({
                            id: b.branch_id,
                            name: getBranchUrlName(b)
                        }))); // Debug log
                        
                        const branch = findBranchByUrlName(branchUrlName);
                        
                        if (branch) {
                            console.log('Found branch:', branch); // Debug log
                            // Ensure branch settings are loaded
                            const branchWithSettings = await ensureBranchSettings(branch);
                            state.currentBranch = branchWithSettings;
                            updateBranchNameDisplays();
                            updateCurrentCart();
                            updateCartUI();
                            
                            switch(page) {
                                case 'menu':
                                    // Check if this is an item detail URL: #/{branch-name}/menu/item/{branch_menu_id}
                                    if (parts.length >= 4 && parts[2] === 'item') {
                                        const branchMenuId = parts[3];
                                        loadItemById(branch.branch_id, branchMenuId);
                                    } else {
                                        loadMenu(branch.branch_id);
                                    }
                                    break;
                                case 'cart':
                                    showView('cart');
                                    renderCart();
                                    break;
                                case 'checkout':
                                    showView('checkout');
                                    renderCheckout();
                                    break;
                                case 'item':
                                    // Legacy support for old format: #/{branch-name}/item/{branch_menu_id}
                                    if (parts.length >= 3) {
                                        const branchMenuId = parts[2];
                                        loadItemById(branch.branch_id, branchMenuId);
                                    } else {
                                        showError('Item ID not provided');
                                        loadMenu(branch.branch_id);
                                    }
                                    break;
                                default:
                                    console.warn('Unknown page:', page);
                                    showView('home');
                            }
                            return;
                        } else {
                            console.error('Branch not found for URL name:', branchUrlName);
                            console.error('Available branch URL names:', state.branches.map(b => getBranchUrlName(b)));
                            showError('Branch not found');
                        }
                    }
                }
                
                // Handle legacy URL format for backward compatibility
                const [route, param] = hash.split('/');
                
                switch(route) {
                    case 'home':
                        showView('home');
                        break;
                    case 'menu':
                        if (param) {
                            // Ensure branches are loaded before loading menu
                            if (state.branches.length === 0) {
                                // If branches aren't loaded yet, load them first then proceed
                                loadBranches().then(() => {
                                    loadMenu(param);
                                }).catch(error => {
                                    console.error('Failed to load branches for menu:', error);
                                    showError('Failed to load branch data');
                                });
                            } else {
                                // Check if we already have menu data for this branch
                                const targetBranchId = parseInt(param, 10);
                                const hasCurrentMenuData = state.menuData && state.menuData.length > 0 && 
                                                          state.currentBranch && 
                                                          state.currentBranch.branch_id === targetBranchId;
                                
                                if (hasCurrentMenuData) {
                                    // We already have the menu data, just show the view
                                    showView('menu');
                                    renderMenuContentArea('all');
                                } else {
                                    // Load the menu data
                                    loadMenu(param);
                                }
                            }
                        } else if (state.currentBranch) {
                            // Check if we already have menu data for the current branch
                            const hasCurrentMenuData = state.menuData && state.menuData.length > 0;
                            
                            if (hasCurrentMenuData) {
                                // We already have the menu data, just show the view
                                showView('menu');
                                renderMenuContentArea('all');
                            } else {
                                // Load the menu data
                                loadMenu(state.currentBranch.branch_id);
                            }
                        } else {
                            showView('home');
                        }
                        break;
                    case 'cart':
                        showView('cart');
                        renderCart();
                        break;
                    case 'checkout':
                        showView('checkout');
                        renderCheckout();
                        break;
                    case 'order':
                        if (param) {
                            showView('order-tracking');
                            loadOrder(param);
                        } else {
                            showView('orders');
                            renderOrderHistory();
                        }
                        break;
                    case 'orders':
                        showView('orders');
                        renderOrderHistory();
                        break;
                    case 'favorites':
                        showView('favorites');
                        renderFavorites();
                        break;
                    default:
                        // Only show home view if there's no hash OR if it's not the initial load
                        if (!hash || !isInitialLoad) {
                            showView('home');
                            renderHome();
                        }
                        // If it's initial load with no hash, show home view after a short delay
                        else if (isInitialLoad && !hash) {
                            setTimeout(() => {
                                showView('home');
                                renderHome();
                            }, 100);
                        }
                }
            }
            
            function showView(viewName) {
                // Hide all views
                elements.views.forEach(view => {
                    view.classList.remove('active');
                });
                
                // Show the requested view
                const viewElement = document.getElementById(`${viewName}-view`);
                if (viewElement) {
                    viewElement.classList.add('active');
                }
                
                // Update active nav link
                elements.navLinks.forEach(link => {
                    link.classList.remove('active');
                    if (link.getAttribute('data-view') === viewName) {
                        link.classList.add('active');
                    }
                });
                
                // Update mobile nav link
                const mobileNavLinks = document.querySelectorAll('.mobile-nav-link');
                mobileNavLinks.forEach(link => {
                    link.classList.remove('active');
                    if (link.getAttribute('data-view') === viewName) {
                        link.classList.add('active');
                    }
                });
                
                // Scroll to top when changing pages
                window.scrollTo({
                    top: 0,
                    behavior: 'smooth'
                });
                
                state.currentView = viewName;
            }
            
            // Enhanced API Service with security and authentication
            const apiService = {
                // Configuration
                baseURL: '/api',
                defaultTimeout: 30000,
                authToken: null,
                
                // Initialize API service
                init() {
                    this.authToken = this.getStoredAuthToken();
                },
                
                // Authentication methods
                setAuthToken(token) {
                    this.authToken = token;
                    if (token) {
                        localStorage.setItem('lunadine_auth_token', token);
                    } else {
                        localStorage.removeItem('lunadine_auth_token');
                    }
                },
                
                getStoredAuthToken() {
                    return localStorage.getItem('lunadine_auth_token');
                },
                
                // Security headers
                getSecurityHeaders() {
                    const headers = {
                        'Content-Type': 'application/json',
                        'X-Requested-With': 'XMLHttpRequest',
                        'X-Client-Version': '1.0.0'
                    };
                    
                    if (this.authToken) {
                        headers['Authorization'] = `Bearer ${this.authToken}`;
                    }
                    
                    return headers;
                },
                
                // Request validation
                validateRequestData(data) {
                    if (!data) return true;
                    
                    // Check for potentially dangerous content
                    const dataString = JSON.stringify(data);
                    const dangerousPatterns = [
                        /<script/i, /javascript:/i, /vbscript:/i, /data:/i,
                        /on\w+=/i, /<iframe/i, /<object/i, /<embed/i
                    ];
                    
                    return !dangerousPatterns.some(pattern => pattern.test(dataString));
                },
                
                async get(url, showGlobalLoading = true, timeout = this.defaultTimeout) {
                    const startTime = performance.now();
                    
                    try {
                        if (showGlobalLoading) {
                            showLoading();
                        }
                        
                        const controller = new AbortController();
                        const timeoutId = setTimeout(() => controller.abort(), timeout);
                        
                        const response = await fetch(`${this.baseURL}/${url}`, {
                            method: 'GET',
                            headers: this.getSecurityHeaders(),
                            signal: controller.signal,
                            credentials: 'same-origin' // CSRF protection
                        });
                        
                        clearTimeout(timeoutId);
                        
                        if (!response.ok) {
                            throw new Error(`API error: ${response.status} ${response.statusText}`);
                        }
                        
                        const data = await response.json();
                        
                        // Track performance
                        const responseTime = performance.now() - startTime;
                        performanceUtils.performanceMetrics.apiResponseTimes.push(responseTime);
                        
                        if (showGlobalLoading) {
                            hideLoading();
                        }
                        
                        return data;
                    } catch (error) {
                        if (showGlobalLoading) {
                            hideLoading();
                        }
                        
                        console.error('API Error:', error);
                        
                        if (error.name === 'AbortError') {
                            showError('Request timed out. Please check your connection and try again.');
                        } else if (error.message.includes('401')) {
                            this.handleAuthError();
                        } else {
                            showError('Failed to load data. Please try again.');
                        }
                        
                        throw error;
                    }
                },
                
                async post(url, data, showGlobalLoading = true, timeout = this.defaultTimeout) {
                    try {
                        // Validate request data for security
                        if (!this.validateRequestData(data)) {
                            throw new Error('Invalid request data detected');
                        }
                        
                        if (showGlobalLoading) {
                            showLoading();
                        }
                        
                        const controller = new AbortController();
                        const timeoutId = setTimeout(() => controller.abort(), timeout);
                        
                        const response = await fetch(`${this.baseURL}/${url}`, {
                            method: 'POST',
                            headers: this.getSecurityHeaders(),
                            body: JSON.stringify(data),
                            signal: controller.signal,
                            credentials: 'same-origin' // CSRF protection
                        });
                        
                        clearTimeout(timeoutId);
                        
                        if (!response.ok) {
                            throw new Error(`API error: ${response.status} ${response.statusText}`);
                        }
                        
                        const result = await response.json();
                        
                        if (showGlobalLoading) {
                            hideLoading();
                        }
                        
                        return result;
                    } catch (error) {
                        if (showGlobalLoading) {
                            hideLoading();
                        }
                        
                        console.error('API Error:', error);
                        
                        if (error.name === 'AbortError') {
                            showError('Request timed out. Please check your connection and try again.');
                        } else if (error.message.includes('401')) {
                            this.handleAuthError();
                        } else {
                            showError('Failed to submit data. Please try again.');
                        }
                        
                        throw error;
                    }
                },
                
                async delete(url, showGlobalLoading = true, timeout = this.defaultTimeout) {
                    try {
                        if (showGlobalLoading) {
                            showLoading();
                        }
                        
                        const controller = new AbortController();
                        const timeoutId = setTimeout(() => controller.abort(), timeout);
                        
                        const response = await fetch(`${this.baseURL}/${url}`, {
                            method: 'DELETE',
                            headers: this.getSecurityHeaders(),
                            signal: controller.signal,
                            credentials: 'same-origin' // CSRF protection
                        });
                        
                        clearTimeout(timeoutId);
                        
                        if (!response.ok) {
                            throw new Error(`API error: ${response.status} ${response.statusText}`);
                        }
                        
                        const result = await response.json();
                        
                        if (showGlobalLoading) {
                            hideLoading();
                        }
                        
                        return result;
                    } catch (error) {
                        if (showGlobalLoading) {
                            hideLoading();
                        }
                        
                        console.error('API Error:', error);
                        
                        if (error.name === 'AbortError') {
                            showError('Request timed out. Please check your connection and try again.');
                        } else if (error.message.includes('401')) {
                            this.handleAuthError();
                        } else {
                            showError('Failed to delete data. Please try again.');
                        }
                        
                        throw error;
                    }
                },
                
                // Handle authentication errors
                handleAuthError() {
                    this.setAuthToken(null);
                    showError('Session expired. Please refresh the page.');
                    // Could redirect to login page in a real app
                },
                
                // Convenience methods for specific endpoints
                async getBranches() {
                    return this.get('branches');
                },
                
                async getBranch(branchId) {
                    return this.get(`branches/${branchId}`);
                },
                
                async getBranchMenu(branchId) {
                    return this.get(`branches/${branchId}/menu`);
                },
                
                async getBranchSettings(branchId) {
                    return this.get(`branches/${branchId}/settings`);
                },
                
                async submitOrder(orderData) {
                    return this.post('orders', orderData);
                },
                
                async cancelOrder(orderId) {
                    return this.delete(`orders/${orderId}`);
                },
                
                async submitFeedback(feedbackData) {
                    return this.post('feedback', feedbackData);
                },
                
                async validatePromoCode(code, branchId) {
                    return this.post('promo/validate', { code, branchId });
                }
            };
                
            // Additional API service extensions for specific methods
            Object.assign(apiService, {
                getBranches() {
                    return this.get('branches', false); // Don't show global loading for branches
                },
                
                getBranch(id) {
                    return this.get(`branches/${id}`, false); // Don't show global loading for branch details
                },
                
                getBranchMenu(branchId) {
                    return this.get(`branches/${branchId}/menu`, false); // Don't show global loading for menu
                },
                
                getBranchBanners(branchId) {
                    return this.get(`branches/${branchId}/banners`, false);
                },
                
                getBranchSettings(branchId) {
                    return this.get(`branches/${branchId}/settings`, false); // Don't show global loading for settings
                },
                
                getBranchTables(branchId) {
                    return this.get(`branches/${branchId}/tables`, false);
                },
                
                getCustomizations(branchMenuId) {
                    return this.get(`customizations/${branchMenuId}`, false);
                },
                
                createOrder(orderData) {
                    return this.post('orders', orderData, true); // Show loading overlay for order creation (user action)
                },
                
                createServiceRequest(requestData) {
                    return this.post('servicerequests', requestData, true); // Show loading overlay for service requests (user action)
                },
                
                getOrder(orderId) {
                    return this.get(`orders/${orderId}`, false); // Don't show global loading for order tracking (use skeleton instead)
                },
                
                getOrderItems(orderId) {
                    return this.get(`orders/${orderId}/items`, false); // Don't show global loading for order tracking (use skeleton instead)
                },
                
                cancelOrder(orderId) {
                    return this.delete(`orders/${orderId}`, true); // Show loading overlay for order cancellation (user action)
                },
                
                getPromotions(branchId) {
                    return branchId ? this.get(`promotions/${branchId}`, false) : this.get('promotions', false); // Don't show global loading for promotions
                },
                
                getTableByQr(qrHash) {
                    return this.get(`tables/qr/${qrHash}`, true); // Show loading overlay for QR scanning (user action)
                },
                
                getFeedback(filter) {
                    if (filter.type === 'branch') {
                        return this.get(`feedback/branch/${filter.id}`, false); // Don't show global loading for feedback data
                    } else if (filter.type === 'order') {
                        return this.get(`feedback/order/${filter.id}`, false); // Don't show global loading for feedback data
                    } else {
                        return this.get('feedback', false); // Don't show global loading for feedback data
                    }
                },
                
                submitFeedback(feedbackData) {
                    return this.post('feedback', feedbackData, true); // Show loading overlay for feedback submission (user action)
                },
                
                getTranslations(languageCode) {
                    return this.get(`translations/${languageCode}`, false); // Don't show global loading for translations
                },
                
                getRestaurant() {
                    return this.get('restaurant', false); // Don't show global loading for restaurant details
                },
                
                getUserOrders(orderIds = null) {
                    // If orderIds provided, fetch only those specific orders
                    if (orderIds && orderIds.length > 0) {
                        const orderIdsParam = orderIds.join(',');
                        return this.get(`orders/history?order_ids=${encodeURIComponent(orderIdsParam)}`, false);
                    }
                    // Otherwise get general order history (fallback)
                    return this.get('orders/history', false);
                }
            });
            
            // Data loading functions
            async function loadBranches() {
                try {
                    showToast(translate('loading_branches'));
                    // Show skeleton views first
                    renderBranchSkeletons();
                    
                    const branches = await apiService.getBranches();
                    state.branches = branches.data || branches;
                    renderHome();
                } catch (error) {
                    console.error('Failed to load branches:', error);
                }
            }
            
            // Helper function to update branch name displays
            function updateBranchNameDisplays() {
                if (!state.currentBranch) {
                    resetBranchNameDisplays();
                    return;
                }
                
                const branchDisplayName = getTranslation(state.currentBranch.internal_name, state.currentBranch.name_translation_key) || state.currentBranch.internal_name || 'Branch';
                
                // Update menu page
                if (elements.menuBranchName) {
                    elements.menuBranchName.textContent = `${translate('menu')} - ${branchDisplayName}`;
                }
                
                // Update cart page
                if (elements.cartBranchName) {
                    elements.cartBranchName.textContent = `${translate('your_cart')} - ${branchDisplayName}`;
                }
                
                // Update checkout page
                if (elements.checkoutBranchName) {
                    elements.checkoutBranchName.textContent = `${translate('checkout')} - ${branchDisplayName}`;
                }
            }
            
            // Helper function to reset branch name displays to default
            function resetBranchNameDisplays() {
                if (elements.menuBranchName) {
                    elements.menuBranchName.textContent = translate('menu');
                }
                
                if (elements.cartBranchName) {
                    elements.cartBranchName.textContent = translate('your_cart');
                }
                
                if (elements.checkoutBranchName) {
                    elements.checkoutBranchName.textContent = translate('checkout');
                }
            }
            
            async function loadMenu(branchId) {
                try {
                    showToast(translate('loading_menu'));
                    
                    // Show menu view and comprehensive skeleton
                    showView('menu');
                    renderCompleteMenuSkeleton();
                    
                    // Load featured branch cover section
                    loadFeaturedBranch();
                    
                    // Ensure translations are loaded before proceeding
                    if (!state.translations[state.language] || Object.keys(state.translations[state.language]).length === 0) {
                        await loadTranslationsFromAPI();
                    }
                    
                    // Check if we already have the branch data
                    let branch = performanceUtils.findBranchById(branchId) || state.branches.find(b => b.branch_id == branchId);
                    
                    if (!branch) {
                        branch = await apiService.getBranch(branchId);
                    }
                    
                    // Load branch settings
                    const settings = await apiService.getBranchSettings(branchId);
                    branch.settings = settings.data || settings;
                    
                    state.currentBranch = branch;
                    updateBranchNameDisplays();
                    
                    // Update cart to show current branch's cart
                    updateCurrentCart();
                    updateCartUI();
                    
                    const menuDataResponse = await apiService.getBranchMenu(branchId);
                    let menuData = menuDataResponse.data || menuDataResponse;

                    // Clear performance caches when new data is loaded
                    performanceUtils.clearCaches();

                    menuData.forEach(category => {
                      if (category.items && Array.isArray(category.items)) {
                       category.items.forEach(item => {
                        // We use parseInt to ensure the ID is a number, preventing future type issues.
                        item.branch_id = parseInt(branchId, 10);
                        });
                      }
                    });

                       state.menuData = menuData;
                    console.log('Menu data loaded:', state.menuData);
                    // Extract categories from menu data
                    state.categories = state.menuData.map(category => ({
                        id: category.category_id,
                        name: getTranslation(category.category_name, category.name_translation_key),
                        image: category.category_image
                    }));
                    console.log('Categories extracted:', state.categories);
                    
                    // Load promotions for this branch
                    try {
                        showToast(translate('loading_promotions'));
                        const promotions = await apiService.getPromotions(branchId);
                        state.promotions = promotions.data || promotions;
                        renderPromotions();
                    } catch (error) {
                        console.error('Failed to load promotions:', error);
                        elements.promotionsContainer.style.display = 'none';
                    }
                    
                    renderCategories();
                    renderMenuItems();
                    
                    // Remove skeleton class after content is loaded
                    setTimeout(() => {
                        document.getElementById('menu-view').classList.remove('skeleton');
                    }, 500);
                    
                    // Debug: Check if elements exist
                    setTimeout(() => {
                        console.log('=== DEBUG INFO ===');
                        console.log('menu-content-area element:', document.getElementById('menu-content-area'));
                        console.log('category-tabs element:', document.getElementById('category-tabs'));
                        console.log('category-tabs-container element:', document.getElementById('category-tabs-container'));
                        console.log('state.menuData:', state.menuData);
                        console.log('state.categories:', state.categories);
                        console.log('=== END DEBUG ===');
                    }, 500);
                } catch (error) {
                    console.error('Failed to load menu:', error);
                }
            }
            
            async function loadOrder(orderId) {
                try {
                    showToast(translate('loading_order'));
                    
                    // Fetch both order details and order items
                    const [orderResponse, itemsResponse] = await Promise.all([
                        apiService.getOrder(orderId),
                        apiService.getOrderItems(orderId)
                    ]);
                    
                    const order = orderResponse.data || orderResponse;
                    const items = itemsResponse.data || itemsResponse || [];
                    
                    // Combine order and items data
                    const completeOrder = {
                        ...order,
                        items: items
                    };
                    
                    renderOrderTracking({ data: completeOrder });
                } catch (error) {
                    console.error('Failed to load order:', error);
                }
            }
            
            async function loadTranslationsFromAPI() {
                try {
                    const response = await apiService.getTranslations(state.language);
                    const apiTranslations = response.data || response;
                    
                    // Merge API translations with local translations
                    if (apiTranslations && typeof apiTranslations === 'object') {
                        state.translations[state.language] = {
                            ...state.translations[state.language],
                            ...apiTranslations
                        };
                    }
                } catch (error) {
                    console.error('Failed to load translations from API:', error);
                    // Fall back to local translations
                } finally {
                    // Always apply translations to update the UI
                    applyTranslations();
                }
            }
            
            async function loadBranchTables(branchId) {
                try {
                    showToast(translate('loading_tables'));
                    const tables = await apiService.getBranchTables(branchId);
                    return tables.data || tables;
                } catch (error) {
                    console.error('Failed to load branch tables:', error);
                    return [];
                }
            }
            
            // Translation helper functions
            function getTranslation(defaultText, translationKey) {
                if (translationKey && 
                    state.translations[state.language] && 
                    state.translations[state.language][translationKey]) {
                    return state.translations[state.language][translationKey];
                }
                return defaultText;
            }
            
            function translate(key) {
                return state.translations[state.language]?.[key] || key;
            }
            
            // DOM Query Cache for better performance
            const domCache = {
                cache: new Map(),
                
                get(selector, context = document) {
                    const key = `${selector}_${context.constructor.name}`;
                    if (!this.cache.has(key)) {
                        const elements = context.querySelectorAll(selector);
                        this.cache.set(key, elements);
                    }
                    return this.cache.get(key);
                },
                
                getSingle(selector, context = document) {
                    const key = `single_${selector}_${context.constructor.name}`;
                    if (!this.cache.has(key)) {
                        const element = context.querySelector(selector);
                        this.cache.set(key, element);
                    }
                    return this.cache.get(key);
                },
                
                clear() {
                    this.cache.clear();
                },
                
                refresh(selector, context = document) {
                    const key = `${selector}_${context.constructor.name}`;
                    this.cache.delete(key);
                    return this.get(selector, context);
                }
            };
            
            // Enhanced applyTranslations with DOM caching
            function applyTranslations() {
                // Update all elements with data-translate attributes
                const translateElements = domCache.get('[data-translate]');
                translateElements.forEach(element => {
                    const key = element.getAttribute('data-translate');
                    element.textContent = translate(key);
                });
                
                // Update placeholders
                const placeholderElements = domCache.get('[data-translate-placeholder]');
                placeholderElements.forEach(element => {
                    const key = element.getAttribute('data-translate-placeholder');
                    element.placeholder = translate(key);
                });
                
                // Update title
                document.title = translate('app_name');
            }
            
            // Generic skeleton renderer to reduce code duplication
            const skeletonRenderer = {
                templates: {
                    branch: `
                        <div class="branch-image-container">
                            <div class="skeleton-image"></div>
                        </div>
                        <div class="branch-content">
                            <div class="branch-header">
                                <div class="skeleton-text title"></div>
                                <div class="skeleton-badge"></div>
                            </div>
                            <div class="skeleton-text subtitle"></div>
                            <div class="skeleton-text description"></div>
                            <div class="branch-footer">
                                <div class="skeleton-text small"></div>
                                <div class="skeleton-button"></div>
                            </div>
                        </div>
                    `,
                    menuItem: `
                        <div class="menu-item-image-container">
                            <div class="skeleton-image"></div>
                        </div>
                        <div class="menu-item-content">
                            <div class="menu-item-header">
                                <div class="skeleton-text title"></div>
                                <div class="skeleton-text price"></div>
                            </div>
                            <div class="skeleton-text description"></div>
                            <div class="menu-item-footer">
                                <div class="prep-time-with-favorite">
                                    <div class="skeleton-text small"></div>
                                    <div class="skeleton-icon"></div>
                                </div>
                            </div>
                        </div>
                        <div class="menu-item-quantity-controller">
                            <div class="skeleton-button"></div>
                        </div>
                    `,
                    promotion: `
                        <div class="promotion-image-container">
                            <div class="skeleton-image"></div>
                        </div>
                        <div class="promotion-content">
                            <div class="promotion-header">
                                <div class="skeleton-text title"></div>
                                <div class="skeleton-badge"></div>
                            </div>
                            <div class="skeleton-text description"></div>
                            <div class="promotion-footer">
                                <div class="skeleton-text small"></div>
                                <div class="skeleton-button small"></div>
                            </div>
                        </div>
                    `,
                    categoryTab: `
                        <div class="skeleton-text tab-text"></div>
                        <div class="skeleton-badge"></div>
                    `
                },
                
                render(container, type, count, className) {
                    if (!container || !this.templates[type]) return;
                    
                    container.innerHTML = '';
                    
                    for (let i = 0; i < count; i++) {
                        const skeletonCard = document.createElement('div');
                        skeletonCard.className = `${className} skeleton`;
                        skeletonCard.innerHTML = this.templates[type];
                        container.appendChild(skeletonCard);
                    }
                }
            };
            
            // Optimized skeleton rendering functions using the generic renderer
            function renderBranchSkeletons(count = 3) {
                skeletonRenderer.render(elements.branchesContainer, 'branch', count, 'branch-card');
            }
            
            function renderMenuItemSkeletons(count = 6) {
                skeletonRenderer.render(elements.menuItemsContainer, 'menuItem', count, 'menu-item-card');
            }
            
            function renderPromotionSkeletons(count = 2) {
                skeletonRenderer.render(elements.promotionsGrid, 'promotion', count, 'promotion-card');
            }
            
            function renderCategoryTabsSkeletons(count = 4) {
                const categoryTabs = document.getElementById('category-tabs');
                if (!categoryTabs) return;
                
                categoryTabs.innerHTML = '';
                
                for (let i = 0; i < count; i++) {
                    const skeletonTab = document.createElement('button');
                    skeletonTab.className = 'category-tab skeleton';
                    skeletonTab.innerHTML = skeletonRenderer.templates.categoryTab;
                    categoryTabs.appendChild(skeletonTab);
                }
            }
            
            function renderMenuContentSkeletons(count = 4) {
                const contentArea = document.getElementById('menu-content-area');
                if (!contentArea) return;
                
                contentArea.innerHTML = '';
                
                const skeletonSection = document.createElement('div');
                skeletonSection.className = 'menu-section';
                skeletonSection.innerHTML = `
                    <div class="menu-section-header">
                        <div>
                            <h3 class="menu-section-title">
                                <div class="skeleton-icon"></div>
                                <div class="skeleton-text section-title"></div>
                            </h3>
                            <div class="skeleton-text subtitle"></div>
                        </div>
                    </div>
                    <div class="menu-section-items">
                        ${Array(count).fill('').map(() => `
                            <div class="menu-item-card skeleton">
                                ${skeletonRenderer.templates.menuItem}
                            </div>
                        `).join('')}
                    </div>
                `;
                
                contentArea.appendChild(skeletonSection);
            }
            
            // Comprehensive menu skeleton that includes all menu page components
            function renderCompleteMenuSkeleton() {
                const menuView = document.getElementById('menu-view');
                if (!menuView) return;
                
                // Add skeleton class to the entire menu view
                menuView.classList.add('skeleton');
                
                // Render individual skeleton components
                renderMenuSearchSkeleton();
                renderPromotionSkeletons();
                renderCategoryTabsSkeletons();
                renderMenuContentSkeletons(6);
            }
            
            // Search bar skeleton
            function renderMenuSearchSkeleton() {
                const searchContainer = document.querySelector('.menu-search-container');
                if (!searchContainer) return;
                
                // Create skeleton overlay for search
                const searchSkeleton = document.createElement('div');
                searchSkeleton.className = 'search-skeleton';
                searchSkeleton.innerHTML = `
                    <div class="skeleton-search-bar">
                        <div class="skeleton-icon"></div>
                        <div class="skeleton-input"></div>
                        <div class="skeleton-button"></div>
                    </div>
                `;
                
                // Add skeleton temporarily
                searchContainer.style.position = 'relative';
                searchContainer.appendChild(searchSkeleton);
                
                // Remove skeleton after content loads
                setTimeout(() => {
                    if (searchSkeleton.parentNode) {
                        searchSkeleton.remove();
                    }
                }, 1000);
            }
            
            // Modal skeleton rendering functions
            function renderItemDetailSkeleton() {
                const modalContent = document.getElementById('item-detail-content');
                const modal = document.querySelector('#item-detail-modal .modal');
                if (!modalContent || !modal) return;
                
                // Add skeleton class to modal
                modal.classList.add('skeleton');
                
                modalContent.innerHTML = `
                    <div class="skeleton-row">
                        <div class="skeleton-col" style="flex: 1;">
                            <div class="skeleton-image"></div>
                        </div>
                        <div class="skeleton-col" style="flex: 1;">
                            <div class="skeleton-text large"></div>
                            <div class="skeleton-text medium"></div>
                            <div class="skeleton-text small"></div>
                            <div class="skeleton-text"></div>
                            <div class="skeleton-text medium"></div>
                        </div>
                    </div>
                    <div class="skeleton-form-group">
                        <div class="skeleton-text small"></div>
                        <div class="skeleton-select"></div>
                    </div>
                    <div class="skeleton-form-group">
                        <div class="skeleton-text small"></div>
                        <div class="skeleton-input"></div>
                    </div>
                    <div class="skeleton-row">
                        <div class="skeleton-button"></div>
                        <div class="skeleton-button"></div>
                    </div>
                `;
            }
            
            function renderServiceModalSkeleton() {
                const modalBody = document.querySelector('#service-modal .modal-body');
                const modal = document.querySelector('#service-modal .modal');
                if (!modalBody || !modal) return;
                
                // Add skeleton class to modal
                modal.classList.add('skeleton');
                
                modalBody.innerHTML = `
                    <div class="skeleton-form-group">
                        <div class="skeleton-text small"></div>
                        <div class="skeleton-select"></div>
                    </div>
                    <div class="skeleton-form-group">
                        <div class="skeleton-text small"></div>
                        <div class="skeleton-textarea"></div>
                    </div>
                    <div class="skeleton-form-group">
                        <div class="skeleton-text small"></div>
                        <div class="skeleton-input"></div>
                    </div>
                `;
                
                // Load actual content after a delay
                setTimeout(() => {
                    renderServiceModalContent();
                }, 300);
            }
            
            function renderServiceModalContent() {
                const modalBody = document.querySelector('#service-modal .modal-body');
                const modal = document.querySelector('#service-modal .modal');
                if (!modalBody || !modal) return;
                
                // Remove skeleton class
                modal.classList.remove('skeleton');
                
                // Render actual content
                modalBody.innerHTML = `
                    <div class="form-group">
                        <label class="form-label" data-translate="request_type">${translate('request_type')}</label>
                        <select class="form-select" id="request-type">
                            <option value="CALL_WAITER" data-translate="call_waiter">${translate('call_waiter')}</option>
                            <option value="REQUEST_BILL" data-translate="request_bill">${translate('request_bill')}</option>
                            <option value="CLEANING_ASSISTANCE" data-translate="cleaning_assistance">${translate('cleaning_assistance')}</option>
                            <option value="OTHER" data-translate="other">${translate('other')}</option>
                        </select>
                    </div>
                    <div class="form-group" id="other-request-container" style="display: none;">
                        <label class="form-label" data-translate="please_specify">${translate('please_specify')}</label>
                        <input type="text" class="form-input" id="other-request" data-translate-placeholder="specify_request" placeholder="${translate('specify_request')}">
                    </div>
                `;
                
                // Re-setup event listeners for the new elements
                setupServiceModalEventListeners();
            }
            
            function setupServiceModalEventListeners() {
                const requestType = document.getElementById('request-type');
                const otherRequestContainer = document.getElementById('other-request-container');
                
                if (requestType) {
                    requestType.addEventListener('change', function() {
                        if (this.value === 'OTHER') {
                            otherRequestContainer.style.display = 'block';
                        } else {
                            otherRequestContainer.style.display = 'none';
                        }
                    });
                }
            }
            
            function renderConfirmationModalSkeleton() {
                const modalBody = document.querySelector('#confirmation-modal .modal-body');
                const modal = document.querySelector('#confirmation-modal .modal');
                if (!modalBody || !modal) return;
                
                // Add skeleton class to modal
                modal.classList.add('skeleton');
                
                modalBody.innerHTML = `
                    <div class="skeleton-text medium"></div>
                    <div class="skeleton-text"></div>
                    <div class="skeleton-text small"></div>
                `;
            }
            
            function renderBranchConflictModalSkeleton() {
                const modalBody = document.querySelector('#branch-conflict-modal .modal-body');
                const modal = document.querySelector('#branch-conflict-modal .modal');
                if (!modalBody || !modal) return;
                
                // Add skeleton class to modal
                modal.classList.add('skeleton');
                
                modalBody.innerHTML = `
                    <div class="skeleton-text medium"></div>
                    <div class="skeleton-text"></div>
                    <div class="skeleton-text"></div>
                    <div class="skeleton-text small"></div>
                `;
            }
            
            // Page skeleton rendering functions
            function renderCartSkeleton() {
                const cartView = document.getElementById('cart-view');
                const cartContainer = document.getElementById('cart-container');
                if (!cartContainer || !cartView) return;
                
                // Add skeleton class to view
                cartView.classList.add('skeleton');
                
                cartContainer.innerHTML = `
                    <div class="page-header">
                        <div class="skeleton-text page-title"></div>
                        <div class="skeleton-text subtitle"></div>
                    </div>
                    
                    <div class="cart-items-section">
                        ${Array(3).fill('').map(() => `
                            <div class="cart-item-card skeleton">
                                <div class="cart-item-image-container">
                                    <div class="skeleton-image"></div>
                                </div>
                                <div class="cart-item-content">
                                    <div class="cart-item-header">
                                        <div class="skeleton-text title"></div>
                                        <div class="skeleton-text price"></div>
                                    </div>
                                    <div class="skeleton-text description"></div>
                                    <div class="cart-item-footer">
                                        <div class="skeleton-text small"></div>
                                        <div class="cart-item-controls">
                                            <div class="skeleton-button small"></div>
                                            <div class="skeleton-text small center"></div>
                                            <div class="skeleton-button small"></div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        `).join('')}
                    </div>
                    
                    <div class="cart-summary-section">
                        <div class="skeleton-text title"></div>
                        <div class="summary-rows">
                            ${Array(4).fill('').map(() => `
                                <div class="summary-row skeleton">
                                    <div class="skeleton-text small"></div>
                                    <div class="skeleton-text small"></div>
                                </div>
                            `).join('')}
                        </div>
                        <div class="skeleton-button primary full-width"></div>
                    </div>
                `;
            }
            
            function renderCheckoutSkeleton() {
                const checkoutView = document.getElementById('checkout-view');
                const checkoutForm = document.getElementById('checkout-form');
                if (!checkoutForm || !checkoutView) return;
                
                // Add skeleton class to view
                checkoutView.classList.add('skeleton');
                
                checkoutForm.innerHTML = `
                    <div class="page-header">
                        <div class="skeleton-text page-title"></div>
                        <div class="skeleton-text subtitle"></div>
                    </div>
                    
                    <div class="checkout-sections">
                        <div class="checkout-section skeleton">
                            <div class="section-header">
                                <div class="skeleton-text section-title"></div>
                            </div>
                            <div class="section-content">
                                <div class="form-group skeleton">
                                    <div class="skeleton-text small"></div>
                                    <div class="skeleton-select"></div>
                                </div>
                                <div class="form-group skeleton">
                                    <div class="skeleton-text small"></div>
                                    <div class="skeleton-input"></div>
                                </div>
                                <div class="form-group skeleton">
                                    <div class="skeleton-text small"></div>
                                    <div class="skeleton-input"></div>
                                </div>
                            </div>
                        </div>
                        
                        <div class="checkout-section skeleton">
                            <div class="section-header">
                                <div class="skeleton-text section-title"></div>
                            </div>
                            <div class="section-content">
                                <div class="order-summary-skeleton">
                                    ${Array(5).fill('').map(() => `
                                        <div class="summary-row skeleton">
                                            <div class="skeleton-text small"></div>
                                            <div class="skeleton-text small"></div>
                                        </div>
                                    `).join('')}
                                </div>
                                <div class="skeleton-button primary full-width"></div>
                            </div>
                        </div>
                    </div>
                `;
            }
            
            function renderOrderTrackingSkeleton() {
                const orderView = document.getElementById('order-tracking-view');
                const orderContainer = document.getElementById('order-tracking-container');
                if (!orderContainer || !orderView) return;
                
                // Add skeleton class to view
                orderView.classList.add('skeleton');
                
                orderContainer.innerHTML = `
                    <!-- Order Type Header Skeleton -->
                    <div class="order-type-header skeleton">
                        <div class="ot-order-type-icon">
                            <div class="skeleton-icon"></div>
                        </div>
                        <div class="order-type-info">
                            <div class="skeleton-text title"></div>
                            <div class="skeleton-text subtitle"></div>
                        </div>
                    </div>
                    
                    <!-- ETA Display Skeleton -->
                    <div class="eta-display skeleton">
                        <div class="skeleton-text small"></div>
                        <div class="skeleton-text large"></div>
                    </div>
                    
                    <!-- Status Progress Skeleton -->
                    <div class="status-progress-custom skeleton">
                        ${Array(4).fill('').map(() => `
                            <div class="status-step-custom">
                                <div class="step-icon">
                                    <div class="skeleton-icon"></div>
                                </div>
                                <div class="skeleton-text small"></div>
                            </div>
                        `).join('')}
                    </div>
                    
                    <!-- Info Cards Skeleton -->
                    <div class="order-type-info-cards skeleton">
                        ${Array(2).fill('').map(() => `
                            <div class="info-card skeleton">
                                <div class="skeleton-text medium"></div>
                                <div class="skeleton-text"></div>
                            </div>
                        `).join('')}
                    </div>
                    
                    <!-- Order Items Skeleton -->
                    <div class="order-details skeleton">
                        <div class="skeleton-text section-title"></div>
                        <div class="order-items-list">
                            ${Array(3).fill('').map(() => `
                                <div class="order-item-card skeleton">
                                    <div class="order-item-image">
                                        <div class="skeleton-image"></div>
                                    </div>
                                    <div class="order-item-content">
                                        <div class="order-item-header">
                                            <div class="skeleton-text title"></div>
                                            <div class="skeleton-text small"></div>
                                        </div>
                                        <div class="skeleton-text description"></div>
                                        <div class="order-item-footer">
                                            <div class="skeleton-text small"></div>
                                        </div>
                                    </div>
                                </div>
                            `).join('')}
                        </div>
                        
                        <!-- Order Summary Skeleton -->
                        <div class="order-summary skeleton">
                            ${Array(5).fill('').map(() => `
                                <div class="summary-row skeleton">
                                    <div class="skeleton-text small"></div>
                                    <div class="skeleton-text small"></div>
                                </div>
                            `).join('')}
                        </div>
                    </div>
                `;
            }
            
            function renderOrdersSkeleton() {
                const ordersView = document.getElementById('orders-view');
                const ordersContainer = document.getElementById('order-history-container');
                if (!ordersContainer || !ordersView) return;
                
                // Add skeleton class to view
                ordersView.classList.add('skeleton');
                
                ordersContainer.innerHTML = `
                    <div class="page-header">
                        <div class="skeleton-text page-title"></div>
                        <div class="skeleton-text subtitle"></div>
                    </div>
                    
                    <div class="orders-list">
                        ${Array(4).fill('').map(() => `
                            <div class="order-history-card skeleton">
                                <div class="order-header">
                                    <div class="order-info">
                                        <div class="skeleton-text title"></div>
                                        <div class="skeleton-text subtitle"></div>
                                    </div>
                                    <div class="order-status">
                                        <div class="skeleton-badge"></div>
                                    </div>
                                </div>
                                <div class="order-body">
                                    <div class="order-items-preview">
                                        ${Array(2).fill('').map(() => `
                                            <div class="order-item-preview skeleton">
                                                <div class="skeleton-image small"></div>
                                                <div class="item-preview-details">
                                                    <div class="skeleton-text small"></div>
                                                    <div class="skeleton-text tiny"></div>
                                                </div>
                                            </div>
                                        `).join('')}
                                    </div>
                                    <div class="order-footer">
                                        <div class="order-total">
                                            <div class="skeleton-text medium"></div>
                                        </div>
                                        <div class="order-actions">
                                            <div class="skeleton-button small"></div>
                                            <div class="skeleton-button small primary"></div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        `).join('')}
                    </div>
                `;
            }
            
            function renderFavoritesSkeleton() {
                const favoritesView = document.getElementById('favorites-view');
                const favoritesContainer = document.getElementById('favorites-container');
                if (!favoritesContainer || !favoritesView) return;
                
                // Add skeleton class to view
                favoritesView.classList.add('skeleton');
                
                favoritesContainer.innerHTML = `
                    <div class="page-header">
                        <div class="skeleton-text page-title"></div>
                        <div class="skeleton-text subtitle"></div>
                    </div>
                    
                    <div class="favorites-grid">
                        ${Array(9).fill('').map(() => `
                            <div class="menu-item-card skeleton">
                                <div class="menu-item-image-container">
                                    <div class="skeleton-image"></div>
                                </div>
                                <div class="menu-item-content">
                                    <div class="menu-item-header">
                                        <div class="skeleton-text title"></div>
                                        <div class="skeleton-text price"></div>
                                    </div>
                                    <div class="skeleton-text description"></div>
                                    <div class="menu-item-footer">
                                        <div class="prep-time-with-favorite">
                                            <div class="skeleton-text small"></div>
                                            <div class="skeleton-icon"></div>
                                        </div>
                                    </div>
                                </div>
                                <div class="menu-item-quantity-controller">
                                    <div class="skeleton-button"></div>
                                </div>
                            </div>
                        `).join('')}
                    </div>
                `;
            }
            
            // Rendering functions
            // Home page rendering with skeleton
            function renderHome() {
                // Show skeleton view immediately
                renderBranchSkeletons();
                
                // Small delay to ensure skeleton is visible
                setTimeout(() => {
                    renderBranches();
                    
                    // Remove skeleton class after content is loaded
                    document.getElementById('home-view').classList.remove('skeleton');
                }, 300); // Minimum 300ms delay to show skeleton
            }
            
            // Featured Branch Cover Section Functions
            async function loadFeaturedBranch() {
                try {
                    const container = document.getElementById('branch-cover-container');
                    const logoContainer = document.getElementById('featured-branch-logo-container');
                    
                    if (!container || !logoContainer) return;
                    
                    // Get the current branch if in menu view, otherwise get the first branch
                    let featuredBranch = null;
                    
                    if (state.currentView === 'menu' && state.currentBranch) {
                        // Use the current branch for menu view
                        featuredBranch = state.currentBranch;
                    } else if (state.branches && state.branches.length > 0) {
                        // Try to find a branch with both cover photo and logo
                        featuredBranch = state.branches.find(branch => 
                            branch.cover_photo_url && branch.logo_url
                        ) || state.branches[0];
                    }
                    
                    if (!featuredBranch) {
                        // If no branches loaded, try to fetch them
                        const response = await apiService.getBranches();
                        const branches = response.data || response;
                        state.branches = branches;
                        
                        if (branches && branches.length > 0) {
                            if (state.currentView === 'menu' && state.currentBranch) {
                                featuredBranch = branches.find(b => b.branch_id === state.currentBranch.branch_id) || branches[0];
                            } else {
                                featuredBranch = branches.find(branch => 
                                    branch.cover_photo_url && branch.logo_url
                                ) || branches[0];
                            }
                        }
                    }
                    
                    if (featuredBranch) {
                        await displayFeaturedBranch(featuredBranch);
                    } else {
                        // Show fallback content if no branches available
                        showFallbackFeaturedBranch();
                    }
                    
                } catch (error) {
                    console.error('Failed to load featured branch:', error);
                    showFallbackFeaturedBranch();
                }
            }
            
            async function displayFeaturedBranch(branch) {
                const container = document.getElementById('branch-cover-container');
                const coverImage = document.getElementById('featured-branch-cover');
                const logoContainer = document.getElementById('featured-branch-logo-container');
                const logoImg = document.getElementById('featured-branch-logo-img');
                const branchName = document.getElementById('featured-branch-name');
                const branchDescription = document.getElementById('featured-branch-description');
                
                if (!container || !coverImage || !logoContainer || !logoImg || !branchName || !branchDescription) {
                    return;
                }
                
                // Remove skeleton classes
                container.classList.remove('skeleton');
                logoContainer.classList.remove('skeleton');
                
                // Set cover image with fallback
                const coverUrl = branch.cover_photo_url || 'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1470&q=80';
                coverImage.style.backgroundImage = `url('${coverUrl}')`;
                
                // Set logo with fallback
                const logoUrl = branch.logo_url || 'https://ui-avatars.com/api/?name=Luna+Dine&background=06C167&color=fff&size=80';
                logoImg.src = logoUrl;
                logoImg.alt = `${branch.internal_name || 'Luna Dine'} Logo`;
                
                // Handle logo loading errors
                logoImg.onerror = () => {
                    logoImg.src = 'https://ui-avatars.com/api/?name=Luna+Dine&background=06C167&color=fff&size=80';
                };
                
                // Set branch name
                const displayName = branch.name_translation_key ? 
                    translate(branch.name_translation_key) : 
                    branch.internal_name || 'Luna Dine';
                branchName.innerHTML = displayName;
                
                // Set branch description
                const description = branch.address ? 
                    `Located at ${branch.address}. Discover our signature dishes and exceptional service.` :
                    'Discover our signature dishes and exceptional service.';
                branchDescription.innerHTML = description;
                
                // Add click interaction to view branch details
                container.style.cursor = 'pointer';
                container.addEventListener('click', () => {
                    if (branch.branch_id) {
                        // Navigate to menu with this branch
                        state.currentBranch = branch;
                        navigateToView('menu');
                        updateBranchNameDisplays();
                    }
                });
            }
            
            function showFallbackFeaturedBranch() {
                const container = document.getElementById('branch-cover-container');
                const coverImage = document.getElementById('featured-branch-cover');
                const logoContainer = document.getElementById('featured-branch-logo-container');
                const logoImg = document.getElementById('featured-branch-logo-img');
                const branchName = document.getElementById('featured-branch-name');
                const branchDescription = document.getElementById('featured-branch-description');
                
                if (!container || !coverImage || !logoContainer || !logoImg || !branchName || !branchDescription) {
                    return;
                }
                
                // Remove skeleton classes
                container.classList.remove('skeleton');
                logoContainer.classList.remove('skeleton');
                
                // Set fallback cover image
                coverImage.style.backgroundImage = `url('https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1470&q=80')`;
                
                // Set fallback logo
                logoImg.src = 'https://ui-avatars.com/api/?name=Luna+Dine&background=06C167&color=fff&size=80';
                logoImg.alt = 'Luna Dine Logo';
                
                // Set fallback content
                branchName.innerHTML = 'Luna Dine';
                branchDescription.innerHTML = 'Experience culinary excellence under the moonlight. Discover our signature dishes and exceptional service.';
            }
            
            async function renderBranches() {
                elements.branchesContainer.innerHTML = '';
                
                for (const branch of state.branches) {
                    // Use branch logo instead of banners
                    const logoUrl = branch.logo_url || branch.cover_photo_url || '/images/branch-default.jpg';
                    
                    // Generate branch status
                    const branchStatus = getBranchStatus(branch);
                    const statusClass = `status-${branchStatus.status}`;
                    
                    // Generate random stats for demo (in real app, these would come from API)
                    const popularDishes = Math.floor(Math.random() * 8) + 3; // 3-10 dishes
                    const avgRating = (Math.random() * 1.5 + 3.5).toFixed(1); // 3.5-5.0
                    const deliveryTime = Math.floor(Math.random() * 20) + 15; // 15-35 min
                    const distance = (Math.random() * 5 + 0.5).toFixed(1); // 0.5-5.5 km
                    
                    const branchCard = document.createElement('div');
                    branchCard.className = 'branch-card';
                    
                    // Create image container
                    const imageContainer = securityUtils.createElement('div', '', 'branch-image-container');
                    const branchImage = performanceUtils.createLazyImage(
                        logoUrl, 
                        branch.internal_name || 'Branch', 
                        'branch-image'
                    );
                    const statusBadge = securityUtils.createElement('div', branchStatus.label, 
                        `branch-status-badge ${statusClass}`);
                    
                    imageContainer.appendChild(branchImage);
                    imageContainer.appendChild(statusBadge);
                    
                    // Create content container
                    const contentContainer = securityUtils.createElement('div', '', 'branch-content');
                    
                    // Create header
                    const headerContainer = securityUtils.createElement('div', '', 'branch-header');
                    const branchName = securityUtils.createElement('h3', 
                        getTranslation(branch.internal_name, branch.name_translation_key), 'branch-name');
                    
                    const ratingContainer = securityUtils.createElement('div', '', 'branch-rating');
                    const starIcon = securityUtils.createElement('i', '', 'fas fa-star');
                    const ratingSpan = securityUtils.createElement('span', avgRating);
                    
                    ratingContainer.appendChild(starIcon);
                    ratingContainer.appendChild(ratingSpan);
                    headerContainer.appendChild(branchName);
                    headerContainer.appendChild(ratingContainer);
                    
                    // Create address
                    const addressP = securityUtils.createElement('p', branch.address || '', 'branch-address');
                    
                    // Create stats container
                    const statsContainer = securityUtils.createElement('div', '', 'branch-stats');
                    
                    // Time stat
                    const timeStat = securityUtils.createElement('div', '', 'branch-stat');
                    const clockIcon = securityUtils.createElement('i', '', 'fas fa-clock');
                    const timeSpan = securityUtils.createElement('span', 
                        branchStatus.displayTime || `${deliveryTime} min`);
                    timeStat.appendChild(clockIcon);
                    timeStat.appendChild(timeSpan);
                    
                    // Delivery stat
                    const deliveryStat = securityUtils.createElement('div', '', 'branch-stat');
                    const truckIcon = securityUtils.createElement('i', '', 'fas fa-motorcycle');
                    const deliverySpan = securityUtils.createElement('span', `${deliveryTime} min`);
                    deliveryStat.appendChild(truckIcon);
                    deliveryStat.appendChild(deliverySpan);
                    
                    statsContainer.appendChild(timeStat);
                    statsContainer.appendChild(deliveryStat);
                    
                    // Create button
                    const viewMenuBtn = securityUtils.createElement('button', translate('view_menu'), 'btn', {
                        'data-branch-id': branch.branch_id
                    });
                    
                    // Assemble content container
                    contentContainer.appendChild(headerContainer);
                    contentContainer.appendChild(addressP);
                    contentContainer.appendChild(statsContainer);
                    contentContainer.appendChild(viewMenuBtn);
                    
                    // Assemble branch card
                    branchCard.appendChild(imageContainer);
                    branchCard.appendChild(contentContainer);
                    
                    // Add click event to the button
                    viewMenuBtn.addEventListener('click', () => {
                        window.location.hash = createBranchUrl(branch, 'menu');
                    });
                    
                    elements.branchesContainer.appendChild(branchCard);
                }
            }
            
            // Helper function to determine branch status
            function getBranchStatus(branch) {
                const now = new Date();
                const currentHour = now.getHours();
                const currentDay = now.getDay();
                
                // Mock operating hours (in real app, these would come from branch data)
                const operatingHours = {
                    monday: { open: 8, close: 22 },
                    tuesday: { open: 8, close: 22 },
                    wednesday: { open: 8, close: 22 },
                    thursday: { open: 8, close: 22 },
                    friday: { open: 8, close: 23 },
                    saturday: { open: 9, close: 23 },
                    sunday: { open: 9, close: 21 }
                };
                
                const days = ['sunday', 'monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday'];
                const todayHours = operatingHours[days[currentDay]];
                
                if (!todayHours) {
                    return {
                        status: 'closed',
                        label: 'Closed',
                        description: 'Currently closed. Please check our operating hours.',
                        displayTime: 'Closed Today'
                    };
                }
                
                if (currentHour < todayHours.open) {
                    return {
                        status: 'closed',
                        label: 'Closed',
                        description: `Opens at ${todayHours.open}:00 AM`,
                        displayTime: `Opens at ${todayHours.open}:00`
                    };
                }
                
                if (currentHour >= todayHours.close - 1 && currentHour < todayHours.close) {
                    return {
                        status: 'closing-soon',
                        label: 'Closing Soon',
                        description: `Closing at ${todayHours.close > 12 ? todayHours.close - 12 : todayHours.close}:00 ${todayHours.close > 12 ? 'PM' : 'AM'}`,
                        displayTime: `Closes ${todayHours.close > 12 ? todayHours.close - 12 : todayHours.close}:00 ${todayHours.close > 12 ? 'PM' : 'AM'}`
                    };
                }
                
                if (currentHour >= todayHours.close) {
                    // Check tomorrow's hours for opening time
                    const tomorrowIndex = (currentDay + 1) % 7;
                    const tomorrowHours = operatingHours[days[tomorrowIndex]];
                    
                    if (tomorrowHours) {
                        return {
                            status: 'closed',
                            label: 'Closed',
                            description: 'Currently closed. Please visit us tomorrow.',
                            displayTime: `Opens ${tomorrowHours.open}:00`
                        };
                    } else {
                        return {
                            status: 'closed',
                            label: 'Closed',
                            description: 'Currently closed. Please check our operating hours.',
                            displayTime: 'Closed Tomorrow'
                        };
                    }
                }
                
                // Random busy status for demo (in real app, this would be based on actual data)
                const isBusy = Math.random() > 0.7; // 30% chance of being busy
                
                if (isBusy) {
                    return {
                        status: 'busy',
                        label: 'Busy',
                        description: 'Currently experiencing high order volume. Delivery may take longer.',
                        displayTime: null // Will show delivery time instead
                    };
                }
                
                return {
                    status: 'open',
                    label: 'Open Now',
                    description: 'Currently open and ready to serve you!',
                    displayTime: null // Will show delivery time instead
                };
            }
            
    
            
            // ===== NEW TABBED LAYOUT FUNCTIONS =====
            
            // Debug function to manually trigger rendering
            window.debugRenderMenu = function() {
                console.log('Manual debug render triggered');
                console.log('state.menuData:', state.menuData);
                console.log('state.categories:', state.categories);
                
                if (state.menuData && state.menuData.length > 0) {
                    renderCategoryTabs();
                    renderMenuContentArea('all');
                    setupStickyTabs();
                    console.log('Manual render completed');
                } else {
                    console.error('No menu data available for rendering');
                }
            };
            
            function renderCategoryTabs() {
                console.log('renderCategoryTabs called');
                console.log('state.categories:', state.categories);
                console.log('state.menuData:', state.menuData);
                
                const categoryTabs = document.getElementById('category-tabs');
                if (!categoryTabs) {
                    console.error('category-tabs element not found');
                    return;
                }
                
                categoryTabs.innerHTML = '';
                
                // Add "All Items" tab
                const allTab = createCategoryTab({
                    id: 'all',
                    name: translate('all_items') || 'All Items',
                    icon: 'fas fa-th-large',
                    count: state.menuData ? state.menuData.reduce((total, cat) => total + (cat.items ? cat.items.length : 0), 0) : 0
                }, true);
                categoryTabs.appendChild(allTab);
                
                // Add category tabs
                state.categories.forEach(category => {
                    const categoryData = performanceUtils.findCategoryById(category.id) || (state.menuData ? state.menuData.find(cat => cat.category_id === category.id) : null);
                    const itemCount = categoryData && categoryData.items ? categoryData.items.length : 0;
                    
                    const tab = createCategoryTab({
                        id: category.id,
                        name: category.name,
                        icon: category.icon || 'fas fa-utensils',
                        count: itemCount,
                        isNew: category.is_new || false
                    });
                    categoryTabs.appendChild(tab);
                });
                
                console.log('Category tabs rendered');
                // Setup tab scrolling
                setupTabScrolling();
            }
            
            function createCategoryTab(category, isActive = false) {
                const tab = document.createElement('button');
                tab.className = `category-tab ${isActive ? 'active' : ''} ${category.isNew ? 'new' : ''}`;
                tab.setAttribute('data-category-id', category.id);
                
                // Create tab content safely
                if (category.icon) {
                    const iconEl = securityUtils.createElement('i', '', `${category.icon} category-icon`);
                    tab.appendChild(iconEl);
                }
                
                const textSpan = securityUtils.createElement('span', category.name, 'tab-text');
                tab.appendChild(textSpan);
                
                if (category.count > 0) {
                    const countSpan = securityUtils.createElement('span', category.count.toString(), 'item-count');
                    tab.appendChild(countSpan);
                }
                
                tab.addEventListener('click', () => {
                    selectCategoryTab(category.id);
                });
                
                return tab;
            }
            
            function selectCategoryTab(categoryId) {
                // Update active tab
                const tabs = document.querySelectorAll('.category-tab');
                tabs.forEach(tab => {
                    if (tab.getAttribute('data-category-id') === categoryId) {
                        tab.classList.add('active');
                    } else {
                        tab.classList.remove('active');
                    }
                });
                
                // Filter and render menu content
                renderMenuContentArea(categoryId);
            }
            
            function renderMenuContentArea(categoryId = 'all') {
                console.log('renderMenuContentArea called with categoryId:', categoryId);
                console.log('state.menuData:', state.menuData);
                console.log('state.categories:', state.categories);
                
                const contentArea = document.getElementById('menu-content-area');
                if (!contentArea) {
                    console.error('menu-content-area element not found');
                    return;
                }
                
                // Show skeleton briefly during category switching
                contentArea.innerHTML = '';
                contentArea.style.display = 'block';
                renderMenuContentSkeletons(3);
                
                // Use setTimeout to allow skeleton to render before processing data
                setTimeout(() => {
                    let categoriesToShow = [];
                    
                    if (categoryId === 'all') {
                        categoriesToShow = state.menuData || [];
                        console.log('Showing all categories:', categoriesToShow.length);
                    } else {
                        const categoryData = performanceUtils.findCategoryById(categoryId) || (state.menuData ? state.menuData.find(cat => cat.category_id == categoryId) : null);
                        if (categoryData) {
                            categoriesToShow = [categoryData];
                            console.log('Showing single category:', categoryData.category_name);
                        }
                    }
                    
                    if (categoriesToShow.length === 0) {
                        console.log('No categories to show');
                        contentArea.innerHTML = `
                            <div class="menu-section-empty">
                                <i class="fas fa-utensils"></i>
                                <h3>${translate('no_items_found') || 'No items found'}</h3>
                                <p>${translate('try_different_category') || 'Try selecting a different category'}</p>
                                <button class="btn" onclick="selectCategoryTab('all')">${translate('view_all_items') || 'View All Items'}</button>
                            </div>
                        `;
                        return;
                    }
                    
                    console.log('Rendering', categoriesToShow.length, 'categories');
                    contentArea.innerHTML = ''; // Clear skeletons
                    categoriesToShow.forEach(category => {
                        const section = createMenuSection(category);
                        contentArea.appendChild(section);
                    });
                }, 100); // Small delay to show skeleton transition
            }
            
            function createMenuSection(category) {
                const section = document.createElement('div');
                section.className = 'menu-section';
                section.id = `category-${category.category_id}`;
                
                const itemCount = category.items ? category.items.length : 0;
                const subtitle = itemCount > 0 ? `${itemCount} ${itemCount === 1 ? 'item' : 'items'}` : '';
                
                section.innerHTML = `
                    <div class="menu-section-header">
                        <div>
                            <h3 class="menu-section-title">
                                <i class="fas fa-utensils section-icon"></i>
                                ${getTranslation(category.category_name, category.name_translation_key)}
                            </h3>
                            ${subtitle ? `<p class="menu-section-subtitle">${subtitle}</p>` : ''}
                        </div>
                    </div>
                    <div class="menu-section-items" id="section-items-${category.category_id}">
                        <!-- Items will be rendered here -->
                    </div>
                `;
                
                // Add items to the section
                const itemsContainer = section.querySelector(`#section-items-${category.category_id}`);
                if (itemsContainer && category.items) {
                    category.items.forEach(item => {
                        const itemCard = createMenuItemCard(item);
                        itemsContainer.appendChild(itemCard);
                    });
                }
                
                return section;
            }
            
            // Update menu cards quantity controllers after rendering
            setTimeout(() => {
                updateMenuCardsQuantityControllers();
            }, 100);
            
            function createMenuItemCard(item) {
                console.log('createMenuItemCard called with item:', {
                    item_name: item.item_name,
                    branch_menu_id: item.branch_menu_id,
                    price: item.price
                });
                
                const isFavorite = state.favorites.some(fav => fav.branch_menu_id === item.branch_menu_id);
                const quantity = getItemQuantityInCart(item.branch_menu_id);
                
                console.log('createMenuItemCard - quantity in cart:', quantity);
                
                const itemCard = document.createElement('div');
                itemCard.className = 'menu-item-card';
                itemCard.setAttribute('data-branch-menu-id', item.branch_menu_id);
                
                // Create image container
                const imageContainer = securityUtils.createElement('div', '', 'menu-item-image-container');
                const itemImage = performanceUtils.createLazyImage(
                    item.image_url || '/images/food-default.jpg',
                    item.item_name || 'Menu Item',
                    'menu-item-image'
                );
                imageContainer.appendChild(itemImage);
                
                if (item.is_featured) {
                    const badge = securityUtils.createElement('span', 'Featured', 'menu-item-badge');
                    imageContainer.appendChild(badge);
                }
                
                // Create content container
                const contentContainer = securityUtils.createElement('div', '', 'menu-item-content');
                
                // Create header
                const headerContainer = securityUtils.createElement('div', '', 'menu-item-header');
                const itemName = securityUtils.createElement('h4', 
                    getTranslation(item.item_name, item.name_translation_key), 'menu-item-name');
                const itemPrice = securityUtils.createElement('div', formatPrice(item.price), 'menu-item-price');
                
                headerContainer.appendChild(itemName);
                headerContainer.appendChild(itemPrice);
                
                // Create description
                const itemDesc = securityUtils.createElement('p', 
                    getTranslation(item.item_description, item.description_translation_key) || translate('delicious_menu_item'), 
                    'menu-item-desc');
                
                // Create footer
                const footerContainer = securityUtils.createElement('div', '', 'menu-item-footer');
                const prepTimeContainer = securityUtils.createElement('div', '', 'prep-time-with-favorite');
                
                const prepTimeSpan = securityUtils.createElement('span', '', 'prep-time');
                const clockIcon = securityUtils.createElement('i', '', 'fas fa-clock');
                const timeText = document.createTextNode(` ${item.preparation_time_minutes || 15} ${translate('mins')}`);
                prepTimeSpan.appendChild(clockIcon);
                prepTimeSpan.appendChild(timeText);
                
                const favoriteBtn = securityUtils.createElement('button', '', 
                    `btn-favorite ${isFavorite ? 'active' : ''}`, {
                    'data-item-id': item.branch_menu_id
                });
                const heartIcon = securityUtils.createElement('i', '', 'fas fa-heart');
                favoriteBtn.appendChild(heartIcon);
                
                prepTimeContainer.appendChild(prepTimeSpan);
                prepTimeContainer.appendChild(favoriteBtn);
                footerContainer.appendChild(prepTimeContainer);
                
                // Assemble content container
                contentContainer.appendChild(headerContainer);
                contentContainer.appendChild(itemDesc);
                contentContainer.appendChild(footerContainer);
                
                // Assemble item card
                itemCard.appendChild(imageContainer);
                itemCard.appendChild(contentContainer);
                
                // Add quantity controller using existing HTML function
                const quantityControllerHTML = createQuantityControllerHTML(item, quantity);
                if (quantityControllerHTML) {
                    const tempDiv = document.createElement('div');
                    tempDiv.innerHTML = quantityControllerHTML;
                    const quantityController = tempDiv.firstElementChild;
                    if (quantityController) {
                        itemCard.appendChild(quantityController);
                    }
                }
                
                console.log('createMenuItemCard - quantity controller HTML:', createQuantityControllerHTML(item, quantity));
                
                // Add click event to show item detail modal (but not when clicking on quantity controller)
                itemCard.addEventListener('click', (e) => {
                    console.log('Menu item card clicked:', item.item_name);
                    console.log('Event target:', e.target);
                    console.log('Closest quantity controller:', e.target.closest('.menu-item-quantity-controller'));
                    console.log('Closest favorite button:', e.target.closest('.btn-favorite'));
                    
                    // Don't open modal if clicking on quantity controller or favorite button
                    if (e.target.closest('.menu-item-quantity-controller') || e.target.closest('.btn-favorite')) {
                        console.log('Click prevented due to quantity controller or favorite button');
                        return;
                    }
                    console.log('Calling showItemDetailModal for:', item.item_name);
                    showItemDetailModal(item);
                });
                
                // Add favorite toggle event
                favoriteBtn.addEventListener('click', (e) => {
                    e.stopPropagation();
                    toggleFavorite(item);
                    favoriteBtn.classList.toggle('active');
                });
                
                // Setup quantity controller events
                setupQuantityControllerEvents(itemCard, item);
                
                return itemCard;
            }
            
            // Event listener management to prevent memory leaks
            const eventListenerManager = {
                listeners: new Map(),
                
                add(element, event, handler, options = {}) {
                    if (!element) return;
                    
                    const key = `${element.constructor.name}_${event}_${handler.name || 'anonymous'}`;
                    
                    // Remove existing listener if any
                    this.remove(element, event, key);
                    
                    // Add new listener
                    element.addEventListener(event, handler, options);
                    
                    // Store reference for cleanup
                    this.listeners.set(key, { element, event, handler, options });
                },
                
                remove(element, event, key) {
                    if (this.listeners.has(key)) {
                        const { element: storedElement, event: storedEvent, handler } = this.listeners.get(key);
                        if (storedElement === element && storedEvent === event) {
                            element.removeEventListener(event, handler);
                            this.listeners.delete(key);
                        }
                    }
                },
                
                cleanup() {
                    for (const [key, { element, event, handler }] of this.listeners) {
                        if (element && element.removeEventListener) {
                            element.removeEventListener(event, handler);
                        }
                    }
                    this.listeners.clear();
                }
            };
            
            function setupStickyTabs() {
                const tabsContainer = document.getElementById('category-tabs-container');
                if (!tabsContainer) return;
                
                const header = document.querySelector('.header');
                const headerHeight = header ? header.offsetHeight : 64;
                
                // Clean up existing scroll listener
                const existingHandler = window.stickyTabsHandler;
                if (existingHandler) {
                    window.removeEventListener('scroll', existingHandler);
                }
                
                const handleScroll = () => {
                    const scrollPosition = window.pageYOffset;
                    
                    if (scrollPosition > headerHeight) {
                        tabsContainer.classList.add('sticky');
                        tabsContainer.style.top = `${headerHeight}px`;
                    } else {
                        tabsContainer.classList.remove('sticky');
                        tabsContainer.style.top = '80px';
                    }
                };
                
                // Store reference for cleanup
                window.stickyTabsHandler = handleScroll;
                window.addEventListener('scroll', handleScroll);
                handleScroll(); // Initial call
            }
            
            function setupTabScrolling() {
                const tabsContainer = document.getElementById('category-tabs');
                const tabsWrapper = document.querySelector('.category-tabs-wrapper');
                
                if (!tabsContainer || !tabsWrapper) return;
                
                // Clean up existing listeners if they exist
                if (tabsContainer.hasTabScrolling) return;
                tabsContainer.hasTabScrolling = true;
                
                const updateScrollIndicators = () => {
                    const isAtStart = tabsContainer.scrollLeft <= 0;
                    const isAtEnd = tabsContainer.scrollLeft >= tabsContainer.scrollWidth - tabsContainer.clientWidth - 1; // -1 for rounding
                    
                    // Add/remove classes to show/hide scroll indicators
                    tabsWrapper.classList.toggle('no-scroll-left', isAtStart);
                    tabsWrapper.classList.toggle('no-scroll-right', isAtEnd);
                    
                    // Add scroll hint animation if there's more content to scroll
                    const canScroll = !isAtStart || !isAtEnd;
                    tabsContainer.classList.toggle('scroll-hint', canScroll);
                };
                
                // Add touch/mouse wheel support for better UX
                let isDown = false;
                let startX;
                let scrollLeft;
                
                // Mouse events for desktop
                const mouseDownHandler = (e) => {
                    isDown = true;
                    startX = e.pageX - tabsContainer.offsetLeft;
                    scrollLeft = tabsContainer.scrollLeft;
                    tabsContainer.style.cursor = 'grabbing';
                    tabsContainer.classList.remove('scroll-hint');
                };
                
                const mouseLeaveHandler = () => {
                    isDown = false;
                    tabsContainer.style.cursor = 'grab';
                };
                
                const mouseUpHandler = () => {
                    isDown = false;
                    tabsContainer.style.cursor = 'grab';
                    updateScrollIndicators();
                };
                
                const mouseMoveHandler = (e) => {
                    if (!isDown) return;
                    e.preventDefault();
                    const x = e.pageX - tabsContainer.offsetLeft;
                    const walk = (x - startX) * 2; // Scroll speed
                    tabsContainer.scrollLeft = scrollLeft - walk;
                };
                
                tabsContainer.addEventListener('mousedown', mouseDownHandler);
                tabsContainer.addEventListener('mouseleave', mouseLeaveHandler);
                tabsContainer.addEventListener('mouseup', mouseUpHandler);
                tabsContainer.addEventListener('mousemove', mouseMoveHandler);
                
                // Touch events for mobile
                let touchStartX = 0;
                let touchScrollLeft = 0;
                
                const touchStartHandler = (e) => {
                    touchStartX = e.touches[0].clientX;
                    touchScrollLeft = tabsContainer.scrollLeft;
                    tabsContainer.classList.remove('scroll-hint');
                };
                
                const touchMoveHandler = (e) => {
                    const touchX = e.touches[0].clientX;
                    const walk = (touchStartX - touchX) * 2; // Scroll speed
                    tabsContainer.scrollLeft = touchScrollLeft + walk;
                };
                
                tabsContainer.addEventListener('touchstart', touchStartHandler, { passive: true });
                tabsContainer.addEventListener('touchmove', touchMoveHandler, { passive: true });
                tabsContainer.addEventListener('touchend', updateScrollIndicators, { passive: true });
                
                // Wheel event for desktop scrolling
                const wheelHandler = (e) => {
                    e.preventDefault();
                    tabsContainer.scrollLeft += e.deltaY * 0.5; // Adjust scroll speed
                    updateScrollIndicators();
                };
                
                tabsContainer.addEventListener('wheel', wheelHandler, { passive: false });
                
                // Keyboard navigation
                const keydownHandler = (e) => {
                    if (!['ArrowLeft', 'ArrowRight'].includes(e.key)) return;
                    
                    e.preventDefault();
                    const scrollAmount = 150;
                    
                    if (e.key === 'ArrowLeft') {
                        tabsContainer.scrollLeft -= scrollAmount;
                    } else {
                        tabsContainer.scrollLeft += scrollAmount;
                    }
                    
                    updateScrollIndicators();
                };
                
                tabsContainer.addEventListener('keydown', keydownHandler);
                
                // Make tabs container focusable for keyboard navigation
                tabsContainer.setAttribute('tabindex', '0');
                tabsContainer.setAttribute('role', 'tablist');
                
                // Update indicators on scroll and resize
                tabsContainer.addEventListener('scroll', updateScrollIndicators);
                
                // Clean up existing resize listener
                if (window.tabsResizeHandler) {
                    window.removeEventListener('resize', window.tabsResizeHandler);
                }
                window.tabsResizeHandler = updateScrollIndicators;
                window.addEventListener('resize', updateScrollIndicators);
                
                // Initial call
                updateScrollIndicators();
                
                // Set initial cursor style
                tabsContainer.style.cursor = 'grab';
            }
            
            // Update the existing renderCategories function to only render tabs
            function renderCategories() {
                console.log('renderCategories called');
                console.log('state.categories:', state.categories);
                
                // Skip rendering original sidebar categories since we removed the sidebar
                // Only render new category tabs
                renderCategoryTabs();
            }
            
            // Update the existing renderMenuItems function to also render content area
            function renderMenuItems() {
                console.log('renderMenuItems called');
                console.log('state.menuData:', state.menuData);
                
                // Render original menu items (for fallback)
                elements.menuItemsContainer.innerHTML = '';
                
                state.menuData.forEach(category => {
                    const categorySection = document.createElement('div');
                    categorySection.id = `category-${category.category_id}`;
                    categorySection.innerHTML = `
                        <h3>${getTranslation('Category', category.category_name)}</h3>
                    `;
                    
                    const itemsGrid = document.createElement('div');
                    itemsGrid.className = 'menu-items-grid';
                    
                    category.items.forEach(item => {
                        const isFavorite = state.favorites.some(fav => fav.branch_menu_id === item.branch_menu_id);
                        const quantity = getItemQuantityInCart(item.branch_menu_id);
                        
                        const itemCard = document.createElement('div');
                        itemCard.className = 'menu-item-card';
                        itemCard.setAttribute('data-branch-menu-id', item.branch_menu_id);
                        itemCard.innerHTML = `
                            <div class="menu-item-image-container">
                                <img src="${item.image_url || '/images/food-default.jpg'}" alt="${item.item_name}" class="menu-item-image">
                                ${item.is_featured ? '<span class="menu-item-badge">Featured</span>' : ''}
                            </div>
                            <div class="menu-item-content">
                                <div class="menu-item-header">
                                    <h4 class="menu-item-name">${getTranslation(item.item_name, item.name_translation_key)}</h4>
                                    <div class="menu-item-price">${formatPrice(item.price)}</div>
                                </div>
                                <p class="menu-item-desc">${getTranslation(item.item_description, item.description_translation_key) || translate('delicious_menu_item')}</p>
                                <div class="menu-item-footer">
                                    <div class="prep-time-with-favorite">
                                        <span class="prep-time"><i class="fas fa-clock"></i> ${item.preparation_time_minutes || 15} ${translate('mins')}</span>
                                        <button class="btn-favorite ${isFavorite ? 'active' : ''}" data-item-id="${item.branch_menu_id}">
                                            <i class="fas fa-heart"></i>
                                        </button>
                                    </div>
                                </div>
                            </div>
                            ${createQuantityControllerHTML(item, quantity)}
                        `;
                        
                        // Add click event to show item detail modal (but not when clicking on quantity controller)
                        itemCard.addEventListener('click', (e) => {
                            console.log('Menu item card clicked (renderMenuContentArea):', item.item_name);
                            console.log('Event target:', e.target);
                            console.log('Closest quantity controller:', e.target.closest('.menu-item-quantity-controller'));
                            console.log('Closest favorite button:', e.target.closest('.btn-favorite'));
                            
                            // Don't open modal if clicking on quantity controller or favorite button
                            if (e.target.closest('.menu-item-quantity-controller') || e.target.closest('.btn-favorite')) {
                                console.log('Click prevented due to quantity controller or favorite button');
                                return;
                            }
                            console.log('Calling showItemDetailModal for:', item.item_name);
                            showItemDetailModal(item);
                        });
                        
                        // Add favorite toggle event
                        const favoriteBtn = itemCard.querySelector('.btn-favorite');
                        favoriteBtn.addEventListener('click', (e) => {
                            e.stopPropagation();
                            toggleFavorite(item);
                            favoriteBtn.classList.toggle('active');
                        });
                        
                        // Setup quantity controller events
                        setupQuantityControllerEvents(itemCard, item);
                        
                        itemsGrid.appendChild(itemCard);
                    });
                    
                    categorySection.appendChild(itemsGrid);
                    elements.menuItemsContainer.appendChild(categorySection);
                });
                
                // Render new content area
                setTimeout(() => {
                    renderMenuContentArea('all');
                }, 100);
                
                // Setup sticky tabs
                setTimeout(() => {
                    setupStickyTabs();
                }, 200);
            }
            
            function renderPromotions() {
                console.log('renderPromotions called');
                console.log('state.promotions:', state.promotions);
                
                if (!state.promotions || state.promotions.length === 0) {
                    if (elements.compactPromotions) {
                        elements.compactPromotions.innerHTML = `
                            <div class="compact-promotions-empty">
                                <i class="fas fa-tag"></i>
                                <p>No special offers available at the moment</p>
                            </div>
                        `;
                    }
                    if (elements.promotionsContainer) {
                        elements.promotionsContainer.style.display = 'none';
                    }
                    return;
                }
                
                // Render compact promotions
                if (elements.compactPromotions) {
                    elements.compactPromotions.innerHTML = `
                        <div class="compact-promotions-slider" id="compact-promotions-slider">
                            <!-- Promotions will be dynamically loaded here -->
                        </div>
                        <button class="compact-promotions-nav prev hidden" id="compact-promotions-prev">
                            <i class="fas fa-chevron-left"></i>
                        </button>
                        <button class="compact-promotions-nav next hidden" id="compact-promotions-next">
                            <i class="fas fa-chevron-right"></i>
                        </button>
                    `;
                    
                    const slider = document.getElementById('compact-promotions-slider');
                    if (slider) {
                        state.promotions.forEach(promo => {
                            const promoCard = createCompactPromotionCard(promo);
                            slider.appendChild(promoCard);
                        });
                    }
                    
                    // Setup navigation buttons
                    setupCompactPromotionsNavigation();
                }
                
                // Keep original promotions container for fallback (hidden)
                if (elements.promotionsContainer) {
                    elements.promotionsContainer.style.display = 'none';
                }
            }
            
            function createCompactPromotionCard(promo) {
                const card = document.createElement('div');
                card.className = 'compact-promotion-card';
                
                const isValid = new Date(promo.end_date) > new Date();
                const validityText = isValid ? 'Valid until ' + new Date(promo.end_date).toLocaleDateString() : 'Expired';
                const validityIcon = isValid ? 'fas fa-clock' : 'fas fa-times-circle';
                
                const promoTitle = getTranslation('Special Offer', promo.description_translation_key);
                const promoDescription = promo.type === 'PERCENTAGE' 
                    ? `${promo.value}% off` 
                    : `${formatPrice(promo.value)} off`;
                
                card.innerHTML = `
                    <div class="compact-promotion-header">
                        <div class="compact-promotion-title">
                            <i class="fas fa-tag promo-icon"></i>
                            ${promoTitle}
                        </div>
                        ${isValid ? '<span class="compact-promotion-badge">Active</span>' : '<span class="compact-promotion-badge">Expired</span>'}
                    </div>
                    <div class="compact-promotion-description">
                        ${promoDescription}${promo.min_order_value ? ` • Min: ${formatPrice(promo.min_order_value)}` : ''}
                    </div>
                    <div class="compact-promotion-footer">
                        <div class="compact-promotion-code">${promo.code || 'PROMO'}</div>
                        <div class="compact-promotion-validity">
                            <i class="${validityIcon} validity-icon"></i>
                            ${isValid ? new Date(promo.end_date).toLocaleDateString() : 'Expired'}
                        </div>
                    </div>
                `;
                
                card.addEventListener('click', () => {
                    // Copy promo code to clipboard
                    const promoCode = promo.code || 'PROMO';
                    navigator.clipboard.writeText(promoCode).then(() => {
                        showToast(`Promo code "${promoCode}" copied to clipboard!`);
                    }).catch(() => {
                        showToast(`Promo code: ${promoCode}`);
                    });
                });
                
                return card;
            }
            
            function setupCompactPromotionsNavigation() {
                const slider = document.getElementById('compact-promotions-slider');
                const prevBtn = document.getElementById('compact-promotions-prev');
                const nextBtn = document.getElementById('compact-promotions-next');
                
                if (!slider || !prevBtn || !nextBtn) return;
                
                const updateNavButtons = () => {
                    const isAtStart = slider.scrollLeft <= 0;
                    const isAtEnd = slider.scrollLeft >= slider.scrollWidth - slider.clientWidth;
                    
                    prevBtn.classList.toggle('hidden', isAtStart);
                    nextBtn.classList.toggle('hidden', isAtEnd);
                };
                
                prevBtn.addEventListener('click', () => {
                    slider.scrollBy({
                        left: -300,
                        behavior: 'smooth'
                    });
                });
                
                nextBtn.addEventListener('click', () => {
                    slider.scrollBy({
                        left: 300,
                        behavior: 'smooth'
                    });
                });
                
                slider.addEventListener('scroll', updateNavButtons);
                window.addEventListener('resize', updateNavButtons);
                
                updateNavButtons(); // Initial call
            }
            
            function renderCart() {
                // Show skeleton view immediately
                renderCartSkeleton();
                
                // Update cart page title with branch name
                updateBranchNameDisplays();
                
                // Update current cart to ensure we're showing the right branch's cart
                updateCurrentCart();
                
                // Small delay to ensure skeleton is visible
                setTimeout(() => {
                    // Clear the skeleton content before rendering actual content
                    elements.cartContainer.innerHTML = '';
                    
                    if (state.cart.length === 0) {
                        const browseMenuUrl = state.currentBranch ? 
                            createBranchUrl(state.currentBranch, 'menu') : 
                            '#menu';
                        
                        elements.cartContainer.innerHTML = `
                            <div class="empty-cart">
                                <i class="fas fa-shopping-cart"></i>
                                <h3>${translate('empty_cart')}</h3>
                                <p>${translate('add_some_delicious_items')}</p>
                                <a href="${browseMenuUrl}" class="btn">${translate('browse_menu')}</a>
                            </div>
                        `;
                    } else {
                        const cartItems = document.createElement('div');
                        cartItems.className = 'cart-items';
                        
                        let subtotal = 0;
                        
                        state.cart.forEach((item, index) => {
                            const itemTotal = item.price * item.quantity;
                            subtotal += itemTotal;
                            
                            const cartItem = document.createElement('div');
                            cartItem.className = 'cart-item';
                            cartItem.setAttribute('data-branch-menu-id', item.branch_menu_id);
                            cartItem.setAttribute('data-cart-index', index);
                    
                    const customizationText = formatCustomizations(item.customizations);
                    const hasCustomizations = customizationText && customizationText.trim() !== '';
                    
                    // Create cart item image
                    const itemImage = performanceUtils.createLazyImage(
                        item.image_url || '/images/food-default.jpg',
                        item.name || 'Cart Item',
                        'cart-item-image'
                    );
                    
                    // Create item details
                    const detailsContainer = securityUtils.createElement('div', '', 'cart-item-details');
                    const itemName = securityUtils.createElement('h4', 
                        getTranslation(item.name, item.name_translation_key), 'cart-item-name');
                    detailsContainer.appendChild(itemName);
                    
                    if (hasCustomizations) {
                        const customizationsP = securityUtils.createElement('p', 
                            customizationText, 'cart-item-customizations');
                        detailsContainer.appendChild(customizationsP);
                    }
                    
                    // Create item actions
                    const actionsContainer = securityUtils.createElement('div', '', 'cart-item-actions');
                    
                    // Quantity control
                    const quantityControl = securityUtils.createElement('div', '', 'quantity-control');
                    const decreaseBtn = securityUtils.createElement('button', '-', 'quantity-btn', {
                        'data-action': 'decrease',
                        'data-index': index.toString()
                    });
                    const quantityInput = securityUtils.createElement('input', '', 'quantity-input', {
                        type: 'text',
                        value: item.quantity.toString(),
                        readonly: 'readonly'
                    });
                    const increaseBtn = securityUtils.createElement('button', '+', 'quantity-btn', {
                        'data-action': 'increase',
                        'data-index': index.toString()
                    });
                    
                    quantityControl.appendChild(decreaseBtn);
                    quantityControl.appendChild(quantityInput);
                    quantityControl.appendChild(increaseBtn);
                    
                    // Remove button
                    const removeBtn = securityUtils.createElement('button', '', 'btn-remove', {
                        'data-index': index.toString()
                    });
                    const trashIcon = securityUtils.createElement('i', '', 'fas fa-trash');
                    removeBtn.appendChild(trashIcon);
                    
                    actionsContainer.appendChild(quantityControl);
                    actionsContainer.appendChild(removeBtn);
                    
                    // Create price section
                    const priceSectionContainer = securityUtils.createElement('div', '', 'cart-item-price-section');
                    
                    if (hasCustomizations) {
                        const priceBreakdownContainer = securityUtils.createElement('div', '', 'cart-item-price-breakdown');
                        const priceBreakdown = securityUtils.createElement('div', formatDetailedPrice(item), 'price-breakdown');
                        priceBreakdownContainer.appendChild(priceBreakdown);
                        priceSectionContainer.appendChild(priceBreakdownContainer);
                    }
                    
                    const priceTotalContainer = securityUtils.createElement('div', '', 'cart-item-price-total');
                    const priceTotal = securityUtils.createElement('div', 
                        `${formatPrice(item.price)} × ${item.quantity} = ${formatPrice(itemTotal)}`, 'price-total');
                    priceTotalContainer.appendChild(priceTotal);
                    priceSectionContainer.appendChild(priceTotalContainer);
                    
                    // Assemble cart item
                    cartItem.appendChild(itemImage);
                    cartItem.appendChild(detailsContainer);
                    cartItem.appendChild(actionsContainer);
                    cartItem.appendChild(priceSectionContainer);
                    
                    cartItems.appendChild(cartItem);
                });
                
                elements.cartContainer.appendChild(cartItems);
                
                // Calculate totals using branch settings
                const settings = state.currentBranch?.settings || {};
                const serviceChargePercentage = parseFloat(settings.service_charge_percentage) || 0;
                const vatPercentage = parseFloat(settings.vat_percentage) || 0;
                
                const serviceCharge = subtotal * (serviceChargePercentage / 100);
                const tax = (subtotal + serviceCharge) * (vatPercentage / 100);
                
                // Calculate discount if promo is applied
                const discountAmount = state.appliedPromo ? calculateDiscountAmount(subtotal, state.appliedPromo) : 0;
                const total = subtotal + serviceCharge + tax - discountAmount;
                
                // Add promo code section before cart summary
                const promoSection = document.createElement('div');
                promoSection.className = 'promo-code-section';
                promoSection.innerHTML = `
                    <h4>${translate('promo_code')}</h4>
                    <div id="promo-code-container">
                        <div class="promo-code-input-group">
                            <input type="text" class="promo-code-input" id="promo-code-input" placeholder="${translate('promo_code')}" maxlength="20">
                            <button class="apply-promo-btn" id="apply-promo-btn">${translate('apply_promo')}</button>
                        </div>
                        <div id="promo-status"></div>
                    </div>
                `;
                
                elements.cartContainer.appendChild(promoSection);
                
                const cartSummary = document.createElement('div');
                cartSummary.className = 'cart-summary';
                cartSummary.innerHTML = `
                    <div class="summary-row">
                        <span>${translate('subtotal')}:</span>
                        <span>${formatPrice(subtotal)}</span>
                    </div>
                    ${serviceCharge > 0 ? `
                    <div class="summary-row">
                        <span>${translate('service_charge')} (${serviceChargePercentage}%):</span>
                        <span>${formatPrice(serviceCharge)}</span>
                    </div>
                    ` : ''}
                    ${tax > 0 ? `
                    <div class="summary-row">
                        <span>${translate('tax')} (${vatPercentage}%):</span>
                        <span>${formatPrice(tax)}</span>
                    </div>
                    ` : ''}
                    ${state.appliedPromo ? `
                    <div class="summary-row discount-row">
                        <span>${translate('discount')} (${state.appliedPromo.code}):</span>
                        <span>-${formatPrice(discountAmount)}</span>
                    </div>
                    ` : ''}
                    <div class="summary-row summary-total">
                        <span>${translate('total')}:</span>
                        <span>${formatPrice(total)}</span>
                    </div>
                    <button class="btn" id="checkout-btn">${translate('proceed_to_checkout')}</button>
                `;
                
                elements.cartContainer.appendChild(cartSummary);
                
                // Attach event listeners using our robust function
                attachCartEventListeners();
                
                // Add promo code functionality
                setTimeout(() => {
                    setupPromoCodeFunctionality();
                }, 100);
                    }
                    
                    // Remove skeleton class after content is loaded
                    document.getElementById('cart-view').classList.remove('skeleton');
                    
                    // Final check to ensure all event listeners are properly attached
                    setTimeout(() => {
                        attachCartEventListeners();
                    }, 100);
                }, 300); // Minimum 300ms delay to show skeleton
            }
            
            async function renderCheckout() {
                // Show skeleton view immediately
                renderCheckoutSkeleton();
                
                // Update checkout page title with branch name
                updateBranchNameDisplays();
                
                // Small delay to ensure skeleton is visible
                setTimeout(async () => {
                    elements.checkoutForm.innerHTML = `
                        <div class="order-type-selector">
                            <div class="order-type-btn active" data-type="dine-in">
                                <div class="order-type-icon">
                                    <i class="fas fa-utensils"></i>
                                </div>
                                <div>${translate('dine_in')}</div>
                            </div>
                            <div class="order-type-btn" data-type="takeaway">
                                <div class="order-type-icon">
                                    <i class="fas fa-box"></i>
                                </div>
                                <div>${translate('takeaway')}</div>
                            </div>
                            <div class="order-type-btn" data-type="delivery">
                                <div class="order-type-icon">
                                    <i class="fas fa-motorcycle"></i>
                                </div>
                                <div>${translate('delivery')}</div>
                            </div>
                        </div>
                        
                        <div id="checkout-details">
                            <!-- Dynamic content based on order type -->
                        </div>
                    `;
                    
                    // Set up order type selection
                    document.querySelectorAll('.order-type-btn').forEach(btn => {
                        btn.addEventListener('click', () => {
                            document.querySelectorAll('.order-type-btn').forEach(b => b.classList.remove('active'));
                            btn.classList.add('active');
                            renderCheckoutDetails(btn.getAttribute('data-type'));
                            // Refresh order summary to update delivery charge
                            setTimeout(() => {
                                renderCheckoutOrderSummary();
                            }, 100);
                        });
                    });
                    
                    // Render initial checkout details
                    await renderCheckoutDetails('dine-in');
                    
                    // Remove skeleton class after content is loaded
                    document.getElementById('checkout-view').classList.remove('skeleton');
                }, 300); // Minimum 300ms delay to show skeleton
            }
            
            async function renderCheckoutDetails(orderType) {
                const detailsContainer = document.getElementById('checkout-details');
                
                if (!state.currentBranch) {
                    detailsContainer.innerHTML = `
                        <div class="error-message">
                            <p>${translate('please_select_branch')}</p>
                        </div>
                    `;
                    return;
                }
                
                switch(orderType) {
                    case 'dine-in':
                        // Load branch tables
                        const tables = await loadBranchTables(state.currentBranch.branch_id);
                        const tableOptions = tables.map(table => 
                            `<option value="${table.table_id}">${translate('table')} ${table.table_identifier}</option>`
                        ).join('');
                        
                        detailsContainer.innerHTML = `
                            <h3>${translate('dine_in')} ${translate('details')}</h3>
                            <div class="form-group">
                                <label class="form-label">${translate('table_number')}</label>
                                <select class="form-select" id="table-number">
                                    <option value="">${translate('select_table')}</option>
                                    ${tableOptions}
                                </select>
                            </div>
                            <div class="form-group">
                                <label class="form-label">${translate('guests_count')}</label>
                                <input type="number" class="form-input" id="guests-count" min="1" value="1">
                            </div>
                        `;
                        break;
                        
                    case 'takeaway':
                        detailsContainer.innerHTML = `
                            <h3>${translate('takeaway')} ${translate('details')}</h3>
                            <div class="form-group">
                                <label class="form-label">${translate('pickup_time')}</label>
                                <input type="time" class="form-input" id="pickup-time-input">
                                <input type="hidden" id="pickup-time" name="pickup-time">
                                <div class="pickup-time-display" id="pickup-time-display"></div>
                            </div>
                            <div class="form-group">
                                <label class="form-label">${translate('your_name')}</label>
                                <input type="text" class="form-input" id="customer-name" value="${state.userInfo?.name || ''}">
                            </div>
                            <div class="form-group">
                                <label class="form-label">${translate('phone_number')}</label>
                                <input type="tel" class="form-input" id="customer-phone" value="${state.userInfo?.phone || ''}">
                            </div>
                        `;
                        break;
                        
                    case 'delivery':
                        detailsContainer.innerHTML = `
                            <h3>${translate('delivery')} ${translate('details')}</h3>
                            <div class="form-group">
                                <label class="form-label">${translate('delivery_address')}</label>
                                <textarea class="form-textarea" id="delivery-address">${state.userInfo?.address || ''}</textarea>
                            </div>
                            <div class="form-group">
                                <label class="form-label">${translate('your_name')}</label>
                                <input type="text" class="form-input" id="customer-name" value="${state.userInfo?.name || ''}">
                            </div>
                            <div class="form-group">
                                <label class="form-label">${translate('phone_number')}</label>
                                <input type="tel" class="form-input" id="customer-phone" value="${state.userInfo?.phone || ''}">
                            </div>
                        `;
                        break;
                }
                
                // Add customer info fields common to all order types
                const paymentSection = document.createElement('div');
                paymentSection.innerHTML = `
                    <h3>${translate('payment')} ${translate('information')}</h3>
                    
                    <div class="form-group">
                        <label class="form-label">${translate('payment_method')}</label>
                        <select class="form-select" id="payment-method">
                            <option value="cash">${translate('cash')}</option>
                            <option value="card">${translate('card')}</option>
                            <option value="mobile">${translate('mobile_payment')}</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label class="form-label">${translate('special_instructions')}</label>
                        <textarea class="form-textarea" id="special-instructions" placeholder="${translate('any_requests')}"></textarea>
                    </div>
                `;
                detailsContainer.appendChild(paymentSection);
                
                // Setup pickup time functionality if it's takeaway order
                if (orderType === 'takeaway') {
                    setTimeout(() => {
                        setupPickupTime();
                    }, 100);
                }
                
                // Add promo code functionality
                setTimeout(() => {
                    setupPromoCodeFunctionality();
                }, 100);
                
                // Render order summary
                renderCheckoutOrderSummary();
            }
            
            function setupPromoCodeFunctionality() {
                console.log('setupPromoCodeFunctionality called');
                
                const promoInput = document.getElementById('promo-code-input');
                const applyBtn = document.getElementById('apply-promo-btn');
                const promoStatus = document.getElementById('promo-status');
                
                console.log('Elements found in setup:', {
                    promoInput: !!promoInput,
                    applyBtn: !!applyBtn,
                    promoStatus: !!promoStatus
                });
                
                if (!promoInput || !applyBtn || !promoStatus) {
                    console.error('Required elements not found in setup');
                    return;
                }
                
                // Update promo code section based on current state
                updatePromoCodeSection();
                
                // Add event listener for apply button
                applyBtn.addEventListener('click', applyPromoCode);
                console.log('Event listener added to apply button');
                
                // Add event listener for Enter key on input
                promoInput.addEventListener('keypress', (e) => {
                    if (e.key === 'Enter') {
                        console.log('Enter key pressed, applying promo code');
                        applyPromoCode();
                    }
                });
                console.log('Event listener added to promo input');
            }
            
            function updatePromoCodeSection() {
                const promoContainer = document.getElementById('promo-code-container');
                const promoStatus = document.getElementById('promo-status');
                
                if (!promoContainer || !promoStatus) return;
                
                if (state.appliedPromo) {
                    // Show applied promo info
                    promoContainer.innerHTML = `
                        <div class="applied-promo-info">
                            <span>
                                <strong>${translate('promo_code')}:</strong> 
                                <span class="applied-promo-code">${state.appliedPromo.code}</span>
                                (${state.appliedPromo.type === 'PERCENTAGE' ? state.appliedPromo.value + '%' : formatPrice(state.appliedPromo.value)})
                            </span>
                            <button class="remove-promo-btn" id="remove-promo-btn">${translate('remove')}</button>
                        </div>
                    `;
                    promoStatus.innerHTML = `<div class="promo-code-status success">${translate('promo_applied')}</div>`;
                    
                    // Add event listener to remove button
                    const removeBtn = document.getElementById('remove-promo-btn');
                    if (removeBtn) {
                        removeBtn.addEventListener('click', removePromoCode);
                    }
                } else {
                    // Show input form
                    promoContainer.innerHTML = `
                        <div class="promo-code-input-group">
                            <input type="text" class="promo-code-input" id="promo-code-input" placeholder="${translate('promo_code')}" maxlength="20">
                            <button class="apply-promo-btn" id="apply-promo-btn">${translate('apply_promo')}</button>
                        </div>
                    `;
                    promoStatus.innerHTML = '';
                    
                    // Re-attach event listeners
                    const newPromoInput = document.getElementById('promo-code-input');
                    const newApplyBtn = document.getElementById('apply-promo-btn');
                    
                    if (newPromoInput && newApplyBtn) {
                        newApplyBtn.addEventListener('click', applyPromoCode);
                        newPromoInput.addEventListener('keypress', (e) => {
                            if (e.key === 'Enter') {
                                applyPromoCode();
                            }
                        });
                    }
                }
            }
            
            async function applyPromoCode() {
                console.log('applyPromoCode function called');
                
                const promoInput = document.getElementById('promo-code-input');
                const applyBtn = document.getElementById('apply-promo-btn');
                const promoStatus = document.getElementById('promo-status');
                
                console.log('Elements found:', {
                    promoInput: !!promoInput,
                    applyBtn: !!applyBtn,
                    promoStatus: !!promoStatus
                });
                
                if (!promoInput || !applyBtn) {
                    console.error('Required elements not found');
                    return;
                }
                
                const promoCodeInput = promoInput.value.trim();
                const validation = securityUtils.validateInput.promoCode(promoCodeInput);
                
                if (!validation.isValid) {
                    console.log('Invalid promo code:', validation.error);
                    const errorMsg = translate('promo_invalid');
                    if (promoStatus) showPromoStatus('error', errorMsg);
                    showError(validation.error);
                    return;
                }
                
                const promoCode = validation.value;
                console.log('Validated promo code:', promoCode);
                
                // Disable button during processing
                applyBtn.disabled = true;
                applyBtn.textContent = '...';
                
                try {
                    console.log('Starting promo code validation...');
                    
                    // Get promotions for current branch
                    if (!state.currentBranch) {
                        console.log('No current branch selected');
                        const errorMsg = translate('please_select_branch');
                        if (promoStatus) showPromoStatus('error', errorMsg);
                        showError(errorMsg);
                        return;
                    }
                    
                    console.log('Current branch:', state.currentBranch);
                    console.log('Fetching promotions for branch:', state.currentBranch.branch_id);
                    
                    const promotions = await apiService.getPromotions(state.currentBranch.branch_id);
                    const promoList = promotions.data || promotions;
                    
                    console.log('Promotions received:', promoList);
                    
                    // Find the promo code
                    const promo = promoList.find(p => 
                        p.code === promoCode && 
                        p.is_active && 
                        (!p.start_date || new Date(p.start_date) <= new Date()) &&
                        (!p.end_date || new Date(p.end_date) >= new Date()) &&
                        (!p.usage_limit || p.usage_count < p.usage_limit)
                    );
                    
                    console.log('Found promo:', promo);
                    
                    if (!promo) {
                        console.log('Promo not found or invalid');
                        
                        // Check specific reasons for failure
                        const inactivePromo = promoList.find(p => p.code === promoCode && !p.is_active);
                        if (inactivePromo) {
                            const errorMsg = translate('promo_invalid');
                            if (promoStatus) showPromoStatus('error', errorMsg);
                            showError(errorMsg);
                            return;
                        }
                        
                        const expiredPromo = promoList.find(p => p.code === promoCode && p.end_date && new Date(p.end_date) < new Date());
                        if (expiredPromo) {
                            const errorMsg = translate('promo_expired');
                            if (promoStatus) showPromoStatus('error', errorMsg);
                            showError(errorMsg);
                            return;
                        }
                        
                        const notStartedPromo = promoList.find(p => p.code === promoCode && p.start_date && new Date(p.start_date) > new Date());
                        if (notStartedPromo) {
                            const errorMsg = translate('promo_not_active');
                            if (promoStatus) showPromoStatus('error', errorMsg);
                            showError(errorMsg);
                            return;
                        }
                        
                        const usageLimitExceeded = promoList.find(p => p.code === promoCode && p.usage_limit && p.usage_count >= p.usage_limit);
                        if (usageLimitExceeded) {
                            const errorMsg = translate('promo_usage_limit');
                            if (promoStatus) showPromoStatus('error', errorMsg);
                            showError(errorMsg);
                            return;
                        }
                        
                        // If none of the specific reasons match, it's an invalid code
                        const errorMsg = translate('promo_invalid');
                        if (promoStatus) showPromoStatus('error', errorMsg);
                        showError(errorMsg);
                        return;
                    }
                    
                    // Check minimum order value
                    const cartSubtotal = calculateCartSubtotal();
                    console.log('Cart subtotal:', cartSubtotal, 'Min order value:', promo.min_order_value);
                    
                    if (promo.min_order_value && cartSubtotal < promo.min_order_value) {
                        console.log('Minimum order value not met');
                        const errorMsg = `${translate('min_order_not_met')} (${formatPrice(promo.min_order_value)})`;
                        if (promoStatus) showPromoStatus('error', errorMsg);
                        showError(errorMsg);
                        return;
                    }
                    
                    // Calculate discount
                    let discountAmount = 0;
                    if (promo.type === 'PERCENTAGE') {
                        discountAmount = (cartSubtotal * promo.value) / 100;
                        if (promo.max_discount_amount && discountAmount > promo.max_discount_amount) {
                            discountAmount = promo.max_discount_amount;
                            console.log('Discount amount limited by max discount:', discountAmount);
                        }
                    } else if (promo.type === 'FIXED_AMOUNT') {
                        discountAmount = promo.value;
                    }
                    
                    console.log('Discount calculated:', discountAmount);
                    
                    // Apply the promo
                    state.appliedPromo = {
                        code: promo.code,
                        type: promo.type,
                        value: promo.value,
                        discount_amount: discountAmount,
                        promo_id: promo.promo_id
                    };
                    
                    console.log('Promo applied:', state.appliedPromo);
                    
                    const successMsg = translate('promo_applied');
                    if (promoStatus) showPromoStatus('success', successMsg);
                    updatePromoCodeSection();
                    
                    // Update order summary if it exists
                    updateOrderSummary();
                    
                    // Also update cart summary if we're on cart page
                    if (state.currentView === 'cart') {
                        updateCartSummaryUI();
                    }
                    
                    // Show success toast as fallback
                    showToast(`Promo code "${promoCode}" applied successfully!`);
                    
                } catch (error) {
                    console.error('Error applying promo code:', error);
                    const errorMsg = translate('promo_invalid');
                    if (promoStatus) showPromoStatus('error', errorMsg);
                    showError(errorMsg);
                } finally {
                    // Re-enable button
                    applyBtn.disabled = false;
                    applyBtn.textContent = translate('apply_promo');
                }
            }
            
            function removePromoCode() {
                state.appliedPromo = null;
                updatePromoCodeSection();
                updateOrderSummary();
                // Also update cart summary if we're on cart page
                if (state.currentView === 'cart') {
                    updateCartSummaryUI();
                }
            }
            
            function showPromoStatus(type, message) {
                const promoStatus = document.getElementById('promo-status');
                if (!promoStatus) return;
                
                promoStatus.innerHTML = `<div class="promo-code-status ${type}">${message}</div>`;
            }
            
            function calculateCartSubtotal() {
                return state.cart.reduce((total, item) => total + (item.price * item.quantity), 0);
            }
            
            function calculateDiscountAmount(subtotal, promo) {
                let discountAmount = 0;
                if (promo.type === 'PERCENTAGE') {
                    discountAmount = (subtotal * promo.value) / 100;
                    if (promo.max_discount_amount && discountAmount > promo.max_discount_amount) {
                        discountAmount = promo.max_discount_amount;
                    }
                } else if (promo.type === 'FIXED_AMOUNT') {
                    discountAmount = promo.value;
                }
                return discountAmount;
            }
            
            function calculateDeliveryCharge(deliveryConfig, subtotal) {
                if (!deliveryConfig) return 0;
                
                // Parse config if it's a string
                const config = typeof deliveryConfig === 'string' ? JSON.parse(deliveryConfig) : deliveryConfig;
                
                // Check for minimum order free delivery
                if (config.minimum_order_free && subtotal >= config.minimum_order_free) {
                    return 0; // Free delivery for orders above minimum
                }
                
                // Calculate based on fee type
                switch (config.type) {
                    case 'fixed':
                        return config.amount || 0;
                    
                    case 'percentage':
                        if (config.percentage_based && config.percentage_based.rate) {
                            return Math.round((subtotal * config.percentage_based.rate) / 100);
                        }
                        return 0;
                    
                    case 'distance':
                        // For distance-based, return base amount (distance calculation would require geolocation)
                        if (config.distance_based && config.distance_based.base_amount) {
                            return config.distance_based.base_amount;
                        }
                        return config.amount || 0;
                    
                    default:
                        return config.amount || 50; // Default fallback
                }
            }
            
            function updateOrderSummary() {
                // This function will be called to update the order summary with discount
                // The order summary is rendered in the placeOrder function, so we just need
                // to ensure it reflects the current state including promo discount
                if (state.currentView === 'checkout') {
                    // Re-render checkout details to update order summary
                    const activeOrderType = document.querySelector('.order-type-btn.active');
                    if (activeOrderType) {
                        renderCheckoutDetails(activeOrderType.getAttribute('data-type'));
                    }
                    // Also update the checkout order summary
                    renderCheckoutOrderSummary();
                }
            }
            
            function renderCheckoutOrderSummary() {
                const orderSummaryContainer = document.getElementById('checkout-order-summary');
                if (!orderSummaryContainer) return;
                
                if (state.cart.length === 0) {
                    orderSummaryContainer.innerHTML = '';
                    return;
                }
                
                // Calculate order totals
                const subtotal = calculateCartSubtotal();
                const serviceChargePercentage = parseFloat(state.currentBranch?.settings?.service_charge_percentage) || 0;
                const vatPercentage = parseFloat(state.currentBranch?.settings?.vat_percentage) || 0;
                
                const serviceCharge = subtotal * (serviceChargePercentage / 100);
                const taxableAmount = subtotal + serviceCharge;
                const vat = taxableAmount * (vatPercentage / 100);
                
                // Calculate discount
                let discountAmount = 0;
                if (state.appliedPromo) {
                    discountAmount = state.appliedPromo.discount_amount;
                }
                
                // Calculate delivery charge if order type is delivery
                let deliveryCharge = 0;
                const activeOrderType = document.querySelector('.order-type-btn.active');
                if (activeOrderType && activeOrderType.getAttribute('data-type') === 'delivery') {
                    const deliveryFeeConfig = state.currentBranch?.settings?.delivery_fee_config;
                    if (deliveryFeeConfig) {
                        try {
                            deliveryCharge = calculateDeliveryCharge(deliveryFeeConfig, subtotal);
                        } catch (e) {
                            console.error('Error calculating delivery charge:', e);
                            deliveryCharge = 0;
                        }
                    } else {
                        deliveryCharge = 50; // Default delivery charge
                    }
                }
                
                // Calculate final total
                const total = subtotal + serviceCharge + vat + deliveryCharge - discountAmount;
                
                orderSummaryContainer.innerHTML = `
                    <h3>${translate('order_summary')}</h3>
                    <div class="summary-row">
                        <span>${translate('subtotal')}:</span>
                        <span>${formatPrice(subtotal)}</span>
                    </div>
                    ${serviceCharge > 0 ? `
                    <div class="summary-row">
                        <span>${translate('service_charge')}${serviceChargePercentage > 0 ? ` (${serviceChargePercentage}%)` : ''}:</span>
                        <span>${formatPrice(serviceCharge)}</span>
                    </div>
                    ` : ''}
                    ${vat > 0 ? `
                    <div class="summary-row">
                        <span>${translate('tax')}${vatPercentage > 0 ? ` (${vatPercentage}%)` : ''}:</span>
                        <span>${formatPrice(vat)}</span>
                    </div>
                    ` : ''}
                    ${deliveryCharge > 0 ? `
                    <div class="summary-row">
                        <span>${translate('delivery_charge')}:</span>
                        <span>${formatPrice(deliveryCharge)}</span>
                    </div>
                    ` : ''}
                    ${state.appliedPromo ? `
                    <div class="summary-row discount-row">
                        <span>${translate('discount')} (${state.appliedPromo.code}):</span>
                        <span>-${formatPrice(discountAmount)}</span>
                    </div>
                    ` : ''}
                    <div class="summary-row summary-total">
                        <span>${translate('total')}:</span>
                        <span>${formatPrice(total)}</span>
                    </div>
                    <div class="checkout-actions">
                        <button class="btn" id="place-order-btn">${translate('place_order')}</button>
                    </div>
                `;
                
                // Set up place order button event listener
                const placeOrderBtn = document.getElementById('place-order-btn');
                if (placeOrderBtn) {
                    placeOrderBtn.addEventListener('click', placeOrder);
                }
            }
            
            // Helper functions to get charge percentages from order data
            function getServiceChargePercentage(orderData) {
                // Try to get from applied_rates_snapshot first
                if (orderData.applied_rates_snapshot) {
                    try {
                        const rates = typeof orderData.applied_rates_snapshot === 'string' 
                            ? JSON.parse(orderData.applied_rates_snapshot) 
                            : orderData.applied_rates_snapshot;
                        if (rates.service_charge_percentage) {
                            return ` (${rates.service_charge_percentage}%)`;
                        }
                    } catch (e) {
                        console.warn('Failed to parse applied_rates_snapshot:', e);
                    }
                }
                
                // Fall back to current branch settings
                if (state.currentBranch?.settings?.service_charge_percentage) {
                    return ` (${state.currentBranch.settings.service_charge_percentage}%)`;
                }
                
                // Try to calculate from amount if available
                if (orderData.service_charge_amount && orderData.items_subtotal && orderData.items_subtotal > 0) {
                    const calculatedPercentage = (orderData.service_charge_amount / orderData.items_subtotal) * 100;
                    if (calculatedPercentage > 0) {
                        return ` (${calculatedPercentage.toFixed(2)}%)`;
                    }
                }
                
                return '';
            }

            function getVatPercentage(orderData) {
                // Try to get from applied_rates_snapshot first
                if (orderData.applied_rates_snapshot) {
                    try {
                        const rates = typeof orderData.applied_rates_snapshot === 'string' 
                            ? JSON.parse(orderData.applied_rates_snapshot) 
                            : orderData.applied_rates_snapshot;
                        if (rates.vat_percentage) {
                            return ` (${rates.vat_percentage}%)`;
                        }
                    } catch (e) {
                        console.warn('Failed to parse applied_rates_snapshot:', e);
                    }
                }
                
                // Fall back to current branch settings
                if (state.currentBranch?.settings?.vat_percentage) {
                    return ` (${state.currentBranch.settings.vat_percentage}%)`;
                }
                
                // Try to calculate from amount if available
                if (orderData.vat_amount && orderData.items_subtotal && orderData.service_charge_amount !== undefined) {
                    const taxableAmount = orderData.items_subtotal + (orderData.service_charge_amount || 0);
                    if (taxableAmount > 0) {
                        const calculatedPercentage = (orderData.vat_amount / taxableAmount) * 100;
                        if (calculatedPercentage > 0) {
                            return ` (${calculatedPercentage.toFixed(2)}%)`;
                        }
                    }
                }
                
                return '';
            }

            function renderOrderTracking(order) {
                // Show skeleton view immediately
                renderOrderTrackingSkeleton();
                
                // Small delay to ensure skeleton is visible
                setTimeout(() => {
                    if (!order || !order.data) {
                        elements.orderTrackingContainer.innerHTML = `
                            <div class="empty-state">
                                <i class="fas fa-receipt"></i>
                                <h3>${translate('order_not_found')}</h3>
                                <p>${translate('order_not_found_message')}</p>
                                <a href="#orders" class="btn">${translate('view_order_history')}</a>
                            </div>
                        `;
                        // Remove skeleton class after content is loaded
                        document.getElementById('order-tracking-view').classList.remove('skeleton');
                        return;
                    }

                    const orderData = order.data;
                    const orderType = orderData.order_type;
                    
                    // Add order type specific class to container
                    elements.orderTrackingContainer.className = `order-tracking-type-${orderType}`;
                    
                    // Check if order is cancelled
                    const isCancelled = orderData.status === 'cancelled';
                    
                    if (isCancelled) {
                        // Show cancelled state instead of normal tracking
                        elements.orderTrackingContainer.innerHTML = `
                            <!-- Order Type Header -->
                            <div class="order-type-header">
                                <div class="ot-order-type-icon">
                                    <i class="fas ${getOrderTypeIcon(orderType)}"></i>
                                </div>
                                <div class="order-type-info">
                                    <h3>${translate('order')} #${orderData.order_uid}</h3>
                                    <p>${translate(orderType)} • <span class="status-badge cancelled">${translate('cancelled')}</span></p>
                                </div>
                            </div>
                            
                            <!-- Cancelled State -->
                            <div class="order-cancelled-state">
                                <div class="cancel-animation">
                                    <i class="fas fa-times-circle"></i>
                                </div>
                                <div class="cancel-message">
                                    <h3>${translate('order_cancelled')}</h3>
                                    <p>${orderData.cancel_reason || translate('order_cancelled_success')}</p>
                                </div>
                                <div class="cancel-actions">
                                    <a href="#orders" class="btn btn-primary">${translate('view_order_history')}</a>
                                    <button class="btn btn-secondary" onclick="window.location.reload()">${translate('back_to_menu')}</button>
                                </div>
                            </div>
                            
                            <!-- Order Items -->
                            <div class="order-details">
                                <h4>${translate('order_items')}</h4>
                                <div class="order-items-list">
                                    ${orderData.items && orderData.items.length > 0 ? orderData.items.map(item => {
                                        const customizationText = formatCustomizations(item.customizations);
                                        const hasCustomizations = customizationText && customizationText.trim() !== '';
                                        
                                        return `
                                            <div class="order-item-card">
                                                <div class="order-item-image">
                                                    <img src="${item.image_url || '/images/food-default.jpg'}" alt="${getTranslation(item.name, item.name_translation_key)}">
                                                </div>
                                                <div class="order-item-content">
                                                    <div class="order-item-header">
                                                        <h5 class="order-item-name">${getTranslation(item.name, item.name_translation_key)}</h5>
                                                        <div class="order-item-quantity">
                                                            <span class="quantity-badge">×${item.quantity}</span>
                                                        </div>
                                                    </div>
                                                    ${hasCustomizations ? `
                                                    <div class="order-item-customizations">
                                                        <i class="fas fa-cog"></i>
                                                        <span>${customizationText}</span>
                                                    </div>
                                                    ` : ''}
                                                    <div class="order-item-footer">
                                                        <div class="order-item-price">
                                                            ${formatPrice(item.price_at_order)} × ${item.quantity} = ${formatPrice(item.item_total)}
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        `;
                                    }).join('') : '<p class="no-items">No items found</p>'}
                                </div>
                                
                                <!-- Order Summary -->
                                <div class="order-summary">
                                    <div class="summary-row">
                                        <span>${translate('subtotal')}:</span>
                                        <span>${formatPrice(orderData.items_subtotal)}</span>
                                    </div>
                                    ${orderData.promo_id && orderData.discount_amount > 0 ? `
                                    <div class="summary-row discount-row">
                                        <span>${translate('discount')} ${orderData.promo_code ? `(${orderData.promo_code})` : ''}:</span>
                                        <span>-${formatPrice(orderData.discount_amount)}</span>
                                    </div>
                                    ` : ''}
                                    ${orderData.service_charge_amount ? `
                                    <div class="summary-row">
                                        <span>${translate('service_charge')}${getServiceChargePercentage(orderData)}:</span>
                                        <span>${formatPrice(orderData.service_charge_amount)}</span>
                                    </div>
                                    ` : ''}
                                    ${orderData.vat_amount ? `
                                    <div class="summary-row">
                                        <span>${translate('tax')}${getVatPercentage(orderData)}:</span>
                                        <span>${formatPrice(orderData.vat_amount)}</span>
                                    </div>
                                    ` : ''}
                                    ${orderData.delivery_charge_amount ? `
                                    <div class="summary-row">
                                        <span>${translate('delivery_charge')}:</span>
                                        <span>${formatPrice(orderData.delivery_charge_amount)}</span>
                                    </div>
                                    ` : ''}
                                    <div class="summary-row total">
                                        <span>${translate('total')}:</span>
                                        <span>${formatPrice(orderData.total_amount)}</span>
                                    </div>
                                </div>
                            </div>
                        `;
                        
                        // Remove skeleton class after content is loaded
                        document.getElementById('order-tracking-view').classList.remove('skeleton');
                        return;
                    }
                    
                    // Get order type specific status steps
                    const statusSteps = getOrderTypeStatusSteps(orderType);
                    const currentStepIndex = statusSteps.indexOf(orderData.status);
                    
                    // Get order type specific icon
                    const orderTypeIcon = getOrderTypeIcon(orderType);
                    
                    // Calculate ETA based on order type and status
                    const etaInfo = calculateOrderETA(orderData);
                    
                    elements.orderTrackingContainer.innerHTML = `
                        <!-- Order Type Header -->
                        <div class="order-type-header">
                            <div class="ot-order-type-icon">
                                <i class="fas ${orderTypeIcon}"></i>
                            </div>
                            <div class="order-type-info">
                                <h3>${translate('order')} #${orderData.order_uid}</h3>
                                <p>${translate(orderType)} • ${translate(orderData.status)}</p>
                            </div>
                        </div>
                        
                        <!-- ETA Display -->
                        ${etaInfo.show ? `
                        <div class="eta-display">
                            <div class="eta-label">${etaInfo.label}</div>
                            <div class="eta-time">${etaInfo.time}</div>
                        </div>
                        ` : ''}
                        
                        <!-- Enhanced Order Type Specific Status Flow -->
                        <div class="status-progress-custom status-flow-${orderType}" style="--completed-steps: ${currentStepIndex >= 0 ? currentStepIndex + 1 : 0}; --total-steps: ${statusSteps.length};">
                            ${statusSteps.map((step, index) => `
                                <div class="status-step-custom ${index <= currentStepIndex ? 'completed' : ''} ${index === currentStepIndex ? 'active' : ''}">
                                    <div class="step-icon">
                                        ${index <= currentStepIndex ? 
                                            `<i class="fas ${getStatusStepIcon(step, orderType)}"></i>` : 
                                            `<i class="fas ${getStatusStepIcon(step, orderType)}" style="color: var(--uber-gray-400);"></i>`
                                        }
                                    </div>
                                    <div class="step-label">${translate(step)}</div>
                                </div>
                            `).join('')}
                        </div>
                        
                        <!-- Order Type Specific Information Cards -->
                        <div class="order-type-info-cards">
                            ${getOrderTypeSpecificInfoCards(orderData, orderType)}
                        </div>
                        
                        <!-- Order Items -->
                        <div class="order-details">
                            <h4>${translate('order_items')}</h4>
                            <div class="order-items-list">
                                ${orderData.items && orderData.items.length > 0 ? orderData.items.map(item => {
                                    const customizationText = formatCustomizations(item.customizations);
                                    const hasCustomizations = customizationText && customizationText.trim() !== '';
                                    
                                    return `
                                        <div class="order-item-card">
                                            <div class="order-item-image">
                                                <img src="${item.image_url || '/images/food-default.jpg'}" alt="${getTranslation(item.name, item.name_translation_key)}">
                                            </div>
                                            <div class="order-item-content">
                                                <div class="order-item-header">
                                                    <h5 class="order-item-name">${getTranslation(item.name, item.name_translation_key)}</h5>
                                                    <div class="order-item-quantity">
                                                        <span class="quantity-badge">×${item.quantity}</span>
                                                    </div>
                                                </div>
                                                ${hasCustomizations ? `
                                                <div class="order-item-customizations">
                                                    <i class="fas fa-cog"></i>
                                                    <span>${customizationText}</span>
                                                </div>
                                                ` : ''}
                                                <div class="order-item-footer">
                                                    <div class="order-item-price">
                                                        ${formatPrice(item.price_at_order)} × ${item.quantity} = ${formatPrice(item.item_total)}
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    `;
                                }).join('') : '<p class="no-items">No items found</p>'}
                            </div>
                            
                            <!-- Order Summary -->
                            <div class="order-summary">
                                <div class="summary-row">
                                    <span>${translate('subtotal')}:</span>
                                    <span>${formatPrice(orderData.items_subtotal)}</span>
                                </div>
                                ${orderData.promo_id && orderData.discount_amount > 0 ? `
                                <div class="summary-row discount-row">
                                    <span>${translate('discount')} ${orderData.promo_code ? `(${orderData.promo_code})` : ''}:</span>
                                    <span>-${formatPrice(orderData.discount_amount)}</span>
                                </div>
                                ` : ''}
                                ${orderData.service_charge_amount ? `
                                <div class="summary-row">
                                    <span>${translate('service_charge')}${getServiceChargePercentage(orderData)}:</span>
                                    <span>${formatPrice(orderData.service_charge_amount)}</span>
                                </div>
                                ` : ''}
                                ${orderData.vat_amount ? `
                                <div class="summary-row">
                                    <span>${translate('tax')}${getVatPercentage(orderData)}:</span>
                                    <span>${formatPrice(orderData.vat_amount)}</span>
                                </div>
                                ` : ''}
                                ${orderData.delivery_charge_amount ? `
                                <div class="summary-row">
                                    <span>${translate('delivery_charge')}:</span>
                                    <span>${formatPrice(orderData.delivery_charge_amount)}</span>
                                </div>
                                ` : ''}
                                <div class="summary-row summary-total">
                                    <span>${translate('total')}:</span>
                                    <span>${formatPrice(orderData.final_amount)}</span>
                                </div>
                            </div>
                        </div>
                        
                        <!-- Order Type Specific Actions -->
                        <div class="order-type-actions">
                            ${getOrderTypeSpecificActions(orderData, orderType)}
                        </div>
                    `;
                    
                    // Add cancel order event listener if order is pending
                    if (orderData.status === 'pending') {
                        const cancelBtn = document.getElementById('cancel-order-btn');
                        if (cancelBtn) {
                            cancelBtn.addEventListener('click', () => {
                                cancelOrder(orderData.order_uid);
                            });
                        }
                    }
                    
                    // Add order type specific action event listeners
                    addOrderTypeActionListeners(orderData, orderType);
                    
                    // Remove skeleton class after content is loaded
                    document.getElementById('order-tracking-view').classList.remove('skeleton');
                    
                    // Setup mobile bounce marquee for status flow
                    setTimeout(() => {
                        setupMobileStatusMarquee();
                    }, 500); // Small delay to ensure DOM is fully rendered
                }, 300);
            }
            
            // Helper function to get order type specific status steps
            function getOrderTypeStatusSteps(orderType) {
                switch(orderType) {
                    case 'dine-in':
                        return ['pending', 'confirmed', 'preparing', 'ready', 'served', 'completed'];
                    case 'takeaway':
                        return ['pending', 'confirmed', 'preparing', 'ready', 'picked_up', 'completed'];
                    case 'delivery':
                        return ['pending', 'confirmed', 'preparing', 'ready', 'out_for_delivery', 'delivered', 'completed'];
                    default:
                        return ['pending', 'confirmed', 'preparing', 'ready', 'completed'];
                }
            }
            
            // Helper function to get order type specific icon
            function getOrderTypeIcon(orderType) {
                switch(orderType) {
                    case 'dine-in':
                        return 'fa-utensils';
                    case 'takeaway':
                        return 'fa-shopping-bag';
                    case 'delivery':
                        return 'fa-motorcycle';
                    default:
                        return 'fa-receipt';
                }
            }
            
            // Helper function to get Font Awesome icon for status steps
            function getStatusStepIcon(status, orderType) {
                const iconMap = {
                    'pending': 'fa-clock',
                    'confirmed': 'fa-check-circle',
                    'preparing': 'fa-fire',
                    'ready': 'fa-bell',
                    'served': 'fa-utensils',
                    'picked_up': 'fa-shopping-bag',
                    'out_for_delivery': 'fa-motorcycle',
                    'delivered': 'fa-home',
                    'completed': 'fa-check-double'
                };
                
                return iconMap[status] || 'fa-circle';
            }
            
            // Helper function to setup mobile bounce marquee for status flow
            function setupMobileStatusMarquee() {
                const statusProgressElements = document.querySelectorAll('.status-progress-custom');
                
                statusProgressElements.forEach(element => {
                    // Remove any potential blurry overlays
                    removeBlurryOverlays(element);
                    
                    // Check if element is scrollable
                    const isScrollable = element.scrollWidth > element.clientWidth;
                    
                    if (isScrollable && window.innerWidth <= 480) {
                        // Add bounce animation class
                        element.classList.add('bouncing');
                        
                        // Pause animation on user interaction
                        let isPaused = false;
                        
                        element.addEventListener('touchstart', () => {
                            if (!isPaused) {
                                element.style.animationPlayState = 'paused';
                                isPaused = true;
                            }
                        });
                        
                        element.addEventListener('touchend', () => {
                            setTimeout(() => {
                                if (isPaused) {
                                    element.style.animationPlayState = 'running';
                                    isPaused = false;
                                }
                            }, 3000); // Resume after 3 seconds of inactivity
                        });
                        
                        element.addEventListener('mouseenter', () => {
                            element.style.animationPlayState = 'paused';
                        });
                        
                        element.addEventListener('mouseleave', () => {
                            setTimeout(() => {
                                element.style.animationPlayState = 'running';
                            }, 2000);
                        });
                        
                        // Add touch feedback for better mobile experience
                        element.addEventListener('touchmove', () => {
                            element.classList.remove('bouncing');
                        });
                        
                        // Restart bouncing after scrolling stops
                        let touchTimeout;
                        element.addEventListener('touchend', () => {
                            clearTimeout(touchTimeout);
                            touchTimeout = setTimeout(() => {
                                if (window.innerWidth <= 480 && element.scrollWidth > element.clientWidth) {
                                    element.classList.add('bouncing');
                                }
                            }, 2000);
                        });
                        
                    } else {
                        // Remove bounce animation if not scrollable or not mobile
                        element.classList.remove('bouncing');
                    }
                });
            }
            
            // Helper function to remove blurry overlays from status progress
            function removeBlurryOverlays(element) {
                // Remove any overlay pseudo-elements by overriding styles
                const style = document.createElement('style');
                style.textContent = `
                    .status-progress-custom::before,
                    .status-progress-custom::after {
                        display: none !important;
                        content: none !important;
                    }
                    .status-progress-custom .status-step-custom::before,
                    .status-progress-custom .status-step-custom::after {
                        display: none !important;
                        content: none !important;
                    }
                    .status-progress-custom {
                        background: transparent !important;
                        backdrop-filter: none !important;
                        filter: none !important;
                    }
                    .status-step-custom {
                        background: transparent !important;
                        backdrop-filter: none !important;
                        filter: none !important;
                    }
                `;
                
                // Add style to head if not already present
                if (!document.querySelector('#remove-overlay-styles')) {
                    style.id = 'remove-overlay-styles';
                    document.head.appendChild(style);
                }
                
                // Also remove any inline styles that might cause overlays
                const steps = element.querySelectorAll('.status-step-custom');
                steps.forEach((step, index) => {
                    // Remove any potential overlay styles from first step specifically
                    if (index === 0) {
                        step.style.filter = 'none';
                        step.style.backdropFilter = 'none';
                        step.style.boxShadow = 'none';
                        step.style.background = '';
                        step.style.position = 'relative';
                        step.style.zIndex = '1';
                    }
                });
            }
            
            // Helper function to calculate order ETA based on type and status
            function calculateOrderETA(orderData) {
                const orderType = orderData.order_type;
                const status = orderData.status;
                const createdAt = new Date(orderData.created_at);
                const now = new Date();
                const elapsedMinutes = Math.floor((now - createdAt) / (1000 * 60));
                
                let etaInfo = { show: false, label: '', time: '' };
                
                switch(orderType) {
                    case 'dine-in':
                        if (status === 'confirmed' || status === 'preparing') {
                            const remainingTime = Math.max(5, 20 - elapsedMinutes);
                            etaInfo = {
                                show: true,
                                label: 'Estimated serving time',
                                time: `${remainingTime} mins`
                            };
                        } else if (status === 'ready') {
                            etaInfo = {
                                show: true,
                                label: 'Being served to your table',
                                time: 'Now'
                            };
                        }
                        break;
                        
                    case 'takeaway':
                        if (status === 'confirmed' || status === 'preparing') {
                            const remainingTime = Math.max(5, 15 - elapsedMinutes);
                            etaInfo = {
                                show: true,
                                label: 'Ready for pickup in',
                                time: `${remainingTime} mins`
                            };
                        } else if (status === 'ready') {
                            etaInfo = {
                                show: true,
                                label: 'Ready for pickup at',
                                time: 'Counter 3'
                            };
                        }
                        break;
                        
                    case 'delivery':
                        if (status === 'confirmed' || status === 'preparing') {
                            const remainingTime = Math.max(10, 35 - elapsedMinutes);
                            etaInfo = {
                                show: true,
                                label: 'Estimated delivery time',
                                time: `${remainingTime} mins`
                            };
                        } else if (status === 'out_for_delivery') {
                            const remainingTime = Math.max(5, 15 - elapsedMinutes);
                            etaInfo = {
                                show: true,
                                label: 'Arriving in',
                                time: `${remainingTime} mins`
                            };
                        }
                        break;
                }
                
                return etaInfo;
            }
            
            // Helper function to get order type specific information cards
            function getOrderTypeSpecificInfoCards(orderData, orderType) {
                const branchName = orderData.branch_name_translation_key ? 
                    getTranslation(orderData.branch_name, orderData.branch_name_translation_key) : 
                    orderData.branch_name;
                
                switch(orderType) {
                    case 'dine-in':
                        return `
                            <div class="info-card">
                                <div class="info-card-header">
                                    <div class="info-card-icon">
                                        <i class="fas fa-store"></i>
                                    </div>
                                    <h4 class="info-card-title">Restaurant Information</h4>
                                </div>
                                <div class="info-card-content">
                                    <p><strong>Branch:</strong> ${branchName || 'Main Branch'}</p>
                                    ${orderData.table_identifier ? `<p><strong>Table:</strong> ${orderData.table_identifier}</p>` : ''}
                                    <p><strong>Ordered:</strong> ${new Date(orderData.created_at).toLocaleString()}</p>
                                </div>
                            </div>
                            <div class="info-card">
                                <div class="info-card-header">
                                    <div class="info-card-icon">
                                        <i class="fas fa-utensils"></i>
                                    </div>
                                    <h4 class="info-card-title">Dining Service</h4>
                                </div>
                                <div class="info-card-content">
                                    <p><strong>Service Type:</strong> Dine-in</p>
                                    <p><strong>Status:</strong> ${translate(orderData.status)}</p>
                                    ${orderData.status === 'ready' ? '<p><strong>Note:</strong> Your food is ready and will be served to your table shortly.</p>' : ''}
                                </div>
                            </div>
                        `;
                        
                    case 'takeaway':
                        return `
                            <div class="info-card">
                                <div class="info-card-header">
                                    <div class="info-card-icon">
                                        <i class="fas fa-store"></i>
                                    </div>
                                    <h4 class="info-card-title">Pickup Information</h4>
                                </div>
                                <div class="info-card-content">
                                    <p><strong>Branch:</strong> ${branchName || 'Main Branch'}</p>
                                    <p><strong>Pickup Counter:</strong> Counter 3</p>
                                    <p><strong>Ordered:</strong> ${new Date(orderData.created_at).toLocaleString()}</p>
                                </div>
                            </div>
                            <div class="info-card">
                                <div class="info-card-header">
                                    <div class="info-card-icon">
                                        <i class="fas fa-shopping-bag"></i>
                                    </div>
                                    <h4 class="info-card-title">Pickup Instructions</h4>
                                </div>
                                <div class="info-card-content">
                                    <p><strong>Order Type:</strong> Takeaway</p>
                                    <p><strong>Status:</strong> ${translate(orderData.status)}</p>
                                    ${orderData.status === 'ready' ? '<p><strong>Ready for pickup!</strong> Please proceed to Counter 3 with your order number.</p>' : ''}
                                </div>
                            </div>
                        `;
                        
                    case 'delivery':
                        return `
                            <div class="info-card">
                                <div class="info-card-header">
                                    <div class="info-card-icon">
                                        <i class="fas fa-map-marker-alt"></i>
                                    </div>
                                    <h4 class="info-card-title">Delivery Information</h4>
                                </div>
                                <div class="info-card-content">
                                    <p><strong>Delivering to:</strong> ${orderData.delivery_address || 'Address not provided'}</p>
                                    <p><strong>From:</strong> ${branchName || 'Main Branch'}</p>
                                    <p><strong>Ordered:</strong> ${new Date(orderData.created_at).toLocaleString()}</p>
                                </div>
                            </div>
                            <div class="info-card">
                                <div class="info-card-header">
                                    <div class="info-card-icon">
                                        <i class="fas fa-motorcycle"></i>
                                    </div>
                                    <h4 class="info-card-title">Delivery Service</h4>
                                </div>
                                <div class="info-card-content">
                                    <p><strong>Service Type:</strong> Delivery</p>
                                    <p><strong>Status:</strong> ${translate(orderData.status)}</p>
                                    ${orderData.status === 'out_for_delivery' ? '<p><strong>Note:</strong> Your order is on the way!</p>' : ''}
                                </div>
                            </div>
                        `;
                        
                    default:
                        return `
                            <div class="info-card">
                                <div class="info-card-header">
                                    <div class="info-card-icon">
                                        <i class="fas fa-info-circle"></i>
                                    </div>
                                    <h4 class="info-card-title">Order Information</h4>
                                </div>
                                <div class="info-card-content">
                                    <p><strong>Branch:</strong> ${branchName || 'Main Branch'}</p>
                                    <p><strong>Order Type:</strong> ${translate(orderType)}</p>
                                    <p><strong>Status:</strong> ${translate(orderData.status)}</p>
                                </div>
                            </div>
                        `;
                }
            }
            
            // Helper function to get order type specific actions
            function getOrderTypeSpecificActions(orderData, orderType) {
                let actions = '';
                
                // Add cancel button for pending orders
                if (orderData.status === 'pending') {
                    actions += `
                        <button class="action-btn action-btn-secondary" id="cancel-order-btn">
                            <i class="fas fa-times"></i>
                            ${translate('cancel_order')}
                        </button>
                    `;
                }
                
                switch(orderType) {
                    case 'dine-in':
                        if (orderData.status === 'confirmed' || orderData.status === 'preparing') {
                            actions += `
                                <button class="action-btn action-btn-primary" id="call-waiter-btn">
                                    <i class="fas fa-concierge-bell"></i>
                                    Call Waiter
                                </button>
                            `;
                        }
                        break;
                        
                    case 'takeaway':
                        if (orderData.status === 'ready') {
                            actions += `
                                <button class="action-btn action-btn-primary" id="pickup-ready-btn">
                                    <i class="fas fa-check"></i>
                                    I'm Here for Pickup
                                </button>
                            `;
                        }
                        break;
                        
                    case 'delivery':
                        if (orderData.status === 'out_for_delivery') {
                            actions += `
                                <button class="action-btn action-btn-primary" id="contact-driver-btn">
                                    <i class="fas fa-phone"></i>
                                    Contact Driver
                                </button>
                            `;
                        }
                        break;
                }
                
                return actions;
            }
            
            // Helper function to add order type specific action listeners
            function addOrderTypeActionListeners(orderData, orderType) {
                switch(orderType) {
                    case 'dine-in':
                        const callWaiterBtn = document.getElementById('call-waiter-btn');
                        if (callWaiterBtn) {
                            callWaiterBtn.addEventListener('click', () => {
                                showToast('Waiter has been notified. They will be with you shortly.');
                            });
                        }
                        break;
                        
                    case 'takeaway':
                        const pickupReadyBtn = document.getElementById('pickup-ready-btn');
                        if (pickupReadyBtn) {
                            pickupReadyBtn.addEventListener('click', () => {
                                showToast('Please proceed to Counter 3 for pickup.');
                            });
                        }
                        break;
                        
                    case 'delivery':
                        const contactDriverBtn = document.getElementById('contact-driver-btn');
                        if (contactDriverBtn) {
                            contactDriverBtn.addEventListener('click', () => {
                                showToast('Driver contact information would be displayed here.');
                            });
                        }
                        break;
                }
            }
            
            // Function to create feedback form
            function createFeedbackForm() {
                const feedbackSection = document.createElement('div');
                feedbackSection.className = 'feedback-section';
                feedbackSection.innerHTML = `
                            <h4>${translate('rate_your_experience')}</h4>
                            <p>${translate('share_your_experience')}</p>
                            <div class="rating-stars">
                                <i class="far fa-star" data-rating="1"></i>
                                <i class="far fa-star" data-rating="2"></i>
                                <i class="far fa-star" data-rating="3"></i>
                                <i class="far fa-star" data-rating="4"></i>
                                <i class="far fa-star" data-rating="5"></i>
                            </div>
                            <div class="form-group">
                                <label class="form-label">${translate('service_quality')}</label>
                                <select class="form-select" id="service-quality-rating">
                                    <option value="">${translate('select_rating')}</option>
                                    <option value="1">1</option>
                                    <option value="2">2</option>
                                    <option value="3">3</option>
                                    <option value="4">4</option>
                                    <option value="5">5</option>
                                </select>
                            </div>
                            <div class="form-group">
                                <label class="form-label">${translate('food_quality')}</label>
                                <select class="form-select" id="food-quality-rating">
                                    <option value="">${translate('select_rating')}</option>
                                    <option value="1">1</option>
                                    <option value="2">2</option>
                                    <option value="3">3</option>
                                    <option value="4">4</option>
                                    <option value="5">5</option>
                                </select>
                            </div>
                            <div class="form-group">
                                <label class="form-label">${translate('ambiance')}</label>
                                <select class="form-select" id="ambiance-rating">
                                    <option value="">${translate('select_rating')}</option>
                                    <option value="1">1</option>
                                    <option value="2">2</option>
                                    <option value="3">3</option>
                                    <option value="4">4</option>
                                    <option value="5">5</option>
                                </select>
                            </div>
                            <div class="form-group">
                                <label class="form-label">${translate('value_for_money')}</label>
                                <select class="form-select" id="value-rating">
                                    <option value="">${translate('select_rating')}</option>
                                    <option value="1">1</option>
                                    <option value="2">2</option>
                                    <option value="3">3</option>
                                    <option value="4">4</option>
                                    <option value="5">5</option>
                                </select>
                            </div>
                            <div class="form-group">
                                <label class="form-label">${translate('would_recommend')}</label>
                                <select class="form-select" id="recommend-select">
                                    <option value="">${translate('select')}</option>
                                    <option value="1">${translate('yes')}</option>
                                    <option value="0">${translate('no')}</option>
                                </select>
                            </div>
                            <div class="form-group">
                                <label class="form-label">${translate('feedback_text')}</label>
                                <textarea class="form-textarea" id="feedback-text" 
                                          placeholder="${translate('share_your_experience')}"></textarea>
                            </div>
                            <button class="btn" id="submit-feedback">${translate('submit_feedback')}</button>
                        `;
                        
                        return feedbackSection;
            }
            
            // Initialize feedback functionality
            function initializeFeedback() {
                const feedbackSection = createFeedbackForm();
                        
                        elements.orderTrackingContainer.appendChild(feedbackSection);
                        
                        // Add event listeners
                        feedbackSection.querySelectorAll('.rating-stars i').forEach(star => {
                            star.addEventListener('click', function() {
                                const rating = parseInt(this.getAttribute('data-rating'));
                                feedbackSection.querySelectorAll('.rating-stars i').forEach((s, index) => {
                                    s.classList.toggle('fas', index < rating);
                                    s.classList.toggle('far', index >= rating);
                                });
                                state.currentRating = rating;
                            });
                        });
                        
                        document.getElementById('submit-feedback').addEventListener('click', async () => {
                            if (!state.currentRating) {
                                showError(translate('please_select_rating'));
                                return;
                            }
                            
                            try {
                                // Validate all rating inputs
                                const serviceRatingEl = document.getElementById('service-quality-rating');
                                const foodRatingEl = document.getElementById('food-quality-rating');
                                const ambianceRatingEl = document.getElementById('ambiance-rating');
                                const valueRatingEl = document.getElementById('value-rating');
                                const recommendEl = document.getElementById('recommend-select');
                                const feedbackTextEl = document.getElementById('feedback-text');
                                
                                // Validate ratings
                                const serviceRating = serviceRatingEl.value ? 
                                    securityUtils.validateInput.rating(serviceRatingEl.value) : { isValid: true, value: null };
                                const foodRating = foodRatingEl.value ? 
                                    securityUtils.validateInput.rating(foodRatingEl.value) : { isValid: true, value: null };
                                const ambianceRating = ambianceRatingEl.value ? 
                                    securityUtils.validateInput.rating(ambianceRatingEl.value) : { isValid: true, value: null };
                                const valueRating = valueRatingEl.value ? 
                                    securityUtils.validateInput.rating(valueRatingEl.value) : { isValid: true, value: null };
                                
                                // Validate recommendation
                                const recommend = recommendEl.value === '1' ? 1 : 0;
                                
                                // Validate feedback text
                                const feedbackText = securityUtils.validateInput.text(feedbackTextEl.value, 1000);
                                
                                // Check for validation errors
                                if (!serviceRating.isValid || !foodRating.isValid || 
                                    !ambianceRating.isValid || !valueRating.isValid || !feedbackText.isValid) {
                                    const errors = [serviceRating, foodRating, ambianceRating, valueRating, feedbackText]
                                        .filter(v => !v.isValid)
                                        .map(v => v.error)
                                        .join(', ');
                                    showError(`Validation errors: ${errors}`);
                                    return;
                                }
                                
                                await apiService.submitFeedback({
                                    branch_id: state.currentBranch.branch_id,
                                    order_id: orderData.order_uid,
                                    rating: state.currentRating,
                                    service_quality_rating: serviceRating.value,
                                    food_quality_rating: foodRating.value,
                                    ambiance_rating: ambianceRating.value,
                                    value_for_money_rating: valueRating.value,
                                    would_recommend: recommend,
                                    feedback_text: feedbackText.value
                                });
                                showToast(translate('feedback_submitted'));
                                feedbackSection.remove();
                            } catch (error) {
                                console.error('Failed to submit feedback:', error);
                                showError(translate('feedback_submission_failed'));
                            }
                        });
            }
            
            function renderOrderHistory() {
                // Show skeleton view immediately
                renderOrdersSkeleton();
                
                // Small delay to ensure skeleton is visible
                setTimeout(async () => {
                    try {
                        // Get order UIDs from localStorage
                        const userOrderIds = state.userOrderIds || [];
                        
                        if (userOrderIds.length === 0) {
                            // No orders found in localStorage
                            const browseMenuUrl = state.currentBranch ? 
                                createBranchUrl(state.currentBranch, 'menu') : 
                                '#menu';
                            
                            elements.orderHistoryContainer.innerHTML = `
                                <div class="empty-state">
                                    <i class="fas fa-receipt"></i>
                                    <h3>${translate('no_orders')}</h3>
                                    <p>${translate('no_orders_message')}</p>
                                    <a href="${browseMenuUrl}" class="btn">${translate('browse_menu')}</a>
                                </div>
                            `;
                            document.getElementById('orders-view').classList.remove('skeleton');
                            return;
                        }

                        // Fetch orders from API using the order UIDs
                        try {
                            const response = await apiService.getUserOrders(userOrderIds);
                            const apiOrders = response?.data || [];
                            
                            if (apiOrders.length === 0) {
                                // API returned no orders, fall back to local storage
                                renderOrderHistoryFromLocalStorage();
                                return;
                            }
                            
                            // Update local storage with fresh API data
                            state.orderHistory = apiOrders.map(order => ({
                                order_uid: order.order_uid,
                                date: order.created_at || order.updated_at,
                                created_at: order.created_at,
                                items: [], // Items would need separate API call
                                final_amount: order.final_amount || 0,
                                status: order.status,
                                order_type: order.order_type,
                                branch_name: order.branch_name,
                                branch_name_translation_key: order.branch_name_translation_key,
                                item_count: order.item_count || 0
                            }));
                            
                            // Save updated data to localStorage
                            saveUserData();
                            
                            // Render the orders from API data
                            renderOrderHistoryUI(state.orderHistory);
                            
                        } catch (apiError) {
                            console.warn('Failed to fetch orders from API, falling back to localStorage:', apiError);
                            // Fall back to localStorage data
                            renderOrderHistoryFromLocalStorage();
                        }
                        
                    } catch (error) {
                        console.error('Error rendering order history:', error);
                        // Show error state
                        elements.orderHistoryContainer.innerHTML = `
                            <div class="empty-state">
                                <i class="fas fa-exclamation-triangle"></i>
                                <h3>${translate('error_loading_orders')}</h3>
                                <p>${translate('error_loading_orders_message')}</p>
                                <button class="btn" onclick="renderOrderHistory()">${translate('retry')}</button>
                            </div>
                        `;
                        document.getElementById('orders-view').classList.remove('skeleton');
                    }
                }, 300); // Minimum 300ms delay to show skeleton
            }
            
            // Separate function to render from localStorage (fallback)
            function renderOrderHistoryFromLocalStorage() {
                if (state.orderHistory.length === 0) {
                    const browseMenuUrl = state.currentBranch ? 
                        createBranchUrl(state.currentBranch, 'menu') : 
                        '#menu';
                    
                    elements.orderHistoryContainer.innerHTML = `
                        <div class="empty-state">
                            <i class="fas fa-receipt"></i>
                            <h3>${translate('no_orders')}</h3>
                            <p>${translate('no_orders_message')}</p>
                            <a href="${browseMenuUrl}" class="btn">${translate('browse_menu')}</a>
                        </div>
                    `;
                    document.getElementById('orders-view').classList.remove('skeleton');
                    return;
                }
                
                renderOrderHistoryUI(state.orderHistory);
            }
            
            // UI rendering function (shared between API and localStorage rendering)
            function renderOrderHistoryUI(orders) {
                const orderHistoryList = document.createElement('div');
                orderHistoryList.className = 'order-history-list';
                
                // Sort orders by date descending (most recent first)
                const sortedOrders = [...orders].sort((a, b) => new Date(b.date || b.created_at) - new Date(a.date || a.created_at));
                
                sortedOrders.forEach(order => {
                    const orderCard = document.createElement('div');
                    orderCard.className = 'order-history-card';
                    
                    // Format date properly
                    const orderDate = new Date(order.date || order.created_at);
                    const formattedDate = orderDate.toLocaleDateString();
                    
                    orderCard.innerHTML = `
                        <div class="order-history-header">
                            <h3>${translate('order')} #${order.order_uid}</h3>
                            <span class="order-date">${formattedDate}</span>
                        </div>
                        <div class="order-history-details">
                            <div class="order-status">
                                <span class="status-badge ${order.status}">${translate(order.status)}</span>
                            </div>
                            <div class="order-total">
                                ${formatPrice(order.final_amount || order.total || 0)}
                            </div>
                        </div>
                        ${order.branch_name || order.branch_name_translation_key ? `<div class="order-branch">
                            <i class="fas fa-store"></i> ${order.branch_name_translation_key ? translate(order.branch_name_translation_key) : order.branch_name}
                        </div>` : ''}
                        ${order.item_count ? `<div class="order-item-count">
                            <i class="fas fa-utensils"></i> ${order.item_count} ${translate('items')}
                        </div>` : ''}
                        <div class="order-history-actions">
                            <button class="btn btn-outline view-order-btn" data-order-id="${order.order_uid}">
                                ${translate('view_details')}
                            </button>
                            ${order.status === 'pending' ? `
                            <button class="btn cancel-order-btn" data-order-id="${order.order_uid}">
                                ${translate('cancel_order')}
                            </button>
                            ` : ''}
                        </div>
                    `;
                    
                    orderHistoryList.appendChild(orderCard);
                });
                
                elements.orderHistoryContainer.innerHTML = '';
                elements.orderHistoryContainer.appendChild(orderHistoryList);

                // Add event listeners
                document.querySelectorAll('.view-order-btn').forEach(btn => {
                    btn.addEventListener('click', (e) => {
                        const orderId = e.target.getAttribute('data-order-id');
                        window.location.hash = `order/${orderId}`;
                    });
                });
                
                document.querySelectorAll('.cancel-order-btn').forEach(btn => {
                    btn.addEventListener('click', (e) => {
                        const orderId = e.target.getAttribute('data-order-id');
                        cancelOrder(orderId);
                    });
                });
                
                // Remove skeleton class after content is loaded
                document.getElementById('orders-view').classList.remove('skeleton');
            }
            
            // Background sync function to update order totals from API
            
            function renderFavorites() {
                // Show skeleton view immediately
                renderFavoritesSkeleton();
                
                // Small delay to ensure skeleton is visible
                setTimeout(() => {
                    if (state.favorites.length === 0) {
                        const browseMenuUrl = state.currentBranch ? 
                            createBranchUrl(state.currentBranch, 'menu') : 
                            '#menu';
                        
                        elements.favoritesContainer.innerHTML = `
                            <div class="empty-state">
                                <i class="fas fa-heart"></i>
                                <h3>${translate('empty_favorites')}</h3>
                                <p>${translate('start_adding_favorites')}</p>
                                <a href="${browseMenuUrl}" class="btn">${translate('browse_menu')}</a>
                            </div>
                        `;
                        // Remove skeleton class after content is loaded
                        document.getElementById('favorites-view').classList.remove('skeleton');
                        return;
                    }

                    const favoritesGrid = document.createElement('div');
                    favoritesGrid.className = 'menu-items-grid';
                    
                    state.favorites.forEach((item, index) => {
                        const quantity = getItemQuantityInCart(item.branch_menu_id);
                        
                        const itemCard = document.createElement('div');
                        itemCard.className = 'menu-item-card';
                        itemCard.setAttribute('data-branch-menu-id', item.branch_menu_id);
                        itemCard.setAttribute('data-favorite-index', index);
                        itemCard.innerHTML = `
                            <div class="menu-item-image-container">
                                <img src="${item.image_url || '/images/food-default.jpg'}" alt="${item.item_name}" class="menu-item-image">
                                ${item.is_featured ? '<span class="menu-item-badge">Featured</span>' : ''}
                            </div>
                            <div class="menu-item-content">
                                <div class="menu-item-header">
                                    <h4 class="menu-item-name">${getTranslation(item.item_name, item.name_translation_key)}</h4>
                                    <div class="menu-item-price">${formatPrice(item.price)}</div>
                                </div>
                                <p class="item-desc">${getTranslation(item.item_description, item.description_translation_key) || translate('delicious_menu_item')}</p>
                                <div class="menu-item-footer">
                                    <div class="prep-time-with-favorite">
                                        <span class="prep-time"><i class="fas fa-clock"></i> ${item.preparation_time_minutes || 15} ${translate('mins')}</span>
                                        <button class="btn-favorite active" data-item-id="${item.branch_menu_id}">
                                            <i class="fas fa-heart"></i>
                                        </button>
                                    </div>
                                </div>
                            </div>
                        `;
                        
                        favoritesGrid.appendChild(itemCard);
                        
                        // Attach event listeners after the element is added to DOM
                        setTimeout(() => {
                            attachFavoriteItemEventListeners(itemCard, item, index);
                            // Note: Removed setupQuantityControllerEvents for favorites page
                        }, 0);
                    });
                    
                    elements.favoritesContainer.innerHTML = ''; // Clear any existing content
                    elements.favoritesContainer.appendChild(favoritesGrid);
                    
                    // Remove skeleton class after content is loaded
                    document.getElementById('favorites-view').classList.remove('skeleton');
                }, 300); // Minimum 300ms delay to show skeleton
            }
            
            // Item Detail Route Handler
            async function loadItemById(branchId, branchMenuId) {
                try {
                    // Check if we already have menu data for this branch
                    let menuData = state.menuData;
                    let needsMenuLoad = !menuData || menuData.length === 0;
                    
                    // If we don't have menu data or it's for a different branch, load it
                    if (needsMenuLoad || (state.currentBranch && state.currentBranch.branch_id != branchId)) {
                        // Show loading state and skeleton views if we need to load data
                        if (needsMenuLoad) {
                            showView('menu');
                            renderMenuItemSkeletons();
                            renderPromotionSkeletons();
                            renderCategoryTabsSkeletons();
                            renderMenuContentSkeletons();
                            
                            // Load featured branch cover section
                            loadFeaturedBranch();
                            
                            // Ensure translations are loaded before proceeding
                            if (!state.translations[state.language] || Object.keys(state.translations[state.language]).length === 0) {
                                await loadTranslationsFromAPI();
                            }
                        }
                        
                        // Load menu data for the branch
                        const menuDataResponse = await apiService.getBranchMenu(branchId);
                        menuData = menuDataResponse.data || menuDataResponse;
                        
                        // Store menu data in state
                        state.menuData = menuData;
                        
                        // Ensure all items have the correct branch_id set (consistent with loadMenu function)
                        menuData.forEach(category => {
                          if (category.items && Array.isArray(category.items)) {
                           category.items.forEach(item => {
                            // We use parseInt to ensure the ID is a number, preventing future type issues.
                            item.branch_id = parseInt(branchId, 10);
                           });
                          }
                        });
                        
                        // Extract categories from menu data (like loadMenu does)
                        state.categories = state.menuData.map(category => ({
                            id: category.category_id,
                            name: getTranslation(category.category_name, category.name_translation_key),
                            image: category.category_image
                        }));
                        console.log('Categories extracted:', state.categories);
                        
                        // Load promotions for this branch (like loadMenu does)
                        try {
                            console.log('Loading promotions for branch:', branchId);
                            const promotions = await apiService.getPromotions(branchId);
                            state.promotions = promotions.data || promotions;
                            renderPromotions();
                            console.log('Promotions loaded and rendered:', state.promotions);
                        } catch (error) {
                            console.error('Failed to load promotions:', error);
                            elements.promotionsContainer.style.display = 'none';
                        }
                        
                        // Render categories (like loadMenu does)
                        renderCategories();
                        console.log('Categories rendered');
                        
                        // Render menu items (like loadMenu does) - this is crucial for menu cards
                        renderMenuItems();
                        console.log('Menu items rendered');
                    }
                    
                    // Find the specific item in the menu data
                    let targetItem = null;
                    for (const category of menuData) {
                        if (category.items && Array.isArray(category.items)) {
                            const item = category.items.find(item => item.branch_menu_id == branchMenuId);
                            if (item) {
                                targetItem = item;
                                break;
                            }
                        }
                    }
                    
                    if (targetItem) {
                        // Double-check that the target item has the correct branch_id set
                        targetItem.branch_id = parseInt(branchId, 10);
                        
                        // Set current branch (only if different from current)
                        const itemBranch = state.branches.find(branch => branch.branch_id == branchId);
                        if (itemBranch && (!state.currentBranch || state.currentBranch.branch_id != branchId)) {
                            const branchWithSettings = await ensureBranchSettings(itemBranch);
                            state.currentBranch = branchWithSettings;
                            updateBranchNameDisplays();
                            updateCurrentCart();
                            updateCartUI();
                        }
                        
                        // Only render menu if it wasn't already visible or if menu content is not rendered
                        if (state.currentView !== 'menu') {
                            showView('menu');
                            renderMenuContentArea('all');
                        } else {
                            // Check if menu content is actually rendered
                            const menuContentArea = document.getElementById('menu-content-area');
                            const menuItemsContainer = document.getElementById('menu-items-container');
                            
                            // If menu content area is empty or not properly rendered, render it
                            if (!menuContentArea || menuContentArea.children.length === 0) {
                                console.log('Menu content area is empty, rendering menu content');
                                renderMenuContentArea('all');
                            } else if (!menuItemsContainer || menuItemsContainer.children.length === 0) {
                                console.log('Menu items container is empty, rendering menu items');
                                renderMenuItems();
                            } else {
                                console.log('Menu content already rendered, skipping re-render');
                            }
                        }
                        
                        // Ensure menu items are rendered (backup call)
                        setTimeout(() => {
                            const menuItemsContainer = document.getElementById('menu-items-container');
                            if (!menuItemsContainer || menuItemsContainer.children.length === 0) {
                                console.log('Backup: Menu items still not rendered, calling renderMenuItems');
                                renderMenuItems();
                            }
                        }, 200);
                        
                        // Then show the item detail modal
                        await showItemDetailModal(targetItem);
                        
                        return true;
                    } else {
                        showError('Item not found');
                        showView('menu');
                        if (state.currentBranch) {
                            loadMenu(state.currentBranch.branch_id);
                        }
                        return false;
                    }
                } catch (error) {
                    console.error('Failed to load item:', error);
                    showError('Failed to load item details');
                    showView('menu');
                    if (state.currentBranch) {
                        loadMenu(state.currentBranch.branch_id);
                    }
                    return false;
                }
            }
            
            // Create URL for item detail
            function createItemUrl(branch, branchMenuId) {
                const branchUrlName = getBranchUrlName(branch);
                
                // For URLs with Unicode characters, we should encode them
                if (/[\u0980-\u09FF\u0800-\uFFFF]/.test(branchUrlName)) {
                    const encodedName = encodeUrlName(branchUrlName);
                    return `#/${encodedName}/menu/item/${branchMenuId}`;
                }
                
                return `#/${branchUrlName}/menu/item/${branchMenuId}`;
            }
            
            // Update URL to reflect current item modal
            function updateUrlForItem(item) {
                if (item && item.branch_id && state.currentBranch) {
                    const newUrl = createItemUrl(state.currentBranch, item.branch_menu_id);
                    if (window.location.hash !== newUrl) {
                        // Use replaceState instead of hash to avoid triggering hashchange event
                        history.replaceState(null, '', newUrl);
                    }
                }
            }
            
            // Item Detail Modal
            async function showItemDetailModal(item) {
                console.log('showItemDetailModal called with item:', item);
                console.log('Item properties:', {
                    item_name: item.item_name,
                    name: item.name,
                    price: item.price,
                    image_url: item.image_url,
                    branch_menu_id: item.branch_menu_id,
                    branch_id: item.branch_id
                });
                
                // Ensure item has all required properties, try to find them if missing
                if (!item.item_name && item.name) {
                    item.item_name = item.name;
                }
                if (!item.item_description && item.description) {
                    item.item_description = item.description;
                }
                if (!item.preparation_time_minutes && item.preparation_time) {
                    item.preparation_time_minutes = item.preparation_time;
                }
                
                // If still missing critical properties, try to find complete item from menu data
                if (!item.item_name || !item.branch_id) {
                    console.log('Item missing critical properties, searching menu data...');
                    if (state.menuData && Array.isArray(state.menuData) && item.branch_menu_id) {
                        for (const category of state.menuData) {
                            if (category.items && Array.isArray(category.items)) {
                                const foundItem = category.items.find(menuItem => 
                                    parseInt(menuItem.branch_menu_id) === parseInt(item.branch_menu_id)
                                );
                                if (foundItem) {
                                    console.log('Found complete item, merging properties:', foundItem);
                                    // Merge the found item properties with the current item
                                    Object.assign(item, foundItem);
                                    break;
                                }
                            }
                        }
                    }
                }
                
                // Final fallback for missing properties
                item.item_name = item.item_name || 'Unknown Item';
                item.item_description = item.item_description || '';
                item.price = item.price || 0;
                item.image_url = item.image_url || '/images/food-default.jpg';
                item.preparation_time_minutes = item.preparation_time_minutes || 15;
                item.calories = item.calories || 250;
                
                console.log('Final item object after normalization:', item);
                
                state.currentItem = item;
                state.currentQuantity = 1;
                state.currentCustomizations = {};
                
                // Show skeleton view immediately
                showModal('item-detail-modal');
                renderItemDetailSkeleton();
                
                // Set the current branch based on the item's branch_id
                if (item.branch_id) {
                    const itemBranch = state.branches.find(branch => branch.branch_id === item.branch_id);
                    if (itemBranch) {
                        // Ensure branch settings are loaded
                        const branchWithSettings = await ensureBranchSettings(itemBranch);
                        state.currentBranch = branchWithSettings;
                        console.log('Set current branch from item:', branchWithSettings.internal_name);
                        
                        // Update branch name displays to reflect the new current branch
                        updateBranchNameDisplays();
                        updateCurrentCart();
                        updateCartUI();
                        
                        // Update URL to reflect the current item (for bookmarking/sharing)
                        updateUrlForItem(item);
                    } else {
                        console.warn('Branch not found for item branch_id:', item.branch_id);
                    }
                } else {
                    console.warn('Item does not have branch_id:', item);
                }
                
                // Load customizations for this item
                try {
                    const customizations = await apiService.getCustomizations(item.branch_menu_id);
                    state.itemCustomizations = customizations.data || customizations;
                    
                    // Render the actual content
                    const modal = document.querySelector('#item-detail-modal .modal');
                    if (modal) {
                        modal.classList.remove('skeleton');
                    }
                    
                    elements.itemDetailContent.innerHTML = `
                    <div class="item-detail-container">
                        <div class="item-image-section">
                            <img src="${item.image_url || '/images/food-default.jpg'}" alt="${item.item_name}" class="item-detail-image">
                            ${item.is_featured ? '<span class="item-badge">Featured</span>' : ''}
                        </div>
                        
                        <div class="item-info-section">
                            <div class="item-header">
                                <h2 class="item-name">${getTranslation(item.item_name, item.name_translation_key)}</h2>
                                <div class="item-price">${formatPrice(item.price)}</div>
                            </div>
                            
                            <p class="item-description">${getTranslation(item.item_description, item.description_translation_key) || translate('delicious_menu_item_description')}</p>
                            
                            <div class="item-meta">
                                <span><i class="fas fa-clock"></i> ${item.preparation_time_minutes || 15} ${translate('mins')}</span>
                                <span><i class="fas fa-fire"></i> ${item.calories || 250} cal</span>
                            </div>
                        </div>
                        
                        <div id="customization-section">
                            <!-- Customization options will be loaded here -->
                        </div>
                        
                        <div class="quantity-selector">
                            <span class="quantity-label">${translate('quantity')}:</span>
                            <div class="quantity-controls">
                                <button id="quantity-decrease">-</button>
                                <input type="number" id="quantity-input" value="1" min="1" max="99">
                                <button id="quantity-increase">+</button>
                            </div>
                        </div>
                    </div>
                `;
                
                // Load customizations
                loadCustomizations(item.branch_menu_id);
                
                // Setup quantity controls
                setupQuantityControls();
                } catch (error) {
                    console.error('Failed to load item details:', error);
                    
                    // Remove skeleton class and show error
                    const modal = document.querySelector('#item-detail-modal .modal');
                    if (modal) {
                        modal.classList.remove('skeleton');
                    }
                    
                    elements.itemDetailContent.innerHTML = `
                        <div class="error-message">
                            <p>${translate('failed_to_load_item_details')}</p>
                        </div>
                    `;
                }
            }
            
            async function loadCustomizations(branchMenuId) {
                try {
                    const response = await apiService.getCustomizations(branchMenuId);
                    
                    // The API returns data in a wrapper format with 'data' field
                    const customizations = response.data || response;
                    console.log('Loaded customizations:', customizations);
                    
                    renderCustomizationOptions(customizations);
                } catch (error) {
                    console.error('Failed to load customizations:', error);
                    // Hide customization section if no customizations available
                    const customizationSection = document.getElementById('customization-section');
                    if (customizationSection) {
                        customizationSection.style.display = 'none';
                    }
                }
            }
            
            function renderCustomizationOptions(customizations) {
                const customizationSection = document.getElementById('customization-section');
                
                if (!customizations.groups || customizations.groups.length === 0) {
                    console.log('No customization groups found, hiding section');
                    customizationSection.style.display = 'none';
                    return;
                }
                
                customizationSection.innerHTML = '';
                
                customizations.groups.forEach(group => {
                    const groupElement = document.createElement('div');
                    groupElement.className = 'customization-group';
                    groupElement.innerHTML = `
                        <h4 class="customization-group-title">${group.name && typeof group.name === 'object' ? (group.name[state.language] || group.name['en-US'] || 'Customization') : getTranslation(group.name, group.name_translation_key)}</h4>
                        <div class="customization-options-list" data-group-id="${group.id}" data-group-type="${group.type}">
                            <!-- Options will be added here -->
                        </div>
                    `;
                    
                    const optionsList = groupElement.querySelector('.customization-options-list');
                    
                    group.options.forEach(option => {
                        const optionElement = document.createElement('div');
                        optionElement.className = 'customization-option';
                        optionElement.setAttribute('data-option-id', option.id);
                        optionElement.setAttribute('data-price-adjustment', option.price_adjustment || 0);
                        
                        const inputType = group.type === 'radio' ? 'radio' : 'checkbox';
                        const inputName = group.type === 'radio' ? `group-${group.id}` : `option-${option.id}`;
                        
                        optionElement.innerHTML = `
                            <div class="customization-option-label">
                                <input type="${inputType}" name="${inputName}" value="${option.id}">
                                <span>${option.name && typeof option.name === 'object' ? (option.name[state.language] || option.name['en-US'] || 'Option') : getTranslation(option.name, option.name_translation_key)}</span>
                            </div>
                            <span class="customization-price">${option.price_adjustment > 0 ? `+${formatPrice(option.price_adjustment)}` : translate('free')}</span>
                        `;
                        
                        optionElement.addEventListener('click', handleCustomizationOptionClick);
                        
                        optionsList.appendChild(optionElement);
                    });
                    
                    customizationSection.appendChild(groupElement);
                });
                
                customizationSection.style.display = 'block';
            }
            
            function handleCustomizationOptionClick(e) {
                const option = e.currentTarget;
                const input = option.querySelector('input');
                const groupType = option.closest('.customization-options-list').getAttribute('data-group-type');
                const groupId = option.closest('.customization-options-list').getAttribute('data-group-id');
                const optionId = option.getAttribute('data-option-id');
                const priceAdjustment = parseFloat(option.getAttribute('data-price-adjustment')) || 0;
                
                if (groupType === 'radio') {
                    // For radio buttons, clear all other options in the group
                    option.closest('.customization-options-list').querySelectorAll('.customization-option').forEach(opt => {
                        opt.classList.remove('selected');
                        opt.querySelector('input').checked = false;
                    });
                    
                    // Select this option
                    option.classList.add('selected');
                    input.checked = true;
                    state.currentCustomizations[groupId] = {
                        optionId: optionId,
                        priceAdjustment: priceAdjustment
                    };
                } else {
                    // For checkboxes, toggle the option
                    input.checked = !input.checked;
                    option.classList.toggle('selected');
                    
                    if (!state.currentCustomizations[groupId]) {
                        state.currentCustomizations[groupId] = [];
                    }
                    
                    if (input.checked) {
                        state.currentCustomizations[groupId].push({
                            optionId: optionId,
                            priceAdjustment: priceAdjustment
                        });
                    } else {
                        state.currentCustomizations[groupId] = state.currentCustomizations[groupId].filter(
                            opt => opt.optionId !== optionId
                        );
                    }
                }
                
                updateItemPrice();
            }
            
            function updateItemPrice() {
                const basePrice = state.currentItem.price;
                let totalPrice = basePrice;
                
                // Add customization prices
                Object.values(state.currentCustomizations).forEach(group => {
                    if (Array.isArray(group)) {
                        group.forEach(option => {
                            totalPrice += option.priceAdjustment;
                        });
                    } else {
                        totalPrice += group.priceAdjustment;
                    }
                });
                
                // Update price display
                const priceElement = document.querySelector('.item-price');
                if (priceElement) {
                    priceElement.textContent = formatPrice(totalPrice);
                }
            }
            
            function setupQuantityControls() {
                const decreaseBtn = document.getElementById('quantity-decrease');
                const increaseBtn = document.getElementById('quantity-increase');
                const quantityInput = document.getElementById('quantity-input');
                
                if (decreaseBtn) {
                    decreaseBtn.addEventListener('click', () => {
                        if (state.currentQuantity > 1) {
                            state.currentQuantity--;
                            quantityInput.value = state.currentQuantity;
                        }
                    });
                }
                
                if (increaseBtn) {
                    increaseBtn.addEventListener('click', () => {
                        if (state.currentQuantity < 99) {
                            state.currentQuantity++;
                            quantityInput.value = state.currentQuantity;
                        }
                    });
                }
                
                if (quantityInput) {
                    quantityInput.addEventListener('change', (e) => {
                        const validation = securityUtils.validateInput.number(e.target.value, 1, 99);
                        if (validation.isValid) {
                            state.currentQuantity = validation.value;
                        } else {
                            e.target.value = state.currentQuantity;
                            showError(validation.error);
                        }
                    });
                }
            }
            
            // ===== MENU CARD QUANTITY CONTROLLER FUNCTIONS =====
            
            /**
             * Check if an item has customizations available
             * @param {number} branchMenuId - The branch menu item ID
             * @returns {Promise<boolean>} - True if item has customizations
             */
            async function hasItemCustomizations(branchMenuId) {
                try {
                    const response = await apiService.getCustomizations(branchMenuId);
                    const customizations = response.data || response;
                    return customizations.groups && customizations.groups.length > 0;
                } catch (error) {
                    console.error('Failed to check customizations:', error);
                    return false;
                }
            }
            
            /**
             * Get the quantity of an item in the current cart
             * @param {number} branchMenuId - The branch menu item ID
             * @returns {number} - Quantity of item in cart (0 if not found)
             */
            function getItemQuantityInCart(branchMenuId) {
                const currentCart = getCurrentBranchCart();
                const cartItem = currentCart.find(item => item.branch_menu_id === branchMenuId);
                return cartItem ? cartItem.quantity : 0;
            }
            
            /**
             * Check if an item is already in the current cart
             * @param {number} branchMenuId - The branch menu item ID
             * @returns {boolean} - True if item is in cart
             */
            function isItemInCart(branchMenuId) {
                return getItemQuantityInCart(branchMenuId) > 0;
            }
            
            /**
             * Add item to cart directly (without customizations)
             * @param {Object} item - The menu item to add
             * @param {number} quantity - The quantity to add
             */
            function addItemToCartDirectly(item, quantity = 1) {
                if (!state.currentBranch) {
                    showError(translate('please_select_branch'));
                    return;
                }
                
                // Check for branch conflict
                const hasConflict = checkBranchConflict(item);
                
                if (hasConflict) {
                    // Show branch conflict modal
                    showBranchConflictModal(item, () => {
                        performDirectAddToCart(item, quantity);
                    });
                    return;
                }
                
                // No conflict, proceed with direct add
                performDirectAddToCart(item, quantity);
            }
            
            /**
             * Perform the actual direct add to cart operation
             * @param {Object} item - The menu item to add
             * @param {number} quantity - The quantity to add
             */
            function performDirectAddToCart(item, quantity) {
                const currentCart = getCurrentBranchCart();
                
                // Check if item already exists in cart
                const existingIndex = currentCart.findIndex(cartItem => 
                    cartItem.branch_menu_id === item.branch_menu_id && 
                    Object.keys(cartItem.customizations || {}).length === 0
                );
                
                if (existingIndex >= 0) {
                    // Update quantity if already exists
                    currentCart[existingIndex].quantity += quantity;
                } else {
                    // Add new item to cart
                    const cartItem = {
                        branch_menu_id: item.branch_menu_id,
                        item_id: item.item_id,
                        name: item.item_name,
                        name_translation_key: item.name_translation_key,
                        price: item.price,
                        base_price: item.price,
                        image_url: item.image_url,
                        customizations: {},
                        quantity: quantity,
                        branch_id: state.currentBranch.branch_id,
                        branch_name: state.currentBranch.internal_name
                    };
                    
                    currentCart.push(cartItem);
                }
                
                saveCart();
                updateCurrentCart();
                updateCartUI();
                showToast(translate('item_added'));
                
                // Update all menu cards to reflect new cart state
                updateMenuCardsQuantityControllers();
            }
            
            /**
             * Update item quantity in cart
             * @param {number} branchMenuId - The branch menu item ID
             * @param {number} newQuantity - The new quantity
             */
            function updateItemQuantityInCart(branchMenuId, newQuantity) {
                if (newQuantity <= 0) {
                    removeItemFromCart(branchMenuId);
                    return;
                }
                
                const currentCart = getCurrentBranchCart();
                const cartItem = currentCart.find(item => item.branch_menu_id === branchMenuId);
                
                if (cartItem) {
                    cartItem.quantity = newQuantity;
                    saveCart();
                    updateCurrentCart();
                    updateCartUI();
                    // Update the menu cards quantity controllers to reflect the new quantity
                    updateMenuCardsQuantityControllers();
                }
            }
            
            /**
             * Remove item from cart
             * @param {number} branchMenuId - The branch menu item ID
             */
            function removeItemFromCart(branchMenuId) {
                const currentCart = getCurrentBranchCart();
                const itemIndex = currentCart.findIndex(item => item.branch_menu_id === branchMenuId);
                
                if (itemIndex >= 0) {
                    currentCart.splice(itemIndex, 1);
                    saveCart();
                    updateCurrentCart();
                    updateCartUI();
                    // Update the menu cards quantity controllers to reflect the item removal
                    updateMenuCardsQuantityControllers();
                }
            }
            
            /**
             * Create quantity controller HTML for menu card
             * @param {Object} item - The menu item
             * @param {number} quantity - Current quantity in cart
             * @returns {string} - HTML string for quantity controller
             */
            function createQuantityControllerHTML(item, quantity) {
                console.log('createQuantityControllerHTML called with:', { item, quantity });
                
                if (quantity === 0) {
                    const html = `
                        <div class="menu-item-quantity-controller">
                            <button class="btn-add-to-cart-menu" data-item-id="${item.branch_menu_id}" title="Add to cart">
                                <i class="fas fa-plus"></i>
                            </button>
                        </div>
                    `;
                    console.log('createQuantityControllerHTML - returning + button:', html);
                    return html;
                } else {
                    const html = `
                        <div class="menu-item-quantity-controller">
                            <div class="quantity-controls-menu" data-item-id="${item.branch_menu_id}">
                                <button class="quantity-decrease" data-item-id="${item.branch_menu_id}" title="Decrease quantity">
                                    <i class="fas fa-minus"></i>
                                </button>
                                <div class="quantity-separator"></div>
                                <input type="number" class="quantity-input" value="${quantity}" min="1" max="99" readonly data-item-id="${item.branch_menu_id}">
                                <div class="quantity-separator"></div>
                                <button class="quantity-increase" data-item-id="${item.branch_menu_id}" title="Increase quantity">
                                    <i class="fas fa-plus"></i>
                                </button>
                            </div>
                        </div>
                    `;
                    console.log('createQuantityControllerHTML - returning quantity controls:', html);
                    return html;
                }
            }
            
            /**
             * Setup event listeners for quantity controller
             * @param {HTMLElement} menuCard - The menu card element
             * @param {Object} item - The menu item
             */
            function setupQuantityControllerEvents(menuCard, item) {
                const controller = menuCard.querySelector('.menu-item-quantity-controller');
                if (!controller) return;
                
                // Add to cart button
                const addBtn = controller.querySelector('.btn-add-to-cart-menu');
                if (addBtn) {
                    addBtn.addEventListener('click', async (e) => {
                        e.stopPropagation();
                        
                        // Check if item has customizations
                        const hasCustomizations = await hasItemCustomizations(item.branch_menu_id);
                        
                        if (hasCustomizations) {
                            // Open item detail modal for customization
                            showItemDetailModal(item);
                        } else {
                            // Add directly to cart
                            addItemToCartDirectly(item, 1);
                        }
                    });
                }
                
                // Quantity decrease button
                const decreaseBtn = controller.querySelector('.quantity-decrease');
                if (decreaseBtn) {
                    decreaseBtn.addEventListener('click', (e) => {
                        e.stopPropagation();
                        const currentQuantity = getItemQuantityInCart(item.branch_menu_id);
                        updateItemQuantityInCart(item.branch_menu_id, currentQuantity - 1);
                    });
                }
                
                // Quantity increase button
                const increaseBtn = controller.querySelector('.quantity-increase');
                if (increaseBtn) {
                    increaseBtn.addEventListener('click', (e) => {
                        e.stopPropagation();
                        const currentQuantity = getItemQuantityInCart(item.branch_menu_id);
                        updateItemQuantityInCart(item.branch_menu_id, currentQuantity + 1);
                    });
                }
            }
            
            /**
             * Update all menu cards quantity controllers
             */
            function updateMenuCardsQuantityControllers() {
                console.log('updateMenuCardsQuantityControllers called');
                const menuCards = document.querySelectorAll('.menu-item-card');
                console.log('Found menu cards:', menuCards.length);
                
                menuCards.forEach(card => {
                    const itemId = parseInt(card.getAttribute('data-branch-menu-id'));
                    if (itemId) {
                        const quantity = getItemQuantityInCart(itemId);
                        const controller = card.querySelector('.menu-item-quantity-controller');
                        if (controller) {
                            console.log('Updating controller for item:', itemId, 'quantity:', quantity);
                            
                            // Find the complete item object from menu data instead of creating a minimal one
                            let completeItem = null;
                            
                            // Search through all categories and items to find the complete item
                            if (state.menuData && Array.isArray(state.menuData)) {
                                for (const category of state.menuData) {
                                    if (category.items && Array.isArray(category.items)) {
                                        const foundItem = category.items.find(item => 
                                            parseInt(item.branch_menu_id) === itemId
                                        );
                                        if (foundItem) {
                                            completeItem = foundItem;
                                            break;
                                        }
                                    }
                                }
                            }
                            
                            // If we found the complete item, use it; otherwise try to create a better fallback
                            let itemToUse;
                            if (completeItem) {
                                itemToUse = completeItem;
                            } else {
                                // Try to get basic info from the cart item if available
                                const cartItem = getCurrentBranchCart().find(item => 
                                    parseInt(item.branch_menu_id) === itemId
                                );
                                
                                if (cartItem) {
                                    itemToUse = {
                                        branch_menu_id: itemId,
                                        item_name: cartItem.name || 'Unknown Item',
                                        price: cartItem.price || 0,
                                        image_url: cartItem.image_url || '/images/food-default.jpg',
                                        branch_id: cartItem.branch_id || state.currentBranch?.branch_id
                                    };
                                } else {
                                    // Last resort minimal object
                                    itemToUse = { 
                                        branch_menu_id: itemId,
                                        item_name: 'Unknown Item',
                                        price: 0,
                                        image_url: '/images/food-default.jpg',
                                        branch_id: state.currentBranch?.branch_id
                                    };
                                }
                            }
                            
                            console.log('updateMenuCardsQuantityControllers - using item:', {
                                itemId,
                                hasCompleteItem: !!completeItem,
                                itemName: itemToUse.item_name,
                                hasBranchId: !!itemToUse.branch_id,
                                itemToUse: itemToUse
                            });
                            
                            const newHTML = createQuantityControllerHTML(itemToUse, quantity);
                            console.log('New quantity controller HTML:', newHTML);
                            
                            controller.innerHTML = newHTML;
                            setupQuantityControllerEvents(card, itemToUse);
                        } else {
                            console.log('No controller found for item:', itemId);
                        }
                    }
                });
            }
            
            // QR Scanner functionality
            let qrScanner = null;
            let cameraStream = null;
            
            function showQRScanner() {
                elements.qrScannerContainer.classList.add('active');
                elements.qrCodeInput.value = '';
                elements.qrCodeInput.focus();
                
                // Initialize camera for QR scanning
                initializeQRCamera();
            }
            
            function hideQRScanner() {
                elements.qrScannerContainer.classList.remove('active');
                stopQRCamera();
            }
            
            async function initializeQRCamera() {
                try {
                    // Check if browser supports camera access
                    if (!navigator.mediaDevices || !navigator.mediaDevices.getUserMedia) {
                        console.warn('Camera not supported, using manual input only');
                        return;
                    }
                    
                    // Create video element for camera feed
                    const qrPlaceholder = document.querySelector('.qr-scanner-placeholder');
                    if (!qrPlaceholder) return;
                    
                    // Create video element if it doesn't exist
                    let video = qrPlaceholder.querySelector('#qr-video');
                    if (!video) {
                        video = document.createElement('video');
                        video.id = 'qr-video';
                        video.style.cssText = `
                            width: 100%;
                            height: 200px;
                            object-fit: cover;
                            border-radius: 8px;
                            border: 2px solid var(--uber-gray-300);
                            margin-bottom: 1rem;
                        `;
                        video.autoplay = true;
                        video.playsInline = true;
                        qrPlaceholder.insertBefore(video, qrPlaceholder.firstChild);
                    }
                    
                    // Create canvas for QR detection
                    let canvas = qrPlaceholder.querySelector('#qr-canvas');
                    if (!canvas) {
                        canvas = document.createElement('canvas');
                        canvas.id = 'qr-canvas';
                        canvas.style.display = 'none';
                        qrPlaceholder.appendChild(canvas);
                    }
                    
                    // Get camera stream
                    cameraStream = await navigator.mediaDevices.getUserMedia({
                        video: { 
                            facingMode: 'environment', // Use back camera if available
                            width: { ideal: 640 },
                            height: { ideal: 480 }
                        }
                    });
                    
                    video.srcObject = cameraStream;
                    
                    // Start QR code detection
                    startQRDetection(video, canvas);
                    
                } catch (error) {
                    console.error('Failed to initialize camera:', error);
                    showError('Camera access denied or not available. Please use manual input.');
                }
            }
            
            function startQRDetection(video, canvas) {
                const context = canvas.getContext('2d');
                
                const detectQR = () => {
                    if (!video.videoWidth || !video.videoHeight) {
                        requestAnimationFrame(detectQR);
                        return;
                    }
                    
                    canvas.width = video.videoWidth;
                    canvas.height = video.videoHeight;
                    context.drawImage(video, 0, 0, canvas.width, canvas.height);
                    
                    try {
                        // Get image data for QR detection
                        const imageData = context.getImageData(0, 0, canvas.width, canvas.height);
                        
                        // Use jsQR library for QR code detection
                        if (window.jsQR) {
                            const code = jsQR(imageData.data, imageData.width, imageData.height);
                            
                            if (code && code.data) {
                                // QR code detected
                                console.log('QR Code detected:', code.data);
                                processQRCode(code.data);
                                return; // Stop detection after successful scan
                            }
                        } else {
                            // Fallback: Try to detect QR patterns manually (basic implementation)
                            // This is a simple pattern matching approach
                            const qrPattern = detectQRPattern(imageData);
                            if (qrPattern) {
                                console.log('QR Pattern detected (basic):', qrPattern);
                                processQRCode(qrPattern);
                                return;
                            }
                        }
                    } catch (error) {
                        console.error('QR detection error:', error);
                    }
                    
                    // Continue scanning if camera is still active
                    if (cameraStream && cameraStream.active) {
                        requestAnimationFrame(detectQR);
                    }
                };
                
                // Start detection
                requestAnimationFrame(detectQR);
            }
            
            function detectQRPattern(imageData) {
                // Basic QR code pattern detection (fallback)
                // This is a simplified approach - in real implementation you'd want a proper QR library
                const { data, width, height } = imageData;
                
                // Look for QR code-like patterns in the image
                // For now, we'll just return null and rely on manual input
                // A full implementation would analyze the pixel data for QR patterns
                return null;
            }
            
            function stopQRCamera() {
                if (cameraStream) {
                    cameraStream.getTracks().forEach(track => track.stop());
                    cameraStream = null;
                }
                
                // Remove video element
                const video = document.querySelector('#qr-video');
                if (video) {
                    video.remove();
                }
                
                // Remove canvas element
                const canvas = document.querySelector('#qr-canvas');
                if (canvas) {
                    canvas.remove();
                }
            }
            
            // Load jsQR library dynamically for QR code detection
            function loadQRLibrary() {
                if (window.jsQR) return Promise.resolve();
                
                return new Promise((resolve, reject) => {
                    const script = document.createElement('script');
                    script.src = 'https://cdn.jsdelivr.net/npm/jsqr@1.4.0/dist/jsQR.js';
                    script.onload = resolve;
                    script.onerror = reject;
                    document.head.appendChild(script);
                });
            }
            
            // Initialize QR library when app starts
            loadQRLibrary().catch(error => {
                console.warn('Failed to load QR library:', error);
            });
            
            async function processQRCode(qrCode) {
                try {
                    showLoading();
                    const table = await apiService.getTableByQr(qrCode);
                    
                    if (!table || !table.data) {
                        throw new Error('Table not found');
                    }
                    
                    // Set current table and branch
                    state.currentTable = table.data;
                    
                    // If we don't have the branch data yet, load it
                    if (!state.currentBranch || state.currentBranch.branch_id !== table.data.branch_id) {
                        const branch = await apiService.getBranch(table.data.branch_id);
                        state.currentBranch = branch.data || branch;
                        updateBranchNameDisplays();
                        
                        // Update cart to show current branch's cart
                        updateCurrentCart();
                        updateCartUI();
                    }
                    
                    hideLoading();
                    hideQRScanner();
                    showToast(translate('table_selected').replace('{table}', table.data.table_identifier));
                    
                    // If we're on the menu page, refresh it with the new branch
                    if (state.currentView === 'menu') {
                        loadMenu(state.currentBranch.branch_id);
                    } else if (state.currentView === 'cart') {
                        renderCart();
                    } else if (state.currentView === 'checkout') {
                        renderCheckout();
                    }
                } catch (error) {
                    hideLoading();
                    console.error('Failed to process QR code:', error);
                    showError(translate('invalid_qr_code'));
                }
            }
            
            // Cart management
            function getBranchCart(branchId) {
                if (!state.branchCarts[branchId]) {
                    state.branchCarts[branchId] = [];
                }
                return state.branchCarts[branchId];
            }
            
            function getCurrentBranchCart() {
                if (!state.currentBranch) {
                    return [];
                }
                return getBranchCart(state.currentBranch.branch_id);
            }
            
            function updateCurrentCart() {
                state.cart = getCurrentBranchCart();
            }
            
            function addToCart() {
                if (!state.currentItem) {
                    showError('No item selected');
                    return;
                }
                
                if (!state.currentBranch) {
                    showError(translate('please_select_branch'));
                    return;
                }
                
                // Check for branch conflict
                const hasConflict = checkBranchConflict(state.currentItem);
                
                if (hasConflict) {
                    // Show branch conflict modal instead of adding directly
                    showBranchConflictModal(state.currentItem, () => {
                        // This callback will be executed if user confirms
                        performAddToCart();
                    });
                    return;
                }
                
                // No conflict, proceed with normal add to cart
                performAddToCart();
            }
            
            function performAddToCart() {
                if (!state.currentItem || !state.currentBranch) {
                    showError('Invalid item or branch');
                    return;
                }
                
                console.log('Adding to cart - current customizations:', state.currentCustomizations);
                console.log('Adding to cart - current item:', state.currentItem);
                
                // Calculate total price with customizations
                let totalPrice = state.currentItem.price;
                Object.values(state.currentCustomizations).forEach(group => {
                    if (Array.isArray(group)) {
                        group.forEach(option => {
                            totalPrice += option.priceAdjustment;
                        });
                    } else {
                        totalPrice += group.priceAdjustment;
                    }
                });
                
                // Get current branch cart
                const currentCart = getCurrentBranchCart();
                
                // Check if item already exists in cart with same customizations
                const existingIndex = currentCart.findIndex(cartItem => 
                    cartItem.branch_menu_id === state.currentItem.branch_menu_id && 
                    JSON.stringify(cartItem.customizations) === JSON.stringify(state.currentCustomizations)
                );
                
                if (existingIndex >= 0) {
                    // Update quantity if already exists
                    currentCart[existingIndex].quantity += state.currentQuantity;
                } else {
                    // Add new item to cart
                    const cartItem = {
                        branch_menu_id: state.currentItem.branch_menu_id,
                        item_id: state.currentItem.item_id,
                        name: state.currentItem.item_name,
                        name_translation_key: state.currentItem.name_translation_key,
                        price: totalPrice,
                        base_price: state.currentItem.price,
                        image_url: state.currentItem.image_url,
                        customizations: state.currentCustomizations,
                        quantity: state.currentQuantity,
                        branch_id: state.currentBranch.branch_id,
                        branch_name: state.currentBranch.internal_name
                    };
                    
                    console.log('Adding cart item:', cartItem);
                    currentCart.push(cartItem);
                }
                
                saveCart();
                updateCurrentCart();
                updateCartUI();
                hideModal('item-detail-modal');
                
                // Update all menu cards to reflect new cart state
                updateMenuCardsQuantityControllers();
                
                // Update URL to go back to menu after adding to cart
                // Use replaceState to avoid triggering router navigation
                if (state.currentBranch) {
                    const menuUrl = createBranchUrl(state.currentBranch, 'menu');
                    if (window.location.hash !== menuUrl) {
                        // Use replaceState instead of hash assignment to avoid router trigger
                        history.replaceState(null, null, menuUrl);
                    }
                }
                
                showToast(translate('item_added'));
            }
            
            function updateCartItemQuantity(index, change) {
                const item = state.cart[index];
                if (!item) return;
                
                item.quantity += change;
                
                if (item.quantity <= 0) {
                    removeCartItemByIndex(index);
                } else {
                    saveCart();
                    updateCurrentCart();
                    updateCartUI();
                    
                    // Update only the specific cart item UI instead of re-rendering everything
                    updateCartItemUI(index);
                    
                    // Re-attach event listeners for quantity controls to ensure they work correctly
                    attachCartEventListeners();
                }
            }
            
            function removeCartItem(index) {
                const item = state.cart[index];
                if (!item) return;
                
                const branchId = item.branch_id;
                const branchMenuId = item.branch_menu_id;
                const customizations = item.customizations;
                
                // Remove from main cart (after capturing item info for DOM removal)
                state.cart.splice(index, 1);
                
                // Update branch cart
                const branchCart = getBranchCart(branchId);
                const branchCartIndex = branchCart.findIndex(cartItem => 
                    cartItem.branch_menu_id === branchMenuId && 
                    JSON.stringify(cartItem.customizations) === JSON.stringify(customizations)
                );
                
                if (branchCartIndex >= 0) {
                    branchCart.splice(branchCartIndex, 1);
                }
                
                saveCart();
                updateCurrentCart();
                updateCartUI();
                
                // Remove the specific cart item from DOM using the captured item info
                removeCartItemFromDOM(item, index);
                
                // After removal, update indices of remaining items and re-attach event listeners
                setTimeout(() => {
                    updateCartItemIndices();
                    attachCartEventListeners();
                }, 350); // Wait for DOM removal animation to complete
            }
            
            function removeCartItemByIndex(index) {
                removeCartItem(index);
            }
            
            // Helper function to update specific cart item UI without full re-render
            function updateCartItemUI(index) {
                if (state.currentView !== 'cart') return;
                
                const cartItem = state.cart[index];
                if (!cartItem) return;
                
                // Find the cart item element by data attributes (more reliable than index)
                const itemElement = document.querySelector(`[data-branch-menu-id="${cartItem.branch_menu_id}"][data-cart-index="${index}"]`);
                if (!itemElement) return;
                
                // Update quantity display
                const quantityInput = itemElement.querySelector('.quantity-input');
                if (quantityInput) {
                    quantityInput.value = cartItem.quantity;
                }
                
                // Update price display
                const priceTotal = itemElement.querySelector('.price-total');
                if (priceTotal) {
                    priceTotal.textContent = `${formatPrice(cartItem.price)} × ${cartItem.quantity} = ${formatPrice(cartItem.price * cartItem.quantity)}`;
                }
                
                // Update cart summary
                updateCartSummaryUI();
            }
            
            // Helper function to update cart item indices after removal
            function updateCartItemIndices() {
                if (state.currentView !== 'cart') return;
                
                const cartItems = document.querySelectorAll('.cart-item');
                cartItems.forEach((itemElement, newIndex) => {
                    itemElement.setAttribute('data-cart-index', newIndex);
                    
                    // Update data-index attributes on all buttons within this item
                    const buttons = itemElement.querySelectorAll('[data-index]');
                    buttons.forEach(button => {
                        button.setAttribute('data-index', newIndex);
                    });
                });
            }
            
            // Helper function to attach event listeners to cart controls using event delegation
            function attachCartEventListeners() {
                if (state.currentView !== 'cart') return;
                
                // Remove any existing delegated listeners
                const cartContainer = document.getElementById('cart-container');
                if (!cartContainer) return;
                
                // Use event delegation for better performance
                cartContainer.removeEventListener('click', handleCartClick);
                cartContainer.addEventListener('click', handleCartClick);
            }
            
            // Centralized cart click handler
            function handleCartClick(e) {
                const target = e.target.closest('[data-action], .btn-remove, #checkout-btn');
                if (!target) return;
                
                if (target.hasAttribute('data-action')) {
                    const action = target.getAttribute('data-action');
                    const index = parseInt(target.getAttribute('data-index'));
                    if (isNaN(index)) return;
                    
                    if (action === 'decrease') {
                        updateCartItemQuantity(index, -1);
                    } else if (action === 'increase') {
                        updateCartItemQuantity(index, 1);
                    }
                } else if (target.classList.contains('btn-remove')) {
                    const index = parseInt(target.getAttribute('data-index'));
                    if (!isNaN(index)) {
                        removeCartItem(index);
                    }
                } else if (target.id === 'checkout-btn') {
                    if (state.currentBranch) {
                        window.location.hash = createBranchUrl(state.currentBranch, 'checkout');
                    } else {
                        window.location.hash = 'checkout';
                    }
                }
            }
            
            // Helper function to remove specific cart item from DOM without full re-render
            function removeCartItemFromDOM(item, index) {
                if (state.currentView !== 'cart') return;
                
                // Find the cart item element by data attributes using the passed item info
                const itemElement = document.querySelector(`[data-branch-menu-id="${item.branch_menu_id}"][data-cart-index="${index}"]`);
                if (!itemElement) return;
                
                // Add fade out animation
                itemElement.style.transition = 'opacity 0.3s ease-out';
                itemElement.style.opacity = '0';
                
                // Remove element after animation
                setTimeout(() => {
                    itemElement.remove();
                    
                    // Update cart summary
                    updateCartSummaryUI();
                    
                    // Show empty cart message if no items left
                    if (state.cart.length === 0) {
                        showEmptyCartMessage();
                    } else {
                        // Re-attach event listeners for remaining items
                        attachCartEventListeners();
                    }
                }, 300);
            }
            
            // Helper function to update cart summary without full re-render
            function updateCartSummaryUI() {
                if (state.currentView !== 'cart') return;
                
                const cartSummary = document.querySelector('.cart-summary');
                if (!cartSummary) return;
                
                // Recalculate totals
                let subtotal = 0;
                state.cart.forEach(item => {
                    subtotal += item.price * item.quantity;
                });
                
                const settings = state.currentBranch?.settings || {};
                const serviceChargePercentage = parseFloat(settings.service_charge_percentage) || 0;
                const vatPercentage = parseFloat(settings.vat_percentage) || 0;
                
                const serviceCharge = subtotal * (serviceChargePercentage / 100);
                const tax = (subtotal + serviceCharge) * (vatPercentage / 100);
                
                // Calculate discount if promo is applied
                const discountAmount = state.appliedPromo ? calculateDiscountAmount(subtotal, state.appliedPromo) : 0;
                const total = subtotal + serviceCharge + tax - discountAmount;
                
                // Update summary HTML
                cartSummary.innerHTML = `
                    <div class="summary-row">
                        <span>${translate('subtotal')}:</span>
                        <span>${formatPrice(subtotal)}</span>
                    </div>
                    ${serviceCharge > 0 ? `
                    <div class="summary-row">
                        <span>${translate('service_charge')} (${serviceChargePercentage}%):</span>
                        <span>${formatPrice(serviceCharge)}</span>
                    </div>
                    ` : ''}
                    ${tax > 0 ? `
                    <div class="summary-row">
                        <span>${translate('tax')} (${vatPercentage}%):</span>
                        <span>${formatPrice(tax)}</span>
                    </div>
                    ` : ''}
                    ${state.appliedPromo ? `
                    <div class="summary-row discount-row">
                        <span>${translate('discount')} (${state.appliedPromo.code}):</span>
                        <span>-${formatPrice(discountAmount)}</span>
                    </div>
                    ` : ''}
                    <div class="summary-row summary-total">
                        <span>${translate('total')}:</span>
                        <span>${formatPrice(total)}</span>
                    </div>
                    <button class="btn" id="checkout-btn">${translate('proceed_to_checkout')}</button>
                `;
                
                // Re-attach checkout button event listener
                const checkoutBtn = document.getElementById('checkout-btn');
                if (checkoutBtn) {
                    checkoutBtn.addEventListener('click', () => {
                        if (state.currentBranch) {
                            window.location.hash = createBranchUrl(state.currentBranch, 'checkout');
                        } else {
                            window.location.hash = 'checkout';
                        }
                    });
                }
            }
            
            // Helper function to show empty cart message
            function showEmptyCartMessage() {
                if (state.currentView !== 'cart') return;
                
                const cartContainer = document.getElementById('cart-container');
                if (!cartContainer) return;
                
                const browseMenuUrl = state.currentBranch ? 
                    createBranchUrl(state.currentBranch, 'menu') : 
                    '#menu';
                
                cartContainer.innerHTML = `
                    <div class="empty-cart">
                        <i class="fas fa-shopping-cart"></i>
                        <h3>${translate('empty_cart')}</h3>
                        <p>${translate('add_some_delicious_items')}</p>
                        <a href="${browseMenuUrl}" class="btn">${translate('browse_menu')}</a>
                    </div>
                `;
            }
            
            // Helper function to refresh cart view completely (if needed)
            function refreshCartView() {
                if (state.currentView !== 'cart') return;
                
                // Show skeleton briefly for better UX
                renderCartSkeleton();
                
                setTimeout(() => {
                    renderCart();
                }, 100);
            }
            
            // Enhanced cart state synchronization
            function synchronizeCartState() {
                // Ensure cart is properly loaded from localStorage
                loadCart();
                
                // Ensure current cart is updated based on current branch
                updateCurrentCart();
                
                // Update cart UI
                updateCartUI();
                
                // If we're currently on cart view, refresh it
                if (state.currentView === 'cart') {
                    refreshCartView();
                }
            }
            
            // Helper function to ensure branch settings are loaded
            async function ensureBranchSettings(branch) {
                if (!branch.settings) {
                    try {
                        const settings = await apiService.getBranchSettings(branch.branch_id);
                        branch.settings = settings.data || settings;
                        console.log('Loaded branch settings for:', branch.internal_name);
                    } catch (error) {
                        console.error('Failed to load branch settings:', error);
                        // Set default settings if loading fails
                        branch.settings = {
                            vat_percentage: 0,
                            service_charge_percentage: 0
                        };
                    }
                }
                return branch;
            }
            
            async function addFavoriteItemToCart(item) {
                if (!item.branch_id) {
                    showError(translate('item_branch_not_available'));
                    return;
                }
                
                // Find the branch for this item
                const itemBranch = state.branches.find(branch => branch.branch_id === item.branch_id);
                if (!itemBranch) {
                    showError(translate('branch_not_found'));
                    return;
                }
                
                // Ensure branch settings are loaded
                const branchWithSettings = await ensureBranchSettings(itemBranch);
                
                // Set current item and branch
                state.currentItem = item;
                state.currentBranch = branchWithSettings;
                state.currentQuantity = 1;
                state.currentCustomizations = {};
                
                // Update branch name displays and cart UI
                updateBranchNameDisplays();
                updateCurrentCart();
                updateCartUI();
                
                // Check for branch conflict
                const hasConflict = checkBranchConflict(item);
                
                if (hasConflict) {
                    // Show branch conflict modal
                    showBranchConflictModal(item, () => {
                        // This callback will be executed if user confirms
                        performAddToCart();
                    });
                    return;
                }
                
                // No conflict, proceed with normal add to cart
                performAddToCart();
            }
            
            function saveCart() {
                localStorage.setItem('lunaDineBranchCarts', JSON.stringify(state.branchCarts));
                localStorage.setItem('lunaDineCart', JSON.stringify(state.cart));
            }
            
            function loadCart() {
                const branchCartsData = localStorage.getItem('lunaDineBranchCarts');
                if (branchCartsData) {
                    state.branchCarts = JSON.parse(branchCartsData);
                }
                
                const cartData = localStorage.getItem('lunaDineCart');
                if (cartData) {
                    state.cart = JSON.parse(cartData);
                }
                
                // Ensure current cart is synchronized
                updateCurrentCart();
            }
            
            function updateCartUI() {
                const totalItems = state.cart.reduce((total, item) => total + item.quantity, 0);
                
                elements.cartCounts.forEach(element => {
                    element.textContent = totalItems;
                });
            }
            
            // Favorites management
            function toggleFavorite(item) {
                const index = state.favorites.findIndex(fav => fav.branch_menu_id === item.branch_menu_id);
                
                if (index >= 0) {
                    // Remove from favorites
                    const removedItem = state.favorites[index];
                    state.favorites.splice(index, 1);
                    
                    // Remove from DOM without full re-render if we're on favorites page
                    if (state.currentView === 'favorites') {
                        removeFavoriteFromDOM(removedItem, index);
                    }
                } else {
                    // Add to favorites
                    const itemWithBranch = { ...item };
                    
                    // If item doesn't have branch_id, try to get it from current branch
                    if (!itemWithBranch.branch_id && state.currentBranch) {
                        itemWithBranch.branch_id = state.currentBranch.branch_id;
                    }
                    
                    // If still no branch_id, try to find it from branches array
                    if (!itemWithBranch.branch_id && state.branches.length > 0) {
                        // Assume the item belongs to the first available branch
                        // This is a fallback - ideally items should have branch_id
                        itemWithBranch.branch_id = state.branches[0].branch_id;
                    }
                    
                    state.favorites.push(itemWithBranch);
                    
                    // If we're on favorites page, add to DOM without full re-render
                    if (state.currentView === 'favorites') {
                        addFavoriteToDOM(itemWithBranch, state.favorites.length - 1);
                    }
                }
                
                saveFavorites();
            }
            
            function saveFavorites() {
                localStorage.setItem('lunaDineFavorites', JSON.stringify(state.favorites));
            }
            
            function loadFavorites() {
                const favoritesData = localStorage.getItem('lunaDineFavorites');
                if (favoritesData) {
                    state.favorites = JSON.parse(favoritesData);
                    
                    // Ensure all loaded favorites have branch_id
                    state.favorites = state.favorites.map(fav => {
                        if (!fav.branch_id) {
                            // Try to get branch_id from current branch
                            if (state.currentBranch) {
                                fav.branch_id = state.currentBranch.branch_id;
                            }
                            // If still no branch_id, try to find it from branches array
                            else if (state.branches.length > 0) {
                                fav.branch_id = state.branches[0].branch_id;
                            }
                        }
                        return fav;
                    });
                    
                    // Save the updated favorites back to localStorage
                    saveFavorites();
                }
            }
            
            // Helper function to remove favorite item from DOM without full re-render
            function removeFavoriteFromDOM(item, index) {
                if (state.currentView !== 'favorites') return;
                
                // Find the favorite item element by data attributes
                const itemElement = document.querySelector(`[data-branch-menu-id="${item.branch_menu_id}"][data-favorite-index="${index}"]`);
                if (!itemElement) return;
                
                // Add fade out animation
                itemElement.style.transition = 'opacity 0.3s ease-out, transform 0.3s ease-out';
                itemElement.style.opacity = '0';
                itemElement.style.transform = 'scale(0.9)';
                
                // Remove element after animation
                setTimeout(() => {
                    itemElement.remove();
                    
                    // Update remaining indices
                    updateFavoriteIndices();
                    
                    // Show empty state if no favorites left
                    if (state.favorites.length === 0) {
                        showEmptyFavoritesMessage();
                    }
                }, 300);
            }
            
            // Helper function to add favorite item to DOM without full re-render
            function addFavoriteToDOM(item, index) {
                if (state.currentView !== 'favorites') return;
                
                const favoritesGrid = document.querySelector('.menu-items-grid');
                if (!favoritesGrid) return;
                
                // Create the favorite item card
                const itemCard = document.createElement('div');
                itemCard.className = 'menu-item-card';
                itemCard.setAttribute('data-branch-menu-id', item.branch_menu_id);
                itemCard.setAttribute('data-favorite-index', index);
                
                const isFeatured = item.is_featured || false;
                const quantity = getItemQuantityInCart(item.branch_menu_id);
                
                itemCard.innerHTML = `
                    <div class="menu-item-image-container">
                        <img src="${item.image_url || '/images/food-default.jpg'}" alt="${item.item_name}" class="menu-item-image">
                        ${isFeatured ? '<span class="menu-item-badge">Featured</span>' : ''}
                    </div>
                    <div class="menu-item-content">
                        <div class="menu-item-header">
                            <h4 class="menu-item-name">${getTranslation(item.item_name, item.name_translation_key)}</h4>
                            <div class="menu-item-price">${formatPrice(item.price)}</div>
                        </div>
                        <p class="item-desc">${getTranslation(item.item_description, item.description_translation_key) || translate('delicious_menu_item')}</p>
                        <div class="menu-item-footer">
                            <div class="prep-time-with-favorite">
                                <span class="prep-time"><i class="fas fa-clock"></i> ${item.preparation_time_minutes || 15} ${translate('mins')}</span>
                                <button class="btn-favorite active" data-item-id="${item.branch_menu_id}">
                                    <i class="fas fa-heart"></i>
                                </button>
                            </div>
                        </div>
                    </div>
                `;
                
                // Add fade in animation
                itemCard.style.opacity = '0';
                itemCard.style.transform = 'scale(0.9)';
                itemCard.style.transition = 'opacity 0.3s ease-out, transform 0.3s ease-out';
                
                favoritesGrid.appendChild(itemCard);
                
                // Trigger animation
                setTimeout(() => {
                    itemCard.style.opacity = '1';
                    itemCard.style.transform = 'scale(1)';
                }, 10);
                
                // Attach event listeners
                attachFavoriteItemEventListeners(itemCard, item, index);
                // Note: Removed setupQuantityControllerEvents for favorites page
            }
            
            // Helper function to update favorite item indices after removal
            function updateFavoriteIndices() {
                if (state.currentView !== 'favorites') return;
                
                const favoriteItems = document.querySelectorAll('.menu-item-card[data-favorite-index]');
                favoriteItems.forEach((itemElement, newIndex) => {
                    itemElement.setAttribute('data-favorite-index', newIndex);
                    
                    // Update data-index attributes on buttons within this item
                    const buttons = itemElement.querySelectorAll('[data-index]');
                    buttons.forEach(button => {
                        button.setAttribute('data-index', newIndex);
                    });
                });
            }
            
            // Helper function to attach event listeners to favorite item
            function attachFavoriteItemEventListeners(itemElement, item, index) {
                // Item click event (show details)
                itemElement.addEventListener('click', (e) => {
                    // Don't trigger if clicking on buttons
                    if (e.target.closest('.menu-item-actions') || e.target.closest('.item-actions')) return;
                    
                    showItemDetailModal(item);
                });
                
                // Favorite button event
                const favoriteBtn = itemElement.querySelector('.btn-favorite');
                if (favoriteBtn) {
                    favoriteBtn.addEventListener('click', (e) => {
                        e.stopPropagation();
                        toggleFavorite(item);
                    });
                }
                
                // Add to cart button event
                const addToCartBtn = itemElement.querySelector('.btn-add-to-cart');
                if (addToCartBtn) {
                    addToCartBtn.addEventListener('click', (e) => {
                        e.stopPropagation();
                        addFavoriteItemToCart(item);
                    });
                }
            }
            
            // Helper function to show empty favorites message
            function showEmptyFavoritesMessage() {
                if (state.currentView !== 'favorites') return;
                
                const favoritesContainer = document.getElementById('favorites-container');
                if (!favoritesContainer) return;
                
                const browseMenuUrl = state.currentBranch ? 
                    createBranchUrl(state.currentBranch, 'menu') : 
                    '#menu';
                
                favoritesContainer.innerHTML = `
                    <div class="empty-state">
                        <i class="fas fa-heart"></i>
                        <h3>${translate('empty_favorites')}</h3>
                        <p>${translate('start_adding_favorites')}</p>
                        <a href="${browseMenuUrl}" class="btn">${translate('browse_menu')}</a>
                    </div>
                `;
            }
            
            // Helper function to refresh favorites view completely (if needed)
            function refreshFavoritesView() {
                if (state.currentView !== 'favorites') return;
                
                // Show skeleton briefly for better UX
                renderFavoritesSkeleton();
                
                setTimeout(() => {
                    renderFavorites();
                }, 100);
            }
            
            // Enhanced favorites state synchronization
            function synchronizeFavoritesState() {
                // Ensure favorites are properly loaded from localStorage
                loadFavorites();
                
                // If we're currently on favorites view, refresh it
                if (state.currentView === 'favorites') {
                    refreshFavoritesView();
                }
            }
            
            // User data management
            function saveUserData() {
                const userData = {
                    favorites: state.favorites,
                    orderHistory: state.orderHistory,
                    userOrderIds: state.userOrderIds,
                    userInfo: state.userInfo,
                    language: state.language
                };
                
                localStorage.setItem('lunaDineUser', JSON.stringify(userData));
            }
            
            function loadUserData() {
                const userData = localStorage.getItem('lunaDineUser');
                
                if (userData) {
                    const parsedData = JSON.parse(userData);
                    state.favorites = parsedData.favorites || [];
                    state.orderHistory = parsedData.orderHistory || [];
                    state.userOrderIds = parsedData.userOrderIds || [];
                    state.userInfo = parsedData.userInfo || null;
                    state.language = parsedData.language || 'en-US';
                }
                
                loadCart();
                loadFavorites();
            }
            
            // Modal management
            function hideModal(modalId) {
                document.getElementById(modalId).classList.remove('active');
            }
            
            // Enhanced showModal function with history management
            function showModal(modalId) {
                console.log('showModal called with:', modalId);
                const modalElement = document.getElementById(modalId);
                if (!modalElement) {
                    console.error('Modal element not found:', modalId);
                    return;
                }
                console.log('Modal element found:', modalElement);
                console.log('Modal current classes:', modalElement.className);
                
                modalElement.classList.add('active');
                console.log('Modal classes after adding active:', modalElement.className);
                
                // Push history state to enable back button functionality
                // This creates a history entry that the back button can return to
                const currentState = history.state || {};
                history.pushState(
                    { ...currentState, modalOpen: true, modalId: modalId }, 
                    '', 
                    window.location.hash
                );
                console.log('History state pushed for modal:', modalId);
            }
            
            // Setup modal event listeners after DOM is loaded
            document.addEventListener('DOMContentLoaded', function() {
                // Initialize performance optimizations
                performanceUtils.init();
                
                // Initialize modern JavaScript features
                modernJS.init();
                
                // Initialize accessibility features
                accessibilityUtils.init();
                
                // Close modal when clicking outside the modal content
                document.querySelectorAll('.modal-overlay').forEach(overlay => {
                    overlay.addEventListener('click', (e) => {
                        // Only close if clicking directly on the overlay (not on modal content)
                        if (e.target === overlay) {
                            const modalId = overlay.id;
                            hideModal(modalId);
                            
                            // Only update URL for item detail modal if it's different from current menu URL
                            // This prevents unnecessary URL changes that might trigger re-renders
                            if (modalId === 'item-detail-modal' && state.currentBranch) {
                                const currentHash = window.location.hash;
                                const menuUrl = createBranchUrl(state.currentBranch, 'menu');
                                
                                // Only update URL if we're not already on the menu page
                                if (!currentHash.includes('/menu') && currentHash !== menuUrl) {
                                    // Use replaceState instead of hash assignment to avoid router trigger
                                    history.replaceState(null, null, menuUrl);
                                }
                            }
                        }
                    });
                });
            });
            
            // Handle browser back button to close modals (moved outside DOMContentLoaded for better mobile support)
            window.addEventListener('popstate', (e) => {
                console.log('popstate event fired', e);
                console.log('Current URL:', window.location.hash);
                console.log('History state:', e.state);
                
                // Check if we're closing a modal (history state indicates modal was open)
                const wasModalOpen = e.state && e.state.modalOpen;
                const activeModals = document.querySelectorAll('.modal-overlay.active');
                console.log('Active modals found:', activeModals.length);
                console.log('Was modal open in history:', wasModalOpen);
                
                if (activeModals.length > 0 || wasModalOpen) {
                    console.log('Closing modals due to back button');
                    // Close all active modals without updating URL
                    // The back button should just close the modal, not navigate
                    activeModals.forEach(modal => {
                        const modalId = modal.id;
                        console.log('Closing modal:', modalId);
                        hideModal(modalId);
                    });
                    
                    // Prevent the default back navigation since we handled the modal closing
                    e.preventDefault();
                    console.log('Prevented default navigation');
                } else {
                    console.log('No active modals and no modal in history, allowing default navigation');
                }
            });
            
            // Override the existing hashchange handler to prevent re-render when closing modals
            const originalHandleRouteChange = handleRouteChange;
            function enhancedHandleRouteChange(isInitialLoad = false) {
                console.log('enhancedHandleRouteChange called, isInitialLoad:', isInitialLoad);
                console.log('Current hash:', window.location.hash);
                
                // Check if we're closing a modal (has modal in history state)
                const historyState = history.state || {};
                const wasModalOpen = historyState.modalOpen;
                const activeModals = document.querySelectorAll('.modal-overlay.active');
                
                console.log('Active modals:', activeModals.length);
                console.log('Was modal open in history:', wasModalOpen);
                
                // If we just closed a modal, don't re-render the page
                if (wasModalOpen && activeModals.length === 0) {
                    console.log('Modal just closed, preventing route change to avoid re-render');
                    // Clear the modal state from history
                    history.replaceState({}, '', window.location.hash);
                    return; // Don't proceed with route change
                }
                
                // Otherwise, proceed with normal route handling
                console.log('Proceeding with normal route handling');
                return originalHandleRouteChange.call(this, isInitialLoad);
            }
            
            // Replace the original hashchange handler
            window.removeEventListener('hashchange', handleRouteChange);
            window.addEventListener('hashchange', enhancedHandleRouteChange);
            
            // Confirmation modal management
            let confirmationCallback = null;
            
            function showConfirmationModal(message, onConfirm) {
                const messageElement = document.getElementById('confirmation-message');
                const modal = document.getElementById('confirmation-modal');
                
                if (messageElement && modal) {
                    messageElement.textContent = message;
                    confirmationCallback = onConfirm;
                    showModal('confirmation-modal');
                }
            }
            
            function handleConfirmationConfirm() {
                if (confirmationCallback) {
                    confirmationCallback();
                    confirmationCallback = null;
                }
                hideModal('confirmation-modal');
            }
            
            function handleConfirmationCancel() {
                confirmationCallback = null;
                hideModal('confirmation-modal');
            }
            
            // Service requests
            function submitServiceRequest() {
                if (!state.currentBranch) {
                    showError(translate('please_select_branch'));
                    return;
                }
                
                const requestData = {
                    branch_id: state.currentBranch.branch_id,
                    table_id: state.currentTable?.table_id || 1,
                    request_type: elements.requestType.value
                };
                
                if (elements.requestType.value === 'OTHER') {
                    requestData.notes = elements.otherRequest.value;
                }
                
                apiService.createServiceRequest(requestData)
                    .then(() => {
                        hideModal('service-modal');
                        showToast(translate('service_request_submitted'));
                    })
                    .catch(error => {
                        console.error('Failed to submit service request:', error);
                    });
            }
            
            // Auto-select first available branch if none is selected
            async function ensureBranchSelected() {
                if (state.currentBranch) {
                    return true;
                }
                
                try {
                    const branches = await apiService.getBranches();
                    const availableBranches = branches.data || branches;
                    
                    if (availableBranches && availableBranches.length > 0) {
                        state.currentBranch = availableBranches[0];
                        console.log('Auto-selected branch:', state.currentBranch);
                        return true;
                    }
                } catch (error) {
                    console.error('Failed to auto-select branch:', error);
                }
                
                return false;
            }
            
            // Validate customizations against API before placing order
            async function validateCustomizationsWithAPI(cartItems) {
                const validationResults = [];
                
                for (const item of cartItems) {
                    if (item.customizations && Object.keys(item.customizations).length > 0) {
                        try {
                            console.log(`Validating customizations for item ${item.branch_menu_id}`);
                            
                            // Get the available customization options from API
                            const response = await apiService.getCustomizations(item.branch_menu_id);
                            const availableOptions = response.data || response;
                            console.log(`Available options for item ${item.branch_menu_id}:`, availableOptions);
                            
                            // Transform our customizations to API format
                            const transformedCustomizations = transformCustomizationsForAPI(item.customizations, item.branch_menu_id);
                            console.log(`Transformed customizations for item ${item.branch_menu_id}:`, transformedCustomizations);
                            
                            // Validate each transformed customization
                            for (const customization of transformedCustomizations) {
                                console.log(`Validating customization:`, customization);
                                
                                // Find the group in available options
                                const group = availableOptions.groups?.find(g => g.id === customization.group_id);
                                if (!group) {
                                    validationResults.push({
                                        item_id: item.branch_menu_id,
                                        error: `Group ${customization.group_id} not found in available options`
                                    });
                                    continue;
                                }
                                
                                // Validate selected options exist in the group
                                for (const optionId of customization.selected_options) {
                                    const optionExists = group.options?.some(opt => opt.id === optionId);
                                    if (!optionExists) {
                                        validationResults.push({
                                            item_id: item.branch_menu_id,
                                            error: `Option ${optionId} not found in group ${customization.group_id}`
                                        });
                                    }
                                }
                                
                                // Validate group type constraints
                                if (group.type === 'radio' && customization.selected_options.length > 1) {
                                    validationResults.push({
                                        item_id: item.branch_menu_id,
                                        error: `Radio group ${customization.group_id} cannot have multiple selections`
                                    });
                                }
                                
                                if (group.required && customization.selected_options.length === 0) {
                                    validationResults.push({
                                        item_id: item.branch_menu_id,
                                        error: `Required group ${customization.group_id} has no selections`
                                    });
                                }
                            }
                            
                        } catch (error) {
                            validationResults.push({
                                item_id: item.branch_menu_id,
                                error: `Failed to validate customizations: ${error.message}`
                            });
                        }
                    }
                }
                
                return validationResults;
            }
            
            // Transform customizations from frontend format to API format
            function transformCustomizationsForAPI(customizations, branchMenuId) {
                if (!customizations || typeof customizations !== 'object') {
                    console.log('No customizations to transform');
                    return [];
                }
                
                console.log('Transforming customizations for branch_menu_id', branchMenuId, ':', customizations);
                
                const apiCustomizations = [];
                
                Object.entries(customizations).forEach(([groupId, groupData]) => {
                    if (Array.isArray(groupData)) {
                        // Checkbox group - multiple selections
                        if (groupData.length > 0) {
                            apiCustomizations.push({
                                group_id: groupId,
                                selected_options: groupData.map(option => option.optionId)
                            });
                            console.log(`Added checkbox group ${groupId}:`, groupData.map(option => option.optionId));
                        }
                    } else if (groupData && groupData.optionId) {
                        // Radio group - single selection
                        apiCustomizations.push({
                            group_id: groupId,
                            selected_options: [groupData.optionId]
                        });
                        console.log(`Added radio group ${groupId}:`, [groupData.optionId]);
                    }
                });
                
                console.log('Transformed API customizations:', apiCustomizations);
                return apiCustomizations;
            }
            
            // Enhanced validation for checkout fields
            function validateCheckoutFields() {
                const orderType = document.querySelector('.order-type-btn.active');
                if (!orderType) {
                    return { valid: false, message: 'Please select an order type' };
                }
                
                const type = orderType.getAttribute('data-type');
                const errors = [];
                
                // Clear previous errors
                validationUtils.clearAllErrors();
                
                switch(type) {
                    case 'dine-in':
                        const tableNumber = document.getElementById('table-number');
                        if (!tableNumber || !tableNumber.value) {
                            errors.push('Table Number is required');
                            validationUtils.showFieldError('table-number', 'Table number is required');
                        }
                        break;
                        
                    case 'takeaway':
                        const customerName = document.getElementById('customer-name');
                        const customerPhone = document.getElementById('customer-phone');
                        const pickupTime = document.getElementById('pickup-time');
                        
                        // Validate name
                        if (customerName) {
                            const nameValidation = validationUtils.validateName(customerName.value);
                            if (!nameValidation.valid) {
                                errors.push(nameValidation.message);
                                validationUtils.showFieldError('customer-name', nameValidation.message);
                            }
                        } else {
                            errors.push('Customer name field not found');
                        }
                        
                        // Validate phone
                        if (customerPhone) {
                            const phoneValidation = validationUtils.validatePhone(customerPhone.value);
                            if (!phoneValidation.valid) {
                                errors.push(phoneValidation.message);
                                validationUtils.showFieldError('customer-phone', phoneValidation.message);
                            }
                        } else {
                            errors.push('Phone number field not found');
                        }
                        
                        // Validate pickup time
                        if (!pickupTime || !pickupTime.value) {
                            errors.push('Pickup time is required');
                            validationUtils.showFieldError('pickup-time', 'Pickup time is required');
                        }
                        break;
                        
                    case 'delivery':
                        const deliveryCustomerName = document.getElementById('customer-name');
                        const deliveryCustomerPhone = document.getElementById('customer-phone');
                        const deliveryAddress = document.getElementById('delivery-address');
                        
                        // Validate delivery name
                        if (deliveryCustomerName) {
                            const nameValidation = validationUtils.validateName(deliveryCustomerName.value);
                            if (!nameValidation.valid) {
                                errors.push(nameValidation.message);
                                validationUtils.showFieldError('customer-name', nameValidation.message);
                            }
                        } else {
                            errors.push('Customer name field not found');
                        }
                        
                        // Validate delivery phone
                        if (deliveryCustomerPhone) {
                            const phoneValidation = validationUtils.validatePhone(deliveryCustomerPhone.value);
                            if (!phoneValidation.valid) {
                                errors.push(phoneValidation.message);
                                validationUtils.showFieldError('customer-phone', phoneValidation.message);
                            }
                        } else {
                            errors.push('Phone number field not found');
                        }
                        
                        // Validate delivery address
                        if (!deliveryAddress || !deliveryAddress.value.trim()) {
                            errors.push('Delivery address is required');
                            validationUtils.showFieldError('delivery-address', 'Delivery address is required');
                        } else if (deliveryAddress.value.trim().length < 10) {
                            errors.push('Please provide a complete delivery address');
                            validationUtils.showFieldError('delivery-address', 'Please provide a complete delivery address');
                        }
                        break;
                }
                
                // Validate payment method
                const paymentMethod = document.getElementById('payment-method');
                if (!paymentMethod || !paymentMethod.value) {
                    errors.push('Payment method is required');
                    validationUtils.showFieldError('payment-method', 'Payment method is required');
                }
                
                return {
                    valid: errors.length === 0,
                    message: errors.length > 0 ? errors.join(', ') : null,
                    errors: errors
                };
            }
            
            // Setup pickup time functionality
            function setupPickupTime() {
                const timeInput = document.getElementById('pickup-time-input');
                const hiddenInput = document.getElementById('pickup-time');
                const display = document.getElementById('pickup-time-display');
                
                if (timeInput) {
                    // Set minimum time to current time
                    const now = new Date();
                    const currentHour = now.getHours().toString().padStart(2, '0');
                    const currentMinute = now.getMinutes().toString().padStart(2, '0');
                    const minTime = `${currentHour}:${currentMinute}`;
                    timeInput.min = minTime;
                    
                    // Add click event to ensure time picker appears
                    timeInput.addEventListener('click', function() {
                        // Force the time picker to show
                        this.showPicker();
                    });
                    
                    // Add input event to validate time selection
                    timeInput.addEventListener('input', function() {
                        validateAndUpdateTime(this);
                    });
                    
                    // Add change event for final validation
                    timeInput.addEventListener('change', function() {
                        validateAndUpdateTime(this);
                    });
                    
                    // Function to validate and update time
                    function validateAndUpdateTime(input) {
                        const selectedTime = input.value;
                        if (selectedTime) {
                            // Validate that selected time is not in the past
                            const now = new Date();
                            const selectedDateTime = new Date();
                            const [hours, minutes] = selectedTime.split(':');
                            selectedDateTime.setHours(parseInt(hours), parseInt(minutes), 0, 0);
                            
                            if (selectedDateTime <= now) {
                                // If selected time is in the past or now, reset to minimum time
                                input.value = minTime;
                                const today = new Date();
                                const dateStr = today.toISOString().split('T')[0];
                                const datetimeStr = `${dateStr}T${minTime}`;
                                hiddenInput.value = datetimeStr;
                                
                                // Show user-friendly display
                                const dateObj = new Date(datetimeStr);
                                updateTimeDisplay(dateObj);
                                
                                // Show warning message
                                showTimeWarning();
                            } else {
                                // Valid future time selected
                                const today = new Date();
                                const dateStr = today.toISOString().split('T')[0];
                                const datetimeStr = `${dateStr}T${selectedTime}`;
                                hiddenInput.value = datetimeStr;
                                
                                // Show user-friendly display
                                const dateObj = new Date(datetimeStr);
                                updateTimeDisplay(dateObj);
                            }
                        } else {
                            hiddenInput.value = '';
                            display.textContent = '';
                        }
                    }
                    
                    // Function to update time display
                    function updateTimeDisplay(dateObj) {
                        const options = { 
                            weekday: 'short', 
                            year: 'numeric', 
                            month: 'short', 
                            day: 'numeric',
                            hour: '2-digit', 
                            minute: '2-digit'
                        };
                        display.textContent = `📅 Pickup: ${dateObj.toLocaleDateString('en-US', options)}`;
                        display.style.color = 'var(--uber-green)';
                        display.style.fontWeight = '600';
                        display.style.marginTop = 'var(--spacing-4)';
                        display.style.fontSize = 'var(--font-size-14)';
                    }
                    
                    // Function to show time warning
                    function showTimeWarning() {
                        const warning = document.createElement('div');
                        warning.textContent = '⚠️ Please select a future time for pickup';
                        warning.style.color = 'var(--uber-red)';
                        warning.style.fontSize = 'var(--font-size-12)';
                        warning.style.marginTop = 'var(--spacing-4)';
                        warning.style.fontWeight = '500';
                        
                        // Remove any existing warning
                        const existingWarning = display.parentNode.querySelector('.time-warning');
                        if (existingWarning) {
                            existingWarning.remove();
                        }
                        
                        // Add new warning
                        warning.className = 'time-warning';
                        display.parentNode.insertBefore(warning, display.nextSibling);
                        
                        // Remove warning after 3 seconds
                        setTimeout(() => {
                            if (warning.parentNode) {
                                warning.remove();
                            }
                        }, 3000);
                    }
                    
                    // Add placeholder text to guide user
                    timeInput.placeholder = 'Select pickup time';
                    timeInput.style.cursor = 'pointer';
                    
                    // Add focus event to enhance UX
                    timeInput.addEventListener('focus', function() {
                        this.style.borderColor = 'var(--uber-green)';
                        this.style.boxShadow = '0 0 0 3px rgba(6, 193, 103, 0.1)';
                    });
                    
                    timeInput.addEventListener('blur', function() {
                        this.style.borderColor = '';
                        this.style.boxShadow = '';
                    });
                }
            }
            
            // Order placement
            async function placeOrder() {
                // Validate required fields based on order type
                const validation = validateCheckoutFields();
                if (!validation.valid) {
                    showError(validation.message);
                    return;
                }
                
                // Ensure we have a branch selected
                const hasBranch = await ensureBranchSelected();
                if (!hasBranch) {
                    showError('No available branches. Please contact support.');
                    return;
                }
                
                if (state.cart.length === 0) {
                    showError('Your cart is empty');
                    return;
                }
                
                const orderType = document.querySelector('.order-type-btn.active').getAttribute('data-type');
                
                const orderData = {
                    branch_id: state.currentBranch.branch_id,
                    order_type: orderType,
                    items: state.cart.map(item => ({
                        item_id: item.item_id,
                        quantity: item.quantity,
                        customizations: transformCustomizationsForAPI(item.customizations, item.branch_menu_id)
                    }))
                };
                
                // Add order type specific data
                switch(orderType) {
                    case 'dine-in':
                        const tableNumber = document.getElementById('table-number');
                        orderData.table_id = tableNumber ? tableNumber.value : null;
                        const guestsCount = document.getElementById('guests-count');
                        orderData.guests_count = guestsCount ? parseInt(guestsCount.value) : 1;
                        break;
                    case 'takeaway':
                        const customerName = document.getElementById('customer-name');
                        orderData.customer_name = customerName ? customerName.value : '';
                        const customerPhone = document.getElementById('customer-phone');
                        orderData.customer_phone = customerPhone ? customerPhone.value : '';
                        const pickupTime = document.getElementById('pickup-time'); // Hidden field
                        orderData.pickup_time = pickupTime ? pickupTime.value : '';
                        break;
                    case 'delivery':
                        const deliveryCustomerName = document.getElementById('customer-name');
                        orderData.customer_name = deliveryCustomerName ? deliveryCustomerName.value : '';
                        const deliveryCustomerPhone = document.getElementById('customer-phone');
                        orderData.customer_phone = deliveryCustomerPhone ? deliveryCustomerPhone.value : '';
                        const deliveryAddress = document.getElementById('delivery-address');
                        orderData.delivery_address = deliveryAddress ? deliveryAddress.value : '';
                        
                        // Calculate delivery charge
                        const deliveryFeeConfig = state.currentBranch?.settings?.delivery_fee_config;
                        const subtotal = calculateCartSubtotal();
                        if (deliveryFeeConfig) {
                            try {
                                orderData.delivery_charge_amount = calculateDeliveryCharge(deliveryFeeConfig, subtotal);
                            } catch (e) {
                                console.error('Error calculating delivery charge:', e);
                                orderData.delivery_charge_amount = 0;
                            }
                        } else {
                            // Fallback: Default delivery charge if no config found
                            orderData.delivery_charge_amount = 50; // Default amount
                        }
                        break;
                }
                
                // Add payment method
                const paymentMethod = document.getElementById('payment-method');
                orderData.payment_method = paymentMethod ? paymentMethod.value : 'cash';
                
                // Add special instructions
                const specialInstructions = document.getElementById('special-instructions');
                orderData.special_instructions = specialInstructions ? specialInstructions.value : '';
                
                // Add promo code if applied
                if (state.appliedPromo) {
                    orderData.promo_id = state.appliedPromo.promo_id;
                    orderData.discount_amount = state.appliedPromo.discount_amount;
                }
                
                // Save customer info for future orders
                state.userInfo = {
                    name: document.getElementById('customer-name')?.value || '',
                    phone: document.getElementById('customer-phone')?.value || '',
                    address: document.getElementById('delivery-address')?.value || ''
                };
                
                saveUserData();
                
                // Validate customizations before placing order
                console.log('Validating customizations for cart items...');
                const validationErrors = await validateCustomizationsWithAPI(state.cart);
                
                if (validationErrors.length > 0) {
                    console.error('Customization validation errors:', validationErrors);
                    const errorMessage = validationErrors.map(error => error.error).join(', ');
                    showError('Invalid customizations: ' + errorMessage);
                    return;
                }
                
                console.log('Customization validation passed');
                console.log('Placing order with data:', orderData);
                
                apiService.createOrder(orderData)
                    .then(response => {
                        console.log('Order response:', response);
                        
                        // Only clear cart on successful order
                        if (response && response.data) {
                            // Clear current branch cart
                            if (state.currentBranch) {
                                state.branchCarts[state.currentBranch.branch_id] = [];
                                state.cart = [];
                                saveCart();
                                updateCurrentCart();
                                updateCartUI();
                            }
                            
                            // Clear applied promo code
                            state.appliedPromo = null;
                            
                            // Save to order history (restore local storage for immediate display)
                            state.orderHistory.push({
                                order_uid: response.data.order_uid,
                                date: new Date(),
                                created_at: new Date().toISOString(),
                                items: orderData.items,
                                final_amount: response.data.final_amount || 0,
                                status: 'pending'
                            });
                            
                            // Also track this order UID for API verification
                            if (!state.userOrderIds) {
                                state.userOrderIds = [];
                            }
                            state.userOrderIds.push(response.data.order_uid);
                            
                            saveUserData();
                            
                            // Show success message
                            showToast(translate('order_placed_success'));
                            
                            // Redirect to order tracking
                            setTimeout(() => {
                                window.location.hash = `order/${response.data.order_uid}`;
                            }, 1500);
                        } else {
                            // Handle error case - don't clear cart
                            console.error('Invalid order response:', response);
                            showError('Failed to place order. Invalid response from server.');
                        }
                    })
                    .catch(error => {
                        console.error('Failed to place order:', error);
                        console.error('Error details:', error.message);
                        showError(translate('order_failed') + ': ' + (error.message || 'Unknown error'));
                    });
            }
            
            // Order cancellation
            async function cancelOrder(orderId) {
                // Show confirmation modal instead of alert
                showConfirmationModal(
                    translate('confirm_cancel_order'),
                    () => {
                        // This function will be called when user confirms
                        performOrderCancellation(orderId);
                    }
                );
            }
            
            // Function to actually perform the order cancellation
            async function performOrderCancellation(orderId) {
                try {
                    showLoading();
                    const response = await apiService.cancelOrder(orderId);
                    hideLoading();
                    showToast(translate('order_cancelled_success'));
                    
                    // Update order in history
                    const orderIndex = state.orderHistory.findIndex(order => order.order_uid === orderId);
                    if (orderIndex !== -1) {
                        state.orderHistory[orderIndex].status = 'cancelled';
                        saveUserData();
                        renderOrderHistory();
                    }
                    
                    // Redirect to order history after cancellation
                    setTimeout(() => {
                        window.location.hash = '#orders';
                    }, 1500);
                } catch (error) {
                    hideLoading();
                    console.error('Failed to cancel order:', error);
                    showError(translate('cancel_order_failed'));
                }
            }
            
            // Utility functions
            function formatPrice(price) {
                return new Intl.NumberFormat('en-BD', {
                    style: 'currency',
                    currency: 'BDT'
                }).format(price);
            }
            
            function formatCustomizations(customizations) {
                if (!customizations || typeof customizations !== 'object' || Object.keys(customizations).length === 0) {
                    return '';
                }
                
                // Check if customizations is in API format (array of objects) or frontend format (object with groups)
                let customizationData;
                if (Array.isArray(customizations)) {
                    // API format: [{group_id: "x", selected_options: ["a", "b"]}]
                    customizationData = {};
                    
                    customizations.forEach(group => {
                        if (group.group_id && group.selected_options && Array.isArray(group.selected_options)) {
                            if (group.selected_options.length === 1) {
                                // Single selection (radio) - store as object
                                customizationData[group.group_id] = {
                                    optionId: group.selected_options[0]
                                };
                            } else {
                                // Multiple selections (checkbox) - store as array
                                customizationData[group.group_id] = group.selected_options.map(optionId => ({
                                    optionId: optionId
                                }));
                            }
                        }
                    });
                } else {
                    // Frontend format: {groupId: {optionId: "x"} or [{optionId: "x"}, {optionId: "y"}]}
                    customizationData = customizations;
                }
                
                const customizationTexts = [];
                
                Object.entries(customizationData).forEach(([groupId, groupData]) => {
                    if (Array.isArray(groupData)) {
                        // Checkbox group - multiple selections
                        if (groupData.length > 0) {
                            const optionNames = groupData.map(option => {
                                // Try to get a readable name from the option
                                if (option.optionId) {
                                    return option.optionId.charAt(0).toUpperCase() + option.optionId.slice(1).replace(/_/g, ' ');
                                }
                                return '';
                            }).filter(name => name);
                            
                            if (optionNames.length > 0) {
                                customizationTexts.push(optionNames.join(', '));
                            }
                        }
                    } else if (groupData && groupData.optionId) {
                        // Radio group - single selection
                        const optionName = groupData.optionId.charAt(0).toUpperCase() + groupData.optionId.slice(1).replace(/_/g, ' ');
                        customizationTexts.push(optionName);
                    }
                });
                
                return customizationTexts.length > 0 ? customizationTexts.join(', ') : '';
            }
            
            function formatDetailedPrice(item) {
                if (!item.customizations || typeof item.customizations !== 'object' || Object.keys(item.customizations).length === 0) {
                    return formatPrice(item.price);
                }
                
                let customizationPrice = 0;
                const customizationDetails = [];
                
                Object.entries(item.customizations).forEach(([groupId, groupData]) => {
                    if (Array.isArray(groupData)) {
                        // Checkbox group - multiple selections
                        groupData.forEach(option => {
                            if (option.priceAdjustment && option.priceAdjustment > 0) {
                                customizationPrice += option.priceAdjustment;
                                customizationDetails.push(`+${formatPrice(option.priceAdjustment)} (${option.optionId.charAt(0).toUpperCase() + option.optionId.slice(1).replace(/_/g, ' ')})`);
                            }
                        });
                    } else if (groupData && groupData.priceAdjustment && groupData.priceAdjustment > 0) {
                        // Radio group - single selection
                        customizationPrice += groupData.priceAdjustment;
                        customizationDetails.push(`+${formatPrice(groupData.priceAdjustment)} (${groupData.optionId.charAt(0).toUpperCase() + groupData.optionId.slice(1).replace(/_/g, ' ')})`);
                    }
                });
                
                if (customizationPrice === 0) {
                    return formatPrice(item.price);
                }
                
                const basePrice = item.base_price || (item.price - customizationPrice);
                return `${formatPrice(basePrice)} ${customizationDetails.join(' ')} = ${formatPrice(item.price)}`;
            }
            
            function showLoading() {
                elements.loadingOverlay.classList.add('active');
            }
            
            function hideLoading() {
                elements.loadingOverlay.classList.remove('active');
            }
            
            function showError(message) {
                // Create error toast
                const toast = document.createElement('div');
                toast.className = 'toast error';
                toast.innerHTML = `
                    <i class="fas fa-exclamation-circle"></i>
                    <span>${message}</span>
                `;
                
                document.body.appendChild(toast);
                
                // Remove after 3 seconds
                setTimeout(() => {
                    toast.remove();
                }, 3000);
            }
            
            function showToast(message) {
                // Create success toast
                const toast = document.createElement('div');
                toast.className = 'toast success';
                toast.innerHTML = `
                    <i class="fas fa-check-circle"></i>
                    <span>${message}</span>
                `;
                
                document.body.appendChild(toast);
                
                // Remove after 3 seconds
                setTimeout(() => {
                    toast.remove();
                }, 3000);
            }
            
            // Event handling
            function setupEventListeners() {
                // Navigation
                elements.navLinks.forEach(link => {
                    link.addEventListener('click', (e) => {
                        e.preventDefault();
                        const viewName = link.getAttribute('data-view');
                        
                        // Handle branch-specific URLs for menu, cart, and checkout
                        if (viewName === 'menu' && state.currentBranch) {
                            window.location.hash = createBranchUrl(state.currentBranch, 'menu');
                        } else if (viewName === 'cart' && state.currentBranch) {
                            window.location.hash = createBranchUrl(state.currentBranch, 'cart');
                        } else {
                            window.location.hash = link.getAttribute('href').substring(1);
                        }
                    });
                });
                
                // Cart toggle
                elements.cartToggle.addEventListener('click', () => {
                    if (state.currentBranch) {
                        window.location.hash = createBranchUrl(state.currentBranch, 'cart');
                    } else {
                        window.location.hash = 'cart';
                    }
                });
                
                elements.cartFab.addEventListener('click', () => {
                    if (state.currentBranch) {
                        window.location.hash = createBranchUrl(state.currentBranch, 'cart');
                    } else {
                        window.location.hash = 'cart';
                    }
                });
                
                // QR Scanner
                elements.qrScannerBtn.addEventListener('click', showQRScanner);
                elements.qrScannerClose.addEventListener('click', hideQRScanner);
                elements.qrCodeSubmit.addEventListener('click', () => {
                    const qrCode = elements.qrCodeInput.value.trim();
                    if (qrCode) {
                        processQRCode(qrCode);
                    }
                });
                
                elements.qrCodeInput.addEventListener('keypress', (e) => {
                    if (e.key === 'Enter') {
                        const qrCode = elements.qrCodeInput.value.trim();
                        if (qrCode) {
                            processQRCode(qrCode);
                        }
                    }
                });
                
                // Service request
                elements.serviceRequestBtn.addEventListener('click', () => {
                    showModal('service-modal');
                    renderServiceModalSkeleton();
                });
                
                elements.submitRequestBtn.addEventListener('click', submitServiceRequest);
                
                // Modal close buttons
                document.querySelectorAll('.modal-close').forEach(btn => {
                    btn.addEventListener('click', () => {
                        const modalId = btn.getAttribute('data-modal');
                        hideModal(modalId);
                        
                        // If closing item detail modal, update URL to go back to menu
                        // Use replaceState to avoid triggering router navigation
                        if (modalId === 'item-detail-modal' && state.currentBranch) {
                            const menuUrl = createBranchUrl(state.currentBranch, 'menu');
                            if (window.location.hash !== menuUrl) {
                                // Use replaceState instead of hash assignment to avoid router trigger
                                history.replaceState(null, null, menuUrl);
                            }
                        }
                    });
                });
                
                // Confirmation modal buttons
                const confirmBtn = document.getElementById('confirmation-confirm-btn');
                const cancelBtn = document.getElementById('confirmation-cancel-btn');
                
                if (confirmBtn) {
                    confirmBtn.addEventListener('click', handleConfirmationConfirm);
                }
                
                if (cancelBtn) {
                    cancelBtn.addEventListener('click', handleConfirmationCancel);
                }
                
                // Add to cart button in item detail modal
                elements.addToCartDetailBtn.addEventListener('click', addToCart);
                
                // Request type change
                elements.requestType.addEventListener('change', () => {
                    if (elements.requestType.value === 'OTHER') {
                        elements.otherRequestContainer.style.display = 'block';
                    } else {
                        elements.otherRequestContainer.style.display = 'none';
                    }
                });
                
                // Language toggle
                const languageToggle = document.getElementById('language-toggle');
                const languageDropdown = document.getElementById('language-dropdown');
                
                languageToggle.addEventListener('click', () => {
                    languageDropdown.classList.toggle('show');
                });
                
                // Language selection
                document.querySelectorAll('.language-option').forEach(option => {
                    option.addEventListener('click', async () => {
                        const lang = option.getAttribute('data-lang');
                        console.log('Language changed to:', lang); // Debug log
                        state.language = lang;
                        saveUserData();
                        
                        // Update HTML lang attribute for proper language setting
                        document.documentElement.lang = lang;
                        document.documentElement.dir = lang === 'bn-BD' ? 'ltr' : 'ltr';
                        
                        // Load translations from API
                        await loadTranslationsFromAPI();
                        
                        // Re-render footer with new language
                        renderFooter();
                        
                        // Debug: Check branch translations
                        console.log('Branch translations after language change:');
                        state.branches.forEach(branch => {
                            const translatedName = getTranslation(branch.internal_name, branch.name_translation_key);
                            const urlName = getBranchUrlName(branch);
                            console.log({
                                branchId: branch.branch_id,
                                internalName: branch.internal_name,
                                translationKey: branch.name_translation_key,
                                translatedName: translatedName,
                                urlName: urlName
                            });
                        });
                        
                        languageDropdown.classList.remove('show');
                        
                        // Update active language option
                        document.querySelectorAll('.language-option').forEach(opt => {
                            opt.classList.remove('active');
                        });
                        option.classList.add('active');
                        
                        showToast(translate('language_changed'));
                        
                        // Update branch name displays with new language
                        updateBranchNameDisplays();
                        
                        // Refresh current view with new language and update URL
                        switch (state.currentView) {
                            case 'home':
                                renderHome();
                                break;
                            case 'menu':
                                if (state.currentBranch) {
                                    // Update URL to reflect new language branch name
                                    window.location.hash = createBranchUrl(state.currentBranch, 'menu');
                                    loadMenu(state.currentBranch.branch_id);
                                }
                                break;
                            case 'cart':
                                if (state.currentBranch) {
                                    // Update URL to reflect new language branch name
                                    window.location.hash = createBranchUrl(state.currentBranch, 'cart');
                                }
                                renderCart();
                                break;
                            case 'checkout':
                                if (state.currentBranch) {
                                    // Update URL to reflect new language branch name
                                    window.location.hash = createBranchUrl(state.currentBranch, 'checkout');
                                }
                                renderCheckout();
                                break;
                            case 'orders':
                                renderOrderHistory();
                                break;
                            case 'order-tracking':
                                // Re-render the current order if available
                                const currentOrderId = window.location.hash.split('/')[1];
                                if (currentOrderId) {
                                    loadOrder(currentOrderId);
                                }
                                break;
                            case 'favorites':
                                renderFavorites();
                                break;
                        }
                    });
                });
                
                // Close language dropdown when clicking outside
                document.addEventListener('click', (e) => {
                    if (!languageToggle.contains(e.target) && !languageDropdown.contains(e.target)) {
                        languageDropdown.classList.remove('show');
                    }
                });
                
                // Menu search
                if (elements.menuSearch) {
                    elements.menuSearch.addEventListener('input', utils.debounce((e) => {
                        const searchTerm = e.target.value;
                        updateSearchClearButton(searchTerm);
                        filterMenuItems(searchTerm);
                    }, 300));
                    
                    // Show/hide clear button based on input
                    elements.menuSearch.addEventListener('input', (e) => {
                        updateSearchClearButton(e.target.value);
                    });
                }
                
                // Search clear button
                if (elements.menuSearchClear) {
                    elements.menuSearchClear.addEventListener('click', () => {
                        elements.menuSearch.value = '';
                        updateSearchClearButton('');
                        filterMenuItems('');
                        elements.menuSearch.focus();
                    });
                }
                
                // Advanced search filters functionality
                if (elements.menuSearchFilterToggle && elements.menuSearchFiltersPanel) {
                    // Toggle filters panel
                    elements.menuSearchFilterToggle.addEventListener('click', () => {
                        const isActive = elements.menuSearchFiltersPanel.classList.contains('active');
                        if (isActive) {
                            elements.menuSearchFiltersPanel.classList.remove('active');
                            elements.menuSearchFilterToggle.classList.remove('active');
                        } else {
                            elements.menuSearchFiltersPanel.classList.add('active');
                            elements.menuSearchFilterToggle.classList.add('active');
                        }
                    });
                    
                    // Close filters panel when clicking outside
                    document.addEventListener('click', (e) => {
                        if (!elements.menuSearchFilterToggle.contains(e.target) && 
                            !elements.menuSearchFiltersPanel.contains(e.target)) {
                            elements.menuSearchFiltersPanel.classList.remove('active');
                            elements.menuSearchFilterToggle.classList.remove('active');
                        }
                    });
                    
                    // Price range preset buttons (BDT context)
                    const pricePresets = document.querySelectorAll('.price-preset');
                    pricePresets.forEach(preset => {
                        preset.addEventListener('click', () => {
                            const min = parseInt(preset.getAttribute('data-min'));
                            const max = parseInt(preset.getAttribute('data-max'));
                            
                            if (elements.priceMin) elements.priceMin.value = min === 0 ? '' : min;
                            if (elements.priceMax) elements.priceMax.value = max === 9999 ? '' : max;
                            
                            // Update active state
                            pricePresets.forEach(p => p.classList.remove('active'));
                            preset.classList.add('active');
                        });
                    });
                    
                    // Rating filter options
                    const ratingOptions = document.querySelectorAll('.rating-option');
                    ratingOptions.forEach(option => {
                        option.addEventListener('click', () => {
                            // Update active state
                            ratingOptions.forEach(o => o.classList.remove('active'));
                            option.classList.add('active');
                        });
                    });
                    
                    // Spice level filter options
                    const spiceOptions = document.querySelectorAll('.spice-option');
                    spiceOptions.forEach(option => {
                        option.addEventListener('click', () => {
                            // Update active state
                            spiceOptions.forEach(o => o.classList.remove('active'));
                            option.classList.add('active');
                        });
                    });
                    
                    // Apply filters button
                    if (elements.applyFiltersBtn) {
                        elements.applyFiltersBtn.addEventListener('click', () => {
                            applyAdvancedFilters();
                            elements.menuSearchFiltersPanel.classList.remove('active');
                            elements.menuSearchFilterToggle.classList.remove('active');
                        });
                    }
                    
                    // Clear filters button
                    if (elements.clearFiltersBtn) {
                        elements.clearFiltersBtn.addEventListener('click', () => {
                            clearAllFilters();
                            elements.menuSearchFiltersPanel.classList.remove('active');
                            elements.menuSearchFilterToggle.classList.remove('active');
                        });
                    }
                }
                
                // Branch conflict modal buttons
                if (elements.branchConflictCancelBtn) {
                    elements.branchConflictCancelBtn.addEventListener('click', () => {
                        resolveBranchConflict(false);
                    });
                }
                
                if (elements.branchConflictConfirmBtn) {
                    elements.branchConflictConfirmBtn.addEventListener('click', () => {
                        resolveBranchConflict(true);
                    });
                }
                
                // Modal close buttons for branch conflict modal
                const branchConflictCloseBtns = document.querySelectorAll('[data-modal="branch-conflict-modal"]');
                branchConflictCloseBtns.forEach(btn => {
                    btn.addEventListener('click', () => {
                        resolveBranchConflict(false);
                    });
                });
                
                // Mobile menu functionality
                const mobileMenuToggle = document.getElementById('mobile-menu-toggle');
                const mobileMenu = document.getElementById('mobile-menu');
                const mobileMenuOverlay = document.getElementById('mobile-menu-overlay');
                const mobileMenuClose = document.getElementById('mobile-menu-close');
                
                // Toggle mobile menu
                mobileMenuToggle.addEventListener('click', () => {
                    mobileMenu.classList.toggle('active');
                    mobileMenuOverlay.classList.toggle('active');
                    mobileMenuToggle.classList.toggle('active');
                    document.body.style.overflow = mobileMenu.classList.contains('active') ? 'hidden' : '';
                });
                
                // Close mobile menu
                mobileMenuClose.addEventListener('click', closeMobileMenu);
                mobileMenuOverlay.addEventListener('click', closeMobileMenu);
                
                function closeMobileMenu() {
                    mobileMenu.classList.remove('active');
                    mobileMenuOverlay.classList.remove('active');
                    mobileMenuToggle.classList.remove('active');
                    document.body.style.overflow = '';
                }
                
                // Mobile header actions
                const mobileFavoritesToggle = document.getElementById('mobile-favorites-toggle');
                const mobileOrdersToggle = document.getElementById('mobile-orders-toggle');
                
                if (mobileFavoritesToggle) {
                    mobileFavoritesToggle.addEventListener('click', () => {
                        window.location.hash = 'favorites';
                        closeMobileMenu();
                    });
                }
                
                if (mobileOrdersToggle) {
                    mobileOrdersToggle.addEventListener('click', () => {
                        window.location.hash = 'orders';
                        closeMobileMenu();
                    });
                }
                
                // Mobile navigation links
                const mobileNavLinks = document.querySelectorAll('.mobile-nav-link');
                mobileNavLinks.forEach(link => {
                    link.addEventListener('click', (e) => {
                        e.preventDefault();
                        const viewName = link.getAttribute('data-view');
                        
                        // Handle branch-specific URLs for menu, cart, and checkout
                        if (viewName === 'menu' && state.currentBranch) {
                            window.location.hash = createBranchUrl(state.currentBranch, 'menu');
                        } else if (viewName === 'cart' && state.currentBranch) {
                            window.location.hash = createBranchUrl(state.currentBranch, 'cart');
                        } else {
                            window.location.hash = link.getAttribute('href').substring(1);
                        }
                        
                        // Close mobile menu after navigation
                        closeMobileMenu();
                    });
                });
                
                // Mobile language selection
                const mobileLanguageOptions = document.querySelectorAll('.mobile-language-option');
                mobileLanguageOptions.forEach(option => {
                    option.addEventListener('click', async () => {
                        const lang = option.getAttribute('data-lang');
                        console.log('Mobile language changed to:', lang); // Debug log
                        state.language = lang;
                        saveUserData();
                        
                        // Update HTML lang attribute for proper language setting
                        document.documentElement.lang = lang;
                        document.documentElement.dir = lang === 'bn-BD' ? 'ltr' : 'ltr';
                        
                        // Load translations from API
                        await loadTranslationsFromAPI();
                        
                        // Re-render footer with new language
                        renderFooter();
                        
                        // Update active language option for both desktop and mobile
                        document.querySelectorAll('.language-option, .mobile-language-option').forEach(opt => {
                            opt.classList.remove('active');
                        });
                        option.classList.add('active');
                        
                        // Also update desktop language option
                        const desktopOption = document.querySelector(`.language-option[data-lang="${lang}"]`);
                        if (desktopOption) {
                            desktopOption.classList.add('active');
                        }
                        
                        showToast(translate('language_changed'));
                        
                        // Update branch name displays with new language
                        updateBranchNameDisplays();
                        
                        // Refresh current view with new language and update URL
                        switch (state.currentView) {
                            case 'home':
                                renderHome();
                                break;
                            case 'menu':
                                if (state.currentBranch) {
                                    window.location.hash = createBranchUrl(state.currentBranch, 'menu');
                                    loadMenu(state.currentBranch.branch_id);
                                }
                                break;
                            case 'cart':
                                if (state.currentBranch) {
                                    window.location.hash = createBranchUrl(state.currentBranch, 'cart');
                                }
                                renderCart();
                                break;
                            case 'checkout':
                                if (state.currentBranch) {
                                    window.location.hash = createBranchUrl(state.currentBranch, 'checkout');
                                }
                                renderCheckout();
                                break;
                            case 'orders':
                                renderOrderHistory();
                                break;
                            case 'order-tracking':
                                const currentOrderId = window.location.hash.split('/')[1];
                                if (currentOrderId) {
                                    loadOrder(currentOrderId);
                                }
                                break;
                            case 'favorites':
                                renderFavorites();
                                break;
                        }
                        
                        // Close mobile menu after language change
                        closeMobileMenu();
                    });
                });
                
                // Close mobile menu on window resize if switching to desktop
                window.addEventListener('resize', () => {
                    if (window.innerWidth > 768 && mobileMenu.classList.contains('active')) {
                        closeMobileMenu();
                    }
                    
                    // Update status marquee on resize
                    setupMobileStatusMarquee();
                });
            }
            
            // Search and filter
            function updateSearchClearButton(searchTerm) {
                if (elements.menuSearchClear) {
                    if (searchTerm.trim()) {
                        elements.menuSearchClear.classList.add('visible');
                    } else {
                        elements.menuSearchClear.classList.remove('visible');
                    }
                }
            }
            
            // Advanced filter state
            let advancedFilters = {
                priceMin: null,
                priceMax: null,
                rating: null,
                spice: null,
                dietary: []
            };
            
            // Apply advanced filters
            function applyAdvancedFilters() {
                // Get price range values (in BDT)
                const priceMin = elements.priceMin ? parseFloat(elements.priceMin.value) || null : null;
                const priceMax = elements.priceMax ? parseFloat(elements.priceMax.value) || null : null;
                
                // Get rating filter
                const activeRating = document.querySelector('.rating-option.active');
                const rating = activeRating ? parseInt(activeRating.getAttribute('data-rating')) : null;
                
                // Get spice level filter
                const activeSpice = document.querySelector('.spice-option.active');
                const spice = activeSpice ? parseInt(activeSpice.getAttribute('data-spice')) : null;
                
                // Get dietary preferences
                const dietaryCheckboxes = document.querySelectorAll('.dietary-option input[type="checkbox"]:checked');
                const dietary = Array.from(dietaryCheckboxes).map(cb => cb.value);
                
                // Update filter state
                advancedFilters = {
                    priceMin: priceMin,
                    priceMax: priceMax,
                    rating: rating,
                    spice: spice,
                    dietary: dietary
                };
                
                // Apply filters with current search term
                const searchTerm = elements.menuSearch ? elements.menuSearch.value : '';
                filterMenuItems(searchTerm);
                
                // Show active filters display
                displayActiveFilters();
            }
            
            // Clear all filters
            function clearAllFilters() {
                // Reset filter state
                advancedFilters = {
                    priceMin: null,
                    priceMax: null,
                    rating: null,
                    spice: null,
                    dietary: []
                };
                
                // Clear form inputs
                if (elements.priceMin) elements.priceMin.value = '';
                if (elements.priceMax) elements.priceMax.value = '';
                
                // Clear active states
                document.querySelectorAll('.rating-option.active').forEach(option => {
                    option.classList.remove('active');
                });
                document.querySelectorAll('.spice-option.active').forEach(option => {
                    option.classList.remove('active');
                });
                document.querySelectorAll('.price-preset.active').forEach(preset => {
                    preset.classList.remove('active');
                });
                document.querySelectorAll('.dietary-option input[type="checkbox"]').forEach(checkbox => {
                    checkbox.checked = false;
                });
                
                // Clear active filters display
                const activeFiltersContainer = document.querySelector('.active-filters');
                if (activeFiltersContainer) {
                    activeFiltersContainer.innerHTML = '';
                }
                
                // Re-apply search without filters
                const searchTerm = elements.menuSearch ? elements.menuSearch.value : '';
                filterMenuItems(searchTerm);
            }
            
            // Display active filters as pills
            function displayActiveFilters() {
                const activeFiltersContainer = document.querySelector('.active-filters');
                if (!activeFiltersContainer) return;
                
                activeFiltersContainer.innerHTML = '';
                
                // Price range filter (show in BDT)
                if (advancedFilters.priceMin !== null || advancedFilters.priceMax !== null) {
                    const priceText = `৳${advancedFilters.priceMin || 0} - ৳${advancedFilters.priceMax || '∞'}`;
                    addFilterPill('Price: ' + priceText, 'price');
                }
                
                // Rating filter
                if (advancedFilters.rating !== null && advancedFilters.rating > 0) {
                    addFilterPill(`${advancedFilters.rating}+ Stars`, 'rating');
                }
                
                // Spice level filter
                if (advancedFilters.spice !== null && advancedFilters.spice > 0) {
                    const spiceLevels = ['', 'Mild', 'Medium', 'Hot', 'Extra Hot'];
                    addFilterPill(spiceLevels[advancedFilters.spice], 'spice');
                }
                
                // Dietary filters (use short labels)
                advancedFilters.dietary.forEach(diet => {
                    const shortLabels = {
                        'vegetarian': 'Veg',
                        'vegan': 'Vegan', 
                        'gluten-free': 'GF',
                        'dairy-free': 'DF'
                    };
                    addFilterPill(shortLabels[diet] || diet, 'dietary-' + diet);
                });
            }
            
            // Add individual filter pill
            function addFilterPill(text, type) {
                const activeFiltersContainer = document.querySelector('.active-filters');
                if (!activeFiltersContainer) return;
                
                const pill = document.createElement('div');
                pill.className = 'active-filter-pill';
                pill.innerHTML = `
                    <span>${text}</span>
                    <button data-filter-type="${type}" class="remove-filter-btn">
                        <i class="fas fa-times"></i>
                    </button>
                `;
                
                // Add event listener to the button
                const removeBtn = pill.querySelector('.remove-filter-btn');
                removeBtn.addEventListener('click', () => removeFilter(type));
                
                activeFiltersContainer.appendChild(pill);
            }
            
            // Remove individual filter
            function removeFilter(type) {
                if (type.startsWith('dietary-')) {
                    const diet = type.replace('dietary-', '');
                    advancedFilters.dietary = advancedFilters.dietary.filter(d => d !== diet);
                    // Uncheck checkbox
                    const checkbox = document.querySelector(`.dietary-option input[value="${diet}"]`);
                    if (checkbox) checkbox.checked = false;
                } else {
                    switch (type) {
                        case 'price':
                            advancedFilters.priceMin = null;
                            advancedFilters.priceMax = null;
                            if (elements.priceMin) elements.priceMin.value = '';
                            if (elements.priceMax) elements.priceMax.value = '';
                            document.querySelectorAll('.price-preset.active').forEach(p => p.classList.remove('active'));
                            break;
                        case 'rating':
                            advancedFilters.rating = null;
                            document.querySelectorAll('.rating-option.active').forEach(o => o.classList.remove('active'));
                            break;
                        case 'spice':
                            advancedFilters.spice = null;
                            document.querySelectorAll('.spice-option.active').forEach(o => o.classList.remove('active'));
                            break;
                    }
                }
                
                // Re-apply filters
                const searchTerm = elements.menuSearch ? elements.menuSearch.value : '';
                filterMenuItems(searchTerm);
                displayActiveFilters();
            }
            
            // Check if any filters are currently active
            function hasActiveFilters() {
                return advancedFilters.priceMin !== null ||
                       advancedFilters.priceMax !== null ||
                       (advancedFilters.rating !== null && advancedFilters.rating > 0) ||
                       (advancedFilters.spice !== null && advancedFilters.spice > 0) ||
                       advancedFilters.dietary.length > 0;
            }
            
            function filterMenuItems(searchTerm) {
                console.log('filterMenuItems called with:', searchTerm);
                const term = searchTerm.toLowerCase().trim();
                
                // Get all menu items from all categories
                const allItems = [];
                state.menuData.forEach(category => {
                    if (category.items) {
                        category.items.forEach(item => {
                            allItems.push({
                                ...item,
                                categoryName: getTranslation(category.category_name, category.name_translation_key)
                            });
                        });
                    }
                });
                
                // If no search term and no filters, show all items and reset to current category
                if (!term && !hasActiveFilters()) {
                    selectCategoryTab('all');
                    return;
                }
                
                // Filter items based on search term and advanced filters
                const filteredItems = allItems.filter(item => {
                    // Search term filtering
                    let matchesSearch = true;
                    if (term) {
                        const itemName = getTranslation(item.item_name, item.name_translation_key).toLowerCase();
                        const itemDesc = getTranslation(item.item_description, item.description_translation_key).toLowerCase();
                        const categoryName = item.categoryName.toLowerCase();
                        
                        matchesSearch = itemName.includes(term) || itemDesc.includes(term) || categoryName.includes(term);
                    }
                    
                    // Price range filtering
                    let matchesPrice = true;
                    if (advancedFilters.priceMin !== null && item.price < advancedFilters.priceMin) {
                        matchesPrice = false;
                    }
                    if (advancedFilters.priceMax !== null && item.price > advancedFilters.priceMax) {
                        matchesPrice = false;
                    }
                    
                    // Rating filtering (assuming items have a rating property)
                    let matchesRating = true;
                    if (advancedFilters.rating !== null && advancedFilters.rating > 0) {
                        const itemRating = item.rating || 0; // Default to 0 if no rating
                        matchesRating = itemRating >= advancedFilters.rating;
                    }
                    
                    // Spice level filtering (assuming items have a spice_level property)
                    let matchesSpice = true;
                    if (advancedFilters.spice !== null && advancedFilters.spice > 0) {
                        const itemSpice = item.spice_level || 0; // Default to 0 if no spice level
                        matchesSpice = itemSpice >= advancedFilters.spice;
                    }
                    
                    // Dietary preferences filtering (assuming items have dietary_tags array)
                    let matchesDietary = true;
                    if (advancedFilters.dietary.length > 0) {
                        const itemDietary = item.dietary_tags || [];
                        matchesDietary = advancedFilters.dietary.every(diet => itemDietary.includes(diet));
                    }
                    
                    return matchesSearch && matchesPrice && matchesRating && matchesSpice && matchesDietary;
                });
                
                console.log('Filtered items:', filteredItems.length);
                
                // Show filtered results in the content area
                const contentArea = document.getElementById('menu-content-area');
                if (!contentArea) return;
                
                contentArea.innerHTML = '';
                
                if (filteredItems.length === 0) {
                    contentArea.innerHTML = `
                        <div class="menu-section-empty">
                            <i class="fas fa-search"></i>
                            <h3>No items found</h3>
                            <p>No menu items match your search for "${searchTerm}"</p>
                            <button class="btn" onclick="document.getElementById('menu-search').value = ''; filterMenuItems('');">Clear Search</button>
                        </div>
                    `;
                    return;
                }
                
                // Group filtered items by category
                const groupedItems = {};
                filteredItems.forEach(item => {
                    if (!groupedItems[item.categoryName]) {
                        groupedItems[item.categoryName] = [];
                    }
                    groupedItems[item.categoryName].push(item);
                });
                
                // Create a search results section
                const searchSection = document.createElement('div');
                searchSection.className = 'menu-section';
                searchSection.innerHTML = `
                    <div class="menu-section-header">
                        <div>
                            <h3 class="menu-section-title">
                                <i class="fas fa-search section-icon"></i>
                                Search Results
                            </h3>
                            <p class="menu-section-subtitle">${filteredItems.length} item${filteredItems.length === 1 ? '' : 's'} found for "${searchTerm}"</p>
                        </div>
                    </div>
                `;
                
                const itemsGrid = document.createElement('div');
                itemsGrid.className = 'menu-section-items';
                
                // Add all filtered items
                filteredItems.forEach(item => {
                    const itemCard = createMenuItemCard(item);
                    itemsGrid.appendChild(itemCard);
                });
                
                searchSection.appendChild(itemsGrid);
                contentArea.appendChild(searchSection);
                
                // Highlight the active search state in tabs
                const tabs = document.querySelectorAll('.category-tab');
                tabs.forEach(tab => tab.classList.remove('active'));
            }
            
            // Restaurant details management
            async function loadRestaurantDetails() {
                try {
                    console.log('Loading restaurant details...'); // Debug log
                    const response = await apiService.getRestaurant();
                    state.restaurantDetails = response.data || response;
                    renderFooter();
                } catch (error) {
                    console.error('Failed to load restaurant details:', error);
                    // Use default values if API fails
                    renderFooter();
                }
            }
            
            function renderFooter() {
                // Safety check: ensure footer elements exist
                if (!elements.footerContent || !elements.footerRestaurantName) {
                    console.warn('Footer elements not found, skipping footer render');
                    return;
                }
                
                const restaurant = state.restaurantDetails || {};
                
                // Update footer restaurant name
                elements.footerRestaurantName.textContent = restaurant.name || 'Luna Dine';
                
                // Generate footer HTML
                const footerHTML = `
                    <!-- About Section -->
                    <div class="footer-section">
                        <h3>${translate('about_us')}</h3>
                        <p>${restaurant.description || translate('footer_default_description')}</p>
                        <p>${restaurant.tagline || translate('footer_default_tagline')}</p>
                        <div class="social-links">
                            ${restaurant.social_media_links ? Object.entries(restaurant.social_media_links).map(([platform, url]) => `
                                <a href="${url}" target="_blank" rel="noopener noreferrer" aria-label="${platform}">
                                    <i class="fab fa-${platform}"></i>
                                </a>
                            `).join('') : `
                                <a href="#" target="_blank" rel="noopener noreferrer" aria-label="Facebook">
                                    <i class="fab fa-facebook"></i>
                                </a>
                                <a href="#" target="_blank" rel="noopener noreferrer" aria-label="Instagram">
                                    <i class="fab fa-instagram"></i>
                                </a>
                                <a href="#" target="_blank" rel="noopener noreferrer" aria-label="Twitter">
                                    <i class="fab fa-twitter"></i>
                                </a>
                            `}
                        </div>
                    </div>
                    
                    <!-- Contact Section -->
                    <div class="footer-section">
                        <h3>${translate('contact_us')}</h3>
                        <p><i class="fas fa-map-marker-alt"></i> ${restaurant.address || translate('footer_default_address')}</p>
                        <p><i class="fas fa-phone"></i> ${restaurant.support_phone || translate('footer_default_phone')}</p>
                        <p><i class="fas fa-envelope"></i> ${restaurant.support_email || translate('footer_default_email')}</p>
                        ${restaurant.website_url ? `<p><i class="fas fa-globe"></i> <a href="${restaurant.website_url}" target="_blank" rel="noopener noreferrer">${restaurant.website_url}</a></p>` : ''}
                    </div>
                    
                    <!-- Business Hours Section -->
                    <div class="footer-section">
                        <h3>${translate('business_hours')}</h3>
                        <div class="business-hours">
                            ${restaurant.business_hours ? Object.entries(restaurant.business_hours).map(([day, hours]) => `
                                <div class="day">
                                    <span class="day-name">${translate(day.toLowerCase())}</span>
                                    <span class="hours">${hours}</span>
                                </div>
                            `).join('') : `
                                <div class="day">
                                    <span class="day-name">${translate('monday')}</span>
                                    <span class="hours">11:00-23:00</span>
                                </div>
                                <div class="day">
                                    <span class="day-name">${translate('tuesday')}</span>
                                    <span class="hours">11:00-23:00</span>
                                </div>
                                <div class="day">
                                    <span class="day-name">${translate('wednesday')}</span>
                                    <span class="hours">11:00-23:00</span>
                                </div>
                                <div class="day">
                                    <span class="day-name">${translate('thursday')}</span>
                                    <span class="hours">11:00-23:00</span>
                                </div>
                                <div class="day">
                                    <span class="day-name">${translate('friday')}</span>
                                    <span class="hours">11:00-23:00</span>
                                </div>
                                <div class="day">
                                    <span class="day-name">${translate('saturday')}</span>
                                    <span class="hours">11:00-00:00</span>
                                </div>
                                <div class="day">
                                    <span class="day-name">${translate('sunday')}</span>
                                    <span class="hours">11:00-23:00</span>
                                </div>
                            `}
                        </div>
                    </div>
                    
                    <!-- Quick Links Section -->
                    <div class="footer-section">
                        <h3>${translate('quick_links')}</h3>
                        <ul>
                            <li><a href="#home" data-view="home">${translate('nav_home')}</a></li>
                            <li><a href="#our_branches">${translate('nav_menu')}</a></li>
                            <li><a href="#favorites" data-view="favorites">${translate('nav_favorites')}</a></li>
                            <li><a href="#orders" data-view="orders">${translate('nav_orders')}</a></li>
                            <li><a href="#" id="privacy-policy">${translate('privacy_policy')}</a></li>
                            <li><a href="#" id="terms-service">${translate('terms_of_service')}</a></li>
                        </ul>
                    </div>
                `;
                
                // Update footer content
                elements.footerContent.innerHTML = footerHTML;
                
                // Add click event listeners to footer links
                const footerLinks = elements.footerContent.querySelectorAll('a[data-view]');
                footerLinks.forEach(link => {
                    link.addEventListener('click', (e) => {
                        e.preventDefault();
                        const view = link.getAttribute('data-view');
                        showView(view);
                        window.scrollTo(0, 0);
                    });
                });
            }
            
            // Branch conflict management functions
            function checkBranchConflict(item) {
                console.log('checkBranchConflict called with item:', item);
                
                // Check if cart has items from a different branch
                if (state.cart.length === 0) {
                    console.log('Cart is empty, no branch conflict');
                    return false; // No conflict if cart is empty
                }
                
                const currentCartBranch = state.cart[0].branch_id;
                const newItemBranch = item.branch_id;
                
                console.log('Branch conflict check:', {
                    currentCartBranch,
                    newItemBranch,
                    hasBranchId: !!item.branch_id,
                    itemName: item.item_name || item.name || 'unknown'
                });
                
                // If item doesn't have branch_id, try to find it from menu data
                if (!newItemBranch && item.branch_menu_id) {
                    console.log('Item missing branch_id, searching menu data...');
                    if (state.menuData && Array.isArray(state.menuData)) {
                        for (const category of state.menuData) {
                            if (category.items && Array.isArray(category.items)) {
                                const foundItem = category.items.find(menuItem => 
                                    parseInt(menuItem.branch_menu_id) === parseInt(item.branch_menu_id)
                                );
                                if (foundItem && foundItem.branch_id) {
                                    console.log('Found complete item with branch_id:', foundItem.branch_id);
                                    // Update the item object with the missing branch_id
                                    item.branch_id = foundItem.branch_id;
                                    return currentCartBranch != foundItem.branch_id;
                                }
                            }
                        }
                    }
                }
                
                const hasConflict = currentCartBranch != newItemBranch;
                console.log('Branch conflict result:', hasConflict);
                
                return hasConflict;
            }
            
            function showBranchConflictModal(item, callback) {
                if (!elements.branchConflictModal) {
                    console.error('Branch conflict modal not found');
                    return;
                }
                
                // Store the pending item and callback
                state.pendingCartItem = {
                    item: item,
                    callback: callback
                };
                
                // Get branch names for display
                const currentCartBranch = state.cart[0].branch_id;
                const currentBranch = state.branches.find(b => b.branch_id === currentCartBranch);
                const newBranch = state.branches.find(b => b.branch_id === item.branch_id);
                
                // Update modal content
                if (elements.currentBranchName) {
                    elements.currentBranchName.textContent = getTranslation(currentBranch?.internal_name, currentBranch?.name_translation_key) || 'Unknown Branch';
                }
                
                if (elements.newBranchName) {
                    elements.newBranchName.textContent = getTranslation(newBranch?.internal_name, newBranch?.name_translation_key) || 'Unknown Branch';
                }
                
                // Show the modal
                elements.branchConflictModal.classList.add('active');
            }
            
            function resolveBranchConflict(confirmed) {
                if (!elements.branchConflictModal) {
                    console.error('Branch conflict modal not found');
                    return;
                }
                
                // Hide the modal
                elements.branchConflictModal.classList.remove('active');
                
                if (confirmed && state.pendingCartItem) {
                    // Clear ALL branch carts and main cart
                    state.cart = [];
                    state.currentCart = [];
                    state.branchCarts = {}; // Clear all branch-specific carts
                    updateCartUI();
                    
                    // Execute the callback (add the item)
                    if (state.pendingCartItem.callback) {
                        state.pendingCartItem.callback();
                    }
                }
                
                // Clear the pending item
                state.pendingCartItem = null;
            }
            
            // Hero Section Enhancements
            const heroEnhancements = {
                // Dynamic content for taglines and featured dishes
                taglines: [
                    "Taste the Moonlight Magic",
                    "Culinary Excellence Under Stars",
                    "Where Tradition Meets Innovation",
                    "Dine Under the Moonlight",
                    "Exceptional Flavors Await"
                ],
                
                featuredDishes: [
                    "Chef's Special: Grilled Salmon with Herbs",
                    "Today's Special: Truffle Mushroom Risotto",
                    "Signature Dish: Moonlight Pasta",
                    "House Favorite: Herb-Crusted Lamb",
                    "Daily Special: Seasonal Vegetable Tart"
                ],
                
                currentTaglineIndex: 0,
                currentDishIndex: 0,
                
                init() {
                    this.startDynamicContentRotation();
                    this.animateSocialProof();
                },
                
                startDynamicContentRotation() {
                    const taglineElement = document.getElementById('dynamic-tagline');
                    const dishElement = document.getElementById('featured-dish');
                    
                    if (!taglineElement || !dishElement) return;
                    
                    // Rotate taglines every 7 seconds
                    setInterval(() => {
                        this.currentTaglineIndex = (this.currentTaglineIndex + 1) % this.taglines.length;
                        this.animateTextChange(taglineElement, this.taglines[this.currentTaglineIndex]);
                    }, 7000);
                    
                    // Rotate featured dishes every 7 seconds with offset
                    setInterval(() => {
                        this.currentDishIndex = (this.currentDishIndex + 1) % this.featuredDishes.length;
                        this.animateTextChange(dishElement, this.featuredDishes[this.currentDishIndex]);
                    }, 7000);
                },
                
                animateTextChange(element, newText) {
                    // Fade out
                    element.style.opacity = '0';
                    element.style.transform = 'translateY(10px)';
                    
                    setTimeout(() => {
                        element.textContent = newText;
                        // Fade in
                        element.style.opacity = '1';
                        element.style.transform = 'translateY(0)';
                    }, 300);
                },
                
                animateSocialProof() {
                    const socialProofItems = document.querySelectorAll('.social-proof-item');
                    
                    if (!socialProofItems.length) return;
                    
                    // Animate numbers on scroll into view
                    const observer = new IntersectionObserver((entries) => {
                        entries.forEach(entry => {
                            if (entry.isIntersecting) {
                                this.animateNumber(entry.target.querySelector('.social-proof-number'));
                                observer.unobserve(entry.target);
                            }
                        });
                    });
                    
                    socialProofItems.forEach(item => observer.observe(item));
                },
                
                animateNumber(element) {
                    if (!element) return;
                    
                    const finalText = element.textContent;
                    const isPercentage = finalText.includes('.');
                    const isPlus = finalText.includes('+');
                    const numericValue = parseFloat(finalText.replace(/[^\d.]/g, ''));
                    
                    if (isNaN(numericValue)) return;
                    
                    let currentValue = 0;
                    const increment = numericValue / 50;
                    const timer = setInterval(() => {
                        currentValue += increment;
                        if (currentValue >= numericValue) {
                            currentValue = numericValue;
                            clearInterval(timer);
                        }
                        
                        let displayValue = Math.floor(currentValue);
                        if (isPercentage) {
                            displayValue = (currentValue).toFixed(1);
                        }
                        
                        element.textContent = displayValue + (isPlus ? '+' : '');
                    }, 30);
                }
            };
            
            // Utility functions object
            const utils = {
                debounce(func, wait) {
                    let timeout;
                    return function executedFunction(...args) {
                        const later = () => {
                            clearTimeout(timeout);
                            func(...args);
                        };
                        clearTimeout(timeout);
                        timeout = setTimeout(later, wait);
                    };
                },
                
                throttle(func, limit) {
                    let inThrottle;
                    return function() {
                        const args = arguments;
                        const context = this;
                        if (!inThrottle) {
                            func.apply(context, args);
                            inThrottle = true;
                            setTimeout(() => inThrottle = false, limit);
                        }
                    };
                },
                
                // Cleanup function for better memory management
                cleanup() {
                    if (typeof eventListenerManager !== 'undefined') {
                        eventListenerManager.cleanup();
                    }
                    if (typeof domCache !== 'undefined') {
                        domCache.clear();
                    }
                    // Clear any intervals
                    if (window.heroAnimationInterval) clearInterval(window.heroAnimationInterval);
                    if (window.stickyTabsHandler) {
                        window.removeEventListener('scroll', window.stickyTabsHandler);
                    }
                    if (window.tabsResizeHandler) {
                        window.removeEventListener('resize', window.tabsResizeHandler);
                    }
                }
            };
            
            // Cleanup on page unload to prevent memory leaks
            window.addEventListener('beforeunload', () => {
                utils.cleanup();
            });
            
            // Public methods
            return {
                init
            };
        })();
        
        // Initialize the app when DOM is loaded with improved error handling
        document.addEventListener('DOMContentLoaded', () => {
            try {
                console.log('🍽️ Luna Dine App: Starting initialization...');
                LunaDineApp.init();
                console.log('✅ Luna Dine App: Successfully initialized');
            } catch (error) {
                console.error('❌ Luna Dine App: Initialization failed:', error);
                // Show user-friendly error message
                const errorMessage = document.createElement('div');
                errorMessage.style.cssText = `
                    position: fixed; top: 50%; left: 50%; transform: translate(-50%, -50%);
                    background: #ff4444; color: white; padding: 20px; border-radius: 8px;
                    z-index: 10000; font-family: Arial, sans-serif; text-align: center;
                `;
                errorMessage.innerHTML = `
                    <h3>Application Error</h3>
                    <p>Sorry, there was an issue loading the app. Please refresh the page.</p>
                    <button onclick="location.reload()" style="background: white; color: #ff4444; border: none; padding: 8px 16px; border-radius: 4px; cursor: pointer;">Refresh Page</button>
                `;
                document.body.appendChild(errorMessage);
            }
        });
    