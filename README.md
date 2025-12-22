# End-to-End-Data-Warehouse-Power-BI-Project

Welcome to the Data Warehouse & Analytics Project repository! 🚀
This project demonstrates a modern data warehouse implementation and analytics solution using SQL Server and Power BI, covering the full data lifecycle from ingestion to executive dashboards. It is designed as a portfolio project to showcase industry best practices in data engineering and analytics.

---

## 🏗️ Data Architecture
The project follows the Medallion Architecture with **Bronze, Silver, and Gold layers**:

1.**Bronze Layer**: Stores raw transactional data (sales, inventory, customers, products) as-is from source CSV files.
2.**Silver Layer**: Cleansed, standardized, and normalized data prepared for analysis.
3.**Gold Layer**: Business-ready data modeled into a star schema for reporting and analytics.

## 📖 Project Overview

The project includes:

1-**ETL Pipelines**: Extract, transform, and load data from ERP and CRM source systems into the warehouse.
2-**Data Modeling**: Create fact and dimension tables optimized for analytical queries.
3-**Business Intelligence**: Develop KPIs and interactive Power BI dashboards for executive decision-making.

🎯Key Focus Areas of the Dashboard:

1-**Business Growth Drivers** : Identify what drives company growth: sales, customers, top products, and high-performing regions.
2-**Productivity & Supply Impact** : Analyze operational efficiency and supply chain impact: stock levels, lead times, turnover, and depot performance.
3-**Risk & Business Protection** : Measure and mitigate financial and operational risks: at-risk revenue, lost sales, and supplier performance.

## 🛠️ Tools & Technologies

-**SQL Server** – Database, ETL, and data modeling
-**Power BI** – DAX, Power Query, and dashboards
-**GitHub** – Version control and project documentation

## 🚀 Project Requirements

### Building the Data Warehouse (Data Engineering)

#### Objective
Develop a modern data warehouse using SQL Server to consolidate sales data, enabling analytical reporting and informed decision-making.
Consolidate ERP and CRM data into a unified warehouse.

#### Specifications
- **Data Sources**: Import data from two source systems (ERP and CRM) provided as CSV files.
- **Data Quality**: Cleanse and resolve data quality issues prior to analysis.
- **Integration**: Combine both sources into a single, user-friendly data model designed for analytical queries.
- **Scope**: Focus on the latest dataset only; historization of data is not required.

### BI: Analytics & Reporting (Business Intelligence)

### Objective: 
Provide actionable insights to support strategic decision-making.

#### Specifications
- Analyze customer behavior, product performance, and sales trends.
- Deliver insights using SQL queries and Power BI dashboards.
- Enable stakeholders to make informed decisions through KPIs and visual analytics.


## 🛡️ License

This project is licensed under the MIT License
. You are free to use, modify, and share this project with proper attribution.
