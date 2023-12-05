import pymysql

# Section: static methods


def connect_to_sql_database(host:str, username: str, password: str):
    """
    Connects to jsfinance database using the username and password.
    :param: str host: database host, often localhost
    :param str username: username, often "root"
    :param str password: user's password
    :return: conn, object of type MySQLConnection if successful
             Otherwise, returns None if connection was unsuccessful.
    """

    # establishing the connection
    try:
        conn = pymysql.connect(
            host=host,
            user=username,
            password=password,
            database="jsfinance",
            cursorclass=pymysql.cursors.DictCursor)

    except Exception as e:
        # Handle error by returning None and printing message
        print(f"Error connecting to database:\n{e}")
        conn = None

    return conn


def connect_via_command_line_input():
    """
    Prompts user for their username and password. Attempts to connect to that
    database using connect_to_sql_database() function.

    :return: Object of type <class 'mysql.connector.connection.MySQLConnection'> if successful.
             Otherwise, returns None if connection was unsuccessful.
    """

    # Prompt user for inputs
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
    def __init__(self):
        self.welcome_message()
        self.connection = connect_via_command_line_input()
        self.cursor = self.connection.cursor()
        self.user = "jsFinance Admin"
        self.status = None

    @staticmethod
    def welcome_message():
        # Inform user they've entered the program
        print("+----------------------------------------------------------------------------------------------------+")
        print("|                                 jsFinance Personal Finance Tracker                                 |")
        print("+----------------------------------------------------------------------------------------------------+")

    def run(self):
        """
        This method runs the command line interface until an error occurs, or until the user quits.
        :return:
        """
        exit_program = False

        print("\nYou've entered the jsFinance tracker! Type any command to begin! (type 'help' to see list of commands).")


        # try-finally block makes sure that connection closes out even if unhandled errors arise
        try:
            while not exit_program:
                user_input = input(f"{self.user}:")
        finally:
            # if self.connection isn't none, then close the connection
            if self.connection:
                self.close_connection()

    def commit_to_database(self):
        self.connection.commit()

    def close_connection(self):
        self.connection.close()


def main():
    program_instance = jsFinance()
    program_instance.run()
    program_instance.close_connection()


if __name__ == "__main__":
    main()