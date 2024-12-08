import csv
from faker import Faker
import random

# Инициализация Faker
fake = Faker('ru_RU')

n = int(input("Введите кол-во записей: "))

# Генерация данных для таблицы authors.csv
with open('./lab1/authors.csv', 'w', newline='', encoding='utf-8') as csvfile:
    fieldnames = ['name', 'birth_date', 'rating', 'bio']
    writer = csv.DictWriter(csvfile, fieldnames=fieldnames)

    writer.writeheader()
    for _ in range(n):
        writer.writerow({
            'name': fake.name(),
            'birth_date': fake.date_of_birth(minimum_age=18),
            'rating': round(random.uniform(0, 5), 1),
            'bio': fake.text(max_nb_chars=500)
        })

# Генерация данных для таблицы publishers.csv
with open('./lab1/publishers.csv', 'w', newline='', encoding='utf-8') as csvfile:
    fieldnames = ['name', 'address', 'phone', 'licence_number']
    writer = csv.DictWriter(csvfile, fieldnames=fieldnames)

    writer.writeheader()
    for _ in range(n):
        writer.writerow({
            'name': fake.company(),
            'address': fake.address(),
            'phone': fake.phone_number(),
            'licence_number': random.randint(100000, 999999)
        })

# Генерация данных для таблицы translators.csv
with open('./lab1/translators.csv', 'w', newline='', encoding='utf-8') as csvfile:
    fieldnames = ['name', 'birth_date', 'bio', 'native_language', 'rating']
    writer = csv.DictWriter(csvfile, fieldnames=fieldnames)

    writer.writeheader()
    for _ in range(n):
        writer.writerow({
            'name': fake.name(),
            'birth_date': fake.date_of_birth(minimum_age=18),
            'bio': fake.text(max_nb_chars=300),
            'native_language': random.choice(['English', 'Spanish', 'French', 'German', 'Italian']),
            'rating': round(random.uniform(0, 5), 1)
        })

# Генерация данных для таблицы books.csv
with open('./lab1/books.csv', 'w', newline='', encoding='utf-8') as csvfile:
    fieldnames = ['title', 'publication_date', 'isbn', 'genre', 'rating', 'author_id', 'publisher_id', 'translator_id']
    writer = csv.DictWriter(csvfile, fieldnames=fieldnames)

    writer.writeheader()
    for _ in range(n):
        writer.writerow({
            'title': fake.sentence(nb_words=random.randint(3, 8)),
            'publication_date': fake.date_of_birth(maximum_age=70),
            'isbn': random.randint(1000000000000, 9999999999999),
            'genre': random.choice(['Fiction', 'Non-fiction', 'Biography', 'History', 'Science']),
            'rating': round(random.uniform(0, 5), 1),
            'author_id': random.randint(1, n),
            'publisher_id': random.randint(1, n),
            'translator_id': random.randint(1, n)
        })

with open('./RK2/data', 'w', encoding='utf-8') as w:
    for _ in range(10):
        line = 'INSERT INTO excursions_stands(excursion_id, stand_id) VALUES (\'{}\', \'{}\');\n'.format(
        random.randint(1, 10),
        random.randint(1, 10))
        w.write(line)