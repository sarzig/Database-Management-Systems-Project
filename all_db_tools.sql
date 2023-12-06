DELIMITER $$
CREATE PROCEDURE deposit_money(IN transaction_date_p VARCHAR(50), IN account_id_p INT, IN amount_p FLOAT)
BEGIN
    -- deposits money into an account
	-- Error Handling -------------------------------------------------------------------------------------------   
    -- Make sure account exists  
    IF (SELECT COUNT(*) FROM accounts WHERE account_id = account_id_p) = 0 THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "Account does not exist.";
    END IF;
    
    -- make the transaction
    CALL create_transaction(transaction_date_p, amount_p, "CASH", account_id_p);
    
END $$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE take_loan(IN transaction_date_p VARCHAR(50), IN account_id_p INT, IN amount_p FLOAT)
BEGIN
    -- creates debt within an account
	-- Error Handling -------------------------------------------------------------------------------------------   
    -- Make sure account exists  
    IF (SELECT COUNT(*) FROM accounts WHERE account_id = account_id_p) = 0 THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "Account does not exist.";
    END IF;
    
    -- make the transaction (always pass absolute value of amount)
    CALL create_transaction(transaction_date_p, abs(amount_p), "DEBT", account_id_p);
    
END $$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE buy_investment_shares(IN transaction_date_p VARCHAR(50), IN account_id_p INT, IN number_shares_p FLOAT, IN symbol_p VARCHAR(10))
BEGIN
    -- takes cash from the specified account and buys stock

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
    WHERE account_id = account_id_p AND symbol = "CASH" AND number_shares > investment_total_cost;
	
    IF NOT enough_cash_in_account THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "Account doesn't contain sufficient cash funds to place trade.";
    END IF;
    
	-- Execute trade - first delete cash and then buy the stock
	CALL create_transaction(transaction_date_p, -1*investment_total_cost, "CASH", account_id_p);
	CALL create_transaction(transaction_date_p, number_shares_p, symbol_p, account_id_p);

END $$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE sell_investment_shares(IN transaction_date_p VARCHAR(50), IN account_id_p INT, IN number_shares_p FLOAT, IN symbol_p VARCHAR(10))
BEGIN
-- sells stock for CASH
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
    WHERE account_id = account_id_p AND symbol = symbol_p;
	
    IF shares_in_account < number_shares_p THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "Not enough shares of investment are in the account.";
    END IF;
    
	-- Execute trade - first delete cash and then buy the stock
	CALL create_transaction(transaction_date_p, investment_total_cost, "CASH", account_id_p);
	CALL create_transaction(transaction_date_p, -1*number_shares_p, symbol_p, account_id_p);

END $$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE create_account(
    IN id_at_institution_p VARCHAR(50),
    IN institution_name_p VARCHAR(200),
    IN account_nickname_p VARCHAR(50),
    IN account_type_p VARCHAR(50),
    IN user_id_p INT,
    IN goal_name_p VARCHAR(50)
)
BEGIN
-- To create an account, institution details are needed (id at institution, institution name).
-- The account must be given a nickname UNIQUE to that user.
-- The account type must be specified, and must be equal to one of the account_type enums.
-- If a goal should be linked to the account, the goal_name must already be associated with
-- that user.
    DECLARE id_and_instution_combo_already_exists BOOLEAN;
	DECLARE goal_does_not_exist BOOLEAN;
    DECLARE goal_id_p INT;

	-- Error Handling -------------------------------------------------------------------------------------------
	-- Check if length of any values are too long
	IF LENGTH(id_at_institution_p) > 50 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'id_at_institution length cannot be more than 50 characters.';
    END IF;
	IF LENGTH(institution_name_p) > 200 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'institution_name length cannot be more than 50 characters.';
    END IF;
	IF LENGTH(account_nickname_p) > 50 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'account_nickname length cannot be more than 50 characters.';
    END IF;
    
	-- Check if account_type_p is one of the specified enums
    IF NOT account_type_p IN ('loan', 'checkings', 'savings', '401(k)', 'roth IRA', 'traditional IRA', '529', 'taxable brokerage', 'cryptocurrency') THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid account_type.';
    END IF;

    -- Check if the account with the same id_at_institution and institution_name already exists
	SELECT COUNT(*) > 0 INTO id_and_instution_combo_already_exists 
    FROM accounts
	WHERE id_at_institution = id_at_institution_p AND institution_name = institution_name_p;
    
    IF id_and_instution_combo_already_exists THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "Combination of ID at institution and institution name already exists.";
    END IF;
    
    -- Check that a goal by that name exists with the current user
	SELECT COUNT(*) = 0 INTO goal_does_not_exist 
    FROM goals
	WHERE goal_name = goal_name_p AND user_id = user_id_p;
    
    -- if goal name is NULL, then goal_id is NULL and there's no error
    IF goal_name_p IS NULL THEN
		SELECT NULL into goal_id_p;
	-- If goal doesn't exist then raise error
	ELSEIF goal_does_not_exist THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "Goal by that name does not exist for this user.";
	-- If goal DOES exist by that name, then find the goal_id_p
	ELSE
		SELECT goal_id INTO goal_id_p
        FROM goals 
        WHERE goal_name = goal_name_p;
    END IF;

	INSERT INTO accounts (id_at_institution, institution_name, account_nickname, account_type, user_id, goal_id) 
    VALUES (id_at_institution_p, institution_name_p, account_nickname_p, account_type_p, user_id_p, goal_id_p);
    
    -- Success code
	SELECT 'Success' AS result;
END $$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE create_family(
	IN family_name_p VARCHAR(100)
    )
BEGIN
	-- error handling
    -- if family name is already taken
	IF EXISTS(SELECT * FROM families WHERE family_name = family_name_p) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'That family name is already taken.';
	-- if family name longer than allowed
    ELSEIF LENGTH(family_name_p) > 100 THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Family name exceeds 50 characters.';
    -- if family name is null
    ELSEIF family_name_p IS NULL OR family_name_p = '' THEN 
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Family name must be provided.';
	END IF;
    
    -- create the family
    INSERT INTO FAMILIES(family_name) VALUES (family_name_p);
    
END $$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE create_goal(
	IN goal_name_p VARCHAR(1000),
    IN goal_amount_p INT,
    IN user_id_p INT
)
BEGIN
-- To create a goal, a goal name, amount, and user_id are needed.
-- Errors occur if a goal by that name already exists for the given user, or
-- if the given user does not exist.
-- Goal amounts can be positive, 0, or negative
	DECLARE goal_name_already_in_use BOOLEAN;
    DECLARE user_does_not_exist BOOLEAN;
    
	-- Error Handling -------------------------------------------------------------------------------------------
	-- Check if length of any values are too long
	IF LENGTH(goal_name_p) > 50 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'goal_name length cannot be more than 50 characters.';
    END IF;
    
    -- Check if user exists
	SELECT COUNT(*) != 1 INTO user_does_not_exist FROM users WHERE user_id = user_id_p;
    IF user_does_not_exist THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "User ID does not exist.";
    END IF;
    
	-- Check if the user_id / goal_name combo already exists
	SELECT COUNT(*) > 0 INTO goal_name_already_in_use FROM goals WHERE goal_name = goal_name_p AND user_id = user_id_p;
    
    IF goal_name_already_in_use THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "Goal name already exists for that user.";
    END IF;
    
	INSERT INTO goals (goal_name, goal_amount, user_id)
    VALUES (goal_name_p, goal_amount_p, user_id_p);

    -- Success code
	SELECT 'Success' AS result;
END $$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE create_investment(
	IN symbol_p VARCHAR(10),
    IN company_name_p VARCHAR(200),
    IN daily_value_p DECIMAL(13,2)
    )
BEGIN
	DECLARE symbol_already_exists BOOLEAN;
    SELECT count(*) > 0 INTO symbol_already_exists FROM investments WHERE symbol = symbol_p;
    
	-- error handling
    -- if symbol or company name is null
    IF symbol_p IS NULL OR company_name_p IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'symbol and company name cannot be null.';

    -- if CASH is set to a value other than 1
    ELSEIF symbol_p = "CASH" and daily_value_p != 1 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'CASH must be created with value 1.';

    -- if DEBT is set to a value other than -1
    ELSEIF symbol_p = "DEBT" and daily_value_p != -1 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'DEBT must be created with value -1.';
    
    -- if non-debt investment is negative
    ELSEIF symbol_p != "DEBT" and daily_value_p < 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'This investment cannot be negative.';
    
    END IF;

	-- if investment already exists, update the company name and daily value
    IF symbol_already_exists THEN
		UPDATE investments SET company_name = company_name_p WHERE symbol = symbol_p;
		UPDATE investments SET daily_value = daily_value_p WHERE symbol = symbol_p;
	
    -- otherwise, create the investment
    ELSE
		INSERT INTO investments(symbol, company_name, daily_value) 
		VALUES (symbol_p, company_name_p, daily_value_p);
	END IF;
    
END $$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE create_transaction(
	IN transaction_date_p VARCHAR(50),
    IN number_shares_p FLOAT,
    IN symbol_p VARCHAR(10),
    IN account_id_p INT
    )
BEGIN
    DECLARE transaction_date_var DATE;
    DECLARE daily_value_var DECIMAL(13, 2);

	-- error handling
    -- if date isn't in correct format
    IF STR_TO_DATE(transaction_date_p, '%Y-%m-%d') IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Incorrect date format: please use YYYY-MM-DD.';

    -- if number_shares is negative or 0
    -- ELSEIF number_shares_p <= 0 THEN
    --     SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Number of shares must be positive.';

    -- if transaction date or number of shares are null
    ELSEIF transaction_date_p IS NULL OR number_shares_p IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Date and number of shares must not be null.';

    -- if symbol doesn't exist
    ELSEIF NOT EXISTS (SELECT * FROM investments WHERE symbol = symbol_p) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Symbol is not found.';

    -- if account reference ID doesn't exist
    ELSEIF NOT EXISTS (SELECT * FROM accounts WHERE account_id = account_id_p) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Account reference ID is not found.';
    END IF;

    -- since date has passed validation, convert the transaction date to a date format
    SELECT STR_TO_DATE(transaction_date_p, '%Y-%m-%d') INTO transaction_date_var;

    -- extract the daily value from the investments table, and assign it to a variable
    SELECT daily_value FROM investments where symbol = symbol_p INTO daily_value_var;

    -- create the transaction
    INSERT INTO transactions(transaction_date, number_shares, symbol, account_id, value_transacted_at)
    VALUES (transaction_date_var, number_shares_p, symbol_p, account_id_p, daily_value_var);
    
    -- If there is already a holdings tuple with the given symbol in that account, update
    IF EXISTS (SELECT * FROM holdings WHERE account_id = account_id_p AND symbol = symbol_p) THEN
		UPDATE holdings SET number_shares = number_shares + number_shares_p WHERE account_id = account_id_p AND symbol = symbol_p;
	-- if holdings tuple in that account DNE, create new tuple
    ELSE
		INSERT into holdings(number_shares, symbol, account_id) VALUES
        (number_shares_p, symbol_p, account_id_p);
    END IF;
END $$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE create_user(
	IN email_p VARCHAR(200), 
    IN first_name_p VARCHAR(100),
    IN last_name_p VARCHAR(100),
    IN family_id_p INT)
BEGIN
	-- procedure for creating user
	-- error handling
    -- if email is already taken
	IF EXISTS(SELECT * FROM users WHERE email = email_p) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'That email is already taken.';
	-- if first name or email parameters are null
    ELSEIF first_name_p IS NULL OR email_p IS NULL THEN 
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'First name and email must be provided.';
	-- if family id parameter doesn't exist
    ELSEIF family_id_p IS NOT NULL AND NOT EXISTS(SELECT * FROM families WHERE family_id = family_id_p) THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Family ID is not found.';
	END IF;
    
    -- create the user
    INSERT INTO USERS(email, first_name, last_name, family_id) VALUES (email_p, first_name_p, last_name_p, family_id_p);
END $$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE delete_account(IN account_nickname_p VARCHAR(1000), IN user_id_p INT)
BEGIN
-- An account can be deleted with its account nickname and the user_id.
-- If the user_id does not exist and the account nickname does not exist for that user then
-- an error occurs.
    DECLARE user_id_does_not_exist BOOLEAN;
	DECLARE account_nickname_does_not_exist BOOLEAN;

	-- Error Handling -------------------------------------------------------------------------------------------
    -- Check if user exists
	SELECT COUNT(*) != 1 INTO user_id_does_not_exist FROM users WHERE user_id = user_id_p;
    IF user_id_does_not_exist THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "User ID does not exist, cannot delete account.";
    END IF;
    
    SELECT COUNT(*) != 1 INTO account_nickname_does_not_exist FROM accounts WHERE user_id = user_id_p AND account_nickname = account_nickname_p;
    IF account_nickname_does_not_exist THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "Account nickname does not exist for that user, cannot delete account.";
	END IF;
    
    -- Execute Deletion
    DELETE FROM accounts WHERE account_nickname = account_nickname_p AND user_id = user_id_p;
    
    -- Success code
	SELECT 'Success' AS result;
END $$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE delete_family(IN family_id_p INT)
BEGIN
-- To delete a family, a family_id is needed. If that family_id does not exist, then
-- an error is raised.
    DECLARE family_does_not_exist BOOLEAN;
    
	-- Error Handling -------------------------------------------------------------------------------------------   
    -- Check if family exists
	SELECT COUNT(*) != 1 INTO family_does_not_exist FROM families WHERE family_id = family_id_p;
    IF family_does_not_exist THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "Family ID does not exist, cannot delete family.";
    END IF;
    
    -- Execute deletion -------------------------------------------------------------------------------------------   
	DELETE FROM families WHERE family_id = family_id_p;
    
    -- Success code
	SELECT 'Success' AS result;
END $$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE delete_goal(IN goal_name_p VARCHAR(1000), IN user_id_p INT)
BEGIN
	DECLARE goal_name_does_not_exist BOOLEAN;
    DECLARE user_does_not_exist BOOLEAN;
    
	-- Error Handling -------------------------------------------------------------------------------------------   
    -- Check if user exists
	SELECT COUNT(*) != 1 INTO user_does_not_exist FROM users WHERE user_id = user_id_p;
    IF user_does_not_exist THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "User ID does not exist, cannot delete goal.";
    END IF;
    
	-- Check if the goal name exists for that user
	SELECT COUNT(*) = 0 INTO goal_name_does_not_exist FROM goals WHERE goal_name = goal_name_p AND user_id = user_id_p;
    
    IF goal_name_does_not_exist THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "Goal doesn't exist for this user, cannot delete goals.";
    END IF;
    
    -- Execute deletion -------------------------------------------------------------------------------------------   
	DELETE FROM goals WHERE goal_name = goal_name_p AND user_id = user_id_p;
    
    -- Success code
	SELECT 'Success' AS result;
END $$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE delete_user(IN user_id_p INT)
BEGIN
-- To delete a user, a user_id is needed. If that user_id does not exist, then
-- an error is raised.
    DECLARE user_does_not_exist BOOLEAN;
    
	-- Error Handling -------------------------------------------------------------------------------------------   
    -- Check if user exists
	SELECT COUNT(*) != 1 INTO user_does_not_exist FROM users WHERE user_id = user_id_p;
    IF user_does_not_exist THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "User ID does not exist, cannot delete user.";
    END IF;
    
    -- Execute deletion -------------------------------------------------------------------------------------------   
	DELETE FROM users WHERE user_id = user_id_p;
    
    -- Success code
	SELECT 'Success' AS result;
END $$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE update_accounts_goal(IN user_id_p INT, IN account_nickname_p VARCHAR(1000), IN goal_name_p VARCHAR(1000))
BEGIN
    DECLARE user_does_not_exist BOOLEAN;
    DECLARE account_does_not_exist BOOLEAN;
    DECLARE goal_does_not_exist BOOLEAN;
    DECLARE new_goal_id INT;
    
	-- Error Handling -------------------------------------------------------------------------------------------   
    -- Check if user exists
	SELECT COUNT(*) != 1 INTO user_does_not_exist FROM users WHERE user_id = user_id_p;
    IF user_does_not_exist THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "User ID does not exist, cannot update account's goal.";
    END IF;
    
    -- Check if account with that name is associated with that user
	SELECT COUNT(*) = 0 INTO account_does_not_exist FROM accounts WHERE account_nickname = account_nickname_p AND user_id = user_id_p;
    IF account_does_not_exist THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "This account doesn't exist for this user, cannot update.";
    END IF;    
    
    -- Check if goal with that name is associated with that user
	SELECT COUNT(*) = 0 INTO goal_does_not_exist FROM goals WHERE goal_name = goal_name_p AND user_id = user_id_p;
    IF goal_does_not_exist THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "This goal doesn't exist for this user, cannot update.";
    END IF;
    
    -- Execute update -------------------------------------------------------------------------------------------   
    -- find correct goal_id
    SELECT goal_id INTO new_goal_id FROM goals WHERE user_id = user_id_p and goal_name = goal_name_p;
    
	UPDATE accounts SET goal_id = new_goal_id WHERE user_id = user_id_p AND account_nickname = account_nickname_p;
    
END $$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE update_goal_amount(
	IN goal_name_p VARCHAR(1000),
    IN user_id_p INT, 
    IN new_goal_amount_p INT
)
BEGIN
-- To update a goal's amount, a goal name, amount, and a user_id are needed.
-- Errors occur if a goal by the old name doesn't exist for the given user, or
-- if the given user does not exist, or if a goal by that amount already
-- exists for the given user.
	DECLARE goal_name_does_not_exist BOOLEAN;
    DECLARE user_does_not_exist BOOLEAN;
    DECLARE amount_is_same BOOLEAN;
    
	-- Error Handling -------------------------------------------------------------------------------------------   
    -- Check if user exists
	SELECT COUNT(*) != 1 INTO user_does_not_exist FROM users WHERE user_id = user_id_p;
    IF user_does_not_exist THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "User ID does not exist, cannot update goal amount.";
    END IF;
    
	-- Check if the OLD goal name exists for that user -> if it doesn't, raise error
	SELECT COUNT(*) = 0 INTO goal_name_does_not_exist FROM goals WHERE goal_name = goal_name_p AND user_id = user_id_p;
    IF goal_name_does_not_exist THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "Goal doesn't exist for this user, cannot update.";
    END IF;
    
    -- Check if the goal already has the same amount
    SELECT COUNT(*) != 0 INTO amount_is_same FROM goals WHERE user_id = user_id_p AND goal_name = goal_name_p AND goal_amount = new_goal_amount_p;
    IF amount_is_same THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "A goal already exists with that name and amount.";
    END IF;
    
    -- Execute update -------------------------------------------------------------------------------------------   
	UPDATE goals SET goal_amount = new_goal_amount_p WHERE user_id = user_id_p AND goal_name = goal_name_p;
    
    -- Success code
	SELECT 'Success' AS result;
END $$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE update_goal_name(
	IN old_goal_name_p VARCHAR(1000),
    IN new_goal_name_p VARCHAR(1000),
    IN user_id_p INT
)
BEGIN
-- To update a goal's name, an old and new goal name and a user_id are needed.
-- Errors occur if a goal by the old name doesn't exist for the given user, or
-- if the given user does not exist, or if a goal by the new name already
-- exists for the given user.
	DECLARE old_goal_name_does_not_exist BOOLEAN;
    DECLARE user_does_not_exist BOOLEAN;
    DECLARE new_goal_name_already_exists BOOLEAN;
    
	-- Error Handling -------------------------------------------------------------------------------------------   
    -- Check if new_goal_name_p is too long
	IF LENGTH(new_goal_name_p) > 50 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Goal name length cannot be more than 50 characters.';
    END IF;
    
    -- Check if user exists
	SELECT COUNT(*) != 1 INTO user_does_not_exist FROM users WHERE user_id = user_id_p;
    IF user_does_not_exist THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "User ID does not exist, cannot update goal name.";
    END IF;
    
	-- Check if the OLD goal name exists for that user -> if it doesn't, raise error
	SELECT COUNT(*) = 0 INTO old_goal_name_does_not_exist FROM goals WHERE goal_name = old_goal_name_p AND user_id = user_id_p;
    IF old_goal_name_does_not_exist THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "Goal doesn't exist for this user, cannot update.";
    END IF;
    
    -- Check if NEW goal name ALREADY exists for that user -> if it does, raise error
    SELECT COUNT(*) != 0 INTO new_goal_name_already_exists FROM goals WHERE user_id = user_id_p AND goal_name = new_goal_name_p;
    IF new_goal_name_already_exists THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "A goal already exists with the intended new name.";
    END IF;
    
    -- Execute update -------------------------------------------------------------------------------------------   
	UPDATE goals SET goal_name = new_goal_name_p WHERE user_id = user_id_p AND goal_name = old_goal_name_p;
    
    -- Success code
	SELECT 'Success' AS result;
END $$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE update_stock_daily_value(IN symbol_p VARCHAR(10), IN new_daily_value_p DECIMAL(13,2)
)
-- procedure for updating an investment's daily value
BEGIN
	-- error handling
    -- if symbol is null
    IF symbol_p IS NULL THEN 
	    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Symbol cannot be null.';
    
    -- if symbol does not exist
	ELSEIF NOT EXISTS(SELECT * FROM investments WHERE symbol = symbol_p) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'That symbol cannot be found';

    -- if erroneously attempting to update CASH or DEBT investments
    ELSEIF symbol_p = "CASH" OR symbol_p = "DEBT" THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "This investment's value cannot be modified";

    -- if new_daily_value_p is negative
    ELSEIF new_daily_value_p < 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'New value cannot be negative.';

    END IF;
    
    -- update the stock's daily value
    UPDATE investments SET daily_value = new_daily_value_p WHERE symbol = symbol_p;

END $$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE update_user_family(IN user_id_p INT, IN family_id_p INT
)
BEGIN
-- To update a user's family, the user_id and family_id must already exist.
-- If the family_id_p is the same as the existing family_id, an error occurs.
    DECLARE user_does_not_exist BOOLEAN;
    DECLARE original_family_id_is_null BOOLEAN;
    DECLARE family_id_already_the_same BOOLEAN;
    DECLARE family_does_not_exist BOOLEAN;
    
	-- Error Handling -------------------------------------------------------------------------------------------   
    -- Check if user exists
	SELECT COUNT(*) != 1 INTO user_does_not_exist FROM users WHERE user_id = user_id_p;
    IF user_does_not_exist THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "User ID does not exist, cannot update family.";
    END IF;
    
	-- Check if family doesn't exist for non-null family_id_p
	SELECT COUNT(*) = 0 INTO family_does_not_exist FROM families WHERE family_id = family_id_p;
    IF family_does_not_exist and family_id_p IS NOT NULL THEN
    		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "Family ID does not exist, cannot update family.";
    END IF;
    
    -- Check if family was already equal to NULL when trying to make family null
	SELECT COUNT(*) = 1 INTO original_family_id_is_null FROM users WHERE user_id = user_id_p AND family_id IS NULL;
	IF original_family_id_is_null AND family_id_p IS NULL THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "User family was already NULL, no change needed.";
    END IF;
    
    -- Check if family was already equal to that value (does NOT work for NULL family)
	SELECT COUNT(*) = 1 INTO family_id_already_the_same FROM users WHERE user_id = user_id_p AND family_id = family_id_p;
	IF family_id_already_the_same THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "User family was already the same value, no change needed.";
    END IF;
    
    -- Execute update -------------------------------------------------------------------------------------------   
	UPDATE users set family_id = family_id_p where user_id = user_id_p;
    
    -- Success code
	SELECT 'Success' AS result;
END $$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE update_user_family_to_null(IN user_id_p INT)
BEGIN
-- To remove a user from a family, the user_id is needed. This procedure
-- requires an existing user_id and for that user to already be associated
-- with a family.
    CALL update_user_family(user_id_p, NULL);
END $$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE view_accounts_details_for_family(IN family_id_p INT)
BEGIN
-- Given a family id, show account details table
    DECLARE family_does_not_exist BOOLEAN;

	-- Error Handling ----------------------------------------------------------------------------------------- 
    -- Check if family exists
    SELECT COUNT(*) != 1 INTO family_does_not_exist FROM families WHERE family_id = family_id_p;
    
    IF family_does_not_exist THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "Family ID does not exist, cannot retrieve account values.";
    END IF;
    
	-- Execute view -------------------------------------------------------------------------------------------   
	SELECT 
		accounts.account_nickname AS "Account Name",
		accounts.account_type AS "Account Type",
		CONCAT('$ ', FORMAT(SUM(number_shares * daily_value), 2)) AS "Account Value"
	FROM holdings 
	JOIN investments ON holdings.symbol = investments.symbol 
	JOIN accounts ON holdings.account_id = accounts.account_id
    JOIN users ON users.user_id = accounts.user_id
	WHERE users.family_id = family_id_p
	GROUP BY 
		accounts.account_nickname,
		accounts.account_type,
		accounts.account_id;
END $$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE view_accounts_details_for_family_by_type(IN family_id_p INT)
BEGIN
-- Given a family id, show account details grouped into Assets, Debt, and calculate Net Worth
    DECLARE family_does_not_exist BOOLEAN;

	-- Error Handling ----------------------------------------------------------------------------------------- 
    -- Check if family exists
    SELECT COUNT(*) != 1 INTO family_does_not_exist FROM families WHERE family_id = family_id_p;
    
    IF family_does_not_exist THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "Family ID does not exist, cannot retrieve account values.";
    END IF;
    
	-- Execute view -------------------------------------------------------------------------------------------   
	SELECT 
    CONCAT('$ ', FORMAT(SUM(
		CASE WHEN accounts.account_type != 'loan' THEN number_shares * daily_value 
             ELSE 0 
        END
        ), 2)) AS "Total Assets",
    CONCAT('$ ', FORMAT(SUM(
		CASE WHEN accounts.account_type = 'loan' THEN number_shares * daily_value 
             ELSE 0 
        END
        ), 2)) AS "Total Debts",
    CONCAT('$ ', FORMAT(SUM(
		CASE WHEN accounts.account_type = 'loan' THEN -1 * (number_shares * daily_value) 
             ELSE number_shares * daily_value 
        END
        ), 2)) AS "Net Worth"
    FROM holdings 
    JOIN investments ON holdings.symbol = investments.symbol 
    JOIN accounts ON holdings.account_id = accounts.account_id
    JOIN users ON users.user_id = accounts.user_id
    WHERE users.family_id = family_id_p;
END $$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE view_accounts_details_for_user(IN user_id_p INT)
BEGIN
-- Given a user id, show account details table
    DECLARE user_does_not_exist BOOLEAN;

	-- Error Handling -------------------------------------------------------------------------------------------   
    -- Check if user exists
    SELECT COUNT(*) != 1 INTO user_does_not_exist FROM users WHERE user_id = user_id_p;
    
    IF user_does_not_exist THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "User ID does not exist, cannot retrieve account values.";
    END IF;
    
	-- Execute view -------------------------------------------------------------------------------------------   
	SELECT 
		accounts.account_nickname AS "Account Name",
		accounts.account_type AS "Account Type",
		concat("$ ", format(COALESCE(ROUND(SUM(number_shares * daily_value), 2), 0), 2)) AS "Account Value"
	FROM holdings 
	LEFT JOIN investments ON holdings.symbol = investments.symbol 
	RIGHT JOIN accounts ON holdings.account_id = accounts.account_id
	WHERE accounts.user_id = user_id_p
	GROUP BY 
		accounts.account_nickname,
		accounts.account_type,
		accounts.account_id;
END $$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE view_user_transactions(IN user_id_p INT)
BEGIN
-- Given a user id, show 20 most recent transactions
    DECLARE user_does_not_exist BOOLEAN;

	-- Error Handling -------------------------------------------------------------------------------------------   
    -- Check if user exists
    SELECT COUNT(*) != 1 INTO user_does_not_exist FROM users WHERE user_id = user_id_p;
    
	IF user_does_not_exist THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "User ID does not exist, cannot retrieve transactions.";
    END IF;
    
	-- Execute view -------------------------------------------------------------------------------------------   
	SELECT 
	account_nickname, transaction_date, symbol, number_shares, concat("$ ", format(number_shares*value_transacted_at, 2)) AS total_amount
	FROM transactions 
	LEFT JOIN accounts ON transactions.account_id = accounts.account_id 
	WHERE user_id = user_id_p
	ORDER BY transaction_date DESC
	LIMIT 20;
END $$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE view_goals_for_user(IN user_id_p INT)
BEGIN
    DECLARE user_does_not_exist BOOLEAN;

	-- Error Handling -------------------------------------------------------------------------------------------   
    -- Check if user exists
    SELECT COUNT(*) != 1 INTO user_does_not_exist FROM users WHERE user_id = user_id_p;
    
    IF user_does_not_exist THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "User ID does not exist, cannot retrieve account values.";
    END IF;
    
	-- Execute view -------------------------------------------------------------------------------------------   
	SELECT 
		GROUP_CONCAT(DISTINCT accounts.account_nickname SEPARATOR ", ") AS "Account Name",
		goals.goal_name AS "Goal Name",
        CONCAT('$ ', FORMAT(SUM(number_shares * daily_value), 2)) AS "Current Value",
        CONCAT('$ ', FORMAT(goals.goal_amount, 2)) AS "Goal Amount",
        CASE WHEN
        (ROUND(SUM(number_shares * daily_value), 2) > goals.goal_amount) = 1
        THEN "YES"
        ELSE "NO"
        END
        AS "Is obtained?"

	FROM holdings 
	JOIN investments ON holdings.symbol = investments.symbol 
	RIGHT JOIN accounts ON holdings.account_id = accounts.account_id
    JOIN goals ON accounts.user_id = goals.user_id AND accounts.goal_id = goals.goal_id
	WHERE accounts.user_id = user_id_p
	GROUP BY 
		goals.goal_name,
        goals.goal_amount;
END$$
DELIMITER ;

DELIMITER $$
CREATE FUNCTION get_user_id(email_p VARCHAR(1000)) RETURNS INT
DETERMINISTIC CONTAINS SQL
BEGIN
	DECLARE result INT;
        
	SELECT user_id INTO result
	FROM users 
	WHERE email = email_p;
        
	-- user does not exist -> error message
	IF result IS NULL THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "User ID does not exist, cannot get user.";
	END IF;
        
	RETURN result;
	
END$$
DELIMITER ;

DELIMITER $$
CREATE FUNCTION get_user_family(user_id_p INT) RETURNS INT
DETERMINISTIC CONTAINS SQL
BEGIN
	DECLARE result INT;
        
	SELECT family_id INTO result
	FROM users 
	WHERE user_id = user_id_p;
        
	-- user does not have family -> return -1
	IF result IS NULL THEN
		SELECT -1 INTO result;
	END IF;
        
	RETURN result;
	
END$$
DELIMITER ;

DELIMITER $$
CREATE FUNCTION get_user_first_name(user_id_p INT) RETURNS VARCHAR(100)
DETERMINISTIC CONTAINS SQL
BEGIN
	DECLARE result VARCHAR(100);
        
	SELECT first_name INTO result
	FROM users 
	WHERE user_id = user_id_p;
        
	-- user does not have first_name -> return -1
	IF result IS NULL THEN
		SELECT "" INTO result;
	END IF;
        
	RETURN result;
	
END $$
DELIMITER ;
CALL 

DELIMITER $$
CREATE PROCEDURE view_all_users()
BEGIN
	SELECT 
		user_id AS "User ID", 
        email, 
        first_name AS "First Name",
        last_name AS "Last Name",
        family_name AS "Family"
    FROM users LEFT JOIN families ON users.family_id = families.family_id;
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE view_all_accounts()
BEGIN
	SELECT * FROM accounts;
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE view_all_goals()
BEGIN
	SELECT * FROM goals;
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE view_all_investments()
BEGIN
	-- Shows all investments in the database and their daily value
	SELECT 
		symbol, 
        company_name AS "Company Name", 
        concat("$ ", FORMAT(daily_value, 2)) AS "Daily Value"
    FROM investments 
    WHERE symbol != "CASH" AND symbol != "DEBT";
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE view_all_families()
BEGIN
	-- Shows all families in the database
	SELECT
		family_id AS "Family ID",
        family_name AS "Family Name"
    FROM families;
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE view_all_holdings()
BEGIN
	SELECT * FROM holdings;
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE view_all_transactions()
BEGIN
	SELECT * FROM transactions;
END$$
DELIMITER ;