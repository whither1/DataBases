CREATE OR REPLACE FUNCTION check_rating() RETURNS TRIGGER AS $$
    if TD["new"]["rating"] is None:
        TD["new"]["rating"] = 0
    elif not (0 <= TD["new"]["rating"] <= 5):
        TD["new"]["rating"] = 0
    return "MODIFY"
$$ LANGUAGE plpython3u;

CREATE TRIGGER book_rating_trigger
BEFORE INSERT ON book
FOR EACH ROW
EXECUTE FUNCTION check_rating();
