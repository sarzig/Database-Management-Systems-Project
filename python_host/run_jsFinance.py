"""
Filename: run_jsFinance.py
Purpose : this file contains the main() function which runs our command line interface.
          "jsFinance" is our take on a personal finance tracker. See the README.md file
          for more details.
"""

from jsFinance import jsFinance
import os


def main():
    if os.name == "nt":
        # sarah pass
        auth_dict = {"host": "localhost", "user": "root", "password": "merapass"}  # cybersecurity # todo:remove password
    else:
        # joseph pass
        auth_dict = {"host": "localhost", "user": "root", "password": "root1234"}  # cybersecurity # todo:remove password

    program_instance = jsFinance(auth_dict)
    program_instance.run()


if __name__ == "__main__":
    main()
