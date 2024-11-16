CREATE TEMP TABLE bookjson(data json);
\COPY bookjson from './lab5/author.json';

-- SELECT * FROM bookjson;

UPDATE book2
SET author_info = value
from (SELECT value, row_number() over () as rn
      FROM bookjson, json_array_elements(data) as value) as json_table
WHERE id = (SELECT id FROM book2 ORDER BY id LIMIT 1 OFFSET rn - 1);