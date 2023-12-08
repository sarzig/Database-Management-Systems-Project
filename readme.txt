Run_jsfinance.py is the driver of the application. Running “Run_jsfinance.py” from a Python interpreter on the command line or from an IDE will open the application.

The application begins in admin mode. The “select user” command enters into user mode, and “admin mode” cycles back to admin mode. “Help” is the most important command to display the available list of commands given your current role.

The application makes use of the following libraries: pymysql, pandas, tabulate, and yfinance. Required versions to successfully build the application are in “requirements.txt.” Libraries can be installed using “pip install” or “brew install” on the command line, if not already installed.

The application utilizes mySQL procedures and functions, stored in the following files:
-jsfinance_create_update_delete_procedures.sql
-jsfinance_read_procedures.sql
-jsfinance_functions.sql