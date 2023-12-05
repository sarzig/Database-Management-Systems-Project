CALL create_investment("META", "facebook company", 42);
select * from investments;
select * from goals;
CALL create_investment("METxA", "WHAT", 8000);

CALL create_goal('my goalie', 100, 1);

CALL create_investment("FB", "FABECOK", 20.62);
CALL update_stock_daily_value("FB", 20000);

DELIMITER $$
CREATE FUNCTION get_user_id(email_p VARCHAR(1000)) RETURNS INT
DETERMINISTIC CONTAINS SQL
BEGIN
	DECLARE result INT;
        
	SELECT user_id INTO result
	FROM users 
	WHERE email = email_p;
        
	IF result IS NULL THEN
		SET result = -1;
	END IF;
        
	RETURN result;
	
END $$
DELIMITER ;