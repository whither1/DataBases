\pset format unaligned
\pset border 0
\pset linestyle ascii
\pset fieldsep ','
\pset tuples_only
\o ./lab5/author.json
    SELECT json_agg(
        row_to_json(author)
    )
    FROM author;
\o