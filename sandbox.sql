CALL create_investment("META", "facebook company", 42);
select * from investments;
select * from goals;
CALL create_investment("METxA", "WHAT", 8000);

CALL create_goal('my goalie', 100, 1);

CALL create_investment("FB", "FABECOK", 20.62);
CALL update_stock_daily_value("FB", 20000);

DELIMITER $$
CREATE PROCEDURE add_cash_and_debt()
BEGIN
	-- CASH and DEBT are essential to database
    -- This procedure ensures their existence
    
    DECLARE cash_missing BOOLEAN;
	DECLARE debt_missing BOOLEAN;

    -- Check if "CASH" tuple exists in investments table
    SELECT COUNT(*) = 0 INTO cash_missing
    FROM investments
    WHERE daily_value = 1 AND symbol = 'CASH';
    
    -- Check if "DEBT" tuple exists in investments table
    SELECT COUNT(*) = 0 INTO debt_missing
    FROM investments
    WHERE daily_value = -1 AND symbol = 'DEBT';

    -- if cash or debt is missing, then update
    IF cash_missing THEN
        CALL create_stock("CASH", "CASH", 1);
	END IF;
	IF debt_missing THEN
		CALL create_stock("DEBT", "DEBT", 1);
    END IF;
END $$
DELIMITER ;