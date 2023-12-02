-- Given a family id, show account details table
DROP PROCEDURE IF EXISTS view_accounts_details_for_family;
DELIMITER $$
CREATE PROCEDURE view_accounts_details_for_family(IN family_id_p INT)
BEGIN
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
		ROUND(SUM(number_shares * daily_value), 2) AS "Account Value"
	FROM holdings 
	JOIN investments ON holdings.symbol = investments.symbol 
	JOIN accounts ON holdings.account_reference_id = accounts.account_reference_id
    JOIN users ON users.user_id = accounts.user_id
	WHERE users.family_id = family_id_p
	GROUP BY 
		accounts.account_nickname,
		accounts.account_type,
		accounts.account_reference_id;
END $$
DELIMITER ;

-- tests ------------------------------------------------------------------------------------------------
-- should show sarah-ronak family account details
CALL view_accounts_details_for_user(1);
CALL view_accounts_details_for_user(2);
CALL view_accounts_details_for_family(1);

-- should show witzig family account details
CALL view_accounts_details_for_family(2);

-- should fail for family which doesn't exist
CALL view_accounts_details_for_family(500);
