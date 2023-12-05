-- To delete a family, a family_id is needed. If that family_id does not exist, then 
-- an error is raised.

DELIMITER $$
CREATE PROCEDURE delete_family(
    IN family_id_p INT
)
BEGIN
    DECLARE family_does_not_exist BOOLEAN;
    
	-- Error Handling -------------------------------------------------------------------------------------------   
    -- Check if family exists
	SELECT COUNT(*) != 1 INTO family_does_not_exist FROM families WHERE family_id = family_id_p;
    IF family_does_not_exist THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "Family ID does not exist, cannot delete family.";
    END IF;
    
    -- Execute deletion -------------------------------------------------------------------------------------------   
	DELETE FROM families WHERE family_id = family_id_p;
    
    -- Success code
	SELECT 'Success' AS result;
END $$
DELIMITER ;

-- testing ---------------------------------------------------------------------------------------------------------
SELECT * FROM jsfinance.users;
SELECT * FROM jsfinance.families;

-- should pass first time
CALL delete_family(1);
-- should fail second time (family already deleted)

-- should fail because family with that ID doesn't exist
CALL delete_family(4000);