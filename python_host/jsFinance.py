"""
Filename: jsFinance.py
Purpose : this file contains the jsFinance class. This class represents an instance of a command line interface. To
          interact with jsFinance class run the file "run_jsfinance.py" or see README.md for more guidance.
"""

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

    @staticmethod
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

        # Sleep for 2 seconds
        time.sleep(2)

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

    def view_account_details_for_user(self, user_id):
        """
        Shows account details for current user.
        :param user_id:
        :return:
        """
