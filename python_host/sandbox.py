from jsFinance import *
from helpers import *
import pandas as pd
from tabulate import tabulate


auth_dict = {"host": "localhost", "user": "root", "password": "merapass"}  # cybersecurity # todo:remove password
connection = connect_to_sql_database(auth_dict)
cursor = connection.cursor()



# using pymysql
from tabulate import tabulate
import pandas as pd
# use this code to convert your result to a df
sql_result_output = cursor.fetchall()
sql_df = pd.DataFrame(sql_result_output)

# this is me hardcoding the df so you can see the different options
df = pd.DataFrame([[1, 'sarah@gmail.com', 'Sarah', 'Witzig', 'our Household'], [2, 'ronak@gmail.com', 'Ronak', 'Padukone', 'our Household'], [3, 'joanne@yahoo.com', 'Joanne', 'Witzig', 'The Witzigs'], [5, 'matthew@gmail.com', 'Matthew', 'Witzig', None]], columns=['User ID', 'Email', 'First Name', 'Last Name', 'Family'])
print(tabulate(df, headers='keys', tablefmt="fancy_grid", showindex=False))
print(tabulate(df, headers='keys', tablefmt="pretty", showindex=False))
print(tabulate(df, headers='keys', tablefmt="presto", showindex=False))
print(tabulate(df, headers='keys', tablefmt="heavy_outline", showindex=False))
print(tabulate(df, headers='keys', tablefmt="rounded_outline", showindex=False))
