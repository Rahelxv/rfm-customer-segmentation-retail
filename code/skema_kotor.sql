CREATE TABLE hh_demographic (
    classification_1 TEXT,
    classification_2 TEXT,
    classification_3 TEXT,
    homeowner_desc TEXT,
    classification_5 TEXT,
    classification_4 TEXT,      
    kid_category_desc TEXT,
    household_key INT
);

CREATE TABLE product (
    product_id INT,
    manufacturer INT,
    department TEXT,
    brand TEXT,
    commodity_desc TEXT,
    sub_commodity_desc TEXT,
    curr_size_of_product TEXT  
);
 
CREATE TABLE campaign_desc (
    description TEXT,
    campaign INT,
    start_day INT,
    end_day INT
);
 
CREATE TABLE transaction_data (
    household_key INT,         
    basket_id BIGINT,         
    day INT,
    product_id INT,
    quantity INT,
    sales_value NUMERIC,        
    store_id INT,                
    retail_disc NUMERIC,
    trans_time INT,
    week_no INT,
    coupon_disc NUMERIC,
    coupon_match_disc NUMERIC
);
 
CREATE TABLE campaign_table (
    description TEXT,
    household_key INT,        
    campaign INT

);
 
CREATE TABLE coupon (
    coupon_upc TEXT,           
    product_id INT ,
    campaign INT
);
 
CREATE TABLE causal_data (
    product_id INT,
    store_id INT,
    week_no INT,
    display TEXT,             
    mailer TEXT               
);
 
CREATE TABLE coupon_redempt (
    household_key INT,          
    day INT,
    coupon_upc TEXT,             
    campaign INT
);
 
