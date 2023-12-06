"""
Filename: jsFinance.py
Purpose : this file contains the jsFinance class. This class represents an instance of a command line interface. To
          interact with jsFinance class run the file "run_jsfinance.py" or see README.md for more guidance.
"""
import re
import time
import pymysql
import tabulate
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
        self.user = "jsFinance Admin"
        self.status = None

        # Define dictionary of program commands
        self.command_dict = {
            "help": self.help_command,
            "exit": self.exit_program,
            "view my account details": self.view_account_details_for_user,
            "select user": self.select_user,
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
                user_input = input(f"{self.user}:")
                self.execute_input(user_input)
        finally:
            # if self.connection isn't none, then close the connection
            if self.connection:
                self.close_connection()

    def exit_program(self):
        """
        Commits changes to database, closes database connection, prints message to user, and then exits the CLI.
        :return: VOID
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
        :return: VOID
        """
        self.connection.commit()

    def close_connection(self):
        """
        Closes connection with database.
        :return: VOID
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
        # if user isn't none, execute
        if self.user != "jsFinance Admin":
            sql_txt = f"CALL view_accounts_details_for_user({self.user})"
            print(sql_txt)

            self.cursor.execute(sql_txt)
            result = self.cursor.fetchall()
            table = tabulate(pd.dataFrame(result), headers='keys', tablefmt='pretty', showindex=False)
            print(table)
        else:
            print("Cannot show account details because user is not selected.")

    def get_input_tuple(self, input_requirements):
        """
        input_requirements is a list of pairs, where the first element of each pair is the input string (what is
        displayed to the user) and the second element is the input datatype.
        :param input_requirements:
        :return: string which can be used to do a sql function call
        """
        parameter_list = []
        for item in input_requirements:
            input_placeholder = input(item[0])

            if item[1] == "Number":
                parameter_list.append(f'{input_placeholder}')
            else:
                parameter_list.append(f'"{input_placeholder}"')

        concatenated_parameter_list = "(" + ", ".join(parameter_list) + ")"
        print(f"concatenated_parameter_list = {concatenated_parameter_list}")
        return concatenated_parameter_list

    def sql_helper(self, function_or_procedure_call, input_requirements):

        # Get parameter string
        parameter_list = self.get_input_tuple(input_requirements)

        # Define the sql text
        sql_txt = f'{function_or_procedure_call}{parameter_list}'
        print(f"Troubleshoot purposes only: {sql_txt}")

        try:
            self.cursor.execute(sql_txt)
            result = self.cursor.fetchall()
            return result

        # Handle SQL error (catching signals written in our procedures/functions)
        except pymysql.Error as e:

            # Extract the error text by finding portion in single quotes
            print(f"Error: {extract_error_message_from_signal(str(e))}")

        # Catch all other exceptions (unknown case)
        except Exception as e:
            print(f"An error occurred: {e}")

    def select_user(self):
        """
        Allows user to "login" by entering their email. If the email is found in users table, then
        self.user will be updated.
        """

        result = self.sql_helper(
            "SELECT get_user_id",
            [["Provide user email:", "string"]])
        print(result)


    def select_user2(self):
        """
        Allows user to "login" by entering their email. If the email is found in users table, then
        self.user will be updated
        """

        # Request email from user
        user_email = input("Enter user email:")

        # Define the sql text
        sql_txt = f'SELECT get_user_id("{user_email}")'
        print(f"Troubleshoot purposes only: {sql_txt}")

        try:
            self.cursor.execute(sql_txt)
            result = self.cursor.fetchall()

        # Handle SQL error (catching signals written in our procedures/functions)
        except pymysql.Error as e:

            # Extract the error text by finding portion in single quotes
            print(f"Error: {extract_error_message_from_signal(str(e))}")

        # Catch all other exceptions (unknown case)
        except Exception as e:
            print(f"An error occurred: {e}")

