"""
Filename: run_jsFinance.py

Purpose : this file contains the main() function which runs our command line interface.
          "jsFinance" is our take on a personal finance tracker.
          See README.md for more details.
"""

from jsFinance import jsFinance


def main():
    """
    main() is the main driver of our CLI. Running run_jsFinance.py starts the CLI.
    """
    program_instance = jsFinance()  # Instantiate application -> this connects to database
    program_instance.run()  # Run application -> this starts the while() loop for user inputs
    program_instance.close_connection()  # Close connection -> exits the program


if __name__ == "__main__":
    main()
