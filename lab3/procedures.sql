CREATE OR REPLACE PROCEDURE books_by_genre(genre_name text)
AS $$
DECLARE
    book_record RECORD;
BEGIN
    FOR book_record IN SELECT title, publication_date, isbn, rating 
                       FROM book 
                       WHERE genre = genre_name
    LOOP
        RAISE NOTICE 'Title: %, Publication Date: %, ISBN: %, Rating: %', 
                     book_record.title, book_record.publication_date, book_record.isbn, book_record.rating;
    END LOOP;
END;
$$ LANGUAGE plpgsql;

DROP PROCEDURE books_by_genre;

CALL books_by_genre('Non-fiction');

CREATE OR REPLACE PROCEDURE del_books_by_date_in_month(cur_date date) 
AS $$
BEGIN
    WITH RECURSIVE DATES as (
        SELECT cur_date as now_date
        UNION ALL
        SELECT CAST((DATES.now_date + INTERVAL'1 DAY') as date)
        FROM DATES
        WHERE DATES.now_date < CAST((cur_date + INTERVAL'1 MONTH') as date)
    )
    DELETE from book where id in (
        SELECT book.id 
        FROM book
        WHERE book.publication_date in (SELECT * from DATES)
    );
END;
$$ LANGUAGE plpgsql;

DROP PROCEDURE del_books_by_date_in_month;

CALL del_books_by_date_in_month('1990-11-01');

CREATE OR REPLACE PROCEDURE update_rating_of_authors(start_aid int, end_aid int) 
AS $$
DECLARE
    author_record RECORD;
    author_cursor CURSOR FOR SELECT id, rating
                             FROM author
                             WHERE id BETWEEN start_aid and end_aid;
BEGIN
    OPEN author_cursor;
    LOOP
        FETCH author_cursor INTO author_record;
        EXIT WHEN NOT FOUND;
        UPDATE book
        SET rating = author_record.rating
        WHERE author_id = author_record.id;
    END LOOP;
    CLOSE author_cursor;
END;
$$ LANGUAGE plpgsql;book_fiction_view

DROP PROCEDURE update_rating_of_authors;

CALL update_rating_of_authors(1, 10);

CREATE OR REPLACE PROCEDURE get_table_metadata(tname name)
AS $$
DECLARE
    column_record RECORD;
BEGIN
    FOR column_record IN SELECT column_name, data_type 
                         FROM information_schema.columns 
                         WHERE table_name = tname
    LOOP
        RAISE NOTICE 'Column Name: %, Data Type: %', 
                     column_record.column_name, column_record.data_type;
    END LOOP;
END;
$$ LANGUAGE plpgsql;

DROP PROCEDURE get_table_metadata;

CALL get_table_metadata('translator');