/*
===============================================================================
DDL Script: Création des tables Bronze
===============================================================================
Script Purpose:
    Ce script crée les tables dans le schéma 'bronze'. 
    Les tables existantes seront supprimées avant la création afin de garantir 
    que la structure DDL soit toujours à jour.
    
Usage:
    Exécuter ce script pour initialiser ou redéfinir la structure des tables 
    du niveau Bronze dans la base de données.
===============================================================================
*/

IF OBJECT_ID ('bronze.crm_cust_info', 'U') IS NOT NULL
	DROP TABLE bronze.crm_cust_info;
CREATE TABLE bronze.crm_cust_info (
	cst_id              INT,
	cst_key             NVARCHAR(50),
	cst_firstname       NVARCHAR(50),
	cst_lastname        NVARCHAR(50),
	cst_material_status NVARCHAR(50),
	cst_gndr            NVARCHAR(50),
	cst_create_date     DATE
);

IF OBJECT_ID ('bronze.crm_prd_info', 'U') IS NOT NULL
	DROP TABLE bronze.crm_prd_info;
CREATE TABLE bronze.crm_prd_info (
	prd_id INT,
	prd_key NVARCHAR(50),
	prd_nm NVARCHAR(50),
	prd_cost INT,
	prd_line NVARCHAR(50),
	prd_start_dt DATETIME,
	prd_end_dt DATETIME
);

IF OBJECT_ID ('bronze.crm_sales_details', 'U') IS NOT NULL
	DROP TABLE bronze.crm_sales_details;
CREATE TABLE bronze.crm_sales_details (
	sls_ord_num NVARCHAR(50),
	sls_prd_key NVARCHAR(50),
	sls_cust_id INT,
	sls_order_dt INT,
	sls_ship_dt INT,
	sls_due_dt INT,
	sls_sales INT,
	sls_quantity INT,
	sls_price INT
);

IF OBJECT_ID ('bronze.erp_loc_a101', 'U') IS NOT NULL
	DROP TABLE bronze.erp_loc_a101;
CREATE TABLE bronze.erp_loc_a101 (
	cid   NVARCHAR(50),
	cntry NVARCHAR(50)
);

IF OBJECT_ID ('bronze.erp_cust_az12', 'U') IS NOT NULL
	DROP TABLE bronze.erp_cust_az12;
CREATE TABLE bronze.erp_cust_az12 (
	cid   NVARCHAR(50),
	bdate DATE,
	gen   NVARCHAR(50)
);

IF OBJECT_ID ('bronze.erp_px_cat_g1v2', 'U') IS NOT NULL
	DROP TABLE bronze.erp_px_cat_g1v2;
CREATE TABLE bronze.erp_px_cat_g1v2 (
	ID          NVARCHAR(50),
	CAT         NVARCHAR(50),
	SUBCAT      NVARCHAR(50),
	MAINTENANCE NVARCHAR(50)
);

IF OBJECT_ID ('bronze.erp_logis_dep_stock', 'U') IS NOT NULL
	DROP TABLE bronze.erp_logis_dep_stock;
CREATE TABLE bronze.erp_logis_dep_stock (
	DEPOT_ID           NVARCHAR(50),
	prd_id             INT,
	prd_key            NVARCHAR(50),
	CURRENT_STOCK      INT,
	SAFETY_STOCK       INT,
	LAST_COUNT_DT      DATETIME,
	DEPOT_COUNTRY      NVARCHAR(50)
);

IF OBJECT_ID ('bronze.erp_logis_sup_perf', 'U') IS NOT NULL
	DROP TABLE bronze.erp_logis_sup_perf;
CREATE TABLE bronze.erp_logis_sup_perf (
	SUPPLIER_ID        NVARCHAR(50),
	prd_key            NVARCHAR(50),
	LEAD_TIME_DAYS     INT,
	QTY_ORDERED       INT,
	QTY_RECEIVED_ON_TIME INT,
	PO_DATE      DATETIME
);

IF OBJECT_ID ('bronze.erp_logis_trans_info', 'U') IS NOT NULL
	DROP TABLE bronze.erp_logis_trans_info;
CREATE TABLE bronze.erp_logis_trans_info (
	sls_ord_num NVARCHAR(50),
	SHIPPING_CARRIER NVARCHAR(50),
	TRACKING_NUM NVARCHAR(50),
	SHIPPING_COST DECIMAL(10,2),
	DELIVERY_TYPE NVARCHAR(50),
	DEPOT_SOURCE_ID NVARCHAR(50)
);