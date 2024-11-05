CREATE OR REPLACE FUNCTION get_average_author_rating(aid INTEGER) RETURNS numeric(2, 1) AS $$
DECLARE
    avg_rating numeric(2, 1);
BEGIN
    SELECT AVG(book.rating) INTO avg_rating 
    FROM book 
    WHERE book.author_id = aid;
    RETURN avg_rating;
END;
$$ LANGUAGE plpgsql;

DROP Function get_average_author_rating;

SELECT get_average_author_rating(10);

CREATE OR REPLACE FUNCTION get_books_by_genre(genre_name text) 
RETURNS TABLE(book_id int, title text, publication_date date, isbn bigint, rating numeric(2, 1)) AS $$
BEGIN
    RETURN QUERY SELECT book.id, book.title, book.publication_date, book.isbn, book.rating 
                 FROM book
                 WHERE book.genre = genre_name;
END;
$$ LANGUAGE plpgsql;

DROP Function get_books_by_genre;

SELECT get_books_by_genre('Fiction');

CREATE OR REPLACE FUNCTION get_books_by_author_id(aid int) 
RETURNS TABLE(book_title text, author_name text) AS $$
BEGIN
    RETURN QUERY
    SELECT title, name
    FROM book join author on book.author_id = author.id
    where book.author_id = aid;
END;
$$ LANGUAGE plpgsql;

DROP Function get_books_by_author_id;

SELECT get_books_by_author_id(10);

CREATE OR REPLACE FUNCTION get_books_by_date_in_year(cur_date date) 
RETURNS TABLE(title text, publication_date date) AS $$
BEGIN
    RETURN QUERY
    WITH RECURSIVE DATES as (
        SELECT cur_date as now_date
        UNION ALL
        SELECT CAST((DATES.now_date + INTERVAL'1 DAY') as date)
        FROM DATES
        WHERE DATES.now_date < CAST((cur_date + INTERVAL'1 YEAR') as date)
    )
    SELECT book.title, book.publication_date 
    FROM book
    WHERE book.publication_date in (SELECT * from DATES);
END;
$$ LANGUAGE plpgsql;

DROP Function get_books_by_date_in_year;

SELECT get_books_by_date_in_year('01-01-2000');

Функция, аргументы: издательство и год. Вывод: какие книги в этом году: название, автор, переводчик

CREATE OR REPLACE FUNCTION get_publisher_books_by_year(pub_id int, year int)
RETURNS TABLE(book_title text, author_name text, translator_name text)
AS $$
DECLARE
    avg_rating numeric(2, 1);
BEGIN
    RETURN QUERY
        SELECT title, (SELECT name FROM author where id = author_id), (SELECT name FROM translator where id = translator_id)
        FROM book
        WHERE publisher_id = pub_id AND year = extract(YEAR FROM publication_date);
-- pub_name text
-- (SELECT id FROM publisher where name = pub_name)
END;
$$ LANGUAGE plpgsql;

DROP Function get_publisher_books_by_year;

SELECT get_publisher_books_by_year(10, 1985);