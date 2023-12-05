-- CREATE USERS
USE jsfinance;
INSERT INTO users (email, first_name, last_name) VALUES
("sarah@gmail.com", "Sarah", "Witzig"),
("ronak@gmail.com", "Ronak", "Padukone"),
("joanne@yahoo.com", "Joanne", "Witzig"),
("phrog_pilot@msn.com", "Bill", "Witzig"),
("matthew@gmail.com", "Matthew", "Witzig"),
("nancylane@aol.com", "Nancy", "Lane"),
("rlane@aol.com", "Ray", "Lane"),
("Vijayananda@gmail.com", "Vijay", "Padukone"),
("Anita@gmail.com", "Anita", "Padukone");

INSERT INTO families (family_name) VALUES
("Witzig Padukone Household"),
("The Witzigs"),
("Lane family"),
("The Padukones");

INSERT INTO accounts (id_at_institution, institution_name, account_nickname, account_type, user_id) VALUES
("20505157", "TD Bank", "My brokerage", "Taxable Brokerage", 1),
("66074247", "Vanguard", "Vanguard 401k", "401(k)", 1),
("72395085", "Vanguard", "Vanguard Roth", "roth IRA", 1),
("31150065", "Vanguard", "Vanguard Trad. IRA", "traditional IRA", 1),
("98178077-01", "Robinhood", "CRYPTO", "cryptocurrency", 1),
("66839606", "Vanguard", "Vanguard 529", "529", 1),
("59346393", "Nelnet", "First Loan", "loan", 1),
("17974534", "Nelnet", "Second Loan", "loan", 1),
("29476087", "Bank of America", "Ronak's Checking", "checkings", 2),
("82441179", "Ally", "Ronak's Saving", "savings", 2),
("54319892", "Nelnet", "Nelnet Loan", "loan", 2),
("08303869", "Northeastern", "Northeastern Loan", "loan", 2),
("35425018", "SLM Corporation", "Sallie Mae", "loan", 2),
("17261416", "FMC Corporation", "Freddie Mac", "loan", 2),
("40639267", "Chase", "Ronak's 401(k)", "401(k)", 2);

INSERT INTO goals (goal_name, goal_amount, user_id) VALUES
("Pay off my loans", 0, 1),
("DEBT FREE", 0, 2),
("House paid off", 0, 4),
("Reach $100k", 100000, 1);

SELECT * FROM users;
SELECT * FROM accounts;
