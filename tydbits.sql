CREATE DATABASE tydbits;

CREATE TABLE users (
	id SERIAL8 PRIMARY KEY,
	name VARCHAR(100),
	email VARCHAR(100) NOT NULL,
	password_digest VARCHAR(400) NOT NULL,
	avatar VARCHAR(400)
);

CREATE TABLE bits (
	id SERIAL8 PRIMARY KEY,
	name VARCHAR(100),
	description VARCHAR(100),
	category_id INTEGER,
	url varchar(200),
	thumbnail VARCHAR(400),
	user_id SERIAL8
);
ALTER TABLE bits ADD  FOREIGN KEY(user_id) REFERENCES users(id);

CREATE TABLE categories (
	id SERIAL4 PRIMARY KEY,
	name VARCHAR(50)
);

CREATE TABLE likes (
	id SERIAL4 PRIMARY KEY,
	user_id SERIAL8 NOT NULL,
	bit_id SERIAL8 NOT NULL
);
ALTER TABLE likes ADD  FOREIGN KEY(user_id) REFERENCES users(id);
ALTER TABLE likes ADD  FOREIGN KEY(bit_id) REFERENCES bits(id);

INSERT INTO categories (name) VALUES ('sounds');
INSERT INTO categories (name) VALUES ('stickers');
INSERT INTO categories (name) VALUES ('quotes');


