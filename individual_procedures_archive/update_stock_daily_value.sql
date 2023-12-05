-- procedure for updating an investment's daily value

DELIMITER $$
CREATE PROCEDURE update_stock_daily_value(
	IN symbol_p VARCHAR(10), 
    IN new_daily_value_p DECIMAL(13,2)
)
BEGIN
	-- error handling
    -- if symbol is null
    IF symbol_p IS NULL THEN 
	    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Symbol cannot be null.';
    
    -- if symbol does not exist
	ELSEIF NOT EXISTS(SELECT * FROM investments WHERE symbol = symbol_p) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'That symbol cannot be found';

    -- if erroneously attempting to update CASH or DEBT investments
    ELSEIF symbol_p = "CASH" OR symbol_p = "DEBT" THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "This investment's value cannot be modified";

    -- if new_daily_value_p is negative
    ELSEIF new_daily_value_p < 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'New value cannot be negative.';

    END IF;
    
    -- update the stock's daily value
    UPDATE investments SET daily_value = new_daily_value_p WHERE symbol = symbol_p;

END $$
DELIMITER ;