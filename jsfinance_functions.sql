/*
Filename: js_finance_functions.sql
Purpose:  This file contains all the functions used in our database. There is only one function which
          serves a create function, and all other functions are "gets" which involve sets of parameters 
          which can uniquely identify only one tuple in the database.
          
Contains: create_family
		  get_account_id_from_user_id_and_account_nickname
          get_user_id(email_p VARCHAR(1000))
          get_user_family(user_id_p INT)
          get_user_first_name(user_id_p INT)
*/

/* 
+----------------------------------------------------------------------------------------------------+
|                                    Section 1: "Create" functions                                   |
+----------------------------------------------------------------------------------------------------+

Most "create" procedures in our database simply return a success code. The family table is unique
in that its only unique identifier is the primary key which auto-increments upon a family's creation.

Therefore after creating a family, it is essential to know the family_id.
*/

USE jsfinance;

DELIMITER $$
CREATE FUNCTION create_family(
	family_name_p VARCHAR(100)
    ) RETURNS INT
    DETERMINISTIC CONTAINS SQL
BEGIN
	-- Creates a family, and returns the family_id if successful. 

	-- Error Handling
    -- if family name is already taken
	IF EXISTS(SELECT * FROM families WHERE family_name = family_name_p) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'That family name is already taken.';
	-- if family name longer than allowed
    ELSEIF LENGTH(family_name_p) > 100 THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Family name exceeds 50 characters.';
    -- if family name is null
    ELSEIF family_name_p IS NULL OR family_name_p = '' THEN 
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Family name must be provided.';
	END IF;
    
    -- create the family
    INSERT INTO FAMILIES(family_name) VALUES (family_name_p);
    
    -- return the ID of the newly created family
    RETURN LAST_INSERT_ID();
END $$
DELIMITER ;

/* 
+----------------------------------------------------------------------------------------------------+
|                                      Section 2: "Get" Functions                                    |
+----------------------------------------------------------------------------------------------------+

This section is our "get" functions - given some unique set of data, these functions return the 
desired output. 
*/

DELIMITER $$
CREATE FUNCTION get_account_id_from_user_id_and_account_nickname(user_id_p INT, account_nickname_p VARCHAR(100))
RETURNS INT
DETERMINISTIC CONTAINS SQL
BEGIN
	-- given a user id and account nickname, this returns the account id
    DECLARE user_does_not_exist INT;
	DECLARE account_id_result INT;

    
	-- Check if user exists
	SELECT COUNT(*) != 1 INTO user_does_not_exist FROM users WHERE user_id = user_id_p;
    IF user_does_not_exist THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "User ID does not exist.";
    END IF;
    
	-- Find the account id
    SELECT account_id INTO account_id_result FROM accounts where account_nickname = account_nickname_p AND user_id = user_id_p;
    
	-- Make sure account exists  
    IF account_id_result IS NULL THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "Account does not exist.";
    END IF;
    
    -- Finally, return the account_id
    RETURN account_id_result;
END $$
DELIMITER ;

DELIMITER $$
CREATE FUNCTION get_user_id(email_p VARCHAR(1000)) RETURNS INT
DETERMINISTIC CONTAINS SQL
BEGIN
	-- given an email, return a user_id
	DECLARE result INT;
        
	SELECT user_id INTO result
	FROM users 
	WHERE email = email_p;
        
	-- user does not exist -> error message
	IF result IS NULL THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "User ID does not exist, cannot get user.";
	END IF;
        
	RETURN result;
	
END$$
DELIMITER ;

DELIMITER $$
CREATE FUNCTION get_user_family(user_id_p INT) RETURNS INT
DETERMINISTIC CONTAINS SQL
BEGIN
	-- given a user_id, return a family_id
	DECLARE result INT;
        
	SELECT family_id INTO result
	FROM users 
	WHERE user_id = user_id_p;
        
	-- user does not have family -> return -1
	IF result IS NULL THEN
		SELECT -1 INTO result;
	END IF;
        
	RETURN result;
	
END$$
DELIMITER ;

DELIMITER $$
CREATE FUNCTION get_user_first_name(user_id_p INT) RETURNS VARCHAR(100)
DETERMINISTIC CONTAINS SQL
BEGIN
	-- given a user_id, return a first name
	DECLARE result VARCHAR(100);
        
	SELECT first_name INTO result
	FROM users 
	WHERE user_id = user_id_p;
        
	-- user does not have first_name -> return -1
	IF result IS NULL THEN
		SELECT "" INTO result;
	END IF;
        
	RETURN result;
	
END $$
DELIMITER ;