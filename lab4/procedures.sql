CREATE OR REPLACE PROCEDURE add_author(name text, birth_date date, rating numeric) AS $$
    plan = plpy.prepare("INSERT INTO author (name, birth_date, rating) VALUES ($1, $2, $3)", ["text", "date", "numeric"])
    plpy.execute(plan, [name, birth_date, rating])
$$ LANGUAGE plpython3u;

DROP PROCEDURE add_author;

CALL add_author('Имя', '2023-01-01', 4.1);

Процедура, определять авторов, работающих с конкретным издательством(название)

CREATE OR REPLACE PROCEDURE get_authors_by_publisher(pub_name text) AS $$
    plan_pub_id = plpy.prepare("SELECT id FROM publisher WHERE name = $1", ["text"])
    pub_id = plpy.execute(plan_pub_id, [pub_name])[0]["id"]

    plan_author_ids = plpy.prepare("SELECT author_id FROM book WHERE publisher_id = $1", ["integer"])
    author_ids = plpy.execute(plan_author_ids, [pub_id])
    
    authors = []
    for arow in author_ids:
        author_id = arow["author_id"]
        plan_get_author = plpy.prepare("SELECT name, birth_date, rating FROM author WHERE id = $1", ["integer"])
        author = plpy.execute(plan_get_author, [author_id])
        authors.append(author[0])
    for author in authors:
        plpy.notice(f"Name: {author["name"]}, Birth_date: {author["birth_date"]}, Rating: {author["rating"]}")
$$ LANGUAGE plpython3u;

DROP PROCEDURE get_authors_by_publisher;

CALL get_authors_by_publisher('АО «Ситникова, Муравьев и Миронов»');