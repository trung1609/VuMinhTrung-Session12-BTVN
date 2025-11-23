CREATE TABLE luyentap8.accounts (
                          account_id SERIAL PRIMARY KEY,
                          account_name VARCHAR(50),
                          balance NUMERIC(12,2)
);

INSERT INTO luyentap8.accounts(account_name, balance)
VALUES ('A', 1000);

BEGIN;
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

SELECT balance FROM luyentap8.accounts WHERE account_id = 1;
-- Kết quả: 1000
BEGIN;

UPDATE luyentap8.accounts
SET balance = 3000
WHERE account_id = 1;

COMMIT;

SELECT balance FROM luyentap8.accounts WHERE account_id = 1;
-- Kết quả: 2000   (THAY ĐỔI)

