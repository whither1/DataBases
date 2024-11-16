import csv
from faker import Faker
import random
from datetime import datetime, timedelta

# Инициализация Faker
fake = Faker('ru_RU')

# Функция для генерации случайной даты рождения
def random_birth_date(start_month, end_month):
    start_date = datetime(year=2024, month=start_month, day=1)
    end_date = datetime(year=2024, month=end_month, day=30)
    time_between_dates = end_date - start_date
    days_between_dates = time_between_dates.days
    random_number_of_days = random.randrange(days_between_dates)
    return start_date + timedelta(days=random_number_of_days)

n = int(input("Введите кол-во записей: "))

# Генерация данных для таблицы authors.csv
with open('/tmp/postgres/authors.csv', 'w', newline='', encoding='utf-8') as csvfile:
    fieldnames = ['name', 'birth_date', 'rating', 'bio']
    writer = csv.DictWriter(csvfile, fieldnames=fieldnames)

    writer.writeheader()
    for _ in range(n):
        writer.writerow({
            'name': fake.name(),
            'birth_date': random_birth_date(1900, 1980),
            'rating': round(random.uniform(0, 5), 1),
            'bio': fake.text(max_nb_chars=500)
        })

# Генерация данных для таблицы publishers.csv
with open('/tmp/postgres/publishers.csv', 'w', newline='', encoding='utf-8') as csvfile:
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
with open('/tmp/postgres/translators.csv', 'w', newline='', encoding='utf-8') as csvfile:
    fieldnames = ['name', 'birth_date', 'bio', 'native_language', 'rating']
    writer = csv.DictWriter(csvfile, fieldnames=fieldnames)

    writer.writeheader()
    for _ in range(n):
        writer.writerow({
            'name': fake.name(),
            'birth_date': random_birth_date(1950, 2023),
            'bio': fake.text(max_nb_chars=300),
            'native_language': random.choice(['English', 'Spanish', 'French', 'German', 'Italian']),
            'rating': round(random.uniform(0, 5), 1)
        })

# Генерация данных для таблицы books.csv
with open('/tmp/postgres/books.csv', 'w', newline='', encoding='utf-8') as csvfile:
    fieldnames = ['title', 'publication_date', 'isbn', 'genre', 'rating', 'author_id', 'publisher_id', 'translator_id']
    writer = csv.DictWriter(csvfile, fieldnames=fieldnames)

    writer.writeheader()
    for _ in range(n):
        writer.writerow({
            'title': fake.sentence(nb_words=random.randint(3, 8)),
            'publication_date': random_birth_date(1980, 2023),
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