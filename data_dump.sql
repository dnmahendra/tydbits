--
-- PostgreSQL database dump
--
command
pg_dump -U user_name -h localhost -t table_name --data-only --column-inserts db_name > data_dump.sql

-- Dumped from database version 9.5.0
-- Dumped by pg_dump version 9.5.0

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

SET search_path = public, pg_catalog;

--
-- Data for Name: bits; Type: TABLE DATA; Schema: public; Owner: sarada
--

INSERT INTO bits (id, name, description, category_id, url, thumbnail) VALUES (2, 'nobody', 'talk to friends', NULL, 'https://tydbits.s3-ap-southeast-2.amazonaws.com/nobody', NULL);
INSERT INTO bits (id, name, description, category_id, url, thumbnail) VALUES (3, 'kevinbacon', 'we are like kevin bacon', 1, 'https://tydbits.s3-ap-southeast-2.amazonaws.com/kevinbacon', NULL);
INSERT INTO bits (id, name, description, category_id, url, thumbnail) VALUES (4, 'sorry', 'how this machine worked', 1, 'https://tydbits.s3-ap-southeast-2.amazonaws.com/sorry', NULL);
INSERT INTO bits (id, name, description, category_id, url, thumbnail) VALUES (5, 'onme', 'It''s on me', 1, 'https://tydbits.s3-ap-southeast-2.amazonaws.com/onme', NULL);
INSERT INTO bits (id, name, description, category_id, url, thumbnail) VALUES (6, 'getout', 'Anyone want to get out', 1, 'https://tydbits.s3-ap-southeast-2.amazonaws.com/getout', NULL);
INSERT INTO bits (id, name, description, category_id, url, thumbnail) VALUES (7, 'breakfast', 'I made breakfast', 1, 'https://tydbits.s3-ap-southeast-2.amazonaws.com/breakfast', NULL);
INSERT INTO bits (id, name, description, category_id, url, thumbnail) VALUES (11, 'plan', 'you have a plan??', 1, 'https://tydbits.s3-ap-southeast-2.amazonaws.com/plan', 'https://tydbits.s3-ap-southeast-2.amazonaws.com/Avatars/6BVnmod.jpg');


--
-- Name: bits_id_seq; Type: SEQUENCE SET; Schema: public; Owner: sarada
--

SELECT pg_catalog.setval('bits_id_seq', 11, true);


--
-- PostgreSQL database dump complete
--

