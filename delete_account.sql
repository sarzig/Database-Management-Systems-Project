-- An account can be deleted with its account nickname and the user_id.
-- If the user_id does not exist and the account nickname does not exist for that user then 
-- an error occurs. 

DELIMITER $$
CREATE PROCEDURE delete_account(
    IN account_nickname_p VARCHAR(1000),
    IN user_id_p INT
)
BEGIN
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

-- testing- ----------------------------------------------------------------------------------------------
SELECT * FROM accounts;
CALL delete_account("Northeastern Loan", 2);
