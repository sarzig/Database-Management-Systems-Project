-- procedure for creating user
DELIMITER $$
CREATE PROCEDURE create_user(
	IN email_p VARCHAR(200), 
    IN first_name_p VARCHAR(100),
    IN last_name_p VARCHAR(100),
    IN family_id_p INT)
BEGIN
	-- error handling
    -- if email is already taken
	IF EXISTS(SELECT * FROM users WHERE email = email_p) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'That email is already taken.';
	-- if first name or email parameters are null
    ELSEIF first_name_p IS NULL OR email_p IS NULL THEN 
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'First name and email must be provided.';
	-- if family id parameter doesn't exist
    ELSEIF NOT EXISTS(SELECT * FROM families WHERE family_id = family_id_p) THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Family ID is not found.';
	END IF;
    
    -- create the user
    INSERT INTO USERS(email, first_name, last_name, family_id) VALUES (email_p, first_name_p, last_name_p, family_id_p);
END $$
DELIMITER ;