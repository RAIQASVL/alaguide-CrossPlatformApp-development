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
        categoryname VARCHAR(255) NOT NULL UNIQUE
    ) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;

-- Table for landmarks
CREATE TABLE
    Landmarks (
        landmark_id INT PRIMARY KEY AUTO_INCREMENT,
        title VARCHAR(100) NOT NULL,
        description VARCHAR(500),
        image_url VARCHAR(255),
        latitude DECIMAL(9, 6),
        longitude DECIMAL(9, 6),
        city_id INT,
        category_id INT,
        FOREIGN KEY (city_id) REFERENCES Cities (city_id) ON DELETE CASCADE,
        FOREIGN KEY (category_id) REFERENCES LandmarksCategory (category_id) ON DELETE CASCADE,
        INDEX alaguideobject_ibfk_1_idx (landmark_id),
        INDEX alaguideobject_ibfk_2_idx (title),
        INDEX alaguideobject_ibfk_3_idx (description),
        INDEX alaguideobject_ibfk_4_idx (image_url),
        INDEX alaguideobject_ibfk_5_idx (latitude),
        INDEX alaguideobject_ibfk_6_idx (longitude)
    ) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;


-- Table for audiobooks
CREATE TABLE
    AudioBooks (
        audiobook_id INT PRIMARY KEY AUTO_INCREMENT,
        landmark_id INT NOT NULL,
        title VARCHAR(255) NOT NULL,
        description VARCHAR(500),
        audio_url VARCHAR(255),
        FOREIGN KEY (landmark_id) REFERENCES Landmarks (landmark_id) ON DELETE CASCADE,
        FOREIGN KEY (title) REFERENCES Landmarks (title) ON DELETE CASCADE,
        FOREIGN KEY (description) REFERENCES Landmarks (description) ON DELETE CASCADE,
        INDEX alaguideobject_ibfk_7_idx (audio_url)
    ) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;

-- Table for landmarks with audio
CREATE TABLE
    AlaguideObjects (
        ala_object_id INT PRIMARY KEY AUTO_INCREMENT,
        landmark_id INT NOT NULL,
        title VARCHAR(255) NOT NULL,
        description VARCHAR(500),
        city_id INT,
        category_id INT,
        latitude DECIMAL(9, 6),
        longitude DECIMAL(9, 6),
        image_url VARCHAR(255),
        audio_url VARCHAR(255),
        FOREIGN KEY (landmark_id) REFERENCES Landmarks (landmark_id) ON DELETE CASCADE,
        FOREIGN KEY (title) REFERENCES Landmarks (title) ON DELETE CASCADE,
        FOREIGN KEY (description) REFERENCES Landmarks (description) ON DELETE CASCADE,
        FOREIGN KEY (city_id) REFERENCES Cities (city_id) ON DELETE CASCADE,
        FOREIGN KEY (category_id) REFERENCES LandmarksCategory (category_id) ON DELETE CASCADE,
        FOREIGN KEY (latitude) REFERENCES Landmarks (latitude) ON DELETE CASCADE,
        FOREIGN KEY (longitude) REFERENCES Landmarks (longitude) ON DELETE CASCADE,
        FOREIGN KEY (image_url) REFERENCES Landmarks (image_url) ON DELETE CASCADE,
        FOREIGN KEY (audio_url) REFERENCES AudioBooks (audio_url) ON DELETE CASCADE
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


-- Table for Google Maps
CREATE TABLE
    MapData (
        id INT AUTO_INCREMENT PRIMARY KEY,
        name VARCHAR(255) DEFAULT NULL,
        data JSON NOT NULL
    );