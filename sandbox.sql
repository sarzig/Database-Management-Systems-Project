CALL create_investment("META", "facebook company", 42);
select * from investments;
select * from goals;
CALL create_investment("METxA", "WHAT", 8000);

CALL create_goal('my goalie', 100, 1);

CALL create_investment("FB", "FABECOK", 20.62);
CALL update_stock_daily_value("FB", 20000);
use jsfinance;
SELECT * FROM users;
SELECT * FROM families;
select * from accounts;
select * from transactions where account_id = 1;
select * from holdings where account_id = 1;
CALL view_accounts_details_for_user(1);

CALL take_loan_by_account_name("2023-12-02", "Ronak's Checking", 2, 5000000);
CALL deposit_money_by_account_name("2023-12-02", "Ronak's Checking", 2, 1);

CALL buy_investment_shares_by_share("2023-12-02", 1, 10, "F");
CALL buy_investment_shares_by_dollar("2023-12-02", 1, .01, "F");
CALL sell_investment_shares_by_share("2023-12-02", 1, 9, "F");
CALL sell_investment_shares_by_dollar("2023-12-02", 1, 20, "F");
CALL deposit_money_by_account_name("2023-12-02", "my brokerage", 1, 1);

CALL deposit_money("2023-12-02", 1, 1);
CALL take_loan("2023-12-02", 1, 1);