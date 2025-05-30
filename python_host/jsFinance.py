"""
Filename: jsFinance.py
Purpose : this file contains the jsFinance class. This class represents an instance of a command line interface. To
          interact with jsFinance class run the file "run_jsfinance.py" or see README.md for more guidance.
"""

import numpy
import time
import sys
from helpers import *


class jsFinance:
    """
    Class jsFinance forms the structure and attributes of a command line interface (CLI) session of
    the personal finance tracker "jsFinance" (Joseph-Sarah Finance).

    It supports connecting to the database with database credentials, and provides two user roles: user and Admin.
    Within these two user roles, a user can act as the database administrator OR can act as an end user.

    Attributes:
        - connection:    The database connection object.
        - cursor:        The database cursor object.
        - user:          Contains either the user_id of the current user or the phrase "Admin".
        - first_name:    Contains either the first_name of the current user or the phrase "Admin".
        - family:        If a user is selected, this holds the family_id of that user. Otherwise, is None.
        - command_dict:  Holds function objects which have keys representing user commands.
        - command_table: Holds tables which are called via help() method.
    """

    def __init__(self, authentication_dict=None):
        """
        Constructor initializes a jsFinance instance. If database connection is unsuccessful, the program
        will end during this constructor (via the connect_via_command_line_input() function).

        :param authentication_dict: optional parameter, dictionary of the form:
                {"host": "some_hostname", "username": "some_username", "password": "some_password"
        """
        welcome_message()

        # Connect via default connection (command line input) or via authentication dictionary
        if authentication_dict:
            self.connection = connect_to_sql_database(authentication_dict)
        else:
            self.connection = connect_via_command_line_input()

        # If connection could not be established, exit program
        if not self.connection:
            self.exit_program()

        # Otherwise establish a cursor object
        self.cursor = self.connection.cursor()

        # Define user role details
        self.user = "Admin"  # tracks current user role ("Admin") OR user_id (i.e. 2, 4, 5)
        self.first_name = "Admin"  # tracks current username
        self.family = None  # IF self.user is not Admin (is a specific user), this holds the family information

        # Define dictionary of program commands
        self.command_dict = {}
        self.command_table = {}
        self.define_command_dict()
        self.define_command_table()

    def define_command_dict(self):
        """
        Builds out the self.command_dict and self.command_table. self.command_dict is the main logical feature
        that transforms users' commands into actions.

        self.command_dict is a dictionary of dictionaries.
           - key:     the command the user can type to execute the action
        Inner dictionary contains:
            - command:   the function object which executes the given command (no parameters allowed).
            - user:      boolean. If True, this command is allowed for role:user.
            - Admin:     boolean. If True, this command is allowed for role:Admin.
            - category:  string. Stores the menu heading of that command
        """

        self.command_dict["help"] = {
            "command": self.help_command,
            "user": True,
            "Admin": True,
            "category": "General"
        }
        self.command_dict["clear"] = {
            "command": clear_screen,
            "user": True,
            "Admin": True,
            "category": "General"
        }
        self.command_dict["select user"] = {
            "command": self.select_user,
            "user": True,
            "Admin": True,
            "category": "General"
        }
        self.command_dict["admin mode"] = {
            "command": self.enter_admin_mode,
            "user": True,
            "Admin": False,
            "category": "General"
        }
        self.command_dict["exit"] = {
            "command": self.exit_program,
            "user": True,
            "Admin": True,
            "category": "General"
        }
        self.command_dict["create user"] = {
            "command": self.create_user,
            "user": False,
            "Admin": True,
            "category": "Modify"
        }
        self.command_dict["create account"] = {
            "command": self.create_account,
            "user": True,
            "Admin": True,
            "category": "Modify"
        }
        self.command_dict["create family"] = {
            "command": self.create_family,
            "user": True,
            "Admin": True,
            "category": "Modify"
        }
        self.command_dict["create goal"] = {
            "command": self.create_goal,
            "user": True,
            "Admin": False,
            "category": "Modify"
        }
        self.command_dict["update my family"] = {
            "command": self.update_my_family,
            "user": True,
            "Admin": False,
            "category": "Modify"
        }
        self.command_dict["place trade"] = {
            "command": self.place_trade,
            "user": True,
            "Admin": False,
            "category": "Transact"
        }
        self.command_dict["deposit money"] = {
            "command": self.deposit_money,
            "user": True,
            "Admin": False,
            "category": "Transact"
        }
        self.command_dict["take out loan"] = {
            "command": self.take_out_loan,
            "user": True,
            "Admin": False,
            "category": "Transact"
        }
        self.command_dict["view my accounts"] = {
            "command": self.view_account_details_for_user,
            "user": True,
            "Admin": False,
            "category": "View"
        }
        self.command_dict["view all families"] = {
            "command": self.view_all_families,
            "user": False,
            "Admin": True,
            "category": "View"
        }
        self.command_dict["view all users"] = {
            "command": self.view_all_users,
            "user": False,
            "Admin": True,
            "category": "View"
        }
        self.command_dict["view all accounts"] = {
            "command": self.view_all_accounts,
            "user": False,
            "Admin": True,
            "category": "View"
        }
        self.command_dict["view all goals"] = {
            "command": self.view_all_goals,
            "user": False,
            "Admin": True,
            "category": "View"
        }
        self.command_dict["view all holdings"] = {
            "command": self.view_all_holdings,
            "user": False,
            "Admin": True,
            "category": "View"
        }
        self.command_dict["view all transactions"] = {
            "command": self.view_all_transactions,
            "user": False,
            "Admin": True,
            "category": "View"
        }
        self.command_dict["view all investments"] = {
            "command": self.view_all_investments,
            "user": True,
            "Admin": True,
            "category": "View"
        }
        self.command_dict["view my transactions"] = {
            "command": self.view_user_transactions,
            "user": True,
            "Admin": False,
            "category": "View"
        }
        self.command_dict["view my goals"] = {
            "command": self.view_goals_for_user,
            "user": True,
            "Admin": False,
            "category": "View"
        }
        self.command_dict["view my family accounts"] = {
            "command": self.view_accounts_details_for_family,
            "user": True,
            "Admin": False,
            "category": "View"
        }
        self.command_dict["view my family summary"] = {
            "command": self.view_accounts_details_for_family_by_type,
            "user": True,
            "Admin": False,
            "category": "View"
        }
        self.command_dict["view my holdings"] = {
            "command": self.view_my_stock_holdings,
            "user": True,
            "Admin": False,
            "category": "View"
        }
        self.command_dict["view my holdings by account"] = {
            "command": self.view_my_stock_holdings_by_account,
            "user": True,
            "Admin": False,
            "category": "View"
        }
        self.command_dict["update goal amount"] = {
            "command": self.update_goal_amount,
            "user": True,
            "Admin": False,
            "category": "Modify"
        }
        self.command_dict["update account's goal"] = {
            "command": self.update_accounts_goal,
            "user": True,
            "Admin": False,
            "category": "Modify"
        }
        self.command_dict["delete my goal"] = {
            "command": self.delete_goal,
            "user": True,
            "Admin": False,
            "category": "Modify"
        }
        self.command_dict["delete my entire account"] = {
            "command": self.delete_user,
            "user": True,
            "Admin": False,
            "category": "Modify"
        }
        self.command_dict["delete my family"] = {
            "command": self.delete_family,
            "user": True,
            "Admin": False,
            "category": "Modify"
        }
        self.command_dict["remove myself from family"] = {
            "command": self.update_my_family_to_null,
            "user": True,
            "Admin": False,
            "category": "Modify"
        }
        self.command_dict["update all stocks"] = {
            "command": self.update_all_stocks,
            "user": False,
            "Admin": True,
            "category": "Transact"
        }

    def define_command_table(self):
        """
        Builds out the self.command_table, the helpful table that can be shown to the user with the "help" command.

        Uses self.command_dict to populate the menus.
        """
        # Build out menu options based on command_dict
        command_list = {"user": {"General": [], "View": [], "Modify": [], "Transact": []},
                        "Admin": {"General": [], "View": [], "Modify": [], "Transact": []}}

        # Populate the menu with the keys that match the user type
        for user_type in ["user", "Admin"]:
            for key in self.command_dict:
                if self.command_dict[key][user_type]:
                    command_list[user_type][self.command_dict[key]["category"]].append(key)

        # Create DataFrames for user and admin
        user_df = pd.DataFrame()
        admin_df = pd.DataFrame()

        # Iterate across user types
        for user_type in ["user", "Admin"]:
            # Iterate across category types
            for category in ["General", "View", "Modify", "Transact"]:
                # Get list of commands of that category for that user type
                commands = command_list[user_type][category]

                # Put into temporary df object
                temporary_command_df = pd.DataFrame({f"{category}": commands})

                # Build out DataFrames and fill all nans with empty strings
                if user_type == "Admin":
                    admin_df = pd.concat([admin_df, temporary_command_df], axis=1).fillna('')
                elif user_type == "user":
                    user_df = pd.concat([user_df, temporary_command_df], axis=1).fillna('')

        # Finally, store in self.command table so help() method can access this.
        self.command_table["Admin"] = admin_df
        self.command_table["user"] = user_df

    def run(self):
        """
        This method runs the command line interface until an error occurs, or until the user quits.
        """
        exit_program = False

        print("\nYou've entered the jsFinance tracker! Type any command to begin!"
              " (type 'help' to see list of commands).")

        # try-finally block makes sure that connection closes out even if unhandled errors arise
        try:
            while not exit_program:
                user_input = input(f"{self.first_name}:")
                self.execute_input(user_input)
        finally:
            self.close_connection()

    def enter_admin_mode(self):
        """
        Updates self.user to "Admin".
        """
        self.user = "Admin"
        self.first_name = "Admin"
        self.family = None

    def exit_program(self):
        """
        Commits changes to database, closes database connection, prints message to user, and then exits the CLI.
        """
        if self.connection:
            # Commit changes to database
            self.commit_to_database()

            # Close database connection
            self.close_connection()

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

        # if self.connection isn't None, then test if connection needs closing
        if self.connection:

            # Check if connection still exists
            try:
                self.connection.ping(reconnect=True)

            # If there's an error, then do nothing
            except pymysql.Error:
                pass

            # If pinging does NOT cause an error, call close()
            else:
                self.connection.close()

    def help_command(self):
        """
        Prints allowed commands at that point in the CLI program.
        """
        if self.user == "Admin":
            print(tabulate(self.command_table["Admin"], headers='keys', tablefmt='heavy_outline', showindex=False))
        else:
            print(tabulate(self.command_table["user"], headers='keys', tablefmt='heavy_outline', showindex=False))

    def execute_input(self, user_input: str):
        """
        Parses user_input and then executes the associated command from self.command_dict.
        :param user_input: string with desired command, like "help" or "show goals"
        """
        # Start by stripping all whitespace from user_input and making lower case
        parsed_input = user_input.strip().lower()

        # If input is a key in self.command_dict then run the function stored with that key
        if parsed_input in self.command_dict.keys():
            command_allowed_for_admin = self.command_dict[parsed_input]["Admin"]
            command_allowed_for_user = self.command_dict[parsed_input]["user"]

            # If user has authority to do that action then execute it
            if (command_allowed_for_admin and self.user == "Admin") or \
                    (command_allowed_for_user and self.user != "Admin"):
                self.command_dict[parsed_input]["command"]()

            # If user does NOT have the authority but it IS a valid command, print helpful message
            else:
                if self.user == "Admin":
                    print('That command is only allowed for individual users. Type "select user" to enter user mode.')
                else:
                    print('That command is only allowed for Admins. Type "Admin mode" to exit user mode.')

        # else, print helpful string
        else:
            print(f'The command "{user_input}" is unknown. Type "help" to see list of valid commands.')

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
        displayed to the user) and the second element is the input data type.
        :param input_requirements: a list of dicts of prompts, data, and data types, like
                [
                 {"user_input": None, "data": 2, "data_type": Number},
                 {"user_input": "Enter your name:", "data": None, "data_type": str}
                ]
        :return: a string representing the output of the user input, like "(5, "Hello world!")"
        """

        # initialize the list of parameter values
        parameter_list = []

        # Iterate across each input requirement
        for item in input_requirements:
            # If the list element requires user input, then prompt for it:
            if item["user_input"]:
                input_placeholder = input(item["user_input"])

            # Otherwise, pass the data directly
            else:
                input_placeholder = item["data"]

            # If data_type is numeric, then don't put double quotes
            if item["data_type"] == "number":
                parameter_list.append(f'{input_placeholder}')

            # If data_type is non-numeric, put double quotes around
            elif item["data_type"] == "string":
                parameter_list.append(f'"{input_placeholder}"')

            # If not number or string, raise error (unknown case)
            else:
                print(f"An unknown error occurred.")

        concatenated_parameter_list = "(" + ", ".join(parameter_list) + ")"

        return concatenated_parameter_list

    def sql_helper(self, function_or_procedure_call, input_requirements=None):
        """
        This helper method does the heavy lifting for interacting with the database. It:
            (1) prompts the user for inputs
            (2) parses them via get_input_tuple
            (3) executes the sql against the database
            (4) returns the result from self.cursor.fetchall()

        :param function_or_procedure_call: the sql query statement, like "SELECT get_user_id"
        :param input_requirements: a list of dicts of prompts, data, and data types, like
                [
                 {"user_input": None, "data": 2, "data_type": "number"},
                 {"user_input": "Enter your name:", "data": None, "data_type": str}
                ]

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

        # Try executing the function/procedure in the database
        try:
            self.cursor.execute(sql_txt)
            result = self.cursor.fetchall()
            # If no error arises, return the result
            return result

        # Handle SQL error (catching signals written in our procedures/functions)
        except pymysql.Error as e:

            # Extract the error text by finding portion in single quotes
            print(f"Program Error: {extract_error_message_from_signal(str(e))}")

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
        # If the results are a table, print them using tabulate
        if result_expectation == "print table":
            if sql_result_output:
                # print(tabulate(pd.DataFrame(sql_result_output), headers='keys', tablefmt='pretty', showindex=False))
                pretty_print_sql_results_table(sql_result_output)
            else:
                print("There is nothing to show for that request.")

        # If the result is a single number, then return that number
        elif result_expectation == "single number":
            if sql_result_output:
                first_dict = sql_result_output[0]
                key, value = next(iter(first_dict.items()))
                if isinstance(value, Number):
                    return value
                else:
                    print("Error in parse result: expected numeric.")
                    return None
            else:
                return None

        elif result_expectation == "string":
            if sql_result_output:
                first_dict = sql_result_output[0]
                key, value = next(iter(first_dict.items()))
                if isinstance(value, str):
                    return value
                else:
                    print("Error in parse result: expected string.")
                    return None
            else:
                print("There is nothing to show for that request.")
                return None

        # otherwise, print an error statement
        else:
            print("Error in parse_result: unknown result_expectation.")
            return None

    def select_user(self):
        """
        Allows user to "login" by entering their email. If the email is found in users table, then
        self.user will be updated.
        """
        # Define prompt and input requirements
        prompt = "SELECT get_user_id"
        input_requirements = [
            {"user_input": "Provide user email:", "data": None, "data_type": "string"}
        ]

        # Execute the sql code and then parse the results
        cursor_output = self.sql_helper(prompt, input_requirements)
        user_id = self.parse_result("single number", cursor_output)

        # If result of parse result is NOT none, then we have new user_id
        if user_id:
            # Updates self.user to the selected user
            self.user = user_id

            # Call automatic_family_update to update self.family
            self.automatic_family_update()
            self.automatic_first_name_update()
        else:
            print('Try "view all users" to see valid user emails.')

    def automatic_family_update(self):
        """
        When the session's self.user is updated to a certain user, update the family accordingly.
        """
        # Define prompt and input requirements
        prompt = "SELECT get_user_family"
        input_requirements = [
            {"user_input": None, "data": self.user, "data_type": "number"}
        ]

        # Execute the sql code and then parse the results
        cursor_output = self.sql_helper(prompt, input_requirements)
        family_id = self.parse_result("single number", cursor_output)

        # Updates self.family to the selected family IF family_id is greater than 0
        if family_id > 0:
            self.family = family_id
        # A user with no family will return get_user_family(user_id_p) = -1
        else:
            self.family = None

    def automatic_first_name_update(self):
        """
        When the session's self.user is updated to a certain user, update the family accordingly.
        """
        # Define prompt and input requirements
        prompt = "SELECT get_user_first_name"
        input_requirements = [
            {"user_input": None, "data": self.user, "data_type": "number"}
        ]

        # Execute the sql code and then parse the results
        cursor_output = self.sql_helper(prompt, input_requirements)
        first_name = self.parse_result("string", cursor_output)

        # Updates self.family to the selected family IF family_id is greater than 0
        if first_name != "":
            self.first_name = first_name
        # A user with no first_name will cause error
        else:
            print("Error: unknown state in automatic_first_name_update.")

    def update_user_family(self, new_family_id: str):
        """
        Update's user's family to the new family ID.
        """
        prompt = "CALL update_user_family"
        input_requirements = [
            {"user_input": None, "data": self.user, "data_type": "number"},
            {"user_input": None, "data": new_family_id, "data_type": "number"}
        ]

        # Execute the sql code
        cursor_output = self.sql_helper(prompt, input_requirements)

    def create_user(self):
        """
        Creates a user in the database.
        """
        # Define prompt and input_requirements
        prompt = f"CALL create_user"

        input_requirements = [
            {"user_input": "Provide user email:", "data": None, "data_type": "string"},
            {"user_input": "Provide user first name:", "data": None, "data_type": "string"},
            {"user_input": "Provide user last name:", "data": None, "data_type": "string"},
            {"user_input": None, "data": "NULL", "data_type": "number"},
        ]

        # Execute the sql code
        cursor_output = self.sql_helper(prompt, input_requirements)

    def create_account(self):
        """
        Creates a new user account. If in admin mode, this requires entering the user_id number. If in user mode,
        this will automatically associate the new account with the session's current user.
        """

        prompt = f"CALL create_account"

        # input requirements are slightly different for admin vs. user. For user, the user_id is automatically  passed
        if self.user == "Admin":
            user_id_input = None
            user_id_request_message = "Provide user ID:"
        else:
            user_id_input = self.user
            user_id_request_message = None

        input_requirements = [
            {"user_input": "Provide account ID at institution:", "data": None, "data_type": "string"},
            {"user_input": "Provide institution name:", "data": None, "data_type": "string"},
            {"user_input": "Provide account nickname:", "data": None, "data_type": "string"},
            {"user_input": "Provide account type (loan, checkings, savings, 401(k), roth IRA, "
                           "traditional IRA, 529, taxable brokerage):", "data": None, "data_type": "string"},
            {"user_input": user_id_request_message, "data": user_id_input, "data_type": "number"},
            {"user_input": None, "data": "NULL", "data_type": "number"},
        ]

        # Execute the sql code
        cursor_output = self.sql_helper(prompt, input_requirements)

        result = self.parse_result("single number", cursor_output)

        if result == 200:
            print("Successfully created account.")

    def create_goal(self):
        """
        Creates a goal associated with the current user.
        """

        prompt = f"CALL create_goal"

        input_requirements = [
            {"user_input": "Provide goal name:", "data": None, "data_type": "string"},
            {"user_input": "Provide goal amount:", "data": None, "data_type": "number"},
            {"user_input": None, "data": self.user, "data_type": "number"}
        ]

        # Execute the sql code
        cursor_output = self.sql_helper(prompt, input_requirements)
        result = self.parse_result("single number", cursor_output)

        if result == 200:
            print("Successfully created goal.")

    def create_family(self):
        """
        Creates a new family. If in admin mode, this simply creates a family. If in user mode,
        this will automatically associate the new family with the current user. If the current user already HAS a
        family, then this will not do anything.
        """

        prompt = f"SELECT create_family"

        # input requirements are slightly different for admin vs. user. If user already has a family, then stop
        if self.user != "Admin":
            # If user already has a family associated with themselves, print message and exit
            if self.family:
                print('Cannot create family as user already has a family associated. '
                      'Try function "remove self from family"')
                pass  # exit the function

            # Otherwise if user has no family, create the family and then associate it with the given user

        input_requirements = [
            {"user_input": "Provide family name:", "data": None, "data_type": "string"}
        ]

        # Execute the sql code
        cursor_output = self.sql_helper(prompt, input_requirements)
        family_id = self.parse_result("single number", cursor_output)

        if family_id:
            print("Successfully created family.")

        # If self.user != "Admin", then associate family id with current user and update self.family
        if self.user != "Admin":
            self.family = family_id
            self.update_user_family(family_id)

    def update_my_family_to_null(self):
        """
        Removes a user's association with their family.
        """
        prompt = f"CALL update_user_family_to_null"
        input_requirements = [
            {"user_input": None, "data": self.user, "data_type": "number"}
        ]

        # Execute the sql code
        cursor_output = self.sql_helper(prompt, input_requirements)
        result = self.parse_result("single number", cursor_output)

        # If deletion was a success, print a message and update the session details
        if result == 200:
            print("Successfully removed user from family.")
            self.automatic_family_update()  # update session variable

    def update_my_family(self):
        """
        Removes a user's association with their family.
        """
        prompt = f"CALL update_user_family"
        input_requirements = [
            {"user_input": None, "data": self.user, "data_type": "number"},
            {"user_input": "Provide Family ID of family you wish to join:", "data": self.user, "data_type": "number"}
        ]

        # Execute the sql code
        cursor_output = self.sql_helper(prompt, input_requirements)
        result = self.parse_result("single number", cursor_output)

        # If deletion was a success, print a message and update the session details
        if result == 200:
            print("Successfully added user to family.")
            self.automatic_family_update()

    def update_all_stocks(self):
        """
        In admin mode, update all stocks daily value to a given date.
        """

        date_to_update = get_valid_date()

        # If date_to_update returns None, cancel the operation
        if not date_to_update:
            print("Valid date was not entered, cancelling stock update.")
            return

        # Otherwise, execute the update
        print("[            Downloading stock data              ]")
        yfinance_df = get_yfinance(date_to_update)

        # If the retrieval failed, the exit the function
        if not isinstance(yfinance_df, pd.DataFrame):
            if yfinance_df == -1:
                print("Unable to download those stocks. Stock values in database have not changed. "
                      "Try a different date.")
                return

        # Define the prompt
        prompt = f"CALL update_stock_daily_value"

        # Loop through yfinance_df and extract symbol and daily_value
        for index, row in yfinance_df.iterrows():
            # if the value IS a number then try to update the database
            if not numpy.isnan(row['value']):
                input_requirements = [
                    {"user_input": None, "data": row['symbol'], "data_type": "string"},
                    {"user_input": None, "data": round(row['value'], 2), "data_type": "number"}
                ]

                # Execute the database update operation
                cursor_output = self.sql_helper(prompt, input_requirements)
                result = self.parse_result("single number", cursor_output)

                # Print failure to user
                if result != 200:
                    print(f'Error: unable to update stock price for symbol "{row["symbol"]}".')

    def take_out_loan(self):
        """
        Using the account nickname, the user can take out a loan in the account.
        """
        prompt = f"CALL take_loan_by_account_name"

        transaction_date = datetime.datetime.today().strftime("%Y-%m-%d")

        input_requirements = [
            {"user_input": None, "data": transaction_date, "data_type": "string"},
            {"user_input": "Provide account nickname:", "data": None, "data_type": "string"},
            {"user_input": None, "data": self.user, "data_type": "number"},
            {"user_input": "Provide loan amount: $", "data": None, "data_type": "number"}
        ]

        # Execute the sql code
        cursor_output = self.sql_helper(prompt, input_requirements)
        result = self.parse_result("single number", cursor_output)

        if result == 200:
            print("Successfully took out loan.")

    def deposit_money(self):
        """
        Using the account nickname, the user can deposit money in the account.
        """
        prompt = f"CALL deposit_money_by_account_name"
        transaction_date = datetime.datetime.today().strftime("%Y-%m-%d")

        input_requirements = [
            {"user_input": None, "data": transaction_date, "data_type": "string"},
            {"user_input": "Provide account nickname:", "data": None, "data_type": "string"},
            {"user_input": None, "data": self.user, "data_type": "number"},
            {"user_input": "Provide deposit amount: $", "data": None, "data_type": "number"}
        ]

        # Execute the sql code
        cursor_output = self.sql_helper(prompt, input_requirements)
        result = self.parse_result("single number", cursor_output)

        if result == 200:
            print("Successfully deposited money.")

    def place_trade(self):
        """
        Allows user to buy or sell an investment in the specified account.
        """
        # Determine if buying or selling - exit function if neither
        buy_or_sell = input('Enter type of trade ("buy" or "sell"):').lower().strip()
        if buy_or_sell != "buy" and buy_or_sell != "sell":
            print(f'Unknown trade type was entered ("{buy_or_sell}").')
            return

        # Determine trade type (by share or amount) - exit function if neither
        trade_type = input('Enter trade method ("share" or "amount"):').lower().strip()
        if trade_type != "share" and trade_type != "amount":
            print(f'Unknown trade type was entered ("{trade_type}").')
            return

        # Determine today's date
        transaction_date = datetime.datetime.today().strftime("%Y-%m-%d")

        # Determine prompt language for provide shares / provide amount
        if trade_type == "share":
            prompt_language = "Provide number of shares:"
        else:
            prompt_language = "Provide amount to trade: $"

        prompt = f"CALL {buy_or_sell}_investment_by_{trade_type}_account_nickname"
        input_requirements = [
                {"user_input": None, "data": transaction_date, "data_type": "string"},
                {"user_input": "Provide account nickname:", "data": None, "data_type": "string"},
                {"user_input": None, "data": self.user, "data_type": "number"},
                {"user_input": f"{prompt_language}", "data": None, "data_type": "number"},
                {"user_input": "Provide symbol to trade:", "data": None, "data_type": "string"},
            ]

        # Execute the sql code
        cursor_output = self.sql_helper(prompt, input_requirements)
        result = self.parse_result("single number", cursor_output)

        if result == 200:
            if buy_or_sell == "buy":
                print("Successfully purchased stock.")
            elif buy_or_sell == "sell":
                print("Successfully sold stock.")
            else:
                print("Success code but unknown state.")

    def delete_user(self):
        """
        Deletes the current user.
        """

        # Prompt user to enter y if they want to delete
        are_you_sure = input('Are you sure you want to delete your entire account? Enter "y" to continue:')
        if are_you_sure.lower().strip() == "y":
            prompt = f"CALL delete_user"
            input_requirements = [
                {"user_input": None, "data": self.user, "data_type": "number"}
            ]

            # Execute the sql code
            cursor_output = self.sql_helper(prompt, input_requirements)
            result = self.parse_result("single number", cursor_output)

            # If deletion was a success, print a message and update the session details
            if result == 200:
                print("Successfully deleted user.")
                self.enter_admin_mode()

    def delete_family(self):
        """
        Deletes the family of the current user.
        """

        prompt = f"CALL delete_family"
        input_requirements = [
            {"user_input": None, "data": self.user, "data_type": "number"}
        ]

        # Execute the sql code
        cursor_output = self.sql_helper(prompt, input_requirements)
        result = self.parse_result("single number", cursor_output)

        # If deletion was a success, print a message and update the session details
        if result == 200:
            print("Successfully deleted family.")
            self.family = None

    def delete_goal(self):
        """
        Deletes the specified goal.
        """

        prompt = f"CALL delete_goal"
        input_requirements = [
            {"user_input": "Provide name of goal to delete:", "data": None, "data_type": "string"},
            {"user_input": None, "data": self.user, "data_type": "number"}
        ]

        # Execute the sql code
        cursor_output = self.sql_helper(prompt, input_requirements)
        result = self.parse_result("single number", cursor_output)

        # If deletion was a success, print a message and update the session details
        if result == 200:
            print("Successfully deleted goal.")

    def view_all_families(self):
        """
        Shows entire family table
        """

        # Define prompt
        prompt = f"CALL view_all_families()"

        # Execute the sql code and then parse the results
        cursor_output = self.sql_helper(prompt)
        self.parse_result("print table", cursor_output)

    def view_all_users(self):
        """
        Shows entire user table
        """

        # Define prompt
        prompt = f"CALL view_all_users()"

        # Execute the sql code and then parse the results
        cursor_output = self.sql_helper(prompt)
        self.parse_result("print table", cursor_output)

    def view_all_accounts(self):
        """
        Shows entire account table.
        """

        # Define prompt
        prompt = f"CALL view_all_accounts()"

        # Execute the sql code and then parse the results
        cursor_output = self.sql_helper(prompt)
        self.parse_result("print table", cursor_output)

    def view_all_goals(self):
        """
        Shows entire goals table.
        """

        # Define prompt
        prompt = f"CALL view_all_goals()"

        # Execute the sql code and then parse the results
        cursor_output = self.sql_helper(prompt)
        self.parse_result("print table", cursor_output)

    def view_all_holdings(self):
        """
        Shows entire holdings table.
        """

        # Define prompt
        prompt = f"CALL view_all_holdings()"

        # Execute the sql code and then parse the results
        cursor_output = self.sql_helper(prompt)
        self.parse_result("print table", cursor_output)

    def view_all_investments(self):
        """
        Shows entire investments table
        """

        # Define prompt
        prompt = f"CALL view_all_investments()"

        # Execute the sql code and then parse the results
        cursor_output = self.sql_helper(prompt)
        self.parse_result("print table", cursor_output)

    def view_all_transactions(self):
        """
        Shows entire transactions table
        """

        # Define prompt
        prompt = f"CALL view_all_transactions()"

        # Execute the sql code and then parse the results
        cursor_output = self.sql_helper(prompt)
        self.parse_result("print table", cursor_output)

    def view_user_transactions(self):
        """
        Shows user's transactions
        """

        # Define prompt
        prompt = f"CALL view_user_transactions({self.user})"

        # Execute the sql code and then parse the results
        cursor_output = self.sql_helper(prompt)
        self.parse_result("print table", cursor_output)

    def view_goals_for_user(self):
        """
        Allows user to view their goals.
        """

        # if user isn't the admin, then execute
        if self.user != "Admin":

            # Define prompt
            prompt = f"CALL view_goals_for_user({self.user})"

            # Execute the sql code and then parse the results
            cursor_output = self.sql_helper(prompt)
            self.parse_result("print table", cursor_output)

        # If no user is selected, print error message
        else:
            print("Cannot show user goals because user is not selected.")

    def view_accounts_details_for_family_by_type(self):
        """
        Allows user to view their family's account summary.
        """
        # if user family isn't None
        if self.family:

            # Define prompt
            prompt = f"CALL view_accounts_details_for_family_by_type({self.family})"

            # Execute the sql code and then parse the results
            cursor_output = self.sql_helper(prompt)
            self.parse_result("print table", cursor_output)

        # If no user is selected, print error message
        else:
            if self.user == "Admin":
                print("Select a user to show family details.")
            else:
                print("User does not have a family to show details.")

    def view_accounts_details_for_family(self):
        """
        Allows user to view their family's account details.
        """
        # if user family isn't None
        if self.family:

            # Define prompt
            prompt = f"CALL view_accounts_details_for_family({self.family})"

            # Execute the sql code and then parse the results
            cursor_output = self.sql_helper(prompt)
            self.parse_result("print table", cursor_output)

        # If no user is selected, print error message
        else:
            if self.user == "Admin":
                print("Select a user to show family details.")
            else:
                print("User does not have a family to show details.")

    def view_my_stock_holdings(self):
        """
        Allows user to view the stock holdings of all their accounts
        """
        # Define prompt
        prompt = f"CALL view_my_holdings({self.user})"

        # Execute the sql code and then parse the results
        cursor_output = self.sql_helper(prompt)
        self.parse_result("print table", cursor_output)

    def view_my_stock_holdings_by_account(self):
        """
        Allows user to view the stock holdings of an account given the account nickname
        """
        # Define prompt
        prompt = f"CALL view_my_holdings_by_account"
        input_requirements = [
            {"user_input": None, "data": self.user, "data_type": "number"},
            {"user_input": "Provide nickname of account to view:", "data": None, "data_type": "string"}
        ]

        # Execute the sql code
        cursor_output = self.sql_helper(prompt, input_requirements)
        result = self.parse_result("print table", cursor_output)

    def update_goal_amount(self):
        """
        Allows a user to update their goal to a new amount.
        """
        prompt = f"CALL update_goal_amount"
        input_requirements = [
            {"user_input": "Provide name of goal to update:", "data": None, "data_type": "string"},
            {"user_input": None, "data": self.user, "data_type": "number"},
            {"user_input": "Provide new goal amount: $", "data": None, "data_type": "number"}
        ]

        # Execute the sql code
        cursor_output = self.sql_helper(prompt, input_requirements)
        result = self.parse_result("single number", cursor_output)

        if result == 200:
            print("Successfully updated goal amount.")

    def update_accounts_goal(self):
        """
        Allows a user to update an account to associate it with a given goal.
        """
        prompt = f"CALL update_accounts_goal"
        input_requirements = [
            {"user_input": None, "data": self.user, "data_type": "number"},
            {"user_input": "Provide account nickname:", "data": None, "data_type": "string"},
            {"user_input": "Provide name of goal:", "data": None, "data_type": "string"}
        ]

        # Execute the sql code
        cursor_output = self.sql_helper(prompt, input_requirements)
        result = self.parse_result("single number", cursor_output)

        if result == 200:
            print("Successfully updated goal associated with account.")
