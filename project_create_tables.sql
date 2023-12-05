DROP DATABASE IF EXISTS jsFinance;
CREATE DATABASE jsFinance;
USE jsFinance;

CREATE TABLE families (
	family_id INT AUTO_INCREMENT PRIMARY KEY,
    family_name VARCHAR (100) NOT NULL
);

CREATE TABLE users (
   user_id INT AUTO_INCREMENT PRIMARY KEY,
    email VARCHAR(200) UNIQUE NOT NULL,
    first_name VARCHAR(100) NOT NULL, 
    last_name VARCHAR(100),
    family_id INT DEFAULT NULL,
	
    -- If user's family changes, then update the details.
    -- If user's family is deleted, then set user's family to NULL.
    CONSTRAINT fk_family_id_users FOREIGN KEY (family_id) REFERENCES families(family_id)
    ON UPDATE CASCADE ON DELETE SET NULL
);

CREATE TABLE goals (
	goal_id INT AUTO_INCREMENT PRIMARY KEY,
    goal_name VARCHAR(50) NOT NULL,
    goal_amount INT,
        
    -- If user_id changes, restrict the change.
    -- If user_id is deleted from database, then the user's goals are also deleted
    user_id INT,
    CONSTRAINT fk_user_id_goals FOREIGN KEY (user_id) REFERENCES users(user_id)
    ON UPDATE RESTRICT ON DELETE CASCADE,
    
	-- Combination of goal_name and user_id must be unique
    CONSTRAINT unique_goal_name_per_user UNIQUE (user_id, goal_name)
);

CREATE TABLE accounts (
	account_reference_id INT AUTO_INCREMENT PRIMARY KEY,
    id_at_institution VARCHAR(50),
    institution_name VARCHAR(200), 
    account_nickname VARCHAR(50),
    account_type ENUM("loan", "checkings", "savings", "401(k)", "roth IRA", "traditional IRA", "529", "taxable brokerage"),
	user_id INT,
    goal_id INT DEFAULT NULL,
    
    -- If user_id changes, restrict the change.
    -- If user_id is deleted from database, then the user's accounts are also deleted (yyy: is this bad?
    CONSTRAINT fk_user_id_accounts FOREIGN KEY (user_id) REFERENCES users(user_id)
    ON UPDATE RESTRICT ON DELETE CASCADE,
    
    -- If goal_id changes, then cascade it.
    -- If goal is deleted, then set null - account is no longer linked to that goal.
    CONSTRAINT fk_goal_id_accounts FOREIGN KEY (goal_id) REFERENCES goals(goal_id) 
    ON UPDATE CASCADE ON DELETE SET NULL,
    
    -- Combination of id_at_institution and institution_name must be unique
    CONSTRAINT unique_bank_details UNIQUE (id_at_institution, institution_name),

	-- Combination of user_id and account_nickname must be unique
	CONSTRAINT unique_account_nickname UNIQUE (user_id, account_nickname)
    );

CREATE TABLE investments (
	symbol VARCHAR(10) PRIMARY KEY,
    company_name VARCHAR(200),
    daily_value DECIMAL(13, 2)
);

CREATE TABLE transactions (
	transaction_id INT AUTO_INCREMENT PRIMARY KEY,
    transaction_date DATE,
    number_shares FLOAT,
    
    symbol VARCHAR(10),
	CONSTRAINT fk_symbol_transactions FOREIGN KEY (symbol) REFERENCES investments(symbol) 
    ON UPDATE CASCADE ON DELETE RESTRICT,
    
    account_reference_id INT,
	CONSTRAINT fk_account_reference_id_transactions FOREIGN KEY (account_reference_id) REFERENCES accounts(account_reference_id) 
    ON UPDATE CASCADE ON DELETE RESTRICT,

    value_transacted_at DECIMAL(13, 2)
);

CREATE TABLE holdings (
	holdings_id INT AUTO_INCREMENT PRIMARY KEY,
    number_shares FLOAT,
    
    symbol VARCHAR(10),
	CONSTRAINT fk_symbol_holdings FOREIGN KEY (symbol) REFERENCES investments(symbol) 
    ON UPDATE CASCADE ON DELETE RESTRICT,
    
    account_reference_id INT,
	CONSTRAINT fk_account_reference_id_holdings FOREIGN KEY (account_reference_id) REFERENCES accounts(account_reference_id) 
    ON UPDATE CASCADE ON DELETE RESTRICT,

    CONSTRAINT holdings_shares_cant_be_negative CHECK (number_shares >= 0)
);

INSERT INTO investments (symbol, company_name, daily_value) VALUES
("CASH", "Cash", 1),
("DEBT", "Debt", -1);

/*
INSERT INTO investments (symbol, company_name, daily_value) VALUES
("AAPL", "Apple Inc", 190.2100067138672),
("ABBV", "Abbvie Inc. Common Stock", 144.11000061035156),
("ABT", "Abbott Laboratories", 105.0),
("ACN", "Accenture Plc", 334.6300048828125),
("AIG", "American International Group", 65.80000305175781),
("ALL", "Allstate Corp", 138.6999969482422),
("AMGN", "Amgen", 271.8699951171875),
("AMZN", "Amazon.Com Inc", 143.5500030517578),
("AXP", "American Express Company", 172.10000610351562),
("BA", "Boeing Company", 233.5399932861328),
("BAC", "Bank of America Corp", 30.68000030517578),
("BIIB", "Biogen Inc Cmn", 232.0),
("BK", "Bank of New York Mellon Corp", 48.58000183105469),
("BLK", "Blackrock", 755.6199951171875),
("BMY", "Bristol-Myers Squibb Company", 49.79999923706055),
("C", "Citigroup Inc", 47.0099983215332),
("CAT", "Caterpillar Inc", 253.77999877929688),
("CL", "Colgate-Palmolive Company", 79.0),
("CMCSA", "Comcast Corp A", 42.93000030517578),
("COF", "Capital One Financial Corp", 114.44000244140625),
("COP", "Conocophillips", 114.7300033569336),
("COST", "Costco Wholesale", 598.530029296875),
("CSCO", "Cisco Systems Inc", 47.744998931884766),
("CVS", "CVS Corp", 70.18000030517578),
("CVX", "Chevron Corp", 144.75999450683594),
("DD", "E.I. Du Pont De Nemours and Company", 71.20999908447266),
("DHR", "Danaher Corp", 221.32000732421875),
("DIS", "Walt Disney Company", 91.61000061035156),
("DOW", "Dow Chemical Company", 51.7400016784668),
("DUK", "Duke Energy Corp", 92.86000061035156),
("EMC", "EMC Corp", 24.290000915527344),
("EMR", "Emerson Electric Company", 88.51000213623047),
("EXC", "Exelon Corp", 38.790000915527344),
("F", "Ford Motor Company", 10.640000343322754),
("META", "Facebook Inc", 318.9800109863281),
("FDX", "Fedex Corp", 264.2200012207031),
("FOX", "21St Centry Fox B Cm", 28.049999237060547),
("FOXA", "21St Centry Fox A Cm", 30.209999084472656),
("GD", "General Dynamics Corp", 252.22999572753906),
("GE", "General Electric Company", 121.01000213623047),
("GILD", "Gilead Sciences Inc", 78.37000274658203),
("GM", "General Motors Company", 32.959999084472656),
("GOOG", "Alphabet Cl C Cap", 130.3699951171875),
("GOOGL", "Alphabet Cl A Cmn", 128.9499969482422),
("GS", "Goldman Sachs Group", 346.6000061035156),
("HAL", "Halliburton Company", 37.220001220703125),
("HD", "Home Depot", 322.0),
("HON", "Honeywell International Inc", 197.52000427246094),
("IBM", "International Business Machines", 160.75999450683594),
("INTC", "Intel Corp", 41.90999984741211),
("JNJ", "Johnson & Johnson", 158.0),
("JPM", "JP Morgan Chase & Co", 156.02000427246094),
("KMI", "Kinder Morgan", 17.850000381469727),
("KO", "Coca-Cola Company", 58.54999923706055),
("LLY", "Eli Lilly and Company", 583.280029296875),
("LMT", "Lockheed Martin Corp", 450.2900085449219),
("LOW", "Lowe's Companies", 205.7100067138672),
("MA", "Mastercard Inc", 407.0899963378906),
("MCD", "McDonald's Corp", 286.54998779296875),
("MDLZ", "Mondelez Intl Cmn A", 71.05999755859375),
("MDT", "Medtronic Inc", 79.55000305175781),
("MET", "Metlife Inc", 64.12999725341797),
("MMM", "3M Company", 102.75),
("MO", "Altria Group", 42.31999969482422),
("MRK", "Merck & Company", 104.91999816894531),
("MS", "Morgan Stanley", 80.68000030517578),
("MSFT", "Microsoft Corp", 366.45001220703125),
("NEE", "Nextera Energy", 58.68000030517578),
("NKE", "Nike Inc", 114.66000366210938),
("ORCL", "Oracle Corp", 114.56999969482422),
("OXY", "Occidental Petroleum Corp", 57.97999954223633),
("PEP", "Pepsico Inc", 169.14999389648438),
("PFE", "Pfizer Inc", 29.209999084472656),
("PG", "Procter & Gamble Company", 152.13999938964844),
("PM", "Philip Morris International Inc", 92.5199966430664),
("PYPL", "Paypal Holdings", 59.310001373291016),
("QCOM", "Qualcomm Inc", 129.08999633789062),
("SBUX", "Starbucks Corp", 97.37999725341797),
("SLB", "Schlumberger N.V.", 51.65999984741211),
("SO", "Southern Company", 71.37999725341797),
("SPG", "Simon Property Group", 129.89500427246094),
("T", "AT&T Inc", 16.979999542236328),
("TGT", "Target Corp", 133.32000732421875),
("TXN", "Texas Instruments", 156.4600067138672),
("UNH", "Unitedhealth Group Inc", 549.0999755859375),
("UNP", "Union Pacific Corp", 232.7899932861328),
("UPS", "United Parcel Service", 155.0),
("USB", "U.S. Bancorp", 39.2599983215332),
("USD", "Ultra Semiconductors Proshares", 42.4900016784668),
("V", "Visa Inc", 254.19000244140625),
("VZ", "Verizon Communications Inc", 38.349998474121094),
("WBA", "Walgreens Bts Aln Cm", 20.729999542236328),
("WFC", "Wells Fargo & Company", 44.95000076293945);


-- CREATE USERS
USE jsfinance;
INSERT INTO families (family_name) VALUES
("Witzig Padukone Household"),
("The Witzigs"),
("Lane family"),
("The Padukones");

INSERT INTO users (email, first_name, last_name, family_id) VALUES
("sarah@gmail.com", "Sarah", "Witzig", 1),
("ronak@gmail.com", "Ronak", "Padukone", 1),
("joanne@yahoo.com", "Joanne", "Witzig", 2),
("phrog_pilot@msn.com", "Bill", "Witzig", 2),
("matthew@gmail.com", "Matthew", "Witzig", NULL),
("nancylane@aol.com", "Nancy", "Lane", 3),
("rlane@aol.com", "Ray", "Lane", 3),
("Vijayananda@gmail.com", "Vijay", "Padukone", 4),
("Anita@gmail.com", "Anita", "Padukone", 4);

INSERT INTO goals (goal_name, goal_amount, user_id) VALUES
("Pay off my loans", 0, 1),
("DEBT FREE", 0, 2),
("House paid off", 0, 4),
("Reach $100k", 100000, 1); 

INSERT INTO accounts (id_at_institution, institution_name, account_nickname, account_type, user_id, goal_id) VALUES
("20505157", "TD Bank", "My brokerage", "Taxable Brokerage", 1, 4),
("66074247", "Vanguard", "Vanguard 401k", "401(k)", 1, 4),
("72395085", "Vanguard", "Vanguard Roth", "roth IRA", 1, 4),
("31150065", "Vanguard", "Vanguard Trad. IRA", "traditional IRA", 1, 4),
("66839606", "Vanguard", "Vanguard 529", "529", 1, 4),
("59346393", "Nelnet", "First Loan", "loan", 1, 1),
("17974534", "Nelnet", "Second Loan", "loan", 1, 1),
("29476087", "Bank of America", "Ronak's Checking", "checkings", 2, NULL),
("82441179", "Ally", "Ronak's Saving", "savings", 2, 2),
("54319892", "Nelnet", "Nelnet Loan", "loan", 2, 2),
("08303869", "Northeastern", "Northeastern Loan", "loan", 2, 2),
("35425018", "SLM Corporation", "Sallie Mae", "loan", 2, 2),
("17261416", "FMC Corporation", "Freddie Mac", "loan", 2, 2),
("40639267", "Chase", "Ronak's 401(k)", "401(k)", 2, NULL);



INSERT INTO investments (symbol, company_name, daily_value)
VALUES
("CASH", "Cash", 1),
("DEBT", "Debt", -1),
('AAPL', 'Apple Inc.', 150.25),
('MSFT', 'Microsoft Corporation', 310.75),
('GOOGL', 'Alphabet Inc.', 2700.50),
('AMZN', 'Amazon.com Inc.', 3450.00),
('FB', 'Meta Platforms, Inc.', 325.50),
('TSLA', 'Tesla, Inc.', 800.60),
('JPM', 'JPMorgan Chase & Co.', 155.20),
('GS', 'The Goldman Sachs Group, Inc.', 380.40),
('WMT', 'Walmart Inc.', 140.80),
('PG', 'Procter & Gamble Co.', 135.90);

SELECT * FROM accounts;

SELECT * FROM holdings;
INSERT INTO holdings (account_reference_id, symbol, number_shares)
VALUES
(1, "CASH", 1000),
(1, "TSLA", 2), 
(1, "PG", 32),
(2, "WMT", 100), 
(2, "GS", 2),
(6, "DEBT", 9000.58),
(7, "DEBT", 3000),
(8, "CASH", 14032),
(9, "CASH", 200),
(10, "DEBT", 31), 
(11, "DEBT", 1999),
(12, "DEBT", 1000), 
(13, "DEBT", 300),
(14, 'AAPL', 150.25),
(14, 'MSFT', 310.75),
(14, 'GOOGL', 2700.50),
(14, 'AMZN', 3450.00),
(14, 'FB', 325.50),
(14, 'TSLA', 800.60),
(14, 'JPM', 155.20),
(14, 'GS', 380.40),
(14, 'WMT', 140.80),
(14, 'PG', 135.90);

INSERT INTO transactions(transaction_date, number_shares, symbol, account_reference_id, value_transacted_at) VALUES
("2022-10-05", 2, "TSLA", 1, 200),
("2022-10-06", 3, "PG", 1, 4);
*/
