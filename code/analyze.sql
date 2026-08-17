--CREATE TABEL PERMANENT FOR RFM ANALYSIS
CREATE TABLE rfm_table AS (
    SELECT 
        household_key,
        (SELECT MAX(day) FROM transaction_data) - MAX(day) AS recency,
        COUNT(DISTINCT basket_id) AS frequency,
        SUM(sales_value) AS monetary
    FROM transaction_data
    GROUP BY household_key
);

--melihat distribusi pembagian recency, frequency, monetary 
SELECT 
    recency,
    COUNT(household_key) AS total_pelanggan,
    ROUND((COUNT(*)::numeric / SUM(COUNT(*)) OVER()) * 100, 2) AS persentase,
    ROUND(SUM(COUNT(*)) OVER (ORDER BY recency) / SUM(COUNT(*)) OVER() * 100, 2) AS kumulatif_persentase,
    CEIL(ROUND(SUM(COUNT(*)) OVER (ORDER BY recency) / SUM(COUNT(*)) OVER() * 100, 2) / 20) AS pembagian_ke
FROM rfm_table
GROUP BY recency
ORDER BY recency ASC; --ganti recency ke frequency atau monetary untuk melihat distribusi variabel lain. 

--mendefinisikan tabel rfm
ALTER TABLE rfm_table
ADD COLUMN recency_rfm INTEGER,
ADD COLUMN frequency_rfm INTEGER,
ADD COLUMN monetary_rfm INTEGER;

--update tabel rfm dengan quantile
UPDATE rfm_table
SET 
    recency_rfm = sub.recency_rfm,
    frequency_rfm = sub.frequency_rfm,
    monetary_rfm = sub.monetary_rfm
FROM (
    SELECT 
        household_key,
        NTILE(5) OVER (ORDER BY recency DESC) AS recency_rfm,
        NTILE(5) OVER (ORDER BY frequency ASC) AS frequency_rfm,
        NTILE(5) OVER (ORDER BY monetary ASC) AS monetary_rfm
    FROM rfm_table
) sub
WHERE rfm_table.household_key = sub.household_key;

--Distribusi tabel RFM 
SELECT recency,
COUNT(*) AS total,
ROUND((COUNT(*)::numeric / SUM(COUNT(*)) OVER()) * 100, 2) AS persentase
FROM rfm_table
GROUP BY recency
ORDER BY recency

--Mean, median, standard deviasi, min-max recency
SELECT 
    ROUND(AVG(recency), 2) AS mean_recency,
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY recency) AS median_recency,
    ROUND(STDDEV(recency), 2) AS std_recency,
    MIN(recency) AS min_recency,
    MAX(recency) AS max_recency
FROM rfm_table;

-- menambahkan kolom rfm kategorisasi
ALTER TABLE rfm_table
ADD COLUMN segmentasi TEXT;

-- update kolom segmentasi
UPDATE rfm_table
SET 
    segmentasi = sub.segment
FROM (
    SELECT 
        household_key,
        CASE 
            WHEN recency_rfm = 5 AND frequency_rfm = 5 AND monetary_rfm = 5 THEN 'CHAMPION'
            WHEN recency_rfm BETWEEN 4 AND 5 AND frequency_rfm BETWEEN 4 AND 5 AND monetary_rfm BETWEEN 4 AND 5 THEN 'LOYALIST'
            WHEN recency_rfm = 1 AND frequency_rfm BETWEEN 1 AND 2 AND monetary_rfm BETWEEN 1 AND 2 THEN 'LOST'
            WHEN recency_rfm BETWEEN 3 AND 5 AND frequency_rfm BETWEEN 3 AND 5 AND monetary_rfm BETWEEN 3 AND 5 THEN 'POTENTIAL LOYALIST'
            WHEN recency_rfm BETWEEN 2 AND 5 AND frequency_rfm BETWEEN 3 AND 5 AND monetary_rfm BETWEEN 1 AND 5 THEN 'REGULAR'
            WHEN recency_rfm BETWEEN 2 AND 5 AND frequency_rfm BETWEEN 1 AND 2 AND monetary_rfm BETWEEN 1 AND 5 THEN 'NEW CUSTOMER'
            WHEN recency_rfm = 1 AND frequency_rfm BETWEEN 1 AND 5 AND monetary_rfm BETWEEN 1 AND 5 THEN 'RISK OF LOSING'
            ELSE 'NONE'
        END AS segment
    FROM rfm_table
) sub
WHERE rfm_table.household_key = sub.household_key;

--rata-rata dan total tiap rfm
SELECT 
ROUND(AVG(recency),2) AS Recency_AVG,
ROUND(AVG(frequency),2) AS Frekuensi_AVG,
ROUND(AVG(monetary),2) AS Monetary_AVG,
ROUND(SUM(frequency),2) AS Total_Frekuensi_Transaksi,
ROUND(SUM(monetary),2) AS Total_Monetary_Transaksi
FROM rfm_table
WHERE segmentasi = 'CHAMPION' --ganti sesuai segmentasi


--Tabel statistik dasar tiap segmentasi
SELECT 
    segmentasi,
    COUNT(household_key) AS Total_Customer,
    ROUND(COUNT(household_key) * 100.0 / SUM(COUNT(household_key)) OVER (), 2) AS Percentage_Customer,
    ROUND(AVG(monetary), 2) AS monetary_avg,
    ROUND(PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY monetary)::numeric, 2) AS monetary_median,
    ROUND(AVG(recency), 2) AS recency_avg,
    ROUND(PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY recency)::numeric, 2) AS recency_median,
    ROUND(AVG(frequency), 2) AS frequency_avg,
    ROUND(PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY frequency)::numeric, 2) AS frequency_median
    SUM(frequency) AS Total_Frekuensi_Transaksi,
    ROUND(SUM(monetary), 2) AS Total_Monetary_Transaksi,
    
    -- 1. Average Order Value (AOV)
    -- Total Belanja Segmen / Total Frekuensi Transaksi Segmen
    ROUND(SUM(monetary) / SUM(frequency), 2) AS AOV,
    
    -- 2. % Contribution to Total Revenue
    -- Total Monetary Segmen / Grand Total Monetary Seluruh Segmen * 100
    ROUND(
        (SUM(monetary) / SUM(SUM(monetary)) OVER ()) * 100, 
        2
    ) AS Revenue_Contribution_Pct
FROM rfm_table
GROUP BY segmentasi
ORDER BY Total_Monetary_Transaksi DESC;


--table produk, kolom department terbanyak
SELECT department,
COUNT(*) AS total
FROM product
GROUP BY department
ORDER BY total DESC

--Membuat Cohort Analysis
WITH first_purchase AS (
    SELECT 
        household_key,
        MIN(day) AS first_day,
        CEIL(MIN(day) / 30.0) AS cohort_month
    FROM transaction_data
    GROUP BY household_key
),

transaction_period AS (
    SELECT 
        t.household_key,
        fp.cohort_month,
        CEIL(t.day / 30.0) - fp.cohort_month AS period_number
    FROM transaction_data t
    JOIN first_purchase fp ON t.household_key = fp.household_key
),

cohort_result AS (
    SELECT 
        cohort_month,
        period_number,
        COUNT(DISTINCT household_key) AS active_customers
    FROM transaction_period
    GROUP BY cohort_month, period_number
)

SELECT 
    cohort_month,
    period_number,
    active_customers,
    FIRST_VALUE(active_customers) OVER (
        PARTITION BY cohort_month ORDER BY period_number
    ) AS cohort_size,
    ROUND(
        active_customers::numeric / 
        FIRST_VALUE(active_customers) OVER (PARTITION BY cohort_month ORDER BY period_number) 
        * 100, 2
    ) AS retention_rate
FROM cohort_result
ORDER BY cohort_month, period_number;


--ganti sql New Customer ke Occasional Customer
UPDATE rfm_table
SET segmentasi = 'OCCASIONAL CUSTOMER'
WHERE segmentasi = 'NEW CUSTOMER';


--demographic statitics heat map viz tableu
SELECT 'classification_1' AS jenis_demographic,
    segmentasi,
    classification_1 AS klasifikasi,
    COUNT(*) AS total_rumah_tangga,
    ROUND((COUNT(*)::numeric / SUM(COUNT(*)) OVER(PARTITION BY segmentasi)) * 100, 2) AS persentase
FROM rfm_table
LEFT JOIN hh_demographic ON rfm_table.household_key = hh_demographic.household_key
GROUP BY segmentasi, classification_1

UNION ALL

SELECT 'classification_2' ,
    segmentasi,
    classification_2 AS klasifikasi,
    COUNT(*) AS total_rumah_tangga,
    ROUND((COUNT(*)::numeric / SUM(COUNT(*)) OVER(PARTITION BY segmentasi)) * 100, 2) AS persentase
FROM rfm_table
LEFT JOIN hh_demographic ON rfm_table.household_key = hh_demographic.household_key
GROUP BY segmentasi, classification_2

UNION ALL

SELECT 'classification_3',
    segmentasi,
    classification_3 AS klasifikasi,
    COUNT(*) AS total_rumah_tangga,
    ROUND((COUNT(*)::numeric / SUM(COUNT(*)) OVER(PARTITION BY segmentasi)) * 100, 2) AS persentase
FROM rfm_table
LEFT JOIN hh_demographic ON rfm_table.household_key = hh_demographic.household_key
GROUP BY segmentasi, classification_3

UNION ALL

SELECT 'homeowner_desc',
    segmentasi,
    homeowner_desc AS klasifikasi,
    COUNT(*) AS total_rumah_tangga,
    ROUND((COUNT(*)::numeric / SUM(COUNT(*)) OVER(PARTITION BY segmentasi)) * 100, 2) AS persentase
FROM rfm_table
LEFT JOIN hh_demographic ON rfm_table.household_key = hh_demographic.household_key
GROUP BY segmentasi, homeowner_desc


UNION ALL

SELECT 'classification_5',
    segmentasi,
    classification_5 AS klasifikasi,
    COUNT(*) AS total_rumah_tangga,
    ROUND((COUNT(*)::numeric / SUM(COUNT(*)) OVER(PARTITION BY segmentasi)) * 100, 2) AS persentase
FROM rfm_table
LEFT JOIN hh_demographic ON rfm_table.household_key = hh_demographic.household_key
GROUP BY segmentasi, classification_5

UNION ALL

SELECT 'classification_4',
    segmentasi,
    classification_4 AS klasifikasi,
    COUNT(*) AS total_rumah_tangga,
    ROUND((COUNT(*)::numeric / SUM(COUNT(*)) OVER(PARTITION BY segmentasi)) * 100, 2) AS persentase
FROM rfm_table
LEFT JOIN hh_demographic ON rfm_table.household_key = hh_demographic.household_key
GROUP BY segmentasi, classification_4

UNION ALL

SELECT 'kid_category_desc',
    segmentasi,
    kid_category_desc AS klasifikasi,
    COUNT(*) AS total_rumah_tangga,
    ROUND((COUNT(*)::numeric / SUM(COUNT(*)) OVER(PARTITION BY segmentasi)) * 100, 2) AS persentase
FROM rfm_table
LEFT JOIN hh_demographic ON rfm_table.household_key = hh_demographic.household_key
GROUP BY segmentasi, kid_category_desc

ORDER BY segmentasi, klasifikasi;


--product rank - 10 by volume transaction
SELECT * FROM (
    SELECT 
        segmentasi,
        commodity_desc,
        department,
        COUNT(*) AS jumlah_transaksi,
        SUM(quantity) AS total_quantity,
        RANK() OVER (PARTITION BY segmentasi ORDER BY COUNT(*) DESC) AS rank_in_segment
    FROM transaction_data
    LEFT JOIN rfm_table ON transaction_data.household_key = rfm_table.household_key
    LEFT JOIN product ON transaction_data.product_id = product.product_id
    GROUP BY segmentasi, commodity_desc, department
) ranked
WHERE rank_in_segment <= 10
ORDER BY segmentasi, rank_in_segment;


--Product rank - 10 by monetary values
SELECT * FROM (
    SELECT 
        segmentasi,
        commodity_desc,
        department,
        COUNT(*) AS jumlah_transaksi,
        SUM(quantity) AS total_quantity,
        SUM(sales_value) AS total_penjualan,
        RANK() OVER (PARTITION BY segmentasi ORDER BY SUM(sales_value) DESC) AS rank_in_segment
    FROM transaction_data
    LEFT JOIN rfm_table ON transaction_data.household_key = rfm_table.household_key
    LEFT JOIN product ON transaction_data.product_id = product.product_id
    GROUP BY segmentasi, commodity_desc, department
) ranked
WHERE rank_in_segment <= 10
ORDER BY segmentasi, rank_in_segment;

-- affinitiy index 
WITH product_segment_stats AS (
    SELECT 
        rfm.segmentasi AS segment,
        p.commodity_desc,
        COUNT(*) AS total_tx,
        ROUND(
            (COUNT(*)::numeric / SUM(COUNT(*)) OVER (PARTITION BY rfm.segmentasi)) * 100, 
            4
        ) AS pct_in_segment
    FROM transaction_data t
    LEFT JOIN rfm_table rfm ON t.household_key = rfm.household_key 
    LEFT JOIN product p ON t.product_id = p.product_id
    WHERE rfm.segmentasi IS NOT NULL
    GROUP BY rfm.segmentasi, p.commodity_desc
),
total_population_stats AS (
    SELECT 
        p.commodity_desc,
        COUNT(*) AS total_tx_population,
        ROUND(
            (COUNT(*)::numeric / SUM(COUNT(*)) OVER ()) * 100, 
            4
        ) AS pct_in_population
    FROM transaction_data t
    LEFT JOIN rfm_table rfm ON t.household_key = rfm.household_key
    LEFT JOIN product p ON t.product_id = p.product_id
    WHERE rfm.segmentasi IS NOT NULL
    GROUP BY p.commodity_desc
)
SELECT
    ps.segment,
    ps.commodity_desc,
    ps.total_tx,
    ps.pct_in_segment,
    tp.pct_in_population,
    ROUND(
        (ps.pct_in_segment / NULLIF(tp.pct_in_population, 0)) * 100, 
        2
    ) AS affinity_index
FROM product_segment_stats ps
JOIN total_population_stats tp ON ps.commodity_desc = tp.commodity_desc
WHERE ps.total_tx >= 100              -- filter signifikansi, sesuaikan angkanya
  AND (ps.pct_in_segment / NULLIF(tp.pct_in_population, 0)) * 100 > 120  -- filter magnitude
ORDER BY ps.segment, affinity_index DESC;

--adding duration to campaign_table
ALTER TABLE campaign_desc 
ADD COLUMN duration INT GENERATED ALWAYS AS (end_day - start_day + 1) STORED;

--tipe kampanye paling banyak
SELECT description,
COUNT(*) AS total
FROM campaign_desc
GROUP BY description

--avg tiap tipe kampanye duration
SELECT description,
AVG(duration) AS total
FROM campaign_desc
GROUP BY description

--berapa jumlah kupon unik dari tiap kampanye
SELECT 
    campaign,
    COUNT(DISTINCT coupon_upc) AS jumlah_kupon
FROM coupon
GROUP BY campaign
ORDER BY jumlah_kupon ASC;

--jumlah kupon unik berdasarkan tiap tipe kampanye
SELECT * 
FROM coupon 
LEFT JOIN campaign_desc ON campaign_desc.campaign = coupon.campaign;


--engagment rate
WITH targeted AS (
    SELECT campaign, COUNT(DISTINCT household_key) AS total_household_target
    FROM campaign_table
    GROUP BY campaign
),
redeemed AS (
    SELECT campaign, COUNT(DISTINCT household_key) AS total_household_redeem
    FROM coupon_redempt
    GROUP BY campaign
),
per_campaign AS (
    SELECT 
        cd.description,
        t.total_household_target,
        COALESCE(r.total_household_redeem, 0) AS total_household_redeem
    FROM targeted t
    JOIN campaign_desc cd ON t.campaign = cd.campaign
    LEFT JOIN redeemed r ON t.campaign = r.campaign
)
SELECT 
    description,
    SUM(total_household_target) AS total_household_target,
    SUM(total_household_redeem) AS total_household_redeem,
    ROUND(SUM(total_household_redeem)::numeric / NULLIF(SUM(total_household_target), 0) * 100, 2) AS engagement_rate_pct
FROM per_campaign
GROUP BY description
ORDER BY engagement_rate_pct DESC


--Engagement Rate berdasarkan segmentasi dan tipe kampanye
WITH targeted AS (
    SELECT ct.campaign, r.segmentasi, COUNT(DISTINCT ct.household_key) AS total_household_target
    FROM campaign_table ct
    JOIN rfm_table r ON ct.household_key = r.household_key
    GROUP BY ct.campaign, r.segmentasi
),
redeemed AS (
    SELECT cr.campaign, r.segmentasi, COUNT(DISTINCT cr.household_key) AS total_household_redeem
    FROM coupon_redempt cr
    JOIN rfm_table r ON cr.household_key = r.household_key
    GROUP BY cr.campaign, r.segmentasi
),
per_campaign AS (
    SELECT 
        cd.description,
        t.segmentasi,
        t.total_household_target,
        COALESCE(rd.total_household_redeem, 0) AS total_household_redeem
    FROM targeted t
    JOIN campaign_desc cd ON t.campaign = cd.campaign
    LEFT JOIN redeemed rd ON t.campaign = rd.campaign AND t.segmentasi = rd.segmentasi
)
SELECT 
    segmentasi,
    description,
    SUM(total_household_target) AS total_household_target,
    SUM(total_household_redeem) AS total_household_redeem,
    ROUND(SUM(total_household_redeem)::numeric / NULLIF(SUM(total_household_target), 0) * 100, 2) AS engagement_rate_pct
FROM per_campaign
GROUP BY segmentasi, description
ORDER BY segmentasi, engagement_rate_pct DESC


--barang apa aja untuk tipe a, b, c dst dan berapa jumlahnya 
SELECT 
    cd.description,
    p.commodity_desc,
    COUNT(DISTINCT c.coupon_upc) AS jumlah_upc
FROM coupon c
JOIN campaign_desc cd ON c.campaign = cd.campaign
JOIN product p ON c.product_id = p.product_id
GROUP BY cd.description, p.commodity_desc
ORDER BY cd.description, jumlah_upc DESC