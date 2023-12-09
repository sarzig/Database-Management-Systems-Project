SQL: To load the jsFinance database, utilize the jsfinance_database_dump.sql data dump. 

If errors prevent loading, the database (and sample data) can be loaded from the files: 
- jsfinance_create_tables.sql
- jsfinance_create_update_delete_procedures.sql
- jsfinance_functions.sql
- Jsfinance_read_procedures.sql

The host application runs in Python. Required libraries (See requirements.txt for versions) are:
- numpy
- pymysql
- pandas
- tabulate
- Yfinance

To begin the program:
No installation directory needs to be specified beyond proper installation of libraries.
run_jsfinance.py is the driver of the application. Running run_jsFinance.py directly in 
Python is recommended; running through an IDE will work, but the “clear” function is 
specifically tailored and may not work within an IDE. 

The application begins in admin mode. The “select user” command enters into user mode,
 and “admin mode” cycles back to admin mode. “Help” is the most important command to 
display the available list of commands given your current role.
