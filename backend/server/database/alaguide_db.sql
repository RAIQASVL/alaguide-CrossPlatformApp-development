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
        countryname VARCHAR(100) NOT NULL
    ) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;

-- Table for cities
CREATE TABLE
    Cities (
        city_id INT PRIMARY KEY AUTO_INCREMENT,
        cityname VARCHAR(100) NOT NULL,
        description TEXT,
        latitude DECIMAL(9, 6),
        longitude DECIMAL(9, 6),
        country_id INT,
        FOREIGN KEY (country_id) REFERENCES Countries (country_id) ON DELETE CASCADE
    ) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;

-- Table for Category
CREATE TABLE
    LandmarksCategory (
        category_id INT PRIMARY KEY AUTO_INCREMENT,
        name VARCHAR(255) NOT NULL UNIQUE
    ) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;

-- Table for landmarks
CREATE TABLE
    Landmarks (
        landmark_id INT PRIMARY KEY AUTO_INCREMENT,
        landmarkname VARCHAR(100) NOT NULL,
        description TEXT,
        image_url VARCHAR(255),
        latitude DECIMAL(9, 6),
        longitude DECIMAL(9, 6),
        city_id INT,
        FOREIGN KEY (city_id) REFERENCES Cities (city_id) ON DELETE CASCADE,
        category_id INT,
        FOREIGN KEY (category_id) REFERENCES LandmarksCategory (category_id) -- Corrected table name
        ON DELETE CASCADE -- Clause for automatic deletion on cascade
    ) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;

-- Table for audiobooks
CREATE TABLE
    AudioBooks (
        audiobook_id INT PRIMARY KEY AUTO_INCREMENT,
        title VARCHAR(255) NOT NULL,
        description TEXT,
        audio_url VARCHAR(255),
        landmark_id INT NOT NULL,
        FOREIGN KEY (landmark_id) REFERENCES Landmarks (landmark_id) ON DELETE CASCADE,
        INDEX alaguideobject_ibfk_3_idx (audio_url)
    ) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;

-- Table for landmarks with audio
CREATE TABLE
    AlaguideObjects (
        ala_object_id INT PRIMARY KEY AUTO_INCREMENT,
        title VARCHAR(255) NOT NULL,
        description TEXT,
        city_id INT,
        FOREIGN KEY (city_id) REFERENCES Cities (city_id) ON DELETE CASCADE,
        category_id INT,
        FOREIGN KEY (category_id) REFERENCES LandmarksCategory (category_id) ON DELETE CASCADE,
        latitude DECIMAL(9, 6),
        longitude DECIMAL(9, 6),
        image_url VARCHAR(255),
        audio_url VARCHAR(255),
        FOREIGN KEY (audio_url) REFERENCES AudioBooks (audio_url) ON DELETE CASCADE
    ) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;

-- Table for users (if required)
CREATE TABLE
    Users (
        user_id INT PRIMARY KEY AUTO_INCREMENT,
        username VARCHAR(100) NOT NULL,
        first_name VARCHAR(100) NOT NULL,
        last_name VARCHAR(100) NOT NULL,
        email VARCHAR(100) NOT NULL,
        password VARCHAR(100) NOT NULL
    ) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;

-- Table for user reviews
CREATE TABLE
    UserReviews (
        review_id INT PRIMARY KEY AUTO_INCREMENT,
        text TEXT,
        rating DECIMAL(2, 1),
        date_posted DATE,
        user_id INT, -- If user authentication is required
        landmark_id INT,
        FOREIGN KEY (user_id) REFERENCES Users (user_id) ON DELETE CASCADE, -- If there is a users table
        FOREIGN KEY (landmark_id) REFERENCES Landmarks (landmark_id) ON DELETE CASCADE
    ) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;

-- Table for likes and raitings (if required)
CREATE TABLE
    LikesRatings (
        like_rating_id INT PRIMARY KEY AUTO_INCREMENT,
        user_id INT,
        landmark_id INT,
        type ENUM ('like', 'rating'),
        date_liked_or_rated DATE,
        FOREIGN KEY (user_id) REFERENCES Users (user_id) ON DELETE CASCADE,
        FOREIGN KEY (landmark_id) REFERENCES Landmarks (landmark_id) ON DELETE CASCADE
    ) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;

-- Table for tags (if required)
CREATE TABLE
    Tags (
        tag_id INT PRIMARY KEY AUTO_INCREMENT,
        tagname VARCHAR(255) NOT NULL
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

-- Table for AllAuth SocialProviders
CREATE TABLE
    SocialProvider (
        provider VARCHAR(50),
        client_id VARCHAR(255),
        secret VARCHAR(255),
        key_jwt VARCHAR(255),
        user_id INT,
        landmark_id INT,
        FOREIGN KEY (user_id) REFERENCES Users (user_id) ON DELETE CASCADE,
        FOREIGN KEY (landmark_id) REFERENCES Landmarks (landmark_id) ON DELETE CASCADE
    ) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;

-- Table for Google Maps
CREATE TABLE
    MapData (
        id INT AUTO_INCREMENT PRIMARY KEY,
        name VARCHAR(255) DEFAULT NULL,
        data JSON NOT NULL
    );