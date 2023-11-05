DROP DATABASE jsFinance;
CREATE DATABASE jsFinance;
USE jsFinance;

CREATE TABLE families (
	family_id INT AUTO_INCREMENT PRIMARY KEY,
    family_name VARCHAR (100)
);

CREATE TABLE users (
	user_id INT AUTO_INCREMENT PRIMARY KEY,
    email VARCHAR(200) UNIQUE,
    first_name VARCHAR(100), 
    last_name VARCHAR(100),
	family_id INT DEFAULT NULL,
	
    -- If user's family changes, then update the details.
    -- If user's family is deleted, then set user's family to NULL.
    CONSTRAINT fk_family_id_users FOREIGN KEY (family_id) REFERENCES families(family_id)
    ON UPDATE CASCADE ON DELETE SET NULL
);

CREATE TABLE goals (
	goal_id INT AUTO_INCREMENT PRIMARY KEY,
    goal_name VARCHAR(50),
    goal_amount INT,
        
    -- If user_id changes, restrict the change.
    -- If user_id is deleted from database, then the user's goals are also deleted (yyy: is this bad?
    user_id INT,
    CONSTRAINT fk_user_id_goals FOREIGN KEY (user_id) REFERENCES users(user_id)
    ON UPDATE RESTRICT ON DELETE CASCADE    
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
    ON UPDATE CASCADE ON DELETE SET NULL
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
    ON UPDATE CASCADE ON DELETE RESTRICT
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
