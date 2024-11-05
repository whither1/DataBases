--author--
alter table author

add constraint unique_id_author UNIQUE (id),
add constraint primary_id_author PRIMARY KEY (id),
alter column id set NOT NULL,

alter column name set NOT NULL,

alter column birth_date set NOT NULL,

alter column rating set NOT NULL,
alter column rating set DEFAULT 0;

--publisher--
alter table publisher

add constraint unique_id_publisher UNIQUE (id),
add constraint primary_id_publisher PRIMARY KEY (id),
alter column id set NOT NULL,

alter column name set NOT NULL,

alter column address set NOT NULL,

alter column phone set NOT NULL,

alter column licence_number set NOT NULL;

--translator--
alter table translator

add constraint unique_id_translator UNIQUE (id),
add constraint primary_id_translator PRIMARY KEY (id),
alter column id set NOT NULL,

alter column name set NOT NULL,

alter column birth_date set NOT NULL,

alter column rating set NOT NULL,
alter column rating set DEFAULT 0;

--book--
alter table book

add constraint unique_id_book UNIQUE (id),
add constraint primary_id_book PRIMARY KEY (id),
alter column id set NOT NULL,

alter column title set NOT NULL,

alter column publication_date set NOT NULL,

alter column isbn set NOT NULL,
add constraint unique_isbn_book UNIQUE (isbn),

alter column genre set NOT NULL,

alter column rating set NOT NULL,
alter column rating set DEFAULT 0,

add constraint foreign_key_author_id_book FOREIGN KEY (author_id) REFERENCES author (id),
add constraint foreign_key_publisher_id_book FOREIGN KEY (publisher_id) REFERENCES publisher (id),
add constraint foreign_key_translator_id_book FOREIGN KEY (translator_id) REFERENCES translator (id);