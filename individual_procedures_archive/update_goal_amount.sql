-- To update a goal's name, an old and new goal name and a user_id are needed.
-- Errors occur if a goal by the old name doesn't exist for the given user, or
-- if the given user does not exist, or if a goal by the new name already
-- exists for the given user.

DELIMITER $$
CREATE PROCEDURE update_goal_amount(
	IN goal_name_p VARCHAR(1000),
    IN user_id_p INT, 
    IN new_goal_amount_p INT
)
BEGIN
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

-- testing ---------------------------------------------------------------------------------------------------------
SELECT * FROM jsfinance.goals;
CALL update_goal_amount("Reach $100k", 1, 100000); -- should fail because the amount is the same
CALL update_goal_amount("Reach $100k", 1, 100001); -- should successfully update
CALL update_goal_amount("DEBT FREE", 4, 4023); -- should fail because user doesn't have goal by that name
CALL update_goal_amount("DEBT FREE", 40, -400); -- should fail because user doesn't exist

