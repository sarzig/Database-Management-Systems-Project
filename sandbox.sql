CALL create_investment("META", "facebook company", 42);
select * from investments;
select * from goals;
CALL create_investment("METxA", "WHAT", 8000);

CALL create_goal('my goalie', 100, 1);

CALL create_investment("FB", "FABECOK", 20.62);
CALL update_stock_daily_value("FB", 20000);

SELECT * FROM users;
SELECT * FROM families;

CALL view_accounts_details_for_user(1);

