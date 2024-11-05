SELECT *
FROM book 
WHERE rating > 4.0;

SELECT *
FROM book
WHERE publication_date BETWEEN '2000-01-01' and NOW();

SELECT *
FROM book
WHERE title LIKE '%народ%';

SELECT *
FROM book
WHERE author_id in (SELECT id 
                    from author
                    where extract(YEAR from now()) - extract(YEAR from birth_date) > 50);

SELECT NAME
FROM author
WHERE EXISTS (SELECT author_id
              FROM book
              WHERE rating < 0.2);

SELECT *
FROM translator
WHERE birth_date > ALL(SELECT publication_date FROM book);

SELECT (SELECT name FROM author WHERE id = author_id), avg(book.rating)
FROM book
GROUP BY author_id;

SELECT *, (SELECT min(publication_date) FROM book) as "Самая ранняя книга",
              (SELECT max(publication_date) FROM book) as "Самая поздняя книга"
FROM book;

SELECT name,
CASE extract(year FROM birth_date)
    WHEN extract(YEAR FROM now()) - 20 THEN '20 лет!'
    WHEN extract(YEAR FROM now()) - 30 THEN '30 лет!'
    WHEN extract(YEAR FROM now()) - 40 THEN '40 лет!'
    WHEN extract(YEAR FROM now()) - 50 THEN '50 лет!'
    WHEN extract(YEAR FROM now()) - 60 THEN '60 лет!'
    WHEN extract(YEAR FROM now()) - 70 THEN '70 лет!'
    WHEN extract(YEAR FROM now()) - 80 THEN '80 лет!'
    WHEN extract(YEAR FROM now()) - 90 THEN '90 лет!'
    WHEN extract(YEAR FROM now()) - 100 THEN '100 лет!'
    ELSE 'Не юбелей('
END as "Юбелеи"
FROM author;

SELECT title,
CASE 
    WHEN extract(YEAR from publication_date) < '2000' THEN 'До 2000-x'
    WHEN extract(YEAR from publication_date) > '2010' THEN 'После 2000-x'
    ELSE 'В 2000-е'
END as "Период выхода"
FROM book;

SELECT (select name from author where id = book.author_id) as "name", count(*) as "work_amount"
-- into #WORK_AMOUNT
from book
GROUP BY author_id
ORDER BY count(*) DESC;

SELECT genre, title
from book JOIN (SELECT id, max(rating) as rating FROM book WHERE genre = 'Fiction' GROUP BY id ORDER BY rating desc LIMIT 1) as best ON best.id = book.id
UNION
SELECT genre, title
from book JOIN (SELECT id, max(rating) as rating FROM book WHERE genre = 'Non-fiction' GROUP BY id ORDER BY rating desc LIMIT 1) as best ON best.id = book.id

SELECT name
FROM author
WHERE id in (SELECT author_id 
            FROM book 
            where translator_id in (SELECT id 
                                   FROM translator 
                                   where rating = (SELECT max(rating) 
                                                    from translator)));

SELECT genre, avg(rating) as avg_rating
FROM book
GROUP BY genre;

SELECT id, avg(rating)
FROM translator
GROUP BY id
HAVING avg(rating) > 3;

INSERT INTO book (title, publication_date, isbn, genre, rating, author_id, publisher_id, translator_id)
VALUES ('Исскуство войны', '2000-01-01', 1423950176773, 'History', 5.0, 826, 264, 173);

INSERT INTO book (title, publication_date, isbn, genre, rating, author_id, publisher_id, translator_id)
SELECT title, publication_date, isbn + 22, genre, 6.0, author_id, publisher_id, 400
FROM book
WHERE rating = 5.0;

UPDATE book
SET rating = rating + 0.1
WHERE rating < 1;

UPDATE translator
SET rating = (SELECT avg(rating)
              FROM book
              WHERE translator_id = 173)
WHERE id = 173;

DELETE FROM book
WHERE author_id = 666;

DELETE FROM book
WHERE translator_id IN (SELECT book.translator_id
                        FROM book JOIN translator ON book.translator_id = translator.id
                        WHERE extract(YEAR from translator.birth_date) - extract(YEAR FROM book.publication_date) BETWEEN 0 and 1)

WITH WORKS (author, NumberOfWorks) AS (
    SELECT DISTINCT author_id, count(*)
    fROM book
    GROUP BY author_id
)
SELECT avg(NumberOfWorks) as "Среднее кол-во произведений"
FROM WORKS

WITH RECURSIVE DATES as (
    SELECT '01-01-1980'::date as cur_date
    UNION ALL
    SELECT CAST((cur_date + INTERVAL'1 DAY') as date)
    FROM DATES
    WHERE cur_date < '01-01-1981'
)
SELECT title, publication_date 
FROM book
WHERE book.publication_date in (SELECT cur_date from DATES)

SELECT a.name, b.title, b.rating, a.rating,
        avg(b.rating) over(PARTITION BY b.author_id) as "avg_book_rating",
        min(b.rating) over(PARTITION BY b.author_id) as "min_book_rating",
        max(b.rating) over(PARTITION BY b.author_id) as "max_book_rating"
FROM book b left outer JOIN author a on b.author_id = a.id 

INSERT INTO book (title, publication_date, isbn, genre, rating, author_id, publisher_id, translator_id)
SELECT title, publication_date, isbn + 1, genre, rating, author_id, publisher_id, translator_id
FROM book
WHERE rating > 4;

DELETE FROM book
WHERE id in (with duplicates as (
                SELECT *,
                    ROW_NUMBER() over (PARTITION BY title ORDER BY id) as row_num
                FROM book
            )
            SELECT id
            FROM duplicates
            WHERE row_num = 2
)

with duplicates as (
                SELECT *,
                    ROW_NUMBER() over (PARTITION BY title ORDER BY id) as row_num
                FROM book
            )
            SELECT id
            FROM duplicates
            WHERE row_num = 2

Название и жанр для книг, которые написал автор, родившийся в 80. Вывести ФИО, издательство, ФИО переводчика

WITH book_info as (
    SELECT title, genre, author_id, publisher_id, translator_id
    FROM book
    where author_id in (SELECT id
                        FROM author
                        WHERE extract(YEAR FROM birth_date) BETWEEN 1980 and 1989)
)
SELECT title, genre, (SELECT name FROM author WHERE id = book_info.author_id) as "author",
                     (SELECT name FROM publisher WHERE id = book_info.publisher_id) as "publisher",
                     (SELECT name FROM translator WHERE id = book_info.translator_id) as "translator"
from book_info
