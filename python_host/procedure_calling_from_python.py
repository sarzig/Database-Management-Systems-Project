from numbers import Number

import pymysql
import time
import pandas as pd

# Replace these values with your MySQL database credentials
db_host = 'localhost'
db_user = 'root'
db_password = 'merapass'
db_name = 'jsfinance'

# Connect to the database
db = pymysql.connect(
    host=db_host,
    user=db_user,
    password=db_password,
    database=db_name,
    cursorclass=pymysql.cursors.DictCursor)


def parameter_parser(parameter_list):
    """
    Given a list of parameters of different data types, this returns a parsed
    string with numeric values not in double quotes, and non-numeric values in double quotes.
    parameter_parser(["text_input", 3.0, "hello", 200]) returns: "text_input", 3.0, "hello", 200
    :param parameter_list: list of parameters of different data types
    :return: formatted string for SQL procedure/function calling purposes
    """

    # Iterate through all list elements
    for i in range(len(parameter_list)):
        # If the parameter is a number, simply convert to a string
        if isinstance(parameter_list[i], Number):
            parameter_list[i] = f'{parameter_list[i]}'

        # otherwise, surround with double quotes
        else:
            parameter_list[i] = f'"{parameter_list[i]}"'

    # Return the joined string
    return ", ".join(parameter_list)

# Example query
try:
    with db.cursor() as cursor:
        cursor = db.cursor()
        # Your SQL query here
        sql_query = "SELECT * FROM users"
        cursor.execute(sql_query)
        result = cursor.fetchall()
        print(result)
        # time.sleep(4)
        procedure_name = 'create_investment'

        # Call the stored procedure
        cursor.execute("CALL create_goal('my goalie', 100, 1)")
        result = cursor.fetchall()
        print(result)
        cursor.execute("SELECT * FROM goals")
        result = pd.DataFrame(cursor.fetchall())
        print(result)


finally:
    # Close the connection
    db.close()
