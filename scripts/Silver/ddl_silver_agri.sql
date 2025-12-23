/*
===============================================================================
DDL Script: Create Silver Tables
===============================================================================
Purpose:
    Ce script crée les tables dans le schéma 'silver'. 
    Les tables existantes sont supprimées si elles existent déjà 
    afin de garantir que la structure DDL soit toujours à jour.
    
Usage:
    Exécuter ce script pour initialiser ou redéfinir la structure des tables 
    du niveau Silver dans la base de données.
===============================================================================
*/

IF OBJECT_ID ('silver.crm_cust_info', 'U') IS NOT NULL
	DROP TABLE silver.crm_cust_info
CREATE TABLE silver.crm_cust_info (
	cst_id              INT,
	cst_key             NVARCHAR(50),
	cst_firstname       NVARCHAR(50),
	cst_lastname        NVARCHAR(50),
	cst_material_status NVARCHAR(50),
	cst_gndr            NVARCHAR(50),
	cst_create_date     DATE,
	dwh_create_date     DATETIME2 DEFAULT GETDATE()
);

IF OBJECT_ID ('silver.crm_prd_info', 'U') IS NOT NULL
	DROP TABLE silver.crm_prd_info;
CREATE TABLE silver.crm_prd_info (
	prd_id INT,
	cat_id NVARCHAR(50), 
	prd_key NVARCHAR(50),
	prd_nm NVARCHAR(50),
	prd_cost INT,
	prd_line NVARCHAR(50),
	prd_start_dt DATE,
	prd_end_dt DATE,
	dwh_create_date     DATETIME2 DEFAULT GETDATE()
);

IF OBJECT_ID('silver.crm_sales_details', 'U') IS NOT NULL
    DROP TABLE silver.crm_sales_details;
CREATE TABLE silver.crm_sales_details (
    sls_ord_num     NVARCHAR(50),
    sls_prd_key     NVARCHAR(50),
    sls_cust_id     INT,
    sls_order_dt    DATE,
    sls_ship_dt     DATE,
    sls_due_dt      DATE,
    sls_sales       INT,
    sls_quantity    INT,
    sls_price       INT,
    dwh_create_date DATETIME2 DEFAULT GETDATE()
);

IF OBJECT_ID ('silver.erp_loc_a101', 'U') IS NOT NULL
	DROP TABLE silver.erp_loc_a101;
CREATE TABLE silver.erp_loc_a101 (
	cid   NVARCHAR(50),
	cntry NVARCHAR(50),
	dwh_create_date     DATETIME2 DEFAULT GETDATE()
);

IF OBJECT_ID ('silver.erp_cust_az12', 'U') IS NOT NULL
	DROP TABLE silver.erp_cust_az12;
CREATE TABLE silver.erp_cust_az12 (
	cid   NVARCHAR(50),
	bdate DATE,
	gen   NVARCHAR(50),
	dwh_create_date     DATETIME2 DEFAULT GETDATE()
);

IF OBJECT_ID ('silver.erp_px_cat_g1v2', 'U') IS NOT NULL
	DROP TABLE silver.erp_px_cat_g1v2;
CREATE TABLE silver.erp_px_cat_g1v2 (
	ID          NVARCHAR(50),
	CAT         NVARCHAR(50),
	SUBCAT      NVARCHAR(50),
	MAINTENANCE NVARCHAR(50),
	dwh_create_date     DATETIME2 DEFAULT GETDATE()
);

IF OBJECT_ID ('silver.erp_logis_dep_stock', 'U') IS NOT NULL
	DROP TABLE silver.erp_logis_dep_stock;
CREATE TABLE silver.erp_logis_dep_stock (
	DEPOT_ID           NVARCHAR(50),
	prd_id             INT,
	cat_id             NVARCHAR(50),
	prd_key            NVARCHAR(50),
	CURRENT_STOCK      INT,
	SAFETY_STOCK       INT,
	LAST_COUNT_DT      DATETIME,
	DEPOT_COUNTRY      NVARCHAR(50),
	dwh_create_date    DATETIME2 DEFAULT GETDATE()
);

IF OBJECT_ID ('silver.erp_logis_sup_perf', 'U') IS NOT NULL
	DROP TABLE silver.erp_logis_sup_perf;
CREATE TABLE silver.erp_logis_sup_perf (
	SUPPLIER_ID        NVARCHAR(50),
	cat_id             NVARCHAR(50),
	prd_key            NVARCHAR(50),
	prd_key_an         NVARCHAR(50),
	LEAD_TIME_DAYS     INT,
	QTY_ORDERED       INT,
	QTY_RECEIVED_ON_TIME INT,
	PO_DATE      DATETIME,
	dwh_create_date     DATETIME2 DEFAULT GETDATE()
);

IF OBJECT_ID ('silver.erp_logis_trans_info', 'U') IS NOT NULL
	DROP TABLE silver.erp_logis_trans_info;
CREATE TABLE silver.erp_logis_trans_info (
	sls_ord_num NVARCHAR(50),
	SHIPPING_CARRIER NVARCHAR(50),
	TRACKING_NUM NVARCHAR(50),
	SHIPPING_COST DECIMAL(10,2),
	DELIVERY_TYPE NVARCHAR(50),
	DEPOT_SOURCE_ID NVARCHAR(50),
	dwh_create_date     DATETIME2 DEFAULT GETDATE()
);