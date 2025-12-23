/*
===============================================================================
DDL Script: Create Gold Views
===============================================================================
Purpose:
    Ce script crée les vues du niveau Gold à partir des tables Silver. 
    Chaque vue représente une dimension ou un fait consolidé, prêt pour l'analyse.
    Les actions réalisées sont les suivantes :
        - Suppression des vues existantes si elles existent.
        - Création de nouvelles vues avec transformation, nettoyage et 
          enrichissement des données Silver.
          
Notes:
    - Les dimensions incluent : dim_customers, dim_products, dim_depot, dim_order.
    - Les faits incluent : fact_sales, fact_stocks, fact_supplier, fact_shipping.
    - Les clés primaires et de substitution (ROW_NUMBER) sont générées pour 
      assurer l'unicité dans les dimensions.

Parameters:
    Aucun. Ce script ne prend pas de paramètres et ne retourne aucune valeur.

Usage Example:
    -- Exécuter tout le script pour recréer toutes les vues Gold
===============================================================================
*/

-- =============================================================================
-- Create Dimension: gold.dim_customers
-- =============================================================================
	 IF OBJECT_ID('gold.dim_customers', 'V') IS NOT NULL
		 DROP VIEW gold.dim_customers;
	 GO
	 CREATE VIEW gold.dim_customers AS
	 SELECT
		ROW_NUMBER() OVER (ORDER BY cst_id) AS customer_key,
		ci.cst_id AS customer_id,
		ci.cst_key AS customer_number,
		ci.cst_firstname AS first_name,
		ci.cst_lastname AS last_name,
		la.cntry AS country,
		ci.cst_material_status AS marital_status,
		CASE WHEN ci.cst_gndr != 'n/a' THEN ci.cst_gndr -- CRM is the Master for gender Info 
			 ELSE COALESCE(ca.gen, 'n/a')
		END AS gender,
		ca.bdate birthdate,
		ci.cst_create_date AS create_date
	FROM silver.crm_cust_info ci
	LEFT JOIN silver.erp_cust_az12 ca
	ON		  ci.cst_key = ca.cid
	LEFT JOIN silver.erp_loc_a101 la
	ON		  ci.cst_key = la.cid;
	GO


-- =============================================================================
-- Create Dimension: gold.dim_products
-- =============================================================================
	IF OBJECT_ID('gold.dim_products', 'V') IS NOT NULL
        DROP VIEW gold.dim_products;
    GO

	CREATE VIEW gold.dim_products AS
	SELECT
		ROW_NUMBER() OVER (ORDER BY pn.prd_start_dt, pn.prd_key) AS product_key,
		pn.prd_id AS product_id,
		pn.prd_key AS product_number,
		pn.prd_nm AS product_name,
		pn.cat_id AS category_id, 
		pc.cat AS category,
		pc.subcat AS subcategory,
		pc.maintenance,
		pn.prd_cost AS cost,
		pn.prd_line AS product_line,
		pn.prd_start_dt AS start_date
	FROM silver.crm_prd_info pn
	LEFT JOIN silver.erp_px_cat_g1v2 pc
	ON pn.cat_id = pc.id
	WHERE prd_end_dt IS NULL; --Filter out all historical data
	GO

-- =============================================================================
-- Create Dimension: gold.dim_depot
-- =============================================================================
	IF OBJECT_ID('gold.dim_depot', 'V') IS NOT NULL
		DROP VIEW gold.dim_depot;
	GO

	CREATE VIEW gold.dim_depot AS
	SELECT DISTINCT
		DEPOT_ID AS depot_id,
		'Depot ' + CAST(DEPOT_ID AS VARCHAR(10)) AS depot_name,
		CASE
			WHEN DEPOT_COUNTRY IS NULL then 'a/n'
			ELSE DEPOT_COUNTRY
		END AS country,
		CASE 
			WHEN SUBSTRING(DEPOT_ID,1, 2) = 'WH' THEN 'Americas'
			WHEN SUBSTRING(DEPOT_ID,4, LEN(DEPOT_ID)) = 'CA' THEN 'Americas'
			WHEN SUBSTRING(DEPOT_ID,4, LEN(DEPOT_ID)) = 'FR' THEN 'Europe'
			WHEN SUBSTRING(DEPOT_ID,4, LEN(DEPOT_ID)) = 'DE' THEN 'Europe'
			WHEN SUBSTRING(DEPOT_ID,4, LEN(DEPOT_ID)) = 'UK' THEN 'Europe'
			ELSE 'Other'
		END AS region
	FROM (
		-- Extract the deposits from fact_stocks
		SELECT DEPOT_ID, DEPOT_COUNTRY
		FROM silver.erp_logis_dep_stock

		UNION

		-- Extract the deposits from fact_shipping
		SELECT DEPOT_SOURCE_ID AS DEPOT_ID, NULL AS DEPOT_COUNTRY
		FROM silver.erp_logis_trans_info
	) AS combined;
	GO

-- =============================================================================
-- Create Dimension: gold.fact_sales
-- =============================================================================
	IF OBJECT_ID('gold.fact_sales', 'V') IS NOT NULL
        DROP VIEW gold.fact_sales;
    GO

	CREATE VIEW gold.fact_sales AS
	SELECT
		sls_ord_num AS order_number,
		pr.product_key,
		cu.customer_key,
		sls_order_dt AS order_date,
		sls_ship_dt shipping_date,
		sls_due_dt AS due_date,
		sls_sales AS sales_amount,
		sls_quantity AS quanty,
		sls_price AS price
	FROM silver.crm_sales_details sd
	LEFT JOIN gold.dim_products pr
	ON sd.sls_prd_key = pr.product_number
	LEFT JOIN gold.dim_customers cu
	ON sd.sls_cust_id = cu.customer_id;
	GO

-- =============================================================================
-- Create Dimension: gold.fact_stocks
-- =============================================================================
	IF OBJECT_ID('gold.fact_stocks', 'V') IS NOT NULL
        DROP VIEW gold.fact_stocks;
    GO

    CREATE VIEW gold.fact_stocks AS
	SELECT  
        DEPOT_ID        AS Depot_id,
        prd_id          AS Product_id,
        cat_id          AS Category_id,
        prd_key         AS Product_key,
        CURRENT_STOCK   AS Current_Stock,
        SAFETY_STOCK    AS Safety_Stock,
        LAST_COUNT_DT   AS Last_Count_Date,
        DEPOT_COUNTRY   AS Depot_Country
    FROM silver.erp_logis_dep_stock
	GO

-- =============================================================================
-- Create Dimension: gold.fact_supplier
-- =============================================================================
	IF OBJECT_ID('gold.fact_supplier', 'V') IS NOT NULL
    DROP VIEW gold.fact_supplier;
	GO

	CREATE VIEW gold.fact_supplier AS
	SELECT
		SUPPLIER_ID,
		cat_id AS Category_id,
		prd_key AS Product_key,
		prd_key_an AS Product_key_Last,
		LEAD_TIME_DAYS,
		QTY_ORDERED AS Quantity_Ordered,
		QTY_RECEIVED_ON_TIME AS Quantity_Received_Time,
		CASt(PO_DATE AS DATE) AS Purchase_Order_Date
	FROM silver.erp_logis_sup_perf
	GO

-- =============================================================================
-- Create Dimension: fact_shipping
-- =============================================================================
	IF OBJECT_ID('gold.fact_shipping', 'V') IS NOT NULL
    DROP VIEW gold.fact_shipping;
	GO

	CREATE VIEW gold.fact_shipping AS
	SELECT DISTINCT
		sls_ord_num AS order_number,
		SHIPPING_CARRIER,
		TRACKING_NUM TRACKING_NUMBER,
		SHIPPING_COST,
		DELIVERY_TYPE,
		DEPOT_SOURCE_ID
	FROM silver.erp_logis_trans_info
	GO
-- =============================================================================
-- Create Dimension: gold.dim_order
-- =============================================================================
	IF OBJECT_ID('gold.dim_order', 'V') IS NOT NULL
		DROP VIEW gold.dim_order;
	GO

	CREATE VIEW gold.dim_order AS
	SELECT DISTINCT
		ROW_NUMBER() OVER (ORDER BY o.order_number) AS order_key,
		o.order_number,
		o.order_date,
		o.shipping_date,
		o.due_date,
		s.SHIPPING_CARRIER,
		s.DELIVERY_TYPE,
		s.SHIPPING_COST
	FROM (
		SELECT
			order_number,
			order_date,
			shipping_date,
			due_date
		FROM gold.fact_sales
	) o
	LEFT JOIN gold.fact_shipping s
		ON o.order_number = s.order_number;
	GO

