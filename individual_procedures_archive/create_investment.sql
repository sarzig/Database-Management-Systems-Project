-- procedure for creating investment

DELIMITER $$
CREATE PROCEDURE create_investment(
	IN symbol_p VARCHAR(10),
    IN company_name_p VARCHAR(200),
    IN daily_value_p DECIMAL(13,2)
    )
BEGIN
	-- error handling
    -- if symbol or company name is null
    IF symbol_p IS NULL OR company_name_p IS NULL OR daily_value_p THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Date and number of shares must not be null.';

    -- if CASH is set to a value other than 1
    ELSEIF symbol_p = "CASH" and daily_value_p != 1 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'CASH must be created with value 1.';

    -- if DEBT is set to a value other than -1
    ELSEIF symbol_p = "DEBT" and daily_value_p != -1 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'DEBT must be created with value -1.';
    
    -- if non-debt investment is negative
    ELSEIF symbol_p != "DEBT" and daily_value_p < 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'This investment cannot be negative.';
    
    END IF;

    -- create the investment
    INSERT INTO investments(symbol, company_name, daily_value) 
    VALUES (symbol_p, company_name_p, daily_value_p);
END $$

DELIMITER ;