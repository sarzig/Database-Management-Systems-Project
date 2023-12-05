-- To delete a user, a user_id is needed. If that user_id does not exist, then 
-- an error is raised.

DELIMITER $$
CREATE PROCEDURE delete_user(
    IN user_id_p INT
)
BEGIN
    DECLARE user_does_not_exist BOOLEAN;
    
	-- Error Handling -------------------------------------------------------------------------------------------   
    -- Check if user exists
	SELECT COUNT(*) != 1 INTO user_does_not_exist FROM users WHERE user_id = user_id_p;
    IF user_does_not_exist THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "User ID does not exist, cannot delete user.";
    END IF;
    
    -- Execute deletion -------------------------------------------------------------------------------------------   
	DELETE FROM users WHERE user_id = user_id_p;
    
    -- Success code
	SELECT 'Success' AS result;
END $$
DELIMITER ;

-- testing ---------------------------------------------------------------------------------------------------------
SELECT * FROM jsfinance.users;
SELECT * FROM jsfinance.goals;

-- should pass first time
CALL delete_user(1);
-- should fail second time (goal already deleted)

-- should fail because user with that ID doesn't exist
CALL delete_user(4000);
