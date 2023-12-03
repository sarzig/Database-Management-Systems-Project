-- Given a user id, show account details table
DROP PROCEDURE IF EXISTS view_accounts_details_for_user;
DELIMITER $$
CREATE PROCEDURE view_accounts_details_for_user(IN user_id_p INT)
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
		accounts.account_nickname AS "Account Name",
		accounts.account_type AS "Account Type",
		concat("$ ", format(COALESCE(ROUND(SUM(number_shares * daily_value), 2), 0), 2)) AS "Account Value"
	FROM holdings 
	LEFT JOIN investments ON holdings.symbol = investments.symbol 
	RIGHT JOIN accounts ON holdings.account_reference_id = accounts.account_reference_id
	WHERE accounts.user_id = user_id_p
	GROUP BY 
		accounts.account_nickname,
		accounts.account_type,
		accounts.account_reference_id;
END $$
DELIMITER ;

-- shoudl show sarah's account details
CALL view_accounts_details_for_user(1);
SELECT * FROM accounts WHERE user_id =1 ;

-- should fail for user who doesn't exist
CALL view_accounts_details_for_user(500);
