SELECT * FROM transactions LEFT JOIN accounts ON transactions.account_reference_id = accounts.account_reference_id WHERE user_id = 1;
SELECT transaction_date, symbol, number_shares, number_shares*value_transacted_at AS total_amount FROM transactions;

-- Given a user id, show 20 most recent transactions
DROP PROCEDURE IF EXISTS view_user_transactions;
DELIMITER $$
CREATE PROCEDURE view_user_transactions(IN user_id_p INT)
BEGIN
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
	LEFT JOIN accounts ON transactions.account_reference_id = accounts.account_reference_id 
	WHERE user_id = user_id_p
	ORDER BY transaction_date DESC
	LIMIT 20;
END $$
DELIMITER ;

-- tests
CALL view_user_transactions(1); -- should work because user exists
CALL view_user_transactions(55); -- should fail because user DNE