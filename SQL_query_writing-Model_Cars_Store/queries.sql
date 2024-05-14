-------
QUERIES
-------
 
-- (1) Table containing number of rows and columns for each table in the database.
CREATE VIEW db_table_info AS
SELECT 'customers' table_name, count(*) number_of_attributes,(SELECT count(*)FROM customers ) number_of_rows FROM pragma_table_info('customers')
UNION ALL
SELECT 'products' table_name, count(*) number_of_attributes,(SELECT count(*)FROM products ) number_of_rows FROM pragma_table_info('products')
UNION ALL
SELECT 'productlines' table_name, count(*) number_of_attributes,(SELECT count(*)FROM productlines ) number_of_rows FROM pragma_table_info('productlines')
UNION ALL
SELECT 'orders' table_name, count(*) number_of_attributes,(SELECT count(*)FROM orders ) number_of_rows FROM pragma_table_info('orders')
UNION ALL
SELECT 'orderdetails' table_name, count(*) number_of_attributes,(SELECT count(*)FROM orderdetails ) number_of_rows FROM pragma_table_info('orderdetails')
UNION ALL
SELECT 'payments' table_name, count(*) number_of_attributes,(SELECT count(*)FROM payments ) number_of_rows FROM pragma_table_info('payments')
UNION ALL
SELECT 'employees' table_name, count(*) number_of_attributes,(SELECT count(*)FROM employees ) number_of_rows FROM pragma_table_info('employees')
UNION ALL
SELECT 'offices' table_name, count(*) number_of_attributes,(SELECT count(*)FROM offices ) number_of_rows FROM pragma_table_info('offices');

-- (2) Table containing top 10 lowest stock per total ordered items. Ordered by total sales revanue of that SKU
WITH stock AS (
 SELECT p.productName, p.productCode,
        ROUND(total_ordered * 1.0 / quantityInStock, 2) as low_stock
   FROM products p 
   JOIN (SELECT productCode, SUM(quantityOrdered) as total_ordered
           FROM orderdetails
          GROUP BY productCode) as ordered
     ON ordered.productCode = p.productCode
  ORDER BY low_stock DESC
  LIMIT 10
)
SELECT productName, stock.productCode, stock.low_stock,
       ROUND(SUM(quantityOrdered * priceEach), 2) AS product_performance
  FROM orderdetails
  JOIN stock
    ON stock.productCode = orderdetails.productCode
 GROUP BY orderdetails.productCode
 ORDER BY product_performance DESC
 LIMIT 10;

-- (3) Table containing top 5 most profitable customers (Add DESC to ORDER BY for top 5 least engaged customers)
WITH customer_profit AS (
SELECT o.customerNumber, ROUND(SUM(quantityOrdered * (priceEach - buyPrice), 2)) AS profit
  FROM products p
  JOIN orderdetails od
    ON p.productCode = od.productCode
  JOIN orders o
    ON o.orderNumber = od.orderNumber
 GROUP BY o.customerNumber
)
SELECT contactLastName, contactFirstName, city, country, profit
  FROM customers 
  JOIN customer_profit
 ORDER BY profit --DESC
 LIMIT 5;

-- (4) Table of new customers per month, and how much they spend to date. 
-- This view truncates datees to only contain year month
WITH payment_with_year_month_table AS (
SELECT *, 
       CAST(SUBSTR(paymentDate, 1,4) AS INTEGER)*100 + CAST(SUBSTR(paymentDate, 6,7) AS INTEGER) AS year_month
  FROM payments p
),

customers_by_month_table AS (
SELECT p1.year_month, COUNT(*) AS number_of_customers, SUM(p1.amount) AS total
  FROM payment_with_year_month_table p1
 GROUP BY p1.year_month
),
-- This view selects all new customers per month, 
-- and the total amount they purchase in their patronage
new_customers_by_month_table AS (
SELECT p1.year_month, 
       COUNT(*) AS number_of_new_customers,
       SUM(p1.amount) AS new_customer_total,
       (SELECT number_of_customers
          FROM customers_by_month_table c
        WHERE c.year_month = p1.year_month) AS number_of_customers,
       (SELECT total
          FROM customers_by_month_table c
         WHERE c.year_month = p1.year_month) AS total
  FROM payment_with_year_month_table p1
 WHERE p1.customerNumber NOT IN (SELECT customerNumber
                                   FROM payment_with_year_month_table p2
                                  WHERE p2.year_month < p1.year_month)
 GROUP BY p1.year_month
)
-- This view calculates the porportion of new customers per month, 
-- and the porportion of purchases that new customers contribute to total amount 
SELECT year_month, 
       ROUND(number_of_new_customers*100/number_of_customers,1) AS number_of_new_customers_props,
       ROUND(new_customer_total*100/total,1) AS new_customers_total_props
  FROM new_customers_by_month_table;

-- (5) Find the 5 most recent orders
SELECT orderDate
  FROM orders
 ORDER BY orderDate DESC
 LIMIT 5;

-- (6) Find the average amount a new customer spends over their lifetime as a patron
SELECT SUM(profit) / count(customerNumber) AS avg_profit_per_customer
  FROM (SELECT o.customerNumber, 
               SUM(quantityOrdered * (priceEach - buyPrice)) AS profit
          FROM products p
          JOIN orderdetails od
            ON p.productCode = od.productCode
          JOIN orders o
            ON o.orderNumber = od.orderNumber
         GROUP BY o.customerNumber
        )
