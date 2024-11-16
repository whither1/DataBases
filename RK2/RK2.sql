CREATE DATABASE RK2;
CREATE TABLE excursion(id serial, excursion_name text, descr text, opening_date date, closing_date date);
CREATE TABLE stand(id serial, stand_name text, domain text, descr text);
CREATE TABLE visitor(id serial, full_name text, address text, phone_number text);
CREATE TABLE excursions_visitors(id serial, excursion_id int, visitor_id int);
CREATE TABLE excursions_stands(id serial, excursion_id int, stand_id int);

DROP TABLE excursions_visitors

alter table excursion
add constraint primary_id_excursion PRIMARY KEY (id);

alter table stand
add constraint primary_id_stand PRIMARY KEY (id);

alter table visitor
add constraint primary_id_visitor PRIMARY KEY (id);

alter table excursions_stands
add constraint primary_id_excursions_stands PRIMARY KEY (id),
add constraint foreign_key_excursion_id_excursions_stands FOREIGN KEY (excursion_id) REFERENCES excursion(id),
add constraint foreign_key_stand_id_excursions_stands FOREIGN KEY (stand_id) REFERENCES stand(id);


alter table excursions_visitors
add constraint primary_id_excursions_visitors PRIMARY KEY (id),
add constraint foreign_key_excursion_id_excursions_visitors FOREIGN KEY (excursion_id) REFERENCES excursion(id),
add constraint foreign_key_visitor_id_excursions_visitors FOREIGN KEY (visitor_id) REFERENCES visitor(id);

INSERT INTO excursion(excursion_name, descr, opening_date, closing_date) VALUES ('Выразить.', 'Неудобно тяжелый еврейский ночь уничтожение.', '2024-01-23', '2024-10-23');
INSERT INTO excursion(excursion_name, descr, opening_date, closing_date) VALUES ('Лиловый.', 'Отдел провинция миг угроза мелькнуть цель песня.', '2024-02-27 00:00:00', '2024-07-30 00:00:00');
INSERT INTO excursion(excursion_name, descr, opening_date, closing_date) VALUES ('Народ.', 'Руководитель доставать монета манера находить.', '2024-02-10 00:00:00', '2024-12-10 00:00:00');
INSERT INTO excursion(excursion_name, descr, opening_date, closing_date) VALUES ('Некоторый.', 'Направо потрясти счастье прежний четко.', '2024-06-04 00:00:00', '2024-07-07 00:00:00');
INSERT INTO excursion(excursion_name, descr, opening_date, closing_date) VALUES ('Эпоха.', 'Оборот факультет район плод мотоцикл совет слать.', '2024-03-19 00:00:00', '2024-12-26 00:00:00');
INSERT INTO excursion(excursion_name, descr, opening_date, closing_date) VALUES ('Вообще.', 'О полоска ломать задрать.', '2024-03-28 00:00:00', '2024-12-22 00:00:00');
INSERT INTO excursion(excursion_name, descr, opening_date, closing_date) VALUES ('Белье.', 'Бак применяться висеть манера ответить.', '2024-05-28 00:00:00', '2024-09-30 00:00:00');
INSERT INTO excursion(excursion_name, descr, opening_date, closing_date) VALUES ('Чем.', 'Демократия настать мучительно теория.', '2024-03-06 00:00:00', '2024-07-05 00:00:00');
INSERT INTO excursion(excursion_name, descr, opening_date, closing_date) VALUES ('Коммунизм.', 'Отметить табак да пламя.', '2024-06-27 00:00:00', '2024-12-04 00:00:00');
INSERT INTO excursion(excursion_name, descr, opening_date, closing_date) VALUES ('Упор.', 'Район полюбить мрачно белье.', '2024-04-29 00:00:00', '2024-10-12 00:00:00');

INSERT INTO stand(stand_name, domain, descr) VALUES ('Терапия.', 'Витрина.', 'Мусор указанный совет ягода.');
INSERT INTO stand(stand_name, domain, descr) VALUES ('Провал.', 'Эффект.', 'Головной четко прошептать.');
INSERT INTO stand(stand_name, domain, descr) VALUES ('Зато.', 'Левый.', 'Карандаш выдержать райком художественный пасть.');
INSERT INTO stand(stand_name, domain, descr) VALUES ('Некоторый.', 'Полоска.', 'Миф прошептать лететь угол чувство оборот тесно.');
INSERT INTO stand(stand_name, domain, descr) VALUES ('Неудобно.', 'Умолять.', 'Картинка штаб бабочка засунуть.');
INSERT INTO stand(stand_name, domain, descr) VALUES ('Спасть.', 'Приходить.', 'Возникновение труп ягода возбуждение потянуться.');
INSERT INTO stand(stand_name, domain, descr) VALUES ('Бетонный.', 'Правый.', 'Соответствие применяться неожиданно соответствие.');
INSERT INTO stand(stand_name, domain, descr) VALUES ('Передо.', 'Пятеро.', 'Коллектив тута пробовать прежний.');
INSERT INTO stand(stand_name, domain, descr) VALUES ('Выражение.', 'Ботинок.', 'При четко миг возможно сутки непривычный монета.');
INSERT INTO stand(stand_name, domain, descr) VALUES ('Передо.', 'Лететь.', 'Шлем выраженный товар манера неправда команда.');

INSERT INTO visitor(full_name, address, phone_number) VALUES ('Октябрина Владиславовна Дорофеева', 'д. Витим, ш. Краснознаменное, д. 59 стр. 91, 647388', '+7 493 422 44 50');
INSERT INTO visitor(full_name, address, phone_number) VALUES ('Доронин Ипполит Игнатьевич', 'ст. Краснодар, ул. Тепличная, д. 8, 740303', '8 (352) 681-99-25');
INSERT INTO visitor(full_name, address, phone_number) VALUES ('Зоя Константиновна Белозерова', 'клх Нижний Новгород, ул. Чайкиной, д. 7/4 к. 36, 640907', '+7 449 016 4619');
INSERT INTO visitor(full_name, address, phone_number) VALUES ('Самсонова Виктория Геннадиевна', 'г. Белореченск, ш. Шолохова, д. 5/4 к. 8/2, 768927', '+7 (838) 898-50-68');
INSERT INTO visitor(full_name, address, phone_number) VALUES ('Измаил Авдеевич Шубин', 'клх Шали, наб. Песчаная, д. 38, 545231', '+70371334343');
INSERT INTO visitor(full_name, address, phone_number) VALUES ('Елизавета Валентиновна Устинова', 'ст. Кисловодск, ш. Молодежное, д. 420, 634360', '8 788 137 30 90');
INSERT INTO visitor(full_name, address, phone_number) VALUES ('Носова Оксана Викторовна', 'к. Ейск, пр. Веселый, д. 1 стр. 94, 912766', '85332973761');
INSERT INTO visitor(full_name, address, phone_number) VALUES ('Майя Николаевна Калашникова', 'с. Майкоп, наб. Абрикосовая, д. 30 стр. 5/8, 294756', '8 (056) 615-6738');
INSERT INTO visitor(full_name, address, phone_number) VALUES ('Панкратий Феофанович Рябов', 'ст. Новгород Великий, бул. Байкальский, д. 321, 984515', '+74250244041');
INSERT INTO visitor(full_name, address, phone_number) VALUES ('Демьян Анисимович Пономарев', 'д. Кимры, пер. 1 Мая, д. 87 стр. 6/4, 199751', '8 (364) 690-7742');

INSERT INTO excursions_visitors(excursion_id, visitor_id) VALUES ('6', '3');
INSERT INTO excursions_visitors(excursion_id, visitor_id) VALUES ('7', '4');
INSERT INTO excursions_visitors(excursion_id, visitor_id) VALUES ('1', '10');
INSERT INTO excursions_visitors(excursion_id, visitor_id) VALUES ('3', '4');
INSERT INTO excursions_visitors(excursion_id, visitor_id) VALUES ('2', '3');
INSERT INTO excursions_visitors(excursion_id, visitor_id) VALUES ('8', '3');
INSERT INTO excursions_visitors(excursion_id, visitor_id) VALUES ('4', '7');
INSERT INTO excursions_visitors(excursion_id, visitor_id) VALUES ('2', '7');
INSERT INTO excursions_visitors(excursion_id, visitor_id) VALUES ('1', '1');
INSERT INTO excursions_visitors(excursion_id, visitor_id) VALUES ('7', '5');

INSERT INTO excursions_stands(excursion_id, stand_id) VALUES ('9', '1');
INSERT INTO excursions_stands(excursion_id, stand_id) VALUES ('1', '8');
INSERT INTO excursions_stands(excursion_id, stand_id) VALUES ('6', '10');
INSERT INTO excursions_stands(excursion_id, stand_id) VALUES ('5', '10');
INSERT INTO excursions_stands(excursion_id, stand_id) VALUES ('6', '4');
INSERT INTO excursions_stands(excursion_id, stand_id) VALUES ('3', '8');
INSERT INTO excursions_stands(excursion_id, stand_id) VALUES ('5', '3');
INSERT INTO excursions_stands(excursion_id, stand_id) VALUES ('5', '2');
INSERT INTO excursions_stands(excursion_id, stand_id) VALUES ('9', '1');
INSERT INTO excursions_stands(excursion_id, stand_id) VALUES ('3', '6');


-- Запрос выбирает имена всех посетителей, которые посещали экскурсии, закрывающиеся в период с 1 октября по 31 декабря 2024 года
SELECT full_name
FROM visitor
WHERE id in (SELECT visitor_id 
            FROM excursions_visitors
            where excursion_id in (SELECT id 
                                   FROM excursion 
                                   where closing_date in (SELECT closing_date 
                                                            from excursion
                                                            WHERE closing_date BETWEEN '2024-10-01' and '2024-12-31')));

-- Запрос выводит именя и продолжительности экскурсий в днях, а также выводит столбцы с самой большой и самой маленькой продолжительностью
SELECT excursion_name, (closing_date - opening_date) as "Продолжительность работы экскурсии",
    (SELECT min(closing_date - opening_date) FROM excursion) as "Продолжительность самой короткой экскурсии",
    (SELECT max(closing_date - opening_date) FROM excursion) as "Продолжительность самая долгой экскурсии"
FROM excursion;

-- Запрос выбирает все названия экскурсий, открывшихся в период с 1 марта по 1 июля 2024 года
SELECT excursion_name
FROM excursion
WHERE opening_date BETWEEN '2024-03-01' AND '2024-06-01';

CREATE OR REPLACE FUNCTION search_danger()
RETURNS TABLE (
    procedure_name TEXT,
    procedure_definition TEXT
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        p.proname::TEXT AS procedure_name,
        pg_get_functiondef(p.oid)::TEXT AS procedure_definition
    FROM 
        pg_proc p
    WHERE 
        pg_get_functiondef(p.oid) ILIKE '%exec%'
        AND p.prokind = 'p';
END;
$$ LANGUAGE plpgsql;

SELECT search_danger();

-- Результат работы:
-- (execute_dynamic_sql,"CREATE OR REPLACE PROCEDURE public.execute_dynamic_sql(IN query text)
--  LANGUAGE plpgsql
-- AS $procedure$
-- BEGIN
    -- EXECUTE query;
-- END;
-- $procedure$
-- ")

-- Процедура для теста
CREATE OR REPLACE PROCEDURE execute_dynamic_sql(query TEXT)
AS $$
BEGIN
    EXECUTE query;
END;
$$ LANGUAGE plpgsql;