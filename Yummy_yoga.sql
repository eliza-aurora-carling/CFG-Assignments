-- Database: Yummy Yoga Caribbean
-- Scenario: A yoga and pilates studio situated on a 
--           beautiful Caribbean beach. Members can book
--           outdoor classes, earn rewards, and
--           track their wellness journey here!
-- Author: Eliza
-- Date: 16.04.2026

-- Part 1: Create database

CREATE DATABASE IF NOT EXISTS YummyYogaCaribbean;
USE YummyYogaCaribbean;


-- Part 2: Creating the tables (with constraints and data types)

-- Table 1: the members of the studio
-- Tracks all club members
CREATE TABLE Members (
    member_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20),
    join_date DATE NOT NULL,
    membership_type ENUM('Monthly', 'Annual', 'Drop-in') DEFAULT 'Drop-in',
    reward_points INT DEFAULT 0,
    CONSTRAINT chk_reward_points CHECK (reward_points >= 0),
    CONSTRAINT chk_join_date CHECK (join_date <= CURDATE())
);

-- Table 2: the classes
CREATE TABLE Classes (
    class_id INT PRIMARY KEY AUTO_INCREMENT,
    class_name VARCHAR(100) NOT NULL,
    class_type ENUM('Yoga', 'Pilates') NOT NULL,
    difficulty_level ENUM('Beginner', 'Intermediate', 'Advanced') NOT NULL,
    duration_minutes INT NOT NULL,
    CONSTRAINT chk_duration CHECK (duration_minutes BETWEEN 30 AND 120),
    price DECIMAL(10,2) NOT NULL,
    CONSTRAINT chk_price CHECK (price > 0)
);

-- Table 3: schedule
CREATE TABLE ClassSchedule (
    schedule_id INT PRIMARY KEY AUTO_INCREMENT,
    class_id INT NOT NULL,
    instructor_name VARCHAR(100) NOT NULL,
    class_date DATE NOT NULL,
    start_time TIME NOT NULL,
    end_time TIME NOT NULL,
    location VARCHAR(100) DEFAULT 'Caribbean Beachfront',
    max_capacity INT NOT NULL,
    current_bookings INT DEFAULT 0,
    FOREIGN KEY (class_id) REFERENCES Classes(class_id) ON DELETE CASCADE,
    CONSTRAINT chk_max_capacity CHECK (max_capacity BETWEEN 5 AND 50),
    CONSTRAINT chk_current_bookings CHECK (current_bookings <= max_capacity),
    CONSTRAINT chk_times CHECK (end_time > start_time)
);

-- Table 4: bookings
CREATE TABLE Bookings (
    booking_id INT PRIMARY KEY AUTO_INCREMENT,
    member_id INT NOT NULL,
    schedule_id INT NOT NULL,
    booking_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    attended BOOLEAN DEFAULT FALSE,
    rating INT NULL,
    FOREIGN KEY (member_id) REFERENCES Members(member_id) ON DELETE CASCADE,
    FOREIGN KEY (schedule_id) REFERENCES ClassSchedule(schedule_id) ON DELETE CASCADE,
    CONSTRAINT chk_rating CHECK (rating BETWEEN 1 AND 5 OR rating IS NULL),
    CONSTRAINT unique_booking UNIQUE (member_id, schedule_id)
);

-- part 3: data

INSERT INTO Members (first_name, last_name, email, phone, join_date, membership_type, reward_points) VALUES
('Sunny', 'Beach', 'sunny@yummyyoga.com', '555-1001', '2024-01-15', 'Annual', 450),
('Coco', 'Palms', 'coco@yummyyoga.com', '555-1002', '2024-02-20', 'Monthly', 120),
('Kai', 'Ocean', 'kai@yummyyoga.com', '555-1003', '2024-03-10', 'Annual', 890),
('Luna', 'Bay', 'luna@yummyyoga.com', '555-1004', '2024-01-05', 'Monthly', 310),
('Ravi', 'Waves', 'ravi@yummyyoga.com', '555-1005', '2024-04-12', 'Drop-in', 0),
('Maya', 'Reef', 'maya@yummyyoga.com', '555-1006', '2024-01-28', 'Annual', 675),
('Jasper', 'Sands', 'jasper@yummyyoga.com', '555-1007', '2024-05-01', 'Monthly', 45),
('Zara', 'Breeze', 'zara@yummyyoga.com', '555-1008', '2024-03-15', 'Annual', 520);

INSERT INTO Classes (class_name, class_type, difficulty_level, duration_minutes, price) VALUES
('Sunrise Flow', 'Yoga', 'Beginner', 45, 15.00),
('Caribbean Power Yoga', 'Yoga', 'Intermediate', 60, 20.00),
('Beach Pilates', 'Pilates', 'Beginner', 50, 18.00),
('Advanced Hot Pilates', 'Pilates', 'Advanced', 60, 25.00),
('Restorative Yoga', 'Yoga', 'Beginner', 75, 22.00),
('Pilates with Weights', 'Pilates', 'Intermediate', 55, 20.00),
('Sunset Vinyasa', 'Yoga', 'Intermediate', 60, 20.00),
('Yoga Nidra', 'Yoga', 'Beginner', 45, 15.00);

INSERT INTO ClassSchedule (class_id, instructor_name, class_date, start_time, end_time, location, max_capacity, current_bookings) VALUES
(1, 'Maria Sunshine', '2024-12-01', '06:30:00', '07:15:00', 'Beachfront Deck', 20, 15),
(2, 'David Wave', '2024-12-01', '08:00:00', '09:00:00', 'Shaded Palapa', 15, 12),
(3, 'Elena Breeze', '2024-12-02', '07:00:00', '07:50:00', 'Beachfront Deck', 25, 20),
(4, 'Carlos Strong', '2024-12-02', '17:00:00', '18:00:00', 'Indoor Studio', 12, 10),
(5, 'Maria Sunshine', '2024-12-03', '18:00:00', '19:15:00', 'Beachfront Deck', 30, 28),
(6, 'Elena Breeze', '2024-12-03', '08:30:00', '09:25:00', 'Shaded Palapa', 15, 8),
(7, 'David Wave', '2024-12-04', '17:30:00', '18:30:00', 'Beachfront Deck', 20, 14),
(8, 'Maria Sunshine', '2024-12-05', '07:00:00', '07:45:00', 'Beachfront Deck', 20, 9);

INSERT INTO Bookings (member_id, schedule_id, booking_date, attended, rating) VALUES
(1, 1, '2024-11-20 10:30:00', TRUE, 5),
(2, 1, '2024-11-20 14:15:00', TRUE, 4),
(3, 2, '2024-11-21 09:00:00', TRUE, 5),
(4, 3, '2024-11-25 08:00:00', TRUE, 4),
(5, 4, '2024-11-28 11:00:00', FALSE, NULL),
(1, 5, '2024-11-29 16:30:00', TRUE, 5),
(6, 6, '2024-11-30 10:00:00', TRUE, 4),
(3, 7, '2024-12-01 09:00:00', FALSE, NULL),
(7, 3, '2024-12-01 14:00:00', TRUE, 5),
(8, 5, '2024-12-02 08:30:00', TRUE, 5),
(2, 8, '2024-12-02 19:00:00', TRUE, 4),
(4, 2, '2024-12-03 07:00:00', FALSE, NULL);


-- Part 4 

-- new member joins the studio/club
INSERT INTO Members (first_name, last_name, email, phone, join_date, membership_type, reward_points)
VALUES ('Finn', 'Turtle', 'finn@yummyyoga.com', '555-1009', CURDATE(), 'Monthly', 0);

-- new class
INSERT INTO Classes (class_name, class_type, difficulty_level, duration_minutes, price)
VALUES ('AcroYoga on the Beach', 'Yoga', 'Intermediate', 90, 30.00);

-- new schedule
INSERT INTO ClassSchedule (class_id, instructor_name, class_date, start_time, end_time, location, max_capacity, current_bookings)
VALUES (9, 'Finn Turtle', '2024-12-10', '09:00:00', '10:30:00', 'Beachfront Deck', 15, 0);



--  All members with annual membership (by last name)
SELECT first_name, last_name, email, reward_points
FROM Members
WHERE membership_type = 'Annual'
ORDER BY last_name;

--  all classes with price less than 20, sorted cheapest first
SELECT class_name, class_type, difficulty_level, price
FROM Classes
WHERE price < 20
ORDER BY price ASC;

--  upcoming classes on the beach (by date and time)
SELECT c.class_name, cs.instructor_name, cs.class_date, cs.start_time, cs.location
FROM ClassSchedule cs
JOIN Classes c ON cs.class_id = c.class_id
WHERE cs.location LIKE '%Beachfront%'
AND cs.class_date >= CURDATE()
ORDER BY cs.class_date ASC, cs.start_time ASC;

-- members who have attended at least one class showing attendance count
SELECT m.first_name, m.last_name, COUNT(b.booking_id) AS classes_attended
FROM Members m
JOIN Bookings b ON m.member_id = b.member_id
WHERE b.attended = TRUE
GROUP BY m.member_id
ORDER BY classes_attended DESC;

-- classes with low availability 
SELECT c.class_name, cs.class_date, cs.start_time, 
       cs.max_capacity, cs.current_bookings,
       (cs.max_capacity - cs.current_bookings) AS spots_left
FROM ClassSchedule cs
JOIN Classes c ON cs.class_id = c.class_id
WHERE (cs.max_capacity - cs.current_bookings) < 3
ORDER BY spots_left ASC;


-- part 6 - query

-- removing a booking that was cancelled (member 5 never showed)
DELETE FROM Bookings 
WHERE member_id = 5 AND attended = FALSE AND rating IS NULL
LIMIT 1;


-- Part 7


-- Avverage rating for each class type
SELECT c.class_type, AVG(b.rating) AS average_rating
FROM Bookings b
JOIN ClassSchedule cs ON b.schedule_id = cs.schedule_id
JOIN Classes c ON cs.class_id = c.class_id
WHERE b.rating IS NOT NULL
GROUP BY c.class_type;

-- total revenue from class bookings
SELECT SUM(c.price) AS total_potential_revenue
FROM Bookings b
JOIN ClassSchedule cs ON b.schedule_id = cs.schedule_id
JOIN Classes c ON cs.class_id = c.class_id
WHERE b.attended = TRUE;

-- Most popular class 
SELECT c.class_name, COUNT(b.booking_id) AS total_bookings
FROM Bookings b
JOIN ClassSchedule cs ON b.schedule_id = cs.schedule_id
JOIN Classes c ON cs.class_id = c.class_id
GROUP BY c.class_id
ORDER BY total_bookings DESC
LIMIT 1;



-- joining 1: Members and their bookings 
SELECT m.first_name, m.last_name, c.class_name, cs.class_date, cs.start_time, b.attended
FROM Members m
JOIN Bookings b ON m.member_id = b.member_id
JOIN ClassSchedule cs ON b.schedule_id = cs.schedule_id
JOIN Classes c ON cs.class_id = c.class_id
ORDER BY cs.class_date DESC;

-- joining 2: classes with instructor and capacity details
SELECT c.class_name, cs.instructor_name, cs.class_date, cs.start_time,
       cs.current_bookings, cs.max_capacity,
       ROUND((cs.current_bookings / cs.max_capacity) * 100, 1) AS percent_full
FROM ClassSchedule cs
JOIN Classes c ON cs.class_id = c.class_id
WHERE cs.class_date >= CURDATE()
ORDER BY percent_full DESC;


-- part 9: more buit-in functions
SELECT CONCAT(UPPER(last_name), ', ', first_name) AS formatted_name,
       email,
       DATEDIFF(CURDATE(), join_date) AS days_as_member
FROM Members
ORDER BY days_as_member DESC;


SELECT c.class_name, cs.class_date, 
       DAYNAME(cs.class_date) AS day_of_week,
       TIME_FORMAT(cs.start_time, '%h:%i %p') AS formatted_start_time
FROM ClassSchedule cs
JOIN Classes c ON cs.class_id = c.class_id
WHERE WEEK(cs.class_date) = WEEK(CURDATE())
ORDER BY cs.class_date;



DELIMITER //

CREATE PROCEDURE BookClass(
    IN p_member_id INT,
    IN p_schedule_id INT
)
BEGIN
    DECLARE v_current_bookings INT;
    DECLARE v_max_capacity INT;
    DECLARE v_class_name VARCHAR(100);
    
    SELECT current_bookings, max_capacity 
    INTO v_current_bookings, v_max_capacity
    FROM ClassSchedule 
    WHERE schedule_id = p_schedule_id;
    
    -- check if the class is full
    IF v_current_bookings >= v_max_capacity THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Class is full! Cannot make booking.';
    ELSE
        -- add the booking
        INSERT INTO Bookings (member_id, schedule_id, booking_date, attended, rating)
        VALUES (p_member_id, p_schedule_id, NOW(), FALSE, NULL);
     
        UPDATE ClassSchedule 
        SET current_bookings = current_bookings + 1
        WHERE schedule_id = p_schedule_id;
        
        -- add 10 reward points to the member
        UPDATE Members 
        SET reward_points = reward_points + 10
        WHERE member_id = p_member_id;
        
        SELECT class_name INTO v_class_name
        FROM Classes c
        JOIN ClassSchedule cs ON c.class_id = cs.class_id
        WHERE cs.schedule_id = p_schedule_id;
        
        SELECT CONCAT('✓ Booking confirmed for ', v_class_name, '! +10 reward points earned.') AS booking_status;
    END IF;
END //

DELIMITER ;

-- Example of calling the stored procedure:
-- CALL BookClass(1, 1);

-- =====================================================
-- PART 11: NORMALIZATION EVIDENCE
-- =====================================================

-- The database is normalized because:
-- 1. Members table stores personal info once (no repetition)
-- 2. Classes table defines class types once (not repeated in each schedule)
-- 3. Bookings connects members and schedules (many-to-many relationship)
-- 4. No duplicate data across tables
-- 5. All non-key attributes depend on the primary key

-- =====================================================
-- PART 12: CREATIVE SCENARIO SUMMARY
-- =====================================================

/*

