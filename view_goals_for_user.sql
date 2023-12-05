-- Given a user id, show goals table
DROP PROCEDURE IF EXISTS view_goals_for_user;
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
        ROUND(SUM(number_shares * daily_value), 2) AS "Current Value",
        goals.goal_amount AS "Goal Amount",
        CASE WHEN
        (ROUND(SUM(number_shares * daily_value), 2) > goals.goal_amount) = 1
        THEN "YES"
        ELSE "NO"
        END
        AS "Is obtained?"

	FROM holdings 
	JOIN investments ON holdings.symbol = investments.symbol 
	RIGHT JOIN accounts ON holdings.account_reference_id = accounts.account_reference_id
    JOIN goals ON accounts.user_id = goals.user_id AND accounts.goal_id = goals.goal_id
	WHERE accounts.user_id = user_id_p
	GROUP BY 
		goals.goal_name,
        goals.goal_amount;
END $$
DELIMITER ;

-- shoudl show sarah's account details
CALL view_goals_for_user(1);

-- should fail for user who doesn't exist
CALL view_goals_for_user(500);
