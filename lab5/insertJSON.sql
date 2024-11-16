CREATE TEMP TABLE bookjson(data json);
\COPY bookjson from './lab5/book1.json';
DROP TABLE if EXISTS book2;
create table book2(id serial, title text, publication_date date, isbn bigint, genre text, rating numeric(2, 1), author_id int, publisher_id int, translator_id int);

INSERT into book2
SELECT
    (value->>'id')::int,
    (value->>'title'),
    (value->>'publication_date')::date,
    (value->>'isbn')::bigint,
    (value->>'genre'),
    (value->>'rating')::numeric,
    (value->>'author_id')::int,
    (value->>'publisher_id')::int,
    (value->>'translator_id')::int
FROM bookjson, json_array_elements(data) as value;

-- INSERT INTO book2 (id, title, publication_date, isbn, genre, rating, author_id, publisher_id, translator_id)
-- VALUES ()

-- \COPY (SELECT id,title,publication_date::date,isbn,genre,rating::numeric(2, 1),author_id,publisher_id,translator_idFROM jsonb_to_recordset(pg_read_file('/home/whither/dataBases/lab5/book1.json')::jsonb) AS books(id int,title text,publication_date text,isbn bigint,genre text,rating text,author_id int,publisher_id int,translator_id int)) TO '/home/whither/dataBases/lab5/book2.csv' WITH CSV HEADER;

-- \copy book2(id, title, publication_date, isbn, genre, rating, author_id, publisher_id, translator_id) from '/home/whither/dataBases/lab5/book2.csv' WITH CSV HEADER;