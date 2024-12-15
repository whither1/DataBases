import json
from faker import Faker
import random
import time
import datetime

# Инициализация Faker
fake = Faker('ru_RU')
id = 0
wait_time_mins = 5 * 60
# Генерация данных для таблицы authors.csv
while True:
    with open('/home/whither/dataBases/lab8/nifi/in_file/' + str(id) + '_author_' + datetime.datetime.now().strftime("%d-%m-%Y_%H:%M:%S") + '.json', 'w', newline='', encoding='utf-8') as out:
        # fieldnames = ['name', 'birth_date', 'rating', 'bio']
        res = []
        for _ in range(100):
            row = {
                'name': fake.name(),
                'birth_date': str(fake.date_of_birth(minimum_age=18)),
                'rating': str(round(random.uniform(0, 5), 1)),
                'bio': fake.text(max_nb_chars=500)
            }
            res.append(row)
        print(json.dumps(res, ensure_ascii=False), file=out)
        id += 1
    time.sleep(wait_time_mins)
