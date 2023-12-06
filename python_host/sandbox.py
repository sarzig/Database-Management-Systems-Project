from jsFinance import *
from helpers import *


auth_dict = {"host": "localhost", "user": "root", "password": "merapass"}  # cybersecurity # todo:remove password
connection = connect_to_sql_database(auth_dict)
cursor = connection.cursor()

email = "sarah@gmail.com"
sql_query = f"SELECT * FROM get_user_id{email}"
cursor.execute(sql_query)
result = cursor.fetchall()

cursor.execute("CALL view_all_users()")
connection.close()


def get_input_tuple(input_requirements):
    """
    input_requirements is a list of pairs, where the first element of each pair is the input string (what is
    displayed to the user) and the second element is the input datatype.
    :param input_requirements:
    :return: string which can be used to do a sql function call
    """
    parameter_list = []
    for item in input_requirements:
        input_placeholder = input(item[0])

        if item[1] is Number:
            parameter_list.append(f'{input_placeholder}')
        else:
            parameter_list.append(f'"{input_placeholder}"')

    return ", ".join(parameter_list)

a=get_input_tuple([["Provide user email:", str], ["Provide number:", Number], ["Porvide string:", str]])
