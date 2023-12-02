import yfinance as yf
import pandas as pd
import tabulate as tabulate

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

sp_100 = pd.DataFrame({'symbol': symbols, 'name': names, 'value': [0.0] * len(symbols)})

# Pull data from yfinance API
date = '2023-12-02'
yf_data = yf.download(symbols, start=date, end=date)['Open']

# Populate the DataFrame
for symbol in symbols:
    sp_100.loc[sp_100['symbol'] == symbol, 'value'] = yf_data[symbol][0]

# Print first 5 rows of the data
print(tabulate.tabulate(sp_100))

print(sp_100)
