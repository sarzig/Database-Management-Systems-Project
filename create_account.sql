-- To create an account, institution details are needed (id at institution, institution name).
-- The account must be given a nickname UNIQUE to that user.
-- The account type must be specified, and must be equal to one of the account_type enums.
-- If a goal should be linked to the account, the goal_name must already be associated with 
-- that user.

DELIMITER $$
CREATE PROCEDURE create_account(
    IN id_at_institution_p VARCHAR(50),
    IN institution_name_p VARCHAR(200),
    IN account_nickname_p VARCHAR(50),
    IN account_type_p VARCHAR(50),
    IN user_id_p INT,
    IN goal_name_p VARCHAR(50)
)
BEGIN
    DECLARE id_and_instution_combo_already_exists BOOLEAN;
	DECLARE goal_does_not_exist BOOLEAN;
    DECLARE goal_id_p INT;

	-- Error Handling -------------------------------------------------------------------------------------------
	-- Check if length of any values are too long
	IF LENGTH(id_at_institution_p) > 50 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'id_at_institution length cannot be more than 50 characters.';
    END IF;
	IF LENGTH(institution_name_p) > 200 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'institution_name length cannot be more than 50 characters.';
    END IF;
	IF LENGTH(account_nickname_p) > 50 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'account_nickname length cannot be more than 50 characters.';
    END IF;
    
	-- Check if account_type_p is one of the specified enums
    IF NOT account_type_p IN ('loan', 'checkings', 'savings', '401(k)', 'roth IRA', 'traditional IRA', '529', 'taxable brokerage', 'cryptocurrency') THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid account_type.';
    END IF;

    -- Check if the account with the same id_at_institution and institution_name already exists
	SELECT COUNT(*) > 0 INTO id_and_instution_combo_already_exists
	FROM accounts
	WHERE id_at_institution = id_at_institution_p
	AND institution_name = institution_name_p;
    
	IF id_and_instution_combo_already_exists THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "Combination of ID at institution and institution name already exists.";
    END IF;
    
    -- Check that a goal by that name exists with the current user
    SELECT COUNT(*) = 0 INTO goal_does_not_exist
    FROM goals
    WHERE goal_name = goal_name_p AND user_id = user_id_p;
    
    -- if goal name is NULL, then goal_id is NULL and there's no error
    IF goal_name_p IS NULL THEN
		SELECT NULL into goal_id_p;
	-- If goal doesn't exist then raise error
	ELSEIF goal_does_not_exist THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "Goal by that name does not exist for this user.";
	-- If goal DOES exist by that name, then find the goal_id_p
	ELSE
		SELECT goal_id INTO goal_id_p
        FROM goals 
        WHERE goal_name = goal_name_p;
    END IF;

	INSERT INTO accounts (id_at_institution, institution_name, account_nickname, account_type, user_id, goal_id) 
    VALUES (id_at_institution_p, institution_name_p, account_nickname_p, account_type_p, user_id_p, goal_id_p);
    
    -- Success code
	SELECT 'Success' AS result;
END $$
DELIMITER ;

-- if this is the first call, it should work
CALL create_account("mera id", "Chase Bank", "My Chase checking", "checkings", 1, NULL);
-- if this is the second call, it should fail
CALL create_account
