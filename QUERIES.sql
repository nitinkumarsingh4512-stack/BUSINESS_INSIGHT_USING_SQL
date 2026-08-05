--Total Revenue
SELECT
  SUM(od.quantity * p.selling_price) AS total_revenue
FROM
  order_details od
  JOIN products p ON od.product_id = p.product_id;

SELECT
  COUNT(*) AS total_orders
FROM
  orders;

SELECT
  COUNT(*) AS total_order_lines
FROM
  order_details;

--Total Profit
SELECT
  SUM(od.quantity * (p.selling_price - p.cost_price)) AS total_profit
FROM
  order_details od
  JOIN products p ON od.product_id = p.product_id;

--Top 5 Revenue-Generating Products
SELECT
  p.product_name,
  SUM(od.quantity * p.selling_price) AS revenue
FROM
  order_details od
  JOIN products p ON od.product_id = p.product_id
GROUP BY
  p.product_name
ORDER BY
  revenue DESC
LIMIT
  5;

--Revenue by Category
SELECT
  p.category,
  SUM(od.quantity * p.selling_price) AS revenue
FROM
  order_details od
  JOIN products p ON od.product_id = p.product_id
GROUP BY
  p.category
ORDER BY
  revenue DESC;

--Monthly Revenue Trend
SELECT
  DATE_TRUNC ('month', o.order_date) AS month,
  SUM(od.quantity * p.selling_price) AS revenue
FROM
  orders o
  JOIN order_details od ON o.order_id = od.order_id
  JOIN products p ON od.product_id = p.product_id
GROUP BY
  month
ORDER BY
  month;

--Top 5 Revenue Products
SELECT
  p.product_name,
  SUM(od.quantity * p.selling_price) AS revenue
FROM
  order_details od
  JOIN products p ON od.product_id = p.product_id
GROUP BY
  p.product_name
ORDER BY
  revenue DESC
LIMIT
  5;

--Add Ranking (Window Function)
SELECT
  p.product_name,
  SUM(od.quantity * p.selling_price) AS revenue,
  RANK() OVER (
    ORDER BY
      SUM(od.quantity * p.selling_price) DESC
  ) AS revenue_rank
FROM
  order_details od
  JOIN products p ON od.product_id = p.product_id
GROUP BY
  p.product_name;

-- Customer Lifetime Value (CLV)
SELECT
  c.customer_id,
  c.customer_name,
  SUM(od.quantity * p.selling_price) AS customer_lifetime_value
FROM
  customers c
  JOIN orders o ON c.customer_id = o.customer_id
  JOIN order_details od ON o.order_id = od.order_id
  JOIN products p ON od.product_id = p.product_id
GROUP BY
  c.customer_id,
  c.customer_name
ORDER BY
  customer_lifetime_value DESC;

--Repeat vs One-Time Customers
SELECT
  c.customer_id,
  c.customer_name,
  COUNT(DISTINCT o.order_id) AS total_orders
FROM
  customers c
  JOIN orders o ON c.customer_id = o.customer_id
GROUP BY
  c.customer_id,
  c.customer_name
ORDER BY
  total_orders DESC;

--Revenue Contribution: Repeat vs One-Time Customers
WITH
  customer_orders AS (
    SELECT
      c.customer_id,
      COUNT(DISTINCT o.order_id) AS total_orders
    FROM
      customers c
      JOIN orders o ON c.customer_id = o.customer_id
    GROUP BY
      c.customer_id
  ),
  customer_revenue AS (
    SELECT
      c.customer_id,
      SUM(od.quantity * p.selling_price) AS revenue
    FROM
      customers c
      JOIN orders o ON c.customer_id = o.customer_id
      JOIN order_details od ON o.order_id = od.order_id
      JOIN products p ON od.product_id = p.product_id
    GROUP BY
      c.customer_id
  )
SELECT
  CASE
    WHEN co.total_orders = 1 THEN 'One-Time'
    ELSE 'Repeat'
  END AS customer_type,
  SUM(cr.revenue) AS total_revenue
FROM
  customer_orders co
  JOIN customer_revenue cr ON co.customer_id = cr.customer_id
GROUP BY
  customer_type;

-- Profit Contribution by Customer Type
WITH
  customer_orders AS (
    SELECT
      c.customer_id,
      COUNT(DISTINCT o.order_id) AS total_orders
    FROM
      customers c
      JOIN orders o ON c.customer_id = o.customer_id
    GROUP BY
      c.customer_id
  ),
  customer_profit AS (
    SELECT
      c.customer_id,
      SUM(od.quantity * (p.selling_price - p.cost_price)) AS profit
    FROM
      customers c
      JOIN orders o ON c.customer_id = o.customer_id
      JOIN order_details od ON o.order_id = od.order_id
      JOIN products p ON od.product_id = p.product_id
    GROUP BY
      c.customer_id
  )
SELECT
  CASE
    WHEN co.total_orders = 1 THEN 'One-Time'
    ELSE 'Repeat'
  END AS customer_type,
  SUM(cp.profit) AS total_profit
FROM
  customer_orders co
  JOIN customer_profit cp ON co.customer_id = cp.customer_id
GROUP BY
  customer_type;

--Average Order Value (AOV)
SELECT
  SUM(od.quantity * p.selling_price) / COUNT(DISTINCT o.order_id) AS average_order_value
FROM
  orders o
  JOIN order_details od ON o.order_id = od.order_id
  JOIN products p ON od.product_id = p.product_id;

-- Top 10% Customers Contribution (Pareto Analysis)
WITH
  customer_revenue AS (
    SELECT
      c.customer_id,
      SUM(od.quantity * p.selling_price) AS revenue
    FROM
      customers c
      JOIN orders o ON c.customer_id = o.customer_id
      JOIN order_details od ON o.order_id = od.order_id
      JOIN products p ON od.product_id = p.product_id
    GROUP BY
      c.customer_id
  ),
  ranked_customers AS (
    SELECT
      customer_id,
      revenue,
      NTILE (10) OVER (
        ORDER BY
          revenue DESC
      ) AS decile
    FROM
      customer_revenue
  )
SELECT
  SUM(revenue) AS top_10_percent_revenue
FROM
  ranked_customers
WHERE
  decile = 1;

--RANK vs DENSE_RANK Comparison
SELECT
  p.product_name,
  SUM(od.quantity * p.selling_price) AS revenue,
  RANK() OVER (
    ORDER BY
      SUM(od.quantity * p.selling_price) DESC
  ) AS rank,
  DENSE_RANK() OVER (
    ORDER BY
      SUM(od.quantity * p.selling_price) DESC
  ) AS dense_rank
FROM
  order_details od
  JOIN products p ON od.product_id = p.product_id
GROUP BY
  p.product_name;