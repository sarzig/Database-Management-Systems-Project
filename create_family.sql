-- procedure for creating family

DELIMITER $$
CREATE PROCEDURE create_family(
	IN family_name_p VARCHAR(100)
    )
BEGIN
	-- error handling
    -- if family name is already taken
	IF EXISTS(SELECT * FROM families WHERE family_name = family_name_p) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'That family name is already taken.';
	-- if family name longer than allowed
    ELSEIF LENGTH(family_name_p) > 100 THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Family name exceeds 50 characters.';
    -- if family name is null
    ELSEIF family_name_p IS NULL THEN 
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Family name must be provided.';
	END IF;
    
    -- create the family
    INSERT INTO FAMILIES(family_name) VALUES (family_name_p);
    
END $$
DELIMITER ;
