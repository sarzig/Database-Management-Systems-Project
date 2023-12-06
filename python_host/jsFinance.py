"""
Filename: jsFinance.py
Purpose : this file contains the jsFinance class. This class represents an instance of a command line interface. To
          interact with jsFinance class run the file "run_jsfinance.py" or see README.md for more guidance.
"""
import re
import time
import pymysql
from tabulate import tabulate
import sys
from helpers import *


# Section: static methods

def connect_via_command_line_input():
    """
    Prompts user for their username and password. Attempts to connect to that
    database using connect_to_sql_database() function.

    :return: Object of type <class 'mysql.connector.connection.MySQLConnection'> if successful.
             Otherwise, returns None if connection was unsuccessful.
    """

    # Prompt user for inputs and strip whitespace
    host = input("Enter database host (often 'localhost'): ").strip()
    username = input("Enter database username (often 'root'): ").strip()
    password = input("Enter database password: ").strip()

    # Attempt connection via connect_to_sql_database and then check validity of the result
    database = connect_to_sql_database(host, username, password)
    connection_was_successful = isinstance(database, pymysql.connections.Connection)

    if connection_was_successful:
        print(f'Successfully connected to database "jsfinance".')
        return database

    else:
        # If fails, let user try again. Recurse until successful connection OR user stops trying
        continue_prompting = input('You did not successfully connect. '
                                   'Enter "y" if you want to try again. '
                                   'Press any other key to exit:')
        if continue_prompting.lower() == "y":
            # User chooses to continue.
            # If the recursive call yields a working connection, this function will return a
            #  MySqlConnection object
            return connect_via_command_line_input()
        else:
            # User doesn't want to continue -> print failure and return None
            print(f'Exiting program. '
                  f'Failed to connect to database "jsfinance" with username "{username}".')
            return None


class jsFinance:
    def __init__(self, authentication_dict=None):
        self.welcome_message()

        # Connect via default connection (command line input) or via authentication dictionary
        if authentication_dict:
            self.connection = connect_to_sql_database(authentication_dict)
        else:
            self.connection = connect_via_command_line_input()

        self.cursor = self.connection.cursor()
        self.user = "Admin"
        self.status = None

        # Define dictionary of program commands
        self.command_dict = {
            "help": self.help_command,
            "exit": self.exit_program,
            "view my account details": self.view_account_details_for_user,
            "select user": self.select_user,
            "admin mode": self.enter_admin_mode
        }

    @staticmethod
    def welcome_message():
        # Inform user they've entered the program
        print("+----------------------------------------------------------------------------------------------------+")
        print("|                                 jsFinance Personal Finance Tracker                                 |")
        print("+----------------------------------------------------------------------------------------------------+")

    def run(self):
        """
        This method runs the command line interface until an error occurs, or until the user quits.
        :return: void
        """
        exit_program = False

        print("\nYou've entered the jsFinance tracker! Type any command to begin!"
              " (type 'help' to see list of commands).")

        # try-finally block makes sure that connection closes out even if unhandled errors arise
        try:
            while not exit_program:
                user_input = input(f"user:{self.user}:")
                self.execute_input(user_input)
        finally:
            # if self.connection isn't none, then close the connection
            if self.connection:
                self.close_connection()

    def enter_admin_mode(self):
        """
        Updates self.user to "Admin"
        """
        self.user = "Admin"

    def exit_program(self):
        """
        Commits changes to database, closes database connection, prints message to user, and then exits the CLI.
        """

        # Commit changes to database
        self.commit_to_database()

        # Close database connection
        self.close_connection

        # Print helpful message
        print("+----------------------------------------------------------------------------------------------------+")
        print("|                                          exiting jsFinance                                         |")
        print("+----------------------------------------------------------------------------------------------------+")

        # Sleep for 1 second
        time.sleep(1)

        # Exit
        sys.exit(0)

    def commit_to_database(self):
        """
        Commits changes to database.
        """
        self.connection.commit()

    def close_connection(self):
        """
        Closes connection with database.
        """
        self.connection.close()

    def execute_input(self, user_input:str):
        """
        Parses user_input and then executes the associated command from self.command_dict.
        :param user_input: string with desired command, like "help" or "show goals"
        :return: VOID
        """
        # Start by stripping all whitespace from user_input and making lower case
        parsed_input = user_input.strip().lower()

        # If input is a key in self.command_dict then run the function stored with that key
        if parsed_input in self.command_dict.keys():
            self.command_dict[parsed_input]()

        # else, print helpful string
        else:
            print(f'The command "{user_input}" is unknown. Type "help" to see list of valid commands.')

    def help_command(self):
        """
        Prints allowed commands at that point in the CLI program.
        :return: VOID
        """
        print(f'Valid program commands are: {", ".join(self.command_dict)}')

    def view_account_details_for_user(self):
        """
        Shows account details for current user.
        """

        # if user isn't the admin, then execute
        if self.user != "Admin":

            # Define prompt
            prompt = f"CALL view_accounts_details_for_user({self.user})"

            # Execute the sql code and then parse the results
            cursor_output = self.sql_helper(prompt)
            self.parse_result("print table", cursor_output)

        # If no user is selected, print error message
        else:
            print("Cannot show account details because user is not selected.")

    @staticmethod
    def get_input_tuple(input_requirements):
        """
        input_requirements is a list of pairs, where the first element of each pair is the input string (what is
        displayed to the user) and the second element is the input datatype.
        :param input_requirements: a list of lists of prompts and data types,
               like [["Input a number:", "Number"],["Input a string:", "String"]]
        :return: a string representing the output of the user input, like "(5, "Hello world!")"
        """

        # initialize the list of parameter values
        parameter_list = []

        # Iterate across each input requirement
        for item in input_requirements:
            # Prompt the user with the first item in the list
            input_placeholder = input(item[0])

            if item[1] == "Number":
                parameter_list.append(f'{input_placeholder}')
            else:
                parameter_list.append(f'"{input_placeholder}"')

        concatenated_parameter_list = "(" + ", ".join(parameter_list) + ")"
        # todo remove troubleshooting
        print(f"Troubleshoot purposes only: concatenated_parameter_list = {concatenated_parameter_list}")
        return concatenated_parameter_list

    def sql_helper(self, function_or_procedure_call, input_requirements=None):
        """
        This helper method does the heavy lifting for interacting with the database. It:
            (1) prompts the user for inputs
            (2) parses them via get_input_tuple
            (3) executes the sql against the database
            (4) returns the result from self.cursor.fetchall()
        and the
        :param function_or_procedure_call: the sql query statement, like "SELECT get_user_id"
        :param input_requirements: a list of lists of prompts and data types,
               like [["Input a number:", "Number"],["Input a string:", "String"]]
        :return: the cursors fetchall result
        """

        # Get parameter string if there are input_requirements
        if input_requirements:
            parameter_list = self.get_input_tuple(input_requirements)

        # If there are no input requirements then there are no parameters
        else:
            parameter_list = ""

        # Define the sql text
        sql_txt = f'{function_or_procedure_call}{parameter_list}'
        print(f"Troubleshoot purposes only: {sql_txt}")  # todo delete this troubleshooting

        # Try executing the function/procedure in the database
        try:
            self.cursor.execute(sql_txt)
            result = self.cursor.fetchall()
            # If no error arises, return the result
            return result

        # Handle SQL error (catching signals written in our procedures/functions)
        except pymysql.Error as e:

            # Extract the error text by finding portion in single quotes
            print(f"Error: {extract_error_message_from_signal(str(e))}")

        # Catch all other exceptions (unknown case)
        except Exception as e:
            print(f"An unknown error occurred: {e}")

        # In error cases, return None
        return None

    @staticmethod
    def parse_result(result_expectation, sql_result_output):
        """
        Given a result expectation and a cursor output, this function parses the result in the desired manner.

        :param result_expectation: "print table", "single number", or None
        :param sql_result_output: the result from the cursor
        :return: parsed result based on the result_expectation. In some cases this simply means printing a table.
        """

        # If there is no result (as in error cases), then return None
        if not sql_result_output:
            return None

        # If the results are a table, print them using tabulate
        if result_expectation == "print table":
            print(tabulate(pd.DataFrame(sql_result_output), headers='keys', tablefmt='pretty', showindex=False))

        # If the result is a single number, then return that number
        elif result_expectation == "single number":
            first_dict = sql_result_output[0]
            key, value = next(iter(first_dict.items()))
            return value

        # otherwise, print an error statement
        else:
            print("Error in parse_result: unknown result_expectation.")

    def select_user(self):
        """
        Allows user to "login" by entering their email. If the email is found in users table, then
        self.user will be updated.
        """
        # Define prompt and input requirements
        prompt = "SELECT get_user_id"
        input_requirements = [["Provide user email:", "string"]]

        # Execute the sql code and then parse the results
        cursor_output = self.sql_helper(prompt, input_requirements)
        user_id = self.parse_result("single number", cursor_output)

        print(f"Troubleshoot purposes only: user_id is now {user_id}")  # todo remove troubleshoot

        # Updates self.user to the selected user
        self.user = user_id


