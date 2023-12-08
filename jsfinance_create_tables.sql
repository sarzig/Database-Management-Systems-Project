/*
Filename: jsfinance_create_tables.sql
Purpose:  Creates all tables needed for our database.
*/

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
	account_id INT AUTO_INCREMENT PRIMARY KEY,
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
    
    -- blocks symbol from being deleted if it was used in any transactions
    symbol VARCHAR(10),
	CONSTRAINT fk_symbol_transactions FOREIGN KEY (symbol) REFERENCES investments(symbol) 
    ON UPDATE CASCADE ON DELETE RESTRICT,
    
    -- if account_id is deleted, then delete associated transactions
    account_id INT,
	CONSTRAINT fk_account_id_transactions FOREIGN KEY (account_id) REFERENCES accounts(account_id) 
    ON UPDATE CASCADE ON DELETE CASCADE,

    value_transacted_at DECIMAL(13, 2)
);

CREATE TABLE holdings (
	holdings_id INT AUTO_INCREMENT PRIMARY KEY,
    number_shares FLOAT,
    
    symbol VARCHAR(10),
	CONSTRAINT fk_symbol_holdings FOREIGN KEY (symbol) REFERENCES investments(symbol) 
    ON UPDATE CASCADE ON DELETE RESTRICT,
    
    -- if account_id is deleted, then delete holdings
    account_id INT,
	CONSTRAINT fk_account_id_holdings FOREIGN KEY (account_id) REFERENCES accounts(account_id) 
    ON UPDATE CASCADE ON DELETE CASCADE,

    CONSTRAINT holdings_shares_cant_be_negative CHECK (number_shares >= 0)
);

USE jsfinance;

/* 
+----------------------------------------------------------------------------------------------------+
|                                             Sample Data                                            |
+----------------------------------------------------------------------------------------------------+
*/

INSERT INTO investments (symbol, company_name, daily_value) VALUES
("CASH", "Cash", 1),
("DEBT", "Debt", -1);

INSERT INTO investments (symbol, company_name, daily_value) VALUES
('AAPL', 'Apple Inc', 190.21),
('ABBV', 'Abbvie Inc. Common Stock', 144.11),
('ABT', 'Abbott Laboratories', 105.00),
('ACN', 'Accenture Plc', 334.63),
('AIG', 'American International Group', 65.80),
('ALL', 'Allstate Corp', 138.70),
('AMGN', 'Amgen', 271.87),
('AMZN', 'Amazon.Com Inc', 143.55),
('AXP', 'American Express Company', 172.10),
('BA', 'Boeing Company', 233.54),
('BAC', 'Bank of America Corp', 30.68),
('BIIB', 'Biogen Inc Cmn', 232.00),
('BK', 'Bank of New York Mellon Corp', 48.58),
('BLK', 'Blackrock', 755.62),
('BMY', 'Bristol-Myers Squibb Company', 49.80),
('C', 'Citigroup Inc', 47.01),
('CAT', 'Caterpillar Inc', 253.78),
('CL', 'Colgate-Palmolive Company', 79.00),
('CMCSA', 'Comcast Corp A', 42.93),
('COF', 'Capital One Financial Corp', 114.44),
('COP', 'Conocophillips', 114.73),
('COST', 'Costco Wholesale', 598.53),
('CSCO', 'Cisco Systems Inc', 47.74),
('CVS', 'CVS Corp', 70.18),
('CVX', 'Chevron Corp', 144.76),
('DD', 'E.I. Du Pont De Nemours and Company', 71.21),
('DHR', 'Danaher Corp', 221.32),
('DIS', 'Walt Disney Company', 91.61),
('DOW', 'Dow Chemical Company', 51.74),
('DUK', 'Duke Energy Corp', 92.86),
('EMC', 'EMC Corp', 24.29),
('EMR', 'Emerson Electric Company', 88.51),
('EXC', 'Exelon Corp', 38.79),
('F', 'Ford Motor Company', 10.64),
('META', 'Facebook Inc', 318.98),
('FDX', 'Fedex Corp', 264.22),
('FOX', '21St Centry Fox B Cm', 28.05),
('FOXA', '21St Centry Fox A Cm', 30.21),
('GD', 'General Dynamics Corp', 252.23),
('GE', 'General Electric Company', 121.01),
('GILD', 'Gilead Sciences Inc', 78.37),
('GM', 'General Motors Company', 32.96),
('GOOG', 'Alphabet Cl C Cap', 130.37),
('GOOGL', 'Alphabet Cl A Cmn', 128.95),
('GS', 'Goldman Sachs Group', 346.60),
('HAL', 'Halliburton Company', 37.22),
('HD', 'Home Depot', 322.00),
('HON', 'Honeywell International Inc', 197.52),
('IBM', 'International Business Machines', 160.76),
('INTC', 'Intel Corp', 41.91),
('JNJ', 'Johnson & Johnson', 158.00),
('JPM', 'JP Morgan Chase & Co', 156.02),
('KMI', 'Kinder Morgan', 17.85),
('KO', 'Coca-Cola Company', 58.55),
('LLY', 'Eli Lilly and Company', 583.28),
('LMT', 'Lockheed Martin Corp', 450.29),
('LOW', "Lowe's Companies", 205.71),
('MA', 'Mastercard Inc', 407.09),
('MCD', "McDonald's Corp", 286.55),
('MDLZ', 'Mondelez Intl Cmn A', 71.06),
('MDT', 'Medtronic Inc', 79.55),
('MET', 'Metlife Inc', 64.13),
('MMM', '3M Company', 102.75),
('MO', 'Altria Group', 42.32),
('MRK', 'Merck & Company', 104.92),
('MS', 'Morgan Stanley', 80.68),
('MSFT', 'Microsoft Corp', 366.45),
('NEE', 'Nextera Energy', 58.68),
('NKE', 'Nike Inc', 114.66),
('ORCL', 'Oracle Corp', 114.57),
('OXY', 'Occidental Petroleum Corp', 57.98),
('PEP', 'Pepsico Inc', 169.15),
('PFE', 'Pfizer Inc', 29.21),
('PG', 'Procter & Gamble Company', 152.14),
('PM', 'Philip Morris International Inc', 92.52),
('PYPL', 'Paypal Holdings', 59.31),
('QCOM', 'Qualcomm Inc', 129.09),
('SBUX', 'Starbucks Corp', 97.38),
('SLB', 'Schlumberger N.V.', 51.66),
('SO', 'Southern Company', 71.38),
('SPG', 'Simon Property Group', 129.89),
('T', 'AT&T Inc', 16.98),
('TGT', 'Target Corp', 133.32),
('TXN', 'Texas Instruments', 156.46),
('UNH', 'Unitedhealth Group Inc', 549.10),
('UNP', 'Union Pacific Corp', 232.79),
('UPS', 'United Parcel Service', 155.00),
('USB', 'U.S. Bancorp', 39.26),
('USD', 'Ultra Semiconductors Proshares', 42.49),
('V', 'Visa Inc', 254.19),
('VZ', 'Verizon Communications Inc', 38.35),
('WBA', 'Walgreens Bts Aln Cm', 20.73),
('WFC', 'Wells Fargo & Company', 44.95);

-- CREATE USERS
INSERT INTO families (family_name) VALUES
("Witzig Padukone Household"),
("The Witzigs");

INSERT INTO users (first_name, last_name, email, family_id) VALUES
("Sarah", "Witzig", "sarah@gmail.com", 1),
("William", "Witzig", "bill@gmail.com", 2),
("Joanne", "Witzig", "jo@gmail.com", 2),
("Joseph", "Mathew", "joseph@gmail.com", NULL),
("Kathleen", "Durant", "k.durant@northeastern.edu", NULL),
("Ronak", "Padukone", "ronak@yahoo.com", 1),
("Matthew", "Witzig", "matthew@gmail.com", NULL),
("Katie", "Markowitz", "katie@gmail.com", NULL),
("Amanda", "Ng", "ang@gmail.com", NULL);

INSERT INTO goals (goal_name, goal_amount, user_id) VALUES
("Pay off my loans", 0, 1),
("Save $5000 emergency fund", 5000, 1),
("Net worth", 200000, 1),
("No more debt", 0, 6),
("Net worth", 1000000, 4),
("Dog fund", 600, 7),
("Cat fund", 2000, 8);

INSERT INTO accounts (id_at_institution, institution_name, account_nickname, account_type, user_id, goal_id) VALUES
("78246166", "Chase", "my chase", "checkings", 1, 3),
("14080047", "Nelnet", "NEU loan", "loan", 1, 1),
("24694959", "Ally", "emergency fund", "savings", 1, 2),
("44200220", "Vanguard", "Stryker 401k", "401(k)", 1, 3),
("92304848", "Santander", "my loans", "loan", 1, 4),
("65138110", "NEU", "NEU loan", "loan", 6, 4),
("52294363", "Bank of America", "my savings", "savings", 6,NULL),
("73556977", "Bank of America", "my checkings", "checkings", 6,NULL),
("35148005", "DFCU", "savings", "savings", 5,NULL),
("15749776", "DFCU", "checkings", "checkings", 5,NULL),
("98783971", "NEU", "My 401k", "401(k)", 5,NULL),
("12124687", "Empower", "My Roth", "roth IRA", 5,NULL),
("45934710", "Ally", "my ally checkings", "checkings", 4, 5),
("65331193", "Ally", "my ally savings", "savings", 4, 5),
("73001785", "NEU", "NEU loan", "loan", 4, 5),
("14812317", "Robinhood", "my brokerage", "taxable brokerage", 4, 5),
("40657505", "Chase", "my checkings", "checkings", 7, 6),
("56503256", "Ally", "my ally checkings", "checkings", 2,NULL),
("32550572", "Ally", "my ally savings", "savings", 2,NULL),
("72198045", "Chase", "my chase checkings", "checkings", 3,NULL),
("19313785", "Chase", "my chase savings", "savings", 3,NULL),
("13767696", "Bank of America", "checkings", "checkings", 8, 7);

INSERT INTO holdings (account_id, symbol, number_shares) VALUES
(1, "CASH", 23605),
(2, "DEBT", 80000),
(3, "CASH", 3520.23),
(4, "CASH", 3000),
(4, "MS", 26.2),
(4, "NKE", 53.5),
(4, "LOW", 0.8),
(4, "MA", 1.86),
(4, "SBUX", 60.5),
(4, "F", 100),
(5, "DEBT", 42042),
(6, "DEBT", 4031),
(7, "CASH", 2472.05),
(8, "CASH", 2070.52),
(9, "CASH", 13596.32),
(10, "CASH", 2882.47),
(11, "CASH", 2813.32),
(11, "AMZN", 55.52),
(11, "AXP", 78.88),
(11, "BA", 94.79),
(11, "BAC", 14.79),
(11, "BIIB", 92.38),
(11, "COST", 85.84),
(11, "USD", 56.66),
(11, "V", 26.98),
(11, "PG", 61.62),
(11, "SO", 90.6),
(11, "TXN", 27.5),
(11, "UNH", 66.69),
(12, "CASH", 506.82),
(12, "AMZN", 30),
(13, "CASH", 3592.72),
(14, "CASH", 2244.4),
(15, "DEBT", 40231),
(16, "MCD", 32),
(16, "KO", 100),
(16, "F", 68.8),
(17, "CASH", 400),
(18, "CASH", 9563.75),
(19, "CASH", 13189.06),
(20, "CASH", 16980.88),
(21, "CASH", 12449.76),
(22, "CASH", 1804.64);