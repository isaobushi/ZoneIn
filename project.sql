CREATE DATABASE student_tool;




CREATE TABLE subjects (
    id SERIAL PRIMARY KEY,
    name VARCHAR(200),
    user_id INTEGER
);


CREATE TABLE users(
    id SERIAL PRIMARY KEY,
    email VARCHAR(400),
    password_digest VARCHAR(400),
    name VARCHAR(400),
    avatar TEXT,
    level DECIMAL(10,2) 
);

CREATE TABLE questions (
    id SERIAL PRIMARY KEY,
    level DECIMAL(10,2),
    subject_id INTEGER,
    result VARCHAR(200)
);

CREATE TABLE joint_user_subjects (
    id SERIAL PRIMARY KEY,
    user_id INTEGER,
    subject_id INTEGER,
    level DECIMAL(10,2)
);

CREATE TABLE student_scores (
    id SERIAL PRIMARY KEY,
    user_id INTEGER,
    subject_id INTEGER,
    question_id INTEGER,
    score INTEGER,
    created_at TIMESTAMP DEFAULT NOW()
);

    