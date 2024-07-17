# Sales record analysis for Model Car Business
In this project, we will do a sales analysis on to discover which models are best sellers, which product lines are best to expand, and how much we can spend on a marketting campaign per new customer to and continue to drive a profit.

We aim to answer 3 questions:

    Question 1: Which products should we order more of or less of?
    
    Question 2: How should we tailor marketing and communication strategies to customer behaviors?
    
    Question 3: How much can we spend on acquiring new customers?

## Summary of findings:
A marketing strategy for new customers to be found is necessary. No new customers have been gained for 8 months, and the rate of new customers has been declining since July 2003 (May 2005 at most recent entry, Jan 2003 is the first entry)

Each customer provides 39039.59 profit on average, indicating that we must spend less than that per new customer. 

Classic Cars are our best-selling models, with vintage cars and motorcycles also popular. Historically significant vehicles are also very popular. Target these product lines for promotional material.

### For more information on the results please see the full analysis below.

### Information about data and resources:

View the full SQL queries at the queries.sql file in this repo.

JupyterLabs and SQLite database browser were used. https://sqlitebrowser.org/dl/

stores.db provided by DataQuest at this link : https://dq-content.s3.amazonaws.com/600/stores.db

DB schema here : <br>

![](db.png)

## Exploring the Database

Generate a view of the table sizes. <br>
Use Query (1) to generate db_table_info, resulting in the following:

table_name | num_attributes | num_Rows
---|---|---
productlines | 4 | 7
orders | 7 | 32
orderdetails | 5 | 2996
payments | 4 | 273
employees | 8 | 23
offices | 9 | 7

### Truncated Query (1): <br>
```
CREATE VIEW db_table_info AS
SELECT 'customers' table_name, 
       count(*) num_attributes,(
       SELECT count(*)
         FROM customers ) num_rows 
  FROM pragma_table_info('customers')
 UNION ALL
SELECT 'products' table_name, 
       count(*) num_attributes,(
       SELECT count(*)
         FROM products ) num_rows 
  FROM pragma_table_info('products')
 UNION ALL
   ...;
```
---

## High priority products for restock via total sold / current stock
Calculate 10 items with low stock compared to units ordered, and order by best product performance, indicating a priority for restock.

Classic cars sell the best, along with historically significant vehicles.

productName|productLine|productCode|low_stock|product_performance
---|---|---|---|---
1968 Ford Mustang|Classic Cars|S12_1099|13.72|161531.48
1928 Mercedes-Benz SSK|Vintage Cars|S18_2795|1.61|132275.98
1997 BMW F650 ST|Motorcycles|S32_1374|5.7|89364.89
F/A 18 Hornet 1/72|Planes|S700_3167|1.9|76618.4
2002 Yamaha YZR M1|Motorcycles|S50_4713|1.65|73670.64
The Mayflower|Ships|S700_1938|1.22|69531.61
1960 BSA Gold Star DBD34|Motorcycles|S24_2000|67.67|67193.49
1928 Ford Phaeton Deluxe|Vintage Cars|S32_4289|7.15|60493.33
Pont Yacht|Ships|S72_3212|2.31|47550.4
1911 Ford Town Car|Vintage Cars|S18_2248|1.54|45306.77

### Query (2) <br>
```
WITH low_stock_table AS (
SELECT productCode, 
       ROUND(SUM(quantityOrdered) * 1.0/(SELECT quantityInStock
                                           FROM products p
                                          WHERE od.productCode = p.productCode), 2) AS low_stock
  FROM orderdetails od
 GROUP BY productCode
 ORDER BY low_stock DESC
 LIMIT 10
)

SELECT productCode,
       (SELECT productName, productLine
          FROM products deets
         WHERE deets.productCode = od.productCode),
       SUM(quantityOrdered * priceEach) AS prod_perf
  FROM orderdetails od
 WHERE productCode IN (SELECT productCode
                         FROM low_stock_table)
 GROUP BY productCode 
 ORDER BY prod_perf DESC
 LIMIT 10;
 ```

 ---

## Determination of customer characteristrics
To tailor events and sales to maintain VIP customers and draw less engaged customers to become VIP customers we must identify their traits.

Calculate profit coming from each customer.

<br>
TOP 5 VIP customers:

contactLastName|contactFirstName|city|country|profit
---|---|---|---|---
Freyre|Diego|Madrid|Spain|326519.66
Nelson|Susan|San Rafael|USA|236769.35
Young|Jeff|NYC|USA|72370.09
Ferguson|Peter|Melbourne|Australia|70311.07
Labrune|Janine|Nantes|France|60875.3

<br>
5 Least engaged customer:

contactLastName|contactFirstName|city|country|profit
---|---|---|---|---
Young|Mary|Glendale|USA|2610.87
Taylor|Leslie|Brickhaven|USA|6586.02
Ricotti|Franco|Milan|Italy|9532.93
Schmitt|Carine|Nantes|France|10063.8
Smith|Thomas|London|UK|10868.04

### Query (3) <br>
```
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
```

---

## Determination of new customers per month
Generate 3 tables

    1. A table of payment information with date as year-month. 
    2. Use this table1 to generate a table of number of customers and total sales amount per month.
    3. Use both above tables to generate a table of new customers per month chronologically, using Where Not In filitering. Only include customers per month who were not customers previously. Select the total amounts from these customers to date.


### Query (4) 
Too long for this format, reference [queries.sql](queries.sql)

It uses 3 views. 

1. Cast the date values of the paytment table into year-month format (yyyymm), but does not group them.
2. Counts total sales and total customer from the first view, grouped by year-month.
3. Use the previous 2 views to generate 5 columns : year-month, number of new customers this month, revenue due to new customers this month, total number of customers this month, and total revenue this month
4. Reduces these hard numbers into the precentage values below

Year Month|% of customers that are new this month|% of sales dollars by new customers this month
---|---|---
200301|100.0|100.0
200302|100.0|100.0
200303|100.0|100.0
200304|100.0|100.0
200305|100.0|100.0
200306|100.0|100.0
200307|75.0|68.3
200308|66.0|54.2
200309|80.0|95.9
200310|69.0|69.3
200311|57.0|53.9
200312|60.0|54.9
200401|33.0|41.1
200402|33.0|26.5
200403|54.0|55.0
200404|40.0|40.3
200405|12.0|17.3
200406|33.0|43.9
200407|10.0|6.5
200408|18.0|26.2
200409|40.0|56.4


## Lacking new customers

The three most recent orders are from May 2005 (Query5)

The new customer per month table ends in September 2004, indicating that there has been no new customers for 8 months. 

A marketing plan to generate new customers is necesssary.

---

### Query (5) <br>

```
SELECT orderDate
  FROM orders
 ORDER BY orderDate DESC
 LIMIT 3;
```
 

## Profit per customer, maximum expendature per new customer

Profit per customer is 39039.59 on average. If we are spending more than this per customer gained it is detrimental to the business.

---

### Query (6) <br>

```
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
```


