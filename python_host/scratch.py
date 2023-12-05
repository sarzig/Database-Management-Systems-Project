import pymysql
import time

# Replace these values with your MySQL database credentials
db_host = 'localhost'
db_user = 'root'
db_password = 'merapass'
db_name = 'jsfinance'

# Connect to the database
db = pymysql.connect(host=db_host, user=db_user, password=db_password, database=db_name, cursorclass=pymysql.cursors.DictCursor)

# Example query
try:
    with db.cursor() as cursor:
        # Your SQL query here
        sql = "SELECT * FROM users"
        cursor.execute(sql)
        result = cursor.fetchall()
        print(result)
        time.sleep(4)
finally:
    # Close the connection
    db.close()
