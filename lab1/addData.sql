\copy author(name, birth_date, rating, bio) from '/tmp/postgres/authors.csv' delimiter ',' csv header;
\copy publisher(name, address, phone, licence_number) from '/tmp/postgres/publishers.csv' delimiter ',' csv header;
\copy translator(name, birth_date, bio, native_language, rating) from '/tmp/postgres/translators.csv' delimiter ',' csv header;
\copy book(title, publication_date, isbn, genre, rating, author_id, publisher_id, translator_id) from '/tmp/postgres/books.csv' delimiter ',' csv header;