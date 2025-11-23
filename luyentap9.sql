CREATE TABLE luyentap9.orders (
                        order_id SERIAL PRIMARY KEY,
                        customer_id INT,
                        product_id INT,
                        quantity INT NOT NULL,
                        total_amount NUMERIC(12,2),
                        order_date TIMESTAMP DEFAULT NOW()
);

BEGIN;
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

SELECT COUNT(*) FROM luyentap9.orders WHERE quantity > 5;
-- Kết quả: 0

BEGIN;

INSERT INTO luyentap9.orders(customer_id, product_id, quantity, total_amount)
VALUES (1, 1, 10, 500);

COMMIT;

SELECT COUNT(*) FROM luyentap9.orders WHERE quantity > 5;
-- Kết quả: 1



BEGIN;
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;

SELECT COUNT(*) FROM luyentap9.orders WHERE quantity > 0;
-- Kết quả: 1

BEGIN;

INSERT INTO luyentap9.orders(customer_id, product_id, quantity, total_amount)
VALUES (1, 1, 10, 700);

COMMIT;

SELECT COUNT(*) FROM luyentap9.orders WHERE quantity > 0;
-- Kết quả: vẫn là 1

