-- LMS database schema (MySQL). Generated from the LMS class diagram.
-- Inheritance: users is the parent table; students, teachers and admins
-- share its primary key (table-per-subclass).

CREATE DATABASE IF NOT EXISTS lms;
USE lms;

CREATE TABLE users (
    user_id        INT AUTO_INCREMENT PRIMARY KEY,
    name           VARCHAR(100)  NOT NULL,
    email          VARCHAR(255)  NOT NULL UNIQUE,
    password_hash  VARCHAR(255)  NOT NULL
);

CREATE TABLE students (
    student_id INT PRIMARY KEY,
    FOREIGN KEY (student_id) REFERENCES users(user_id) ON DELETE CASCADE
);

CREATE TABLE teachers (
    teacher_id INT PRIMARY KEY,
    department VARCHAR(100),
    FOREIGN KEY (teacher_id) REFERENCES users(user_id) ON DELETE CASCADE
);

CREATE TABLE admins (
    admin_id INT PRIMARY KEY,
    FOREIGN KEY (admin_id) REFERENCES users(user_id) ON DELETE CASCADE
);

CREATE TABLE courses (
    course_id   INT AUTO_INCREMENT PRIMARY KEY,
    title       VARCHAR(200) NOT NULL,
    description TEXT,
    teacher_id  INT NOT NULL,
    FOREIGN KEY (teacher_id) REFERENCES teachers(teacher_id)
);

-- Composition: parts are deleted together with their course.
CREATE TABLE contents (
    content_id INT AUTO_INCREMENT PRIMARY KEY,
    title      VARCHAR(200) NOT NULL,
    type       VARCHAR(50)  NOT NULL,
    file_path  VARCHAR(255) NOT NULL,
    course_id  INT NOT NULL,
    FOREIGN KEY (course_id) REFERENCES courses(course_id) ON DELETE CASCADE
);

CREATE TABLE assignments (
    assignment_id INT AUTO_INCREMENT PRIMARY KEY,
    title         VARCHAR(200) NOT NULL,
    deadline      DATETIME     NOT NULL,
    max_grade     INT          NOT NULL CHECK (max_grade > 0),
    course_id     INT NOT NULL,
    FOREIGN KEY (course_id) REFERENCES courses(course_id) ON DELETE CASCADE
);

CREATE TABLE quizzes (
    quiz_id   INT AUTO_INCREMENT PRIMARY KEY,
    title     VARCHAR(200) NOT NULL,
    duration  INT          NOT NULL CHECK (duration > 0), -- minutes
    course_id INT NOT NULL,
    FOREIGN KEY (course_id) REFERENCES courses(course_id) ON DELETE CASCADE
);

-- Association class: resolves the many-to-many Student - Course relationship.
CREATE TABLE enrollments (
    enrollment_id INT AUTO_INCREMENT PRIMARY KEY,
    enrolled_at   DATETIME DEFAULT CURRENT_TIMESTAMP,
    student_id    INT NOT NULL,
    course_id     INT NOT NULL,
    UNIQUE (student_id, course_id),
    FOREIGN KEY (student_id) REFERENCES students(student_id) ON DELETE CASCADE,
    FOREIGN KEY (course_id)  REFERENCES courses(course_id)   ON DELETE CASCADE
);

CREATE TABLE submissions (
    submission_id INT AUTO_INCREMENT PRIMARY KEY,
    file_path     VARCHAR(255) NOT NULL,
    submitted_at  DATETIME DEFAULT CURRENT_TIMESTAMP,
    grade         INT NULL CHECK (grade >= 0),
    assignment_id INT NOT NULL,
    student_id    INT NOT NULL,
    UNIQUE (assignment_id, student_id),
    FOREIGN KEY (assignment_id) REFERENCES assignments(assignment_id) ON DELETE CASCADE,
    FOREIGN KEY (student_id)    REFERENCES students(student_id)       ON DELETE CASCADE
);
