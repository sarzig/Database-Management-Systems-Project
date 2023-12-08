/*
Filename: js_finance_read_procedures.sql

Purpose:  This file contains all the read procedures for our database. It is separated into
          two sections: basic reads and complex reads.

Contains: view_all_users()
          view_all_accounts()
          view_all_goals()
          view_all_investments()
          view_all_families()
          view_all_holdings()
          view_all_transactions()
          view_accounts_details_for_family(IN family_id_p INT)
          view_accounts_details_for_family_by_type(IN family_id_p INT)
          view_accounts_details_for_user(IN user_id_p INT)
          view_user_transactions(IN user_id_p INT)
          view_goals_for_user(IN user_id_p INT)
          view_my_holdings(IN user_id_p INT)
          view_my_holdings_by_account(IN user_id_p INT, IN account_nickname_p VARCHAR(100))
*/

/* 
+----------------------------------------------------------------------------------------------------+
|                                         Section 1: Basic Reads                                     |
+----------------------------------------------------------------------------------------------------+

The views in this section are more or less directly from the tables, or they contain very simple joins. 

*/

USE jsfinance;

DELIMITER $$
CREATE PROCEDURE view_all_users()
BEGIN
	-- View users table (joined with family table to view family name)
	SELECT 
		user_id,
        email, 
        first_name,
        last_name,
        family_name
    FROM users LEFT JOIN families ON users.family_id = families.family_id;
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE view_all_accounts()
BEGIN
	-- View accounts table. Accounts with no goals are shown with goal_id = 0
	SELECT 
		account_id,
		id_at_institution,
		account_nickname,
		account_type,
		user_id,
		FORMAT(COALESCE(goal_id, 0), 0) AS "Goal ID"
    FROM accounts;
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE view_all_goals()
BEGIN
	-- view goal table. Format money appropriately.
	SELECT 
		goal_id,
		goal_name,
		CONCAT('$ ', FORMAT(COALESCE(ROUND(goal_amount, 2), 0), 2)) AS "Goal Amount",
		user_id
    FROM goals;
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE view_all_investments()
BEGIN
	-- view investments (stocks) table. Format money appropriately.
	SELECT 
		symbol, 
		company_name,
		CONCAT('$ ', FORMAT(COALESCE(ROUND(daily_value, 2), 0), 2)) AS "Daily Value"
	FROM investments;
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE view_all_families()
BEGIN
	-- view family table
	SELECT * FROM families;
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE view_all_holdings()
BEGIN
	-- view holdings table
	SELECT * FROM holdings;
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE view_all_transactions()
BEGIN
	-- View transactions table. Format money appropriately.
	SELECT 
		transaction_id,
		transaction_date,
		number_shares,
		symbol,
		account_id,
		CONCAT('$ ', FORMAT(COALESCE(ROUND(value_transacted_at, 2), 0), 2)) AS "Value Transacted At"
    FROM transactions;
END$$
DELIMITER ;

/* 
+----------------------------------------------------------------------------------------------------+
|                                        Section 2: Complex Reads                                    |
+----------------------------------------------------------------------------------------------------+

This section contains views which require more complex operations than the basic reads.

*/

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
		CONCAT('$ ', FORMAT(SUM(number_shares * daily_value), 2), 0) AS "Account Value"
	FROM accounts 
    LEFT JOIN holdings ON accounts.account_id = holdings.account_id
    LEFT JOIN investments ON holdings.symbol = investments.symbol 
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
    CONCAT('$ ', FORMAT(COALESCE(SUM(
		CASE WHEN accounts.account_type != 'loan' THEN number_shares * daily_value 
             ELSE 0 
        END
        ), 0), 2)) AS "Total Assets",
    CONCAT('$ ', FORMAT(COALESCE(SUM(
		CASE WHEN accounts.account_type = 'loan' THEN number_shares * daily_value 
             ELSE 0 
        END
        ), 0), 2)) AS "Total Debts",
    CONCAT('$ ', FORMAT(COALESCE(SUM(
		CASE WHEN accounts.account_type = 'loan' THEN -1 * (number_shares * daily_value) 
             ELSE number_shares * daily_value 
        END
        ), 0), 2)) AS "Net Worth"
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
		accounts.id_at_institution,
        accounts.institution_name,
        accounts.account_nickname AS "Account Name",
        accounts.account_type,
        CONCAT("$ ", FORMAT(COALESCE(ROUND(SUM(COALESCE(number_shares, 0) * COALESCE(daily_value, 0)), 2), 0), 2)) AS "Account Value"
    FROM accounts
    LEFT JOIN holdings ON accounts.account_id = holdings.account_id
    LEFT JOIN investments ON holdings.symbol = investments.symbol 
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
		COALESCE(GROUP_CONCAT(DISTINCT accounts.account_nickname SEPARATOR ", "), " - ") AS "Account Name(s)",
		goals.goal_name AS "Goal Name",
        CONCAT('$ ', FORMAT(COALESCE(SUM(number_shares * daily_value), 0), 2)) AS "Current Value",
        CONCAT('$ ', FORMAT(goals.goal_amount, 2)) AS "Goal Amount",
        CASE WHEN
        (ROUND(SUM(number_shares * daily_value), 2) >= ROUND(goals.goal_amount, 2)) = 1
        THEN "YES"
        ELSE "NO"
        END
        AS "Is obtained?"
	FROM goals 
    LEFT JOIN accounts ON goals.user_id = accounts.user_id AND goals.goal_id = accounts.goal_id
    LEFT JOIN holdings ON accounts.account_id = holdings.account_id
	LEFT JOIN investments ON holdings.symbol = investments.symbol 
    WHERE goals.user_id = user_id_p
	GROUP BY 
		goals.goal_name,
        goals.goal_amount;
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE view_my_holdings(IN user_id_p INT)
BEGIN
	-- given a user id, this shows the stock holdings of all accounts
    DECLARE user_does_not_exist INT;
    
	-- Check if user exists
	SELECT COUNT(*) != 1 INTO user_does_not_exist FROM users WHERE user_id = user_id_p;
    IF user_does_not_exist THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "User ID does not exist.";
    END IF;
    
	SELECT 
		account_nickname, 
        account_type,
        symbol,
        number_shares, 
        CONCAT("$ ", format(daily_value, 2)) AS daily_value,
		CONCAT("$ ", format(number_shares*daily_value, 2)) AS total_value
    FROM holdings 
    NATURAL JOIN accounts 
    NATURAL JOIN investments 
    WHERE accounts.user_id = user_id_p AND number_shares > 0
	ORDER BY account_nickname, symbol;
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE view_my_holdings_by_account(IN user_id_p INT, IN account_nickname_p VARCHAR(100))
BEGIN
	-- given a user id, this shows the stock holdings of all accounts
    DECLARE user_does_not_exist INT;
    DECLARE account_id_p INT;
    
	-- Check if user exists
	SELECT COUNT(*) != 1 INTO user_does_not_exist FROM users WHERE user_id = user_id_p;
    IF user_does_not_exist THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "User ID does not exist.";
    END IF;
    
    SELECT get_account_id_from_user_id_and_account_nickname(user_id_p, account_nickname_p) INTO account_id_p;
    
	SELECT 
		account_nickname, 
        account_type,
        symbol,
        number_shares, 
        CONCAT("$ ", format(daily_value, 2)) AS daily_value,
		CONCAT("$ ", format(number_shares*daily_value, 2)) AS total_value
    FROM holdings 
    NATURAL JOIN accounts 
    NATURAL JOIN investments 
    WHERE accounts.user_id = user_id_p AND number_shares > 0 AND accounts.account_id = account_id_p
	ORDER BY account_nickname, symbol;
END$$
DELIMITER ;

