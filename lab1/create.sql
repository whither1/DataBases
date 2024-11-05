create table author(id serial, name text, birth_date date, rating numeric(2, 1), bio text);
create table publisher(id serial, name text, address text, phone text, licence_number int);
create table translator(id serial, name text, birth_date date, bio text, native_language varchar(25), rating numeric(2, 1));

create table book(id serial, title text, publication_date date, isbn bigint, genre text, rating numeric(2, 1), author_id int, publisher_id int, translator_id int);