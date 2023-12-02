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
    account_type ENUM("loan", "checkings", "savings", "401(k)", "roth IRA", "traditional IRA", "529", "taxable brokerage", "cryptocurrency"),
    
    -- If user_id changes, restrict the change.
    -- If user_id is deleted from database, then the user's accounts are also deleted (yyy: is this bad?
    user_id INT,
    CONSTRAINT fk_user_id_accounts FOREIGN KEY (user_id) REFERENCES users(user_id)
    ON UPDATE RESTRICT ON DELETE CASCADE,
    
    -- If goal_id changes, then cascade it.
    -- If goal is deleted, then set null- account is no longer linked to that goal.
    goal_id INT,
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
    industry ENUM("oil and gas", "yyy", "add industries here plz"),
    daily_value DECIMAL(13, 2)
);

-- yyy should we also have amount? or or that redundant?
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
    
    symbol VARCHAR(10),
	CONSTRAINT fk_symbol_holdings FOREIGN KEY (symbol) REFERENCES investments(symbol) 
    ON UPDATE CASCADE ON DELETE RESTRICT,
    
    account_reference_id INT,
	CONSTRAINT fk_account_reference_id_holdings FOREIGN KEY (account_reference_id) REFERENCES accounts(account_reference_id) 
    ON UPDATE CASCADE ON DELETE RESTRICT    
);

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

INSERT INTO accounts (id_at_institution, institution_name, account_nickname, account_type, user_id) VALUES
("20505157", "TD Bank", "My brokerage", "Taxable Brokerage", 1),
("66074247", "Vanguard", "Vanguard 401k", "401(k)", 1),
("72395085", "Vanguard", "Vanguard Roth", "roth IRA", 1),
("31150065", "Vanguard", "Vanguard Trad. IRA", "traditional IRA", 1),
("98178077-01", "Robinhood", "CRYPTO", "cryptocurrency", 1),
("66839606", "Vanguard", "Vanguard 529", "529", 1),
("59346393", "Nelnet", "First Loan", "loan", 1),
("17974534", "Nelnet", "Second Loan", "loan", 1),
("29476087", "Bank of America", "Ronak's Checking", "checkings", 2),
("82441179", "Ally", "Ronak's Saving", "savings", 2),
("54319892", "Nelnet", "Nelnet Loan", "loan", 2),
("08303869", "Northeastern", "Northeastern Loan", "loan", 2),
("35425018", "SLM Corporation", "Sallie Mae", "loan", 2),
("17261416", "FMC Corporation", "Freddie Mac", "loan", 2),
("40639267", "Chase", "Ronak's 401(k)", "401(k)", 2);

INSERT INTO goals (goal_name, goal_amount, user_id) VALUES
("Pay off my loans", 0, 1),
("DEBT FREE", 0, 2),
("House paid off", 0, 4),
("Reach $100k", 100000, 1); 

