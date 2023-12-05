import datetime
import yfinance as yf
import pandas as pd
import tabulate as tabulate


def get_valid_date():
    """
    Prompts user for day, month, year. If date is a valid WEEKDAY date in the past, it returns a datetime object.
    :return:
    """
    print("Provide a date to calculate stock prices (must be weekday):")
    month_input = input("Month:")
    day_input = input("Day:")
    year_input = input("Year:")

    # Try to make a datetime object out of the inputs
    try:
        selected_date = datetime.date(
            int(year_input),
            int(month_input),
            int(day_input))

    except ValueError:
        print(f'The attempted date {day_input}/{month_input}/{year_input} is not a valid date.')
        return get_valid_date()

    # If selected day is a weekEND, there will be no stock data
    if selected_date.weekday() >= 5:
        print(f'You selected a weekend date, {selected_date.strftime("%Y-%m-%d")}, please select another date.')
        return get_valid_date()

    # Reaching here means the date is VALID and NON-WEEKEND. Return the datetime object
    return selected_date


def get_yfinance(input_date: datetime.date):
    """
    Get stock data for the S and P 100 in the form of a dataFrame.
    :param input_date: a datetime.date object which is not a weekend
    :return: dataFrame object containing stock symbols, names, and values on the given date
    """

    # establish symbols and names of top 100 companies in S+P
    symbols = ["AAPL", "ABBV", "ABT", "ACN", "AIG", "ALL", "AMGN", "AMZN", "AXP", "BA", "BAC", "BIIB", "BK", "BLK", "BMY",
               "C", "CAT", "CL", "CMCSA", "COF", "COP", "COST", "CSCO", "CVS", "CVX", "DD", "DHR", "DIS", "DOW", "DUK",
               "EMC", "EMR", "EXC", "F", "META", "FDX", "FOX", "FOXA", "GD", "GE", "GILD", "GM", "GOOG", "GOOGL", "GS",
               "HAL", "HD", "HON", "IBM", "INTC", "JNJ", "JPM", "KMI", "KO", "LLY", "LMT", "LOW", "MA", "MCD", "MDLZ",
               "MDT", "MET", "MMM", "MO", "MRK", "MS", "MSFT", "NEE", "NKE", "ORCL", "OXY", "PEP", "PFE", "PG", "PM",
               "PYPL", "QCOM", "SBUX", "SLB", "SO", "SPG", "T", "TGT", "TXN", "UNH", "UNP", "UPS", "USB", "USD", "V", "VZ",
               "WBA", "WFC", ]
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
             "JP Morgan Chase & Co", "Kinder Morgan", "Coca-Cola Company", "Eli Lilly and Company", "Lockheed Martin Corp",
             "Lowe's Companies", "Mastercard Inc", "McDonald's Corp", "Mondelez Intl Cmn A", "Medtronic Inc", "Metlife Inc",
             "3M Company", "Altria Group", "Merck & Company", "Morgan Stanley", "Microsoft Corp", "Nextera Energy",
             "Nike Inc", "Oracle Corp", "Occidental Petroleum Corp", "Pepsico Inc", "Pfizer Inc",
             "Procter & Gamble Company", "Philip Morris International Inc", "Paypal Holdings", "Qualcomm Inc",
             "Starbucks Corp", "Schlumberger N.V.", "Southern Company", "Simon Property Group", "AT&T Inc", "Target Corp",
             "Texas Instruments", "Unitedhealth Group Inc", "Union Pacific Corp", "United Parcel Service", "U.S. Bancorp",
             "Ultra Semiconductors Proshares", "Visa Inc", "Verizon Communications Inc", "Walgreens Bts Aln Cm",
             "Wells Fargo & Company", ]

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
