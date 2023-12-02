-- TODO - this needs to add or subtract from holdings. Logic:
-- if account already has holding named symbol, then update holdings = holdings + number_shares * daily value
-- if account does not have holding named symbol, then:
-- INSERT into holdings(number_shares, symbol, account_reference_id) VALUES
-- (number_shares_p, symbol_p, account_reference_id_p)

-- procedure for creating transaction

DELIMITER $$
CREATE PROCEDURE create_transaction(
	IN transaction_date_p VARCHAR(50),
    IN number_shares_p FLOAT,
    IN symbol_p VARCHAR(10),
    IN account_reference_id_p INT
    )
BEGIN
    DECLARE transaction_date_var DATE;
    DECLARE daily_value_var DECIMAL(13, 2);

	-- error handling
    -- if date isn't in correct format
    IF STR_TO_DATE(transaction_date_p, '%Y-%m-%d') IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Incorrect date format: please use YYYY-MM-DD.';

    -- if number_shares is negative or 0
    ELSEIF number_shares_p <= 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Number of shares must be positive.';

    -- if transaction date or number of shares are null
    ELSEIF transaction_date_p IS NULL OR number_shares_p IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Date and number of shares must not be null.';

    -- if symbol doesn't exist
    ELSEIF NOT EXISTS (SELECT * FROM investments WHERE symbol = symbol_p) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Symbol is not found.';

    -- if account reference ID doesn't exist
    ELSEIF NOT EXISTS (SELECT * FROM accounts WHERE account_reference_id = account_reference_id_p) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Account reference ID is not found.';
    END IF;

    -- since date has passed validation, convert the transaction date to a date format
    SELECT STR_TO_DATE(transaction_date_p, '%Y-%m-%d') INTO transaction_date_var;

    -- extract the daily value from the investments table, and assign it to a variable
    SELECT daily_value FROM investments where symbol = symbol_p INTO daily_value_var;

    -- create the transaction
    INSERT INTO transactions(transaction_date, number_shares, symbol, account_reference_id, value_transacted_at)
    VALUES (transaction_date_var, number_shares_p, symbol_p, account_reference_id_p, daily_value_var);
END $$

DELIMITER ;
