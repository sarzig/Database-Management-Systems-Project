DELIMITER $$
CREATE PROCEDURE deposit_money(IN transaction_date_p VARCHAR(50), IN account_reference_id_p INT, IN amount_p FLOAT)
-- deposits money into an account
BEGIN
	-- Error Handling -------------------------------------------------------------------------------------------   
    -- Make sure account exists  
    IF (SELECT COUNT(*) FROM accounts WHERE account_reference_id = account_reference_id_p) = 0 THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "Account does not exist.";
    END IF;
    
    -- make the transaction
    CALL create_transaction(transaction_date_p, amount_p, "CASH", account_reference_id_p);
    
END $$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE take_loan(IN transaction_date_p VARCHAR(50), IN account_reference_id_p INT, IN amount_p FLOAT)
-- creates debt within an account
BEGIN
	-- Error Handling -------------------------------------------------------------------------------------------   
    -- Make sure account exists  
    IF (SELECT COUNT(*) FROM accounts WHERE account_reference_id = account_reference_id_p) = 0 THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "Account does not exist.";
    END IF;
    
    -- make the transaction (always pass absolute value of amount)
    CALL create_transaction(transaction_date_p, abs(amount_p), "DEBT", account_reference_id_p);
    
END $$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE buy_investment_shares(IN transaction_date_p VARCHAR(50), IN account_reference_id_p INT, IN number_shares_p FLOAT, IN symbol_p VARCHAR(10))
-- takes cash from the specified account and buys stock
BEGIN
	DECLARE investment_daily_value FLOAT;
	DECLARE investment_total_cost FLOAT;
    DECLARE enough_cash_in_account INT;
	
	-- Error Handling -------------------------------------------------------------------------------------------   
    -- See if symbol exists
    IF (SELECT COUNT(*) FROM investments WHERE symbol = symbol_p) = 0 THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "Investment symbol doesn't exist.";
    END IF;
    
    -- calculate the cost of the investment    
    SELECT daily_value INTO investment_daily_value FROM investments WHERE symbol = symbol_p;
    SELECT investment_daily_value * number_shares_p INTO investment_total_cost;
    
    -- See if enough cash is in account
    SELECT COUNT(*) > 0 INTO enough_cash_in_account 
    FROM holdings 
    WHERE account_reference_id = account_reference_id_p AND symbol = "CASH" AND number_shares > investment_total_cost;
	
    IF NOT enough_cash_in_account THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "Account doesn't contain sufficient cash funds to place trade.";
    END IF;
    
	-- Execute trade - first delete cash and then buy the stock
	CALL create_transaction(transaction_date_p, -1*investment_total_cost, "CASH", account_reference_id_p);
	CALL create_transaction(transaction_date_p, number_shares_p, symbol_p, account_reference_id_p);

END $$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE sell_investment_shares(IN transaction_date_p VARCHAR(50), IN account_reference_id_p INT, IN number_shares_p FLOAT, IN symbol_p VARCHAR(10))
-- sells stock for CASH
BEGIN
	DECLARE investment_daily_value FLOAT;
	DECLARE investment_total_cost FLOAT;
    DECLARE shares_in_account FLOAT;
	
	-- Error Handling -------------------------------------------------------------------------------------------   
    -- See if symbol exists
    IF (SELECT COUNT(*) FROM investments WHERE symbol = symbol_p) = 0 THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "Investment symbol doesn't exist.";
    END IF;
    
    -- calculate the cost of the investment    
    SELECT daily_value INTO investment_daily_value FROM investments WHERE symbol = symbol_p;
    SELECT investment_daily_value * number_shares_p INTO investment_total_cost;
    
    -- See if that many shares of investment are in the account
    SELECT number_shares INTO shares_in_account 
    FROM holdings 
    WHERE account_reference_id = account_reference_id_p AND symbol = symbol_p;
	
    IF shares_in_account < number_shares_p THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "Not enough shares of investment are in the account.";
    END IF;
    
	-- Execute trade - first delete cash and then buy the stock
	CALL create_transaction(transaction_date_p, investment_total_cost, "CASH", account_reference_id_p);
	CALL create_transaction(transaction_date_p, -1*number_shares_p, symbol_p, account_reference_id_p);

END $$
DELIMITER ;

select * FROM transactions;
SELECT * FROM holdings WHERE account_Reference_id = 1;
CALL sell_investment_shares("2022-10-10", 1, 2, "TSLA");