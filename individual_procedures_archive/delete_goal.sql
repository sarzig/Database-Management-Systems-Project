-- To delete a goal, a goal name and user_id are needed.
-- Errors occur if a goal by that name doesn't exist for the given user, or
-- if the given user does not exist.

DELIMITER $$
CREATE PROCEDURE delete_goal(
	IN goal_name_p VARCHAR(1000),
    IN user_id_p INT
)
BEGIN
	DECLARE goal_name_does_not_exist BOOLEAN;
    DECLARE user_does_not_exist BOOLEAN;
    
	-- Error Handling -------------------------------------------------------------------------------------------   
    -- Check if user exists
	SELECT COUNT(*) != 1 INTO user_does_not_exist FROM users WHERE user_id = user_id_p;
    IF user_does_not_exist THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "User ID does not exist, cannot delete goal.";
    END IF;
    
	-- Check if the goal name exists for that user
	SELECT COUNT(*) = 0 INTO goal_name_does_not_exist FROM goals WHERE goal_name = goal_name_p AND user_id = user_id_p;
    
    IF goal_name_does_not_exist THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "Goal doesn't exist for this user, cannot delete goals.";
    END IF;
    
    -- Execute deletion -------------------------------------------------------------------------------------------   
	DELETE FROM goals WHERE goal_name = goal_name_p AND user_id = user_id_p;
    
    -- Success code
	SELECT 'Success' AS result;
END $$
DELIMITER ;

-- testing ---------------------------------------------------------------------------------------------------------
SELECT * FROM jsfinance.goals;
-- should pass first time
CALL delete_goal("DEBT FREE", 2);
-- should fail second time (goal already deleted)

-- should pass first time
CALL delete_goal("sarah max out hsa", 1);
-- should fail second time^

-- should fail because user with that ID doesn't exist
CALL delete_goal("dumb goal6", 4000);
