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
        country VARCHAR(100),
        city VARCHAR(100),
        landmark VARCHAR(255) NOT NULL UNIQUE,
        latitude DECIMAL(9, 6) UNIQUE,
        longitude DECIMAL(9, 6) UNIQUE,
        FOREIGN KEY (country) REFERENCES Countries (country) ON DELETE CASCADE,
        FOREIGN KEY (city) REFERENCES Cities (city) ON DELETE CASCADE,
        INDEX idx_landmark (landmark),
        INDEX idx_latitude (latitude),
        INDEX idx_longitude (longitude)
    ) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;

-- Table for audiobooks
CREATE TABLE
    AudioBooks (
        audiobook_id INT PRIMARY KEY AUTO_INCREMENT,
        landmark_id INT NOT NULL,
        title VARCHAR(255) UNIQUE NOT NULL,
        author VARCHAR(100) NOT NULL,
        guide VARCHAR(100) NOT NULL,
        audio_url VARCHAR(255) UNIQUE NOT NULL,
        FOREIGN KEY (landmark_id) REFERENCES Landmarks (landmark_id) ON DELETE CASCADE,
        INDEX idx_title (title),
        INDEX idx_audio_url (audio_url)
    ) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;

-- Table for landmarks with audio
CREATE TABLE
    AlaguideObjects (
        ala_object_id INT PRIMARY KEY AUTO_INCREMENT,
        country VARCHAR(100),
        city VARCHAR(100),
        category VARCHAR(255),
        landmark VARCHAR(255),
        title VARCHAR(100),
        author VARCHAR(100),
        guide VARCHAR(100),
        description TEXT,
        latitude DECIMAL(9, 6),
        longitude DECIMAL(9, 6),
        image_url VARCHAR(255),
        audio_url VARCHAR(255),
        FOREIGN KEY (country) REFERENCES Countries (country) ON DELETE CASCADE,
        FOREIGN KEY (city) REFERENCES Cities (city) ON DELETE CASCADE,
        FOREIGN KEY (category) REFERENCES LandmarksCategory (category) ON DELETE CASCADE,
        FOREIGN KEY (landmark) REFERENCES Landmarks (landmark) ON DELETE CASCADE,
        FOREIGN KEY (title) REFERENCES AudioBooks (title) ON DELETE CASCADE,
        FOREIGN KEY (audio_url) REFERENCES AudioBooks (audio_url) ON DELETE CASCADE,
        FOREIGN KEY (latitude) REFERENCES Landmarks (latitude) ON DELETE CASCADE,
        FOREIGN KEY (longitude) REFERENCES Landmarks (longitude) ON DELETE CASCADE
    ) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;