# Business Insights SQL Project

A PostgreSQL project modeling a simple e-commerce business (customers, products, orders, order line items) and a set of analytical queries for revenue, profit, and customer-value insights.

## 📁 Repository Structure

```
business-insights-sql/
├── database/
│   └── DATABASE.sql        # Database creation
├── schema/
│   └── CREATE_TABLE.sql    # Table definitions (DDL)
├── erd/
│   └── erd.pgerd           # Entity-Relationship Diagram (pgAdmin ERD Tool format)
├── queries/
│   └── QUERIES.sql         # Analytical / reporting queries
└── README.md
```

## 🗄️ Schema Overview

| Table           | Description                                      |
|-----------------|---------------------------------------------------|
| `customers`     | Customer profile: name, email, city, state, signup date |
| `products`      | Product catalog with cost price and selling price |
| `orders`        | One row per order, linked to a customer and region |
| `order_details` | Line items per order (product + quantity)         |

**Relationships**
- `orders.customer_id` → `customers.customer_id`
- `order_details.order_id` → `orders.order_id`
- `order_details.product_id` → `products.product_id`

Open `erd/erd.pgerd` in the [pgAdmin ERD Tool](https://www.pgadmin.org/docs/pgadmin4/latest/erd_tool.html) to view/edit the diagram visually.

## 📊 Analytical Queries

`queries/QUERIES.sql` covers:
- Total revenue, total profit, total orders, total order lines
- Top 5 revenue-generating products
- Revenue by product category
- Monthly revenue trend (`DATE_TRUNC`)
- Product revenue ranking (`RANK()` vs `DENSE_RANK()`)
- Customer Lifetime Value (CLV)
- Repeat vs. one-time customer counts and revenue/profit contribution
- Average Order Value (AOV)
- Top 10% customer contribution — Pareto analysis (`NTILE`)

## 🚀 Setup

```bash
# 1. Create the database
psql -U postgres -f database/DATABASE.sql

# 2. Connect to it and create the schema
psql -U postgres -d BUSINESS_INSIGHTS -f schema/CREATE_TABLE.sql

# 3. (Optional) Load your own sample data, then run the analysis queries
psql -U postgres -d BUSINESS_INSIGHTS -f queries/QUERIES.sql
```

## 🛠️ Tech
- PostgreSQL
- pgAdmin ERD Tool

## 📄 License
MIT
