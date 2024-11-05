CREATE TYPE publisher_info AS (
    name text,
    address text,
    phone text,
    licence_number text
);

CREATE OR REPLACE FUNCTION get_publisher_info(pub_id integer) RETURNS publisher_info AS $$
    plan = plpy.prepare("SELECT name, address, phone, licence_number FROM publisher WHERE id = $1", ["integer"])
    result = plpy.execute(plan, [pub_id])
    if result:
        return (result[0]["name"], result[0]["address"], result[0]["phone"], result[0]["licence_number"])
    else:
        return None
$$ LANGUAGE plpython3u;

DROP FUNCTION get_publisher_info;

SELECT get_publisher_info(1);