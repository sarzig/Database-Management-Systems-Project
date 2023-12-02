-- Given a family id, show account details grouped into Assets, Debt, and calculate Net Worth
DROP PROCEDURE IF EXISTS view_accounts_details_for_family_by_type;
DELIMITER $$
CREATE PROCEDURE view_accounts_details_for_family_by_type(IN family_id_p INT)
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
    ROUND(SUM(CASE WHEN accounts.account_type != 'loan' THEN number_shares * daily_value 
             ELSE 0 
        END), 2) AS "Total Assets",
    ROUND(SUM(CASE WHEN accounts.account_type = 'loan' THEN number_shares * daily_value 
             ELSE 0 
        END), 2) AS "Total Debts",
    ROUND(SUM(CASE WHEN accounts.account_type = 'loan' THEN -1 * (number_shares * daily_value) 
             ELSE number_shares * daily_value 
        END), 2) AS "Net Worth"
    FROM holdings 
    JOIN investments ON holdings.symbol = investments.symbol 
    JOIN accounts ON holdings.account_reference_id = accounts.account_reference_id
    JOIN users ON users.user_id = accounts.user_id
    WHERE users.family_id = family_id_p;
END $$
DELIMITER ;

-- tests ------------------------------------------------------------------------------------------------
-- should show sarah-ronak family account details
CALL view_accounts_details_for_family(1);
CALL view_accounts_details_for_family_by_type(1);

-- should show witzig family account details
CALL view_accounts_details_for_family(2);
CALL view_accounts_details_for_family_by_type(2);


-- should fail for family which doesn't exist
CALL view_accounts_details_for_family(500);
CALL view_accounts_details_for_family_by_type(500);
