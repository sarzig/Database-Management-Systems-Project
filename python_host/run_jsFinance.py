"""
Filename: run_jsFinance.py
Purpose : this file contains the main() function which runs our command line interface.
          "jsFinance" is our take on a personal finance tracker. See the README.md file
          for more details.
"""

from jsFinance import jsFinance
import os

# todo: delete troubleshooting var at end
global troubleshoot
troubleshoot = True


def main():

    # delete later - user should only use CLI to enter
    if False:

        if os.name == "nt":
            # sarah pass
            auth_dict = {"host": "localhost", "username": "root", "password": "merapass"}  # todo:remove password
        else:
            # joseph pass
            auth_dict = {"host": "localhost", "username": "root", "password": "root1234"}  # todo:remove password

        program_instance = jsFinance(auth_dict)
        program_instance.run()

    else:
        program_instance = jsFinance()
        program_instance.run()


if __name__ == "__main__":
    main()
