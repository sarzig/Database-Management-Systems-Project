-- To update a goal's name, an old and new goal name and a user_id are needed.
-- Errors occur if a goal by the old name doesn't exist for the given user, or
-- if the given user does not exist, or if a goal by the new name already
-- exists for the given user.

DELIMITER $$
CREATE PROCEDURE update_goal_name(
	IN old_goal_name_p VARCHAR(1000),
    IN new_goal_name_p VARCHAR(1000),
    IN user_id_p INT
)
BEGIN
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

-- testing ---------------------------------------------------------------------------------------------------------
SELECT * FROM jsfinance.goals;
CALL update_goal_name("Reach $100k", "Pay off my loans", 1); -- should fail because the new name is already taken
CALL update_goal_name("Pay off my loans", "AHHH", 1); -- should successfully update
CALL update_goal_name("DEBT FREE", "new name", 4); -- should fail because user doesn't have goal by that name
CALL update_goal_name("DEBT FREE", "new name", 40); -- should fail because user doesn't exist

