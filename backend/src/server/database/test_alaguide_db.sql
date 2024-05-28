DROP DATABASE IF EXISTS alaguide_db;

CREATE DATABASE alaguide_db;

USE alaguide_db;

SET
    NAMES utf8mb4;

SET
    character_set_client = utf8mb4;

-- Table for countries
CREATE TABLE
    Countries (
        country_id INT PRIMARY KEY AUTO_INCREMENT,
        country VARCHAR(100) NOT NULL UNIQUE,
        INDEX idx_country (country)
    ) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;

-- Table for cities
CREATE TABLE
    Cities (
        city_id INT PRIMARY KEY AUTO_INCREMENT,
        city VARCHAR(100) NOT NULL UNIQUE,
        description TEXT,
        latitude DECIMAL(9, 6),
        longitude DECIMAL(9, 6),
        country VARCHAR(100),
        FOREIGN KEY (country) REFERENCES Countries (country) ON DELETE CASCADE,
        INDEX idx_city (city)
    ) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;

-- Table for Category
CREATE TABLE
    LandmarksCategory (
        category_id INT PRIMARY KEY AUTO_INCREMENT,
        category VARCHAR(255) NOT NULL UNIQUE,
        INDEX idx_category (category)
    ) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;

-- Table for landmarks
CREATE TABLE
    Landmarks (
        landmark_id INT PRIMARY KEY AUTO_INCREMENT,
        landmark VARCHAR(255) NOT NULL UNIQUE,
        description TEXT,
        image_url VARCHAR(255) UNIQUE,
        latitude DECIMAL(9, 6) UNIQUE,
        longitude DECIMAL(9, 6) UNIQUE,
        city VARCHAR(100),
        category VARCHAR(255),
        FOREIGN KEY (city) REFERENCES Cities (city) ON DELETE CASCADE,
        FOREIGN KEY (category) REFERENCES LandmarksCategory (category) ON DELETE CASCADE,
        INDEX idx_landmark (landmark),
        INDEX idx_image_url (image_url),
        INDEX idx_latitude (latitude),
        INDEX idx_longitude (longitude)
    ) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;

-- Table for audiobooks
CREATE TABLE
    AudioBooks (
        audiobook_id INT PRIMARY KEY AUTO_INCREMENT,
        landmark_id INT NOT NULL,
        title VARCHAR(255) NOT NULL,
        description TEXT,
        audio_url VARCHAR(255) UNIQUE,
        FOREIGN KEY (landmark_id) REFERENCES Landmarks (landmark_id) ON DELETE CASCADE,
        INDEX idx_audio_url (audio_url)
    ) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;

-- Table for landmarks with audio
CREATE TABLE
    AlaguideObjects (
        ala_object_id INT PRIMARY KEY AUTO_INCREMENT,
        landmark VARCHAR(255),
        description TEXT,
        city VARCHAR(100),
        category VARCHAR(255),
        latitude DECIMAL(9, 6),
        longitude DECIMAL(9, 6),
        image_url VARCHAR(255),
        audio_url VARCHAR(255),
        FOREIGN KEY (landmark) REFERENCES Landmarks (landmark) ON DELETE CASCADE,
        FOREIGN KEY (city) REFERENCES Cities (city) ON DELETE CASCADE,
        FOREIGN KEY (category) REFERENCES LandmarksCategory (category) ON DELETE CASCADE,
        FOREIGN KEY (latitude) REFERENCES Landmarks (latitude) ON DELETE CASCADE,
        FOREIGN KEY (longitude) REFERENCES Landmarks (longitude) ON DELETE CASCADE,
        FOREIGN KEY (image_url) REFERENCES Landmarks (image_url) ON DELETE CASCADE,
        FOREIGN KEY (audio_url) REFERENCES AudioBooks (audio_url) ON DELETE CASCADE
    ) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;

-- Table for tags (if required)
CREATE TABLE
    Tags (
        tag_id INT PRIMARY KEY AUTO_INCREMENT,
        tag VARCHAR(255) NOT NULL
    ) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;

-- Table for many-to-many ralationship between landmarks and tags (if required)
CREATE TABLE
    LandmarkTags (
        landmark_id INT,
        tag_id INT,
        PRIMARY KEY (landmark_id, tag_id),
        FOREIGN KEY (landmark_id) REFERENCES Landmarks (landmark_id) ON DELETE CASCADE,
        FOREIGN KEY (tag_id) REFERENCES Tags (tag_id) ON DELETE CASCADE
    ) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;

-- Table for Google Maps
CREATE TABLE
    MapData (
        id INT AUTO_INCREMENT PRIMARY KEY,
        name VARCHAR(255) DEFAULT NULL,
        data JSON NOT NULL
    );