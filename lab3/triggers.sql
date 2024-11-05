CREATE OR REPLACE FUNCTION update_author_rating_after_insert()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE author
    SET rating = (SELECT AVG(rating) FROM book WHERE author_id = NEW.author_id)
    WHERE id = NEW.author_id;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_author_rating_trigger
AFTER INSERT ON book
FOR EACH ROW
EXECUTE FUNCTION update_author_rating_after_insert();

INSERT INTO book (title, publication_date, isbn, genre, rating, author_id, publisher_id, translator_id)
VALUES ('TEST', '2024-01-01', 7123958204781, 'Test', 2.0, 1, 264, 173);


CREATE VIEW book_fiction_view AS
SELECT *
FROM book
WHERE genre = 'Fiction';

DROP VIEW book_view;

CREATE OR REPLACE FUNCTION prevent_delete_book_view()
RETURNS TRIGGER AS $$
BEGIN
    RAISE NOTICE 'Cant drop fiction book';    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER prevent_delete_book_view_trigger
INSTEAD OF DELETE ON book_fiction_view
FOR EACH ROW
EXECUTE FUNCTION prevent_delete_book_view();

DROP TRIGGER prevent_delete_book_view_trigger ON book_view;

DELETE FROM book_fiction_view
WHERE author_id = 88;