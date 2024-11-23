import psycopg2

conn_params = {
    'dbname': 'books',
    'user': '',
    'password': '',
    'host': '127.0.0.1',
    'port': '5432'
}

def print_menu():
    print("\n0 - Выход")
    print("1 - Скалярный запрос")
    print("2 - Несколько соединений")
    print("3 - Запрос с ОТВ и оконными функциями")
    print("4 - Запрос к метаданным")
    print("5 - Скалярная функция")
    print("6 - Табличная функция")
    print("7 - Хранимая процедура")
    print("8 - Системная функция")
    print("9 - Создать таблицу")
    print("10 - Вставить данные в созданную таблицу")
    print("11 - По названию издательства определить книги текущего года в заданном жанре. Вывести 10 книг")
    print("Выберите действие: ")

querys = {
    1: "SELECT AVG(rating) FROM translator",
    2: "SELECT author.name, publisher.name FROM author JOIN book ON (author.id = book.author_id) JOIN publisher ON (publisher.id = book.publisher_id) ORDER BY author.name",
    3: """
WITH BookWithRank AS (
    SELECT
        title,
        rating,
        genre,
        AVG(rating) OVER (PARTITION BY genre) AS avg_rating_by_genre,
        RANK() OVER (PARTITION BY genre ORDER BY rating DESC) AS rank_in_genre
    FROM
        book
)
SELECT
    title,
    rating,
    genre,
    avg_rating_by_genre,
    rank_in_genre
FROM
    BookWithRank
ORDER BY
    genre,
    rank_in_genre;
""",
    4: "SELECT column_name, data_type, column_default FROM information_schema.columns WHERE table_name = 'book'",
    5: "SELECT get_average_author_rating(38);",
    6: "SELECT get_books_by_genre('Biography');",
    7: "CALL del_books_by_date_in_month('2004-09-01');",
    8: "SELECT current_database();",
    9: "CREATE TABLE IF NOT EXISTS reader(id serial, name text, fav_genre text, fav_book_id int, bio text);",
    10: "INSERT INTO reader(name, fav_genre, fav_book_id, bio) values (\'test_entry\', \'Fiction\', 2, \'TEST\')",
    11: "SELECT * FROM book JOIN publisher ON book.publisher_id = publisher.id WHERE (extract(YEAR from publication_date) = extract(YEAR from now()) AND genre = \'{}\' AND name = \'{}\') LIMIT 10;"
}

def main():
    with psycopg2.connect(**conn_params) as conn:
        with conn.cursor() as cur:
            choice = 0
            while True:
                print_menu()
                choice = int(input())
                if not 0 <= choice <= 12:
                    print("Введите номер действия от 0 до 10")
                if not choice:
                    break
                try:
                    if choice == 11:
                        genre = input("Введите жанр искомых книг: ")
                        publisher = input("Введите издательство искомых книг: ")
                        cur.execute(querys[choice].format(genre, publisher))
                    else:
                        cur.execute(querys[choice])
                    conn.commit()
                except psycopg2.errors.UndefinedTable:
                    print("Сначала создайте таблицу(опция 9)")
                    conn.rollback()
                else:
                    if cur.description:
                        rows = cur.fetchall()
                        for row in rows:
                            print(*row)
                    else:
                        print("Успех!")

if __name__ == '__main__':
    main()
