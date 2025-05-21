-- إنشاء قاعدة البيانات
CREATE DATABASE IF NOT EXISTS grand_horizon;
USE grand_horizon;

-- جدول المستخدمين
CREATE TABLE users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    phone VARCHAR(20),
    registration_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    last_login DATETIME,
    profile_image VARCHAR(255)
);

-- جدول أنواع الغرف
CREATE TABLE room_types (
    type_id INT PRIMARY KEY AUTO_INCREMENT,
    type_name VARCHAR(50) UNIQUE NOT NULL,
    description TEXT,
    base_price DECIMAL(10,2) NOT NULL,
    capacity INT NOT NULL,
    size VARCHAR(20),
    featured_image VARCHAR(255)
);

-- جدول الغرف
CREATE TABLE rooms (
    room_id INT PRIMARY KEY AUTO_INCREMENT,
    type_id INT NOT NULL,
    room_number VARCHAR(10) UNIQUE NOT NULL,
    status ENUM('available', 'occupied', 'maintenance') DEFAULT 'available',
    FOREIGN KEY (type_id) REFERENCES room_types(type_id)
);

-- جدول المرافق
CREATE TABLE amenities (
    amenity_id INT PRIMARY KEY AUTO_INCREMENT,
    amenity_name VARCHAR(50) UNIQUE NOT NULL,
    icon_class VARCHAR(50)
);

-- جدول علاقة الغرف بالمرافق
CREATE TABLE room_amenities (
    room_id INT,
    amenity_id INT,
    PRIMARY KEY (room_id, amenity_id),
    FOREIGN KEY (room_id) REFERENCES rooms(room_id),
    FOREIGN KEY (amenity_id) REFERENCES amenities(amenity_id)
);

-- جدول الحجوزات
CREATE TABLE bookings (
    booking_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    room_id INT NOT NULL,
    check_in DATE NOT NULL,
    check_out DATE NOT NULL,
    adults INT DEFAULT 1,
    children INT DEFAULT 0,
    total_price DECIMAL(10,2) NOT NULL,
    status ENUM('pending', 'confirmed', 'cancelled', 'completed') DEFAULT 'pending',
    booking_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    special_requests TEXT,
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (room_id) REFERENCES rooms(room_id)
);

-- جدول الدفعات
CREATE TABLE payments (
    payment_id INT PRIMARY KEY AUTO_INCREMENT,
    booking_id INT NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    payment_method VARCHAR(50) NOT NULL,
    transaction_id VARCHAR(100) UNIQUE,
    payment_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    status ENUM('pending', 'completed', 'failed', 'refunded') DEFAULT 'pending',
    FOREIGN KEY (booking_id) REFERENCES bookings(booking_id)
);

-- جدول التقييمات
CREATE TABLE reviews (
    review_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    room_id INT NOT NULL,
    rating INT CHECK (rating BETWEEN 1 AND 5),
    comment TEXT,
    review_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (room_id) REFERENCES rooms(room_id)
);

-- جدول الأخبار
CREATE TABLE news (
    news_id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(255) NOT NULL,
    content TEXT NOT NULL,
    author_id INT NOT NULL,
    publish_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    featured_image VARCHAR(255),
    category VARCHAR(50),
    views INT DEFAULT 0,
    FOREIGN KEY (author_id) REFERENCES users(user_id)
);

-- جدول المعرض
CREATE TABLE gallery (
    image_id INT PRIMARY KEY AUTO_INCREMENT,
    image_url VARCHAR(255) NOT NULL,
    category VARCHAR(50) NOT NULL,
    description TEXT,
    upload_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    room_id INT,
    FOREIGN KEY (room_id) REFERENCES rooms(room_id)
);

-- جدول التفضيلات
CREATE TABLE preferences (
    preference_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT UNIQUE NOT NULL,
    pillow_type VARCHAR(50),
    floor_preference VARCHAR(50),
    special_needs TEXT,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);