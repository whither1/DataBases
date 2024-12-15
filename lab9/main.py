import time
import threading
import psycopg2
import redis
import matplotlib.pyplot as plt

# Redis connection
r = redis.Redis(host='localhost', port=2345, db=0)
run_flag = True

# Database connection
def get_db_connection():
    return psycopg2.connect(
        host="localhost",
        database="books",
        user="whither",
        password="q1w2e3",
        port="5432"
    )

# Query without cache
def query_without_cache():
    conn = get_db_connection()
    cur = conn.cursor()
    start_time = time.time_ns()
    cur.execute("""
        SELECT name, rating
        FROM author
        ORDER BY rating DESC
        LIMIT 10;
    """)
    result = cur.fetchall()
    end_time = time.time_ns()
    conn.close()
    return (end_time - start_time) // 10**3

# Query with Redis cache
def query_with_redis_cache():
    conn = get_db_connection()
    cur = conn.cursor()
    start_time = time.time_ns()
    cached_data = r.get('top_authors')
    if not cached_data:
        cur.execute("""
            SELECT name, rating
            FROM author
            ORDER BY rating DESC
            LIMIT 10;
        """)
        result = cur.fetchall()
        r.set('top_authors', str(result))
    end_time = time.time_ns()
    conn.close()
    return (end_time - start_time) // 10**3

# Data modification functions
def add_data():
    i = 0
    while run_flag:
        time.sleep(10)
        conn = get_db_connection()
        cur = conn.cursor()
        cur.execute(f"INSERT INTO author (name, birth_date, rating, bio) VALUES ('Redis{i}', '2024-12-13', 9.9, 'testing for redis');")
        conn.commit()
        conn.close()
        r.delete('top_authors')  # Invalidate cache
        i += 1

def delete_data():
    i = 0
    while run_flag:
        time.sleep(10)
        conn = get_db_connection()
        cur = conn.cursor()
        cur.execute(f"DELETE FROM author WHERE name = 'Redis{i}';")
        conn.commit()
        conn.close()
        r.delete('top_authors')  # Invalidate cache
        i += 1

def modify_data():
    i = 0
    while run_flag:
        time.sleep(10)
        conn = get_db_connection()
        cur = conn.cursor()
        cur.execute(f"UPDATE author SET rating = 9.8 WHERE name = 'Redis{i}';")
        conn.commit()
        conn.close()
        r.delete('top_authors')  # Invalidate cache
        i += 1

# Monitoring loop
def monitor_queries(add_flag, delete_flag, modify_flag, duration):
    # Start data modification threads based on flags
    threads = []
    if add_flag:
        add_thread = threading.Thread(target=add_data)
        add_thread.start()
        threads.append(add_thread)
    elif delete_flag:
        # delete_thread = threading.Timer(interval=10.0, function=delete_data)
        delete_thread = threading.Thread(target=delete_data)
        delete_thread.start()
        threads.append(delete_thread)
    elif modify_flag:
        # modify_thread = threading.Timer(interval=10.0, function=modify_data)
        modify_thread = threading.Thread(target=modify_data)
        modify_thread.start()
        threads.append(modify_thread)

    db_times = []
    redis_times = []
    global run_flag
    start = time.time()
    while time.time() - start < duration:
        # if add_flag and not add_thread.is_alive():
        #     add_thread.start()
        # elif modify_flag and not modify_thread.is_alive():
        #     modify_thread.start()
        # elif delete_flag and not delete_thread.is_alive():
        #     delete_thread.start()
        db_time = query_without_cache()
        redis_time = query_with_redis_cache()
        db_times.append(db_time)
        redis_times.append(redis_time)
        time.sleep(5)
    # if add_flag:
    #     add_thread.cancel()
    # elif modify_flag:
    #     modify_thread.cancel()
    # elif delete_flag:
    #     delete_thread.cancel()
    run_flag = False
    for thread in threads:
        thread.join()
    
    return db_times, redis_times

# Main execution
if __name__ == '__main__':
    duration = 60
    states = [(False, False, False), (True, False, False), (False, False, True), (False, True, False)]

    for i, seq in enumerate(states):
        # Start monitoring queries
        run_flag = True
        db_times, redis_times = monitor_queries(*seq, duration=duration)

        r.delete('top_authors')
        print(db_times)
        print(redis_times)
        # Plot the results
        plt.figure(figsize=(12,6))
        plt.plot(range(len(db_times)), db_times, label='Запрос напрямую через БД')
        plt.plot(range(len(redis_times)), redis_times, label='Запрос через Redis в качестве кэша')
        plt.xlabel('Итерация запроса')
        plt.ylabel('Время выполнения (мкс)')
        # plt.title('Сравнительный анализ времени без изменения данных в БД')
        plt.legend()
        plt.savefig(f"/home/whither/dataBases/lab9/time_{i+1}.svg", format="svg", bbox_inches='tight', pad_inches=0.1)
        plt.show()
        plt.close()
    r.close()
