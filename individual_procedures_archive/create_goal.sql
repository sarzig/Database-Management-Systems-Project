-- To create a goal, a goal name, amount, and user_id are needed.
-- Errors occur if a goal by that name already exists for the given user, or
-- if the given user does not exist.
-- Goal amounts can be positive, 0, or negative

DELIMITER $$
CREATE PROCEDURE create_goal(
	IN goal_name_p VARCHAR(1000),
    IN goal_amount_p INT,
    IN user_id_p INT
)
BEGIN
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

-- testing ---------------------------------------------------------------------------------------------------------
-- should fail because goal already exists with user 2 (but with different amount)
CALL create_goal("DEBT FREE", 300000, 2);

-- should pass first time
CALL create_goal("sarah max out hsa", 300000, 1);
-- should fail second time^

-- should fail because user with that ID doesn't exist
CALL create_goal("dumb goal", 0, 4000);
