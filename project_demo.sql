-- Workbench proof of operation success

-- Show view ALL investments
SELECT * FROM investments;

-- Show user's transactions
SELECT transactions.* FROM transactions JOIN accounts WHERE account_nickname = "my brokerage" and user_id = 1;

-- Show holdings by account
CALL view_my_holdings_by_account(1, "my brokerage");