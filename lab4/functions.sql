CREATE OR REPLACE FUNCTION calculate_age(aid INTEGER) RETURNS integer AS $$
    import datetime
    plan = plpy.prepare("SELECT birth_date FROM author WHERE id = $1;", ["integer"])
    author_birth_date = datetime.date.fromisoformat(plpy.execute(plan, [aid])[0]["birth_date"])
    today = datetime.date.today()
    age = today.year - author_birth_date.year
    if (today.month, today.day) < (author_birth_date.month, author_birth_date.day):
        age -= 1
    return age
$$ LANGUAGE plpython3u;

DROP FUNCTION calculate_age;

SELECT calculate_age(3);

CREATE OR REPLACE FUNCTION avg_rating_sfunc(state numeric[], rating numeric) RETURNS numeric[] AS $$
    if state is None:
        return [rating, 1]
    else:
        return [state[0] + rating, state[1] + 1]
$$ LANGUAGE plpython3u;

CREATE OR REPLACE FUNCTION avg_rating_finalfunc(state numeric[]) RETURNS numeric(2, 1) AS $$
    return state[0] / state[1] if state[1] > 0 else 0
$$ LANGUAGE plpython3u;

CREATE AGGREGATE avg_rating(numeric) (
    sfunc = avg_rating_sfunc,
    stype = numeric[],
    finalfunc = avg_rating_finalfunc,
    initcond = '{0, 0}'
);

DROP AGGREGATE avg_rating(numeric);

SELECT avg_rating(rating) from book;

CREATE OR REPLACE FUNCTION get_books_by_translator(translator_name text) RETURNS TABLE(id integer, title text, publication_date date, isbn bigint, genre text, rating numeric, author_id integer, publisher_id integer, translator_id integer) AS $$
    return plpy.execute(f"SELECT * FROM book WHERE translator_id = (SELECT id FROM translator WHERE name = '{translator_name}')")
$$ LANGUAGE plpython3u;

DROP FUNCTION get_books_by_translator;

SELECT get_books_by_translator('Наталья Степановна Ширяева');

