from jsFinance import *
from helpers import *


auth_dict = {"host": "localhost", "user": "root", "password": "merapass"}  # cybersecurity # todo:remove password
connection = connect_to_sql_database(auth_dict)
cursor = connection.cursor()

email = "sarah@gmail.com"
sql_query = f"SELECT * FROM get_user_id{email}"
cursor.execute(sql_query)
result = cursor.fetchall()

connection.close()