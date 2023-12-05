"""
Note: this file is deprecated / for reference only
"""

from numbers import Number

import pymysql
import time
import pandas as pd
import yfinance as yf
import pandas as pd
import tabulate as tabulate
import yfinance_download

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


def update_stocks(database, stock_data: pd.DataFrame):
    with db.cursor() as cursor:
        function_cursor = database.cursor()

        # Create an empty list
        # Iterate over each row in the dataFrame and create the investment
        for rows in stock_data.itertuples():
            # Create list for the current row
            parameter_list = [rows.symbol, rows.name, rows.value]

            # append the list to the final list

            print(rows.value)

            parameter_string = parameter_parser(parameter_list)
            print(parameter_list)
            print(parameter_string)

            # Call the stored procedure
            function_cursor.execute(f"CALL create_investment({parameter_string})")
            result = function_cursor.fetchall()
            print(result)
        db.commit()
update_stocks(db, a)

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
        print(result)
        db.commit()

        update_stocks(db)
finally:
    # Close the connection
    db.close()

