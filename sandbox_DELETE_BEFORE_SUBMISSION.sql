use jsfinance;
SELECT * FROM users;
SELECT * FROM goals;
SELECT * FROM families;
select * from accounts;
SELECT * FROM transactions;
SELECT * FROM accounts;
SELECT * FROM holdings;
SELECT * FROM investments;

SELECT * FROM goals;
CALL delete_user(1);
--  CALL create_transaction(IN transaction_date_p VARCHAR(50), IN number_shares_p FLOAT, IN symbol_p VARCHAR(10), IN account_id_p INT)
CALL create_transaction("2020-12-12", 1, "F", 1);

CALL update_stock_daily_value()