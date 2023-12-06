"""
Filename: helpers.py
Purpose : This file contains helpers that support the "run_jsfinance.py" command line interface program, and helpers
          that support the jsFinance.py class.
"""

from numbers import Number
import datetime
import yfinance as yf
import pandas as pd
import pymysql


def extract_error_message_from_signal(error_text: str) -> str:
    """
    Given a message like Error: (1644, 'User ID does not exist, cannot get user.'), this
    function extracts just the part within single quotes.
    :param error_text: the error text to be parsed
    :return: the parsed message between first and last single quotes
    """

    # If the message has multiple single quotes, we can parse it
    if error_text.count("'") > 1:
        # return text between first and last single color
        first_quote_index = error_text.find("'") + 1
        last_quote_index = error_text.rfind("'")
        return error_text[first_quote_index:last_quote_index]

    # Otherwise, just return the input
    else:
        return error_text


def connect_to_sql_database(authentication_dict: dict):
    """
    Connects to jsfinance database using the username and password.
    :param: dict authentication_dict: dictionary with keys host, user and password
    :return: conn, object of type MySQLConnection if successful
             Otherwise, returns None if connection was unsuccessful.
    """

    # establishing the connection
    try:
        conn = pymysql.connect(
            host=authentication_dict["host"],
            user=authentication_dict["user"],
            password=authentication_dict["password"],
            database="jsfinance",
            cursorclass=pymysql.cursors.DictCursor)

    except Exception as e:
        # Handle error by returning None and printing message
        print(f"Error connecting to database:\n{e}")
        conn = None

    return conn


def parameter_parser(parameter_list):
    """
    Given a list of parameters of different data types, this returns a parsed
    string with numeric values not in double quotes, and non-numeric values in double quotes.
    parameter_parser(["text_input", 3.0, "hello", 200]) returns: "text_input", 3.0, "hello", 200
    :param parameter_list: list of parameters of different data types
    :return: formatted string for SQL procedure/function calling purposes
    """

    # Iterate through all list elements
    for i in range(len(parameter_list)):
        # If the parameter is a number, simply convert to a string
        if isinstance(parameter_list[i], Number):
            parameter_list[i] = f'{parameter_list[i]}'

        # otherwise, surround with double quotes
        else:
            parameter_list[i] = f'"{parameter_list[i]}"'

    # Return the joined string
    return ", ".join(parameter_list)


def get_valid_date() -> datetime.date:
    """
    Prompts user for day, month, year. If date is a valid WEEKDAY date in the past, it returns a datetime object.

    If user enters nothing for all three dates, then get_valid_date exits.
    :return: Either a valid date (datetime.date object) or None.
    """
    print("Provide a date to calculate stock prices (must be weekday):")
    month_input = input("Month:").lower()
    if month_input == "q":
        print('You have entered "q". Exiting date selection.')
        return None

    day_input = input("Day:").lower()
    if day_input == "q":
        print('You have entered "q". Exiting date selection.')
        return None

    year_input = input("Year:").lower()
    if year_input == "q":
        print('You have entered "q". Exiting date selection.')
        return None

    # If all entries are blank string or any are "q", return None
    if month_input == "" and day_input == "" and year_input == "":
        print("You have not selected a date. Exiting date selection.")
        return None

    # Try to make a datetime object out of the inputs
    try:
        selected_date = datetime.date(
            int(year_input),
            int(month_input),
            int(day_input))

    except ValueError:
        print(f'The attempted date {day_input}/{month_input}/{year_input} is not a valid date. '
              f'Type "q" to exit date selection.')
        return get_valid_date()

    # If selected day is a weekEND, there will be no stock data
    if selected_date.weekday() >= 5:
        print(f'You selected a weekend date, {selected_date.strftime("%Y-%m-%d")}, please select another date. '
              f"Type 'q' to exit date selection.")
        return get_valid_date()

    # If selected date is in the future, there will be no stock data
    if selected_date > datetime.datetime.now().date():
        print(f'You selected a date in the future, {selected_date.strftime("%Y-%m-%d")}, please select another date. '
              f"Type 'q' to exit date selection.")
        return get_valid_date()

    # Reaching here means the date is VALID and NON-WEEKEND. Return the datetime object
    return selected_date


def get_yfinance(input_date: datetime.date) -> pd.DataFrame:
    """
    Get stock data for the S and P 100 in the form of a dataFrame.
    :param input_date: a datetime.date object which is not a weekend
    :return: dataFrame object containing stock symbols, names, and values on the given date
    """

    # establish symbols and names of top 100 companies in S+P
    symbols = ["AAPL", "ABBV", "ABT", "ACN", "AIG", "ALL", "AMGN", "AMZN", "AXP", "BA", "BAC", "BIIB", "BK", "BLK",
               "BMY", "C", "CAT", "CL", "CMCSA", "COF", "COP", "COST", "CSCO", "CVS", "CVX", "DD", "DHR", "DIS", "DOW",
               "DUK", "EMC", "EMR", "EXC", "F", "META", "FDX", "FOX", "FOXA", "GD", "GE", "GILD", "GM", "GOOG", "GOOGL",
               "GS", "HAL", "HD", "HON", "IBM", "INTC", "JNJ", "JPM", "KMI", "KO", "LLY", "LMT", "LOW", "MA", "MCD",
               "MDLZ", "MDT", "MET", "MMM", "MO", "MRK", "MS", "MSFT", "NEE", "NKE", "ORCL", "OXY", "PEP", "PFE", "PG",
               "PM", "PYPL", "QCOM", "SBUX", "SLB", "SO", "SPG", "T", "TGT", "TXN", "UNH", "UNP", "UPS", "USB", "USD",
               "V", "VZ", "WBA", "WFC"]
    names = ["Apple Inc", "Abbvie Inc. Common Stock", "Abbott Laboratories", "Accenture Plc",
             "American International Group", "Allstate Corp", "Amgen", "Amazon.Com Inc", "American Express Company",
             "Boeing Company", "Bank of America Corp", "Biogen Inc Cmn", "Bank of New York Mellon Corp", "Blackrock",
             "Bristol-Myers Squibb Company", "Citigroup Inc", "Caterpillar Inc", "Colgate-Palmolive Company",
             "Comcast Corp A", "Capital One Financial Corp", "Conocophillips", "Costco Wholesale", "Cisco Systems Inc",
             "CVS Corp", "Chevron Corp", "E.I. Du Pont De Nemours and Company", "Danaher Corp", "Walt Disney Company",
             "Dow Chemical Company", "Duke Energy Corp", "EMC Corp", "Emerson Electric Company", "Exelon Corp",
             "Ford Motor Company", "Facebook Inc", "Fedex Corp", "21St Centry Fox B Cm", "21St Centry Fox A Cm",
             "General Dynamics Corp", "General Electric Company", "Gilead Sciences Inc", "General Motors Company",
             "Alphabet Cl C Cap", "Alphabet Cl A Cmn", "Goldman Sachs Group", "Halliburton Company", "Home Depot",
             "Honeywell International Inc", "International Business Machines", "Intel Corp", "Johnson & Johnson",
             "JP Morgan Chase & Co", "Kinder Morgan", "Coca-Cola Company", "Eli Lilly and Company",
             "Lockheed Martin Corp", "Lowe's Companies", "Mastercard Inc", "McDonald's Corp", "Mondelez Intl Cmn A",
             "Medtronic Inc", "Metlife Inc", "3M Company", "Altria Group", "Merck & Company", "Morgan Stanley",
             "Microsoft Corp", "Nextera Energy", "Nike Inc", "Oracle Corp", "Occidental Petroleum Corp", "Pepsico Inc",
             "Pfizer Inc", "Procter & Gamble Company", "Philip Morris International Inc", "Paypal Holdings",
             "Qualcomm Inc", "Starbucks Corp", "Schlumberger N.V.", "Southern Company", "Simon Property Group",
             "AT&T Inc", "Target Corp", "Texas Instruments", "Unitedhealth Group Inc", "Union Pacific Corp",
             "United Parcel Service", "U.S. Bancorp", "Ultra Semiconductors Proshares", "Visa Inc",
             "Verizon Communications Inc", "Walgreens Bts Aln Cm", "Wells Fargo & Company"]

    # Create database with symbols and company names and placeholder value of 0.0
    sp_100 = pd.DataFrame({'symbol': symbols, 'name': names, 'value': [0.0] * len(symbols)})

    # Convert date to string of correct format for yfinance
    input_date_plus_one_day = input_date + datetime.timedelta(days=1)
    input_date_string = input_date.strftime("%Y-%m-%d")
    input_date_plus_one_day_string = input_date_plus_one_day.strftime("%Y-%m-%d")

    yf_data = yf.download(
        symbols,
        start=input_date_string,
        end=input_date_plus_one_day_string)['Open']

    # Populate the DataFrame
    for symbol in symbols:
        sp_100.loc[sp_100['symbol'] == symbol, 'value'] = yf_data[symbol][0]

    # Return the dataFrame
    return sp_100
