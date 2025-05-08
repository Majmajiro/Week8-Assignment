-- First create the afterschool_programs database
CREATE DATABASE afterschool_programs;
USE afterschool_programs;

-- Create the students table, instructors table, programs table, enrollments table, location table and payments table plus their relationships
-- Students Table
CREATE TABLE Students (
    student_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    date_of_birth DATE,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone_number VARCHAR(20),
    level ENUM('Beginner', 'Intermediate', 'Advanced') NOT NULL,
    registration_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Instructors Table
CREATE TABLE Instructors (
    instructor_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone_number VARCHAR(20),
    biography TEXT,
    active BOOLEAN DEFAULT TRUE
);

-- Locations Table
CREATE TABLE Locations (
    location_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    address VARCHAR(255),
    city VARCHAR(100),
    country VARCHAR(100)
);

-- Programs Table
CREATE TABLE Programs (
    program_id INT AUTO_INCREMENT PRIMARY KEY,
    program_name VARCHAR(100) NOT NULL,
    description TEXT NOT NULL,
    level ENUM('Beginner', 'Intermediate', 'Advanced') NOT NULL,
    mode_of_delivery ENUM('Group Class', 'Private Class', 'Virtual Class') NOT NULL,
    duration INT, -- Duration in weeks
    price DECIMAL(10, 2) NOT NULL,
    location_id INT,
    FOREIGN KEY (location_id) REFERENCES Locations(location_id)
);

-- Enrollments Table
CREATE TABLE Enrollments (
    enrollment_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT,
    program_id INT,
    enrollment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status ENUM('Enrolled', 'Completed', 'Cancelled') DEFAULT 'Enrolled',
    FOREIGN KEY (student_id) REFERENCES Students(student_id),
    FOREIGN KEY (program_id) REFERENCES Programs(program_id)
);

-- Payments Table
CREATE TABLE Payments (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    enrollment_id INT,
    payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    amount DECIMAL(10, 2) NOT NULL,
    payment_status ENUM('Pending', 'Completed', 'Failed') DEFAULT 'Pending',
    FOREIGN KEY (enrollment_id) REFERENCES Enrollments(enrollment_id)
);

-- Program_Instructors Table (M:M relationship between Programs and Instructors)
CREATE TABLE Program_Instructors (
    program_id INT,
    instructor_id INT,
    PRIMARY KEY (program_id, instructor_id),
    FOREIGN KEY (program_id) REFERENCES Programs(program_id),
    FOREIGN KEY (instructor_id) REFERENCES Instructors(instructor_id)
);

--Inserting sample data into the tables
-- Insert Locations
INSERT INTO Locations (name, address, city, country) VALUES
('Classroom A', '123 Main St', 'Nairobi', 'Kenya'),
('Classroom B', '456 Market St', 'Nairobi', 'Kenya');

-- Insert Programs
INSERT INTO Programs (program_name, description, level, mode_of_delivery, duration, price, location_id) VALUES
('Basic Coding', 'Introduction to coding basics for kids.', 'Beginner', 'Group Class', 8, 1500, 1),
('Advanced Chess', 'Learn advanced chess strategies and gameplay.', 'Advanced', 'Private Class', 12, 2000, 2);

-- Insert Students
INSERT INTO Students (first_name, last_name, email, phone_number, level) VALUES
('John', 'Doe', 'john.doe@example.com', '1234567890', 'Beginner'),
('Jane', 'Smith', 'jane.smith@example.com', '0987654321', 'Advanced');

-- Insert Instructors
INSERT INTO Instructors (first_name, last_name, email, phone_number, biography) VALUES
('Mary', 'Johnson', 'mary.johnson@example.com', '1122334455', 'Experienced in teaching coding and chess.'),
('Samuel', 'Kamau', 'samuel.kamau@example.com', '2233445566', 'STEM educator and chess coach.');

-- Insert Enrollments
INSERT INTO Enrollments (student_id, program_id, status) VALUES
(1, 1, 'Enrolled'),
(2, 2, 'Enrolled');

-- Insert Payments
INSERT INTO Payments (enrollment_id, amount, payment_status) VALUES
(1, 1500, 'Completed'),
(2, 2000, 'Pending');

-- Insert Program_Instructors
INSERT INTO Program_Instructors (program_id, instructor_id) VALUES
(1, 1), -- Mary teaches Basic Coding
(2, 2); -- Samuel teaches Advanced Chess

-- Decided to update some data for student 1 and instructor 1
UPDATE Students
SET email = 'john.doe@yahoo.com'
WHERE student_id = 1;

UPDATE Instructors
SET email = 'mary.johnson@expressmail.com'
WHERE instructor_id = 1;

-- Decided to also add tracking tables >> schedule, attendance and rating and insert some sample data into them
-- Tracks session dates and attendance
CREATE TABLE Attendance (
    attendance_id INT AUTO_INCREMENT PRIMARY KEY,
    enrollment_id INT NOT NULL,
    date DATE NOT NULL,
    status ENUM('Present', 'Absent', 'Excused') NOT NULL,
    FOREIGN KEY (enrollment_id) REFERENCES Enrollments(enrollment_id)
);

-- Schedules specific session dates/times for each program
CREATE TABLE Schedule (
    schedule_id INT AUTO_INCREMENT PRIMARY KEY,
    program_id INT NOT NULL,
    session_date DATE NOT NULL,
    start_time TIME NOT NULL,
    end_time TIME NOT NULL,
    FOREIGN KEY (program_id) REFERENCES Programs(program_id)
);

-- Tracks student feedback on programs
CREATE TABLE Ratings (
    rating_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT NOT NULL,
    program_id INT NOT NULL,
    rating INT CHECK (rating BETWEEN 1 AND 5),
    comment TEXT,
    FOREIGN KEY (student_id) REFERENCES Students(student_id),
    FOREIGN KEY (program_id) REFERENCES Programs(program_id)
);

-- Schedule sessions
INSERT INTO Schedule (program_id, session_date, start_time, end_time) VALUES
(1, '2025-05-10', '10:00:00', '11:30:00'),
(2, '2025-05-11', '14:00:00', '15:30:00');

-- Record attendance
INSERT INTO Attendance (enrollment_id, date, status) VALUES
(1, '2025-05-10', 'Present'),
(2, '2025-05-11', 'Absent');

-- Add student ratings
INSERT INTO Ratings (student_id, program_id, rating, comment) VALUES
(1, 1, 5, 'Amazing introduction to coding!'),
(2, 2, 4, 'Loved the chess challenges.');


