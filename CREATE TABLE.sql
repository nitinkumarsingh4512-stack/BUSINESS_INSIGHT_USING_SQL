--Create Customers Table
CREATE TABLE
  customers (
    customer_id SERIAL PRIMARY KEY,
    customer_name VARCHAR(100),
    email VARCHAR(100),
    city VARCHAR(50),
    state VARCHAR(50),
    signup_date DATE
  );

--Create Products Table
CREATE TABLE
  products (
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(100),
    category VARCHAR(50),
    cost_price NUMERIC(10, 2),
    selling_price NUMERIC(10, 2)
  );

--Create Orders Table
CREATE TABLE
  orders (
    order_id SERIAL PRIMARY KEY,
    customer_id INT REFERENCES customers (customer_id),
    order_date DATE,
    region VARCHAR(50)
  );

--Create Order Details Table
CREATE TABLE
  order_details (
    order_detail_id SERIAL PRIMARY KEY,
    order_id INT REFERENCES orders (order_id),
    product_id INT REFERENCES products (product_id),
    quantity INT
  );