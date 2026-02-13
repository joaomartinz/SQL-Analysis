# 📊 Olist E-commerce SQL Analysis 

## 📌 Project Overview

This project analyzes sales performance using the Brazilian Olist e-commerce dataset.

The primary objective was to perform data extraction, transformation, and analytical processing using **SQL**, and then build a professional dashboard in **Power BI** for visualization.

> ⚠️ The core business logic, aggregations, and analytical calculations were developed in SQL.  
> Power BI was used as a visualization layer.

## 🎯 Objectives

- Calculate total revenue
- Analyze monthly revenue trends
- Compute Month-over-Month (MoM) growth
- Identify top-performing product categories
- Analyze revenue distribution by state
- Evaluate order status distribution
- Rank states by revenue performance


## 🛠️ Technologies Used


- **PostgreSQL** – Data extraction and transformation  
- **SQL** – Joins, aggregations, revenue calculations, time-series analysis  
- **Power BI** – Dashboard development and visualization 

## 🧱 Database Structure

The project was structured using a fact-and-dimension approach:

### Main Tables

- **orders** → order status and timestamps

- **order_items** → transactional data (price, freight)

- **customers** → customer location data

- **products** → product category information

`order_items` was treated as the main fact table, as it concentrates the financial metrics of the business.

## 📂 Project Structure
/data

/sql

 ├── 01_create_tables.sql

 ├── 02_data_validation.sql

 ├── 03_business_queries.sql

README.md

Dashboard.png

datamodel.png
 ### **01_create_tables.sql**

- Contains table creation scripts and schema definition.

### **02_data_validation.sql**

- Includes sanity checks such as:

- Row counts

- Null validation

- Duplicate detection

- Data consistency checks

### **03_business_queries.sql**

- Contains business-focused analysis:

- Revenue metrics

- Product category performance

- Customer regional analysis

- Temporal trends

- Month-over-Month growth

# 📊 Business Analysis Performed

### 🔹 Revenue Analysis
- Total revenue
- Revenue by order status
- Average order value (AOV)
- Top 10 highest-value orders

### 🔹 Product-Level Analysis
- Revenue by product category
- Quantity sold per category
- Category participation percentage
- High-value categories identification

### 🔹 Customer Analysis
- Revenue by state
- Average order value by region
- Top customers by total spending
- Order distribution per state

### 🔹 Temporal Analysis
- Monthly revenue
- Monthly order volume
- Monthly average order value
- Month-over-Month revenue growth (MoM using `LAG`)

## 🔎 Key Insights

- Revenue showed consistent growth throughout 2017 and early 2018.
- São Paulo generated the highest revenue among all states.
- Over 97% of orders were successfully delivered.
- Revenue concentration is strong among the top product categories.
- Growth stabilized after the initial expansion period.

## 📈 Conclusion

This project demonstrates the ability to transform raw transactional data into structured analytical insights using SQL, and to communicate results effectively through a business-oriented dashboard.