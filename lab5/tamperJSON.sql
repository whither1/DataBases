SELECT author_info->'name' FROM book2;

SELECT author_info->>'birth_date' FROM book2;

SELECT author_info ? 'aid' FROM book2;

UPDATE book2
set author_info = jsonb_set(author_info, '{name}', '"имя2"')
WHERE id = 2;

SELECT jsonb_each_text(author_info)
from book2;

-- Извлеч все записи с жанром 'Non-Fiction'
SELECT author_info
FROM book2
WHERE genre = 'Non-fiction'