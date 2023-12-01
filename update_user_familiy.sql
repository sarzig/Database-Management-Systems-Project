-- To update a user's family, the user_id and family_id must already exist.
-- If the family_id_p is the same as the existing family_id, an error occurs.

DELIMITER $$
CREATE PROCEDURE update_user_family(
    IN user_id_p INT,
    IN family_id_p INT
)
BEGIN
    DECLARE user_does_not_exist BOOLEAN;
    DECLARE original_family_id_is_null BOOLEAN;
    DECLARE family_id_already_the_same BOOLEAN;
    DECLARE family_does_not_exist BOOLEAN;
    
	-- Error Handling -------------------------------------------------------------------------------------------   
    -- Check if user exists
	SELECT COUNT(*) != 1 INTO user_does_not_exist FROM users WHERE user_id = user_id_p;
    IF user_does_not_exist THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "User ID does not exist, cannot update family.";
    END IF;
    
	-- Check if family doesn't exist for non-null family_id_p
	SELECT COUNT(*) = 0 INTO family_does_not_exist FROM families WHERE family_id = family_id_p;
    IF family_does_not_exist and family_id_p IS NOT NULL THEN
    		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "Family ID does not exist, cannot update family.";
    END IF;
    
    -- Check if family was already equal to NULL when trying to make family null
	SELECT COUNT(*) = 1 INTO original_family_id_is_null FROM users WHERE user_id = user_id_p AND family_id IS NULL;
	IF original_family_id_is_null AND family_id_p IS NULL THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "User family was already NULL, no change needed.";
    END IF;
    
    -- Check if family was already equal to that value (does NOT work for NULL family)
	SELECT COUNT(*) = 1 INTO family_id_already_the_same FROM users WHERE user_id = user_id_p AND family_id = family_id_p;
	IF family_id_already_the_same THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "User family was already the same value, no change needed.";
    END IF;
    
    -- Execute update -------------------------------------------------------------------------------------------   
	UPDATE users set family_id = family_id_p where user_id = user_id_p;
    
    -- Success code
	SELECT 'Success' AS result;
END $$
DELIMITER ;

-- testing ---------------------------------------------------------------------------------------------------------
SELECT * FROM families;
SELECT * FROM users;
-- should update sarah's family to 4
CALL update_user_family(1, 4);
-- should fail on second attempt

-- should try to update matthew's family to null and fail
CALL update_user_family(5, NULL);

-- should update sarah's family to null
CALL update_user_family(1, NULL);

-- should fail because family_id doesn't exist
CALL update_user_family(1, 5000);

-- should fail because user_id doesn't exist
CALL update_user_family(5000, NULL);
