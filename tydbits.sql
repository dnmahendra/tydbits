CREATE DATABASE tydbits;

CREATE TABLE users (
	id SERIAL8 PRIMARY KEY,
	name VARCHAR(100),
	email VARCHAR(100) NOT NULL,
	password_digest VARCHAR(400) NOT NULL
);

CREATE TABLE bits (
	id SERIAL8 PRIMARY KEY,
	name VARCHAR(100),
	description VARCHAR(100),
	category_id INTEGER,
	url varchar(200)
);

CREATE TABLE categories (
	id SERIAL4 PRIMARY KEY,
	name VARCHAR(50)
);

CREATE TABLE likes (
	id SERIAL4 PRIMARY KEY,
	user_id SERIAL8 NOT NULL,
	bit_id SERIAL8 NOT NULL
);

INSERT INTO category (name) VALUES ('sounds');
INSERT INTO category (name) VALUES ('stickers');
INSERT INTO category (name) VALUES ('quotes');

