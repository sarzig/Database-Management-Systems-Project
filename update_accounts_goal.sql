DROP PROCEDURE IF EXISTS update_accounts_goal;
DELIMITER $$
CREATE PROCEDURE update_accounts_goal(
    IN user_id_p INT,
    IN account_nickname_p VARCHAR(1000),
    IN goal_name_p VARCHAR(1000)
)
BEGIN
    DECLARE user_does_not_exist BOOLEAN;
    DECLARE account_does_not_exist BOOLEAN;
    DECLARE goal_does_not_exist BOOLEAN;
    DECLARE new_goal_id INT;
    
	-- Error Handling -------------------------------------------------------------------------------------------   
    -- Check if user exists
	SELECT COUNT(*) != 1 INTO user_does_not_exist FROM users WHERE user_id = user_id_p;
    IF user_does_not_exist THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "User ID does not exist, cannot update account's goal.";
    END IF;
    
    -- Check if account with that name is associated with that user
	SELECT COUNT(*) = 0 INTO account_does_not_exist FROM accounts WHERE account_nickname = account_nickname_p AND user_id = user_id_p;
    IF account_does_not_exist THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "This account doesn't exist for this user, cannot update.";
    END IF;    
    
    -- Check if goal with that name is associated with that user
	SELECT COUNT(*) = 0 INTO goal_does_not_exist FROM goals WHERE goal_name = goal_name_p AND user_id = user_id_p;
    IF goal_does_not_exist THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "This goal doesn't exist for this user, cannot update.";
    END IF;
    
    -- Execute update -------------------------------------------------------------------------------------------   
    -- find correct goal_id
    SELECT goal_id INTO new_goal_id FROM goals WHERE user_id = user_id_p and goal_name = goal_name_p;
    
	UPDATE accounts SET goal_id = new_goal_id WHERE user_id = user_id_p AND account_nickname = account_nickname_p;
    
END $$
DELIMITER ;

-- Tests --------------------------------------------------------------------------------------------------------
SELECT * FROM accounts;
SELECT * FROM goals;
CALL update_accounts_goal(2, "Ronak's Checking", "DEBT FREE"); -- should add ronak's checking to goal successfully!
CALL update_accounts_goal(2, "My brokerage", "DEBT FREE"); -- should fail bc user 2 doesn't have brokerage by that name
CALL update_accounts_goal(2, "My ACCOUNT", "DEBT FREE"); -- should fail bc user 2 doesn't have brokerage by that name
CALL update_accounts_goal(2, "Ronak's Checking", "yalla"); -- should fail bc user 2 doesn't have goal by that name
