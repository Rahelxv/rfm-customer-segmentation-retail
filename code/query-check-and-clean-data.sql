-- ============================================
-- hh_demographic
-- ============================================

---
--classification_1--
---
--check data kosong
SELECT classification_1 
FROM hh_demographic 
WHERE classification_1 IS NULL; --tidak ada data kosong

--check distinct value
SELECT DISTINCT classification_1 
FROM hh_demographic;

--calculate distribution for each value, by jumlah and persentase ; then order it by number
 SELECT 
    classification_1, 
    COUNT(*) AS jumlah,
    ROUND((COUNT(*)::numeric / SUM(COUNT(*)) OVER()) * 100, 2) AS persentase
FROM hh_demographic 
GROUP BY classification_1
ORDER BY CASE classification_1
        WHEN 'Age Group1' THEN 1
        WHEN 'Age Group2' THEN 2
        WHEN 'Age Group3' THEN 3
        WHEN 'Age Group4' THEN 4
        WHEN 'Age Group5' THEN 5
        WHEN 'Age Group6' THEN 6
    END; 

---
--classification_2--
---
--check data kosong
SELECT classification_2 
FROM hh_demographic 
WHERE classification_2 IS NULL; --tidak ada data kosong

--check distinct value
SELECT DISTINCT classification_2 
FROM hh_demographic;

--calculate distribution for each value, by jumlah and persentase ; then order it by value given
SELECT classification_2, 
COUNT(*) AS jumlah,
ROUND((COUNT(*)::numeric / SUM(COUNT(*))OVER())*100,2) AS persentase
FROM hh_demographic 
GROUP BY classification_2
ORDER BY CASE classification_2
	WHEN 'X' THEN 1
	WHEN 'Y' THEN 2
	WHEN 'Z' THEN 3
	END;


---
--classification_3--
---
--check data kosong
SELECT classification_3 
FROM hh_demographic 
WHERE classification_3 IS NULL; --tidak ada data kosong

--check distinct value
SELECT DISTINCT classification_3 
FROM hh_demographic;

--calculate distribution for each value, by jumlah and persentase ; then order it by value given
SELECT classification_3, 
COUNT(*) AS jumlah,
ROUND((COUNT(*)::numeric / SUM(COUNT(*))OVER())*100,2) AS persentase
FROM hh_demographic 
GROUP BY classification_3
ORDER BY CASE classification_3
	WHEN 'Level1' THEN 1
	WHEN 'Level2' THEN 2
	WHEN 'Level3' THEN 3
	WHEN 'Level4' THEN 4
	WHEN 'Level5' THEN 5
	WHEN 'Level6' THEN 6
	WHEN 'Level7' THEN 7
	WHEN 'Level8' THEN 8
	WHEN 'Level9' THEN 9
	WHEN 'Level10' THEN 10
	WHEN 'Level11' THEN 11
	WHEN 'Level12' THEN 12
	END;

---
--homeowner_desc--
---
--check data kosong
SELECT homeowner_desc 
FROM hh_demographic 
WHERE homeowner_desc IS NULL; --tidak ada data kosong

--check values distinct
SELECT DISTINCT homeowner_desc 
FROM hh_demographic 

--calculate distribution for each value, by jumlah and persentase ; then order it by value given
SELECT homeowner_desc, 
COUNT(*) AS jumlah,
ROUND((COUNT(*)::numeric / SUM(COUNT(*))OVER())*100,2) AS persentase
FROM hh_demographic 
GROUP BY homeowner_desc
ORDER BY CASE homeowner_desc
	WHEN 'Homeowner' THEN 1
	WHEN 'Probabel Owner' THEN 2
	WHEN 'Unknown' THEN 3
	WHEN 'Probable Renter' THEN 4
	WHEN 'Renter' THEN 5
	END;

---
--classification_5--
---
--Check data kosong
SELECT classification_5 
FROM hh_demographic 
WHERE classification_5 IS NULL --tidak ada data kosong

--Check distinct value
SELECT DISTINCT classification_5 
FROM hh_demographic 

--calculate distribution for each value, by jumlah and persentase ; then order it by value given
SELECT classification_5, 
COUNT(*) AS jumlah,
ROUND((COUNT(*)::numeric / SUM(COUNT(*))OVER())*100,2) AS persentase
FROM hh_demographic 
GROUP BY classification_5
ORDER BY CASE classification_5
	WHEN 'Group1' THEN 1
	WHEN 'Group2' THEN 2
	WHEN 'Group3' THEN 3
	WHEN 'Group4' THEN 4
	WHEN 'Group5' THEN 5
	WHEN 'Group6' THEN 6
	END;

---
--classification_4--
---
--check data kosong
SELECT classification_4 
FROM hh_demographic 
WHERE classification_4 IS NULL; -- tidak ada

--select distinct
SELECT DISTINCT classification_4 
FROM hh_demographic 

--calculate distribution for each value, by jumlah and persentase ; then order it by value given
SELECT classification_4, 
COUNT(*) AS jumlah,
ROUND((COUNT(*)::numeric / SUM(COUNT(*))OVER())*100,2) AS persentase
FROM hh_demographic 
GROUP BY classification_4
ORDER BY CASE classification_4
	WHEN '1' THEN 1
	WHEN '2' THEN 2
	WHEN '3' THEN 3
	WHEN '4' THEN 4
	WHEN '5+' THEN 5
	END;

---
--kid_category_desc --
---
--nilai kosong
SELECT kid_category_desc
FROM hh_demographic
WHERE kid_category_desc IS NULL; -- TIDAK ADA

--distinct values
SELECT DISTINCT kid_category_desc
FROM hh_demographic

--calculate distribution for each value, by jumlah and persentase ; then order it by value given
SELECT kid_category_desc , 
COUNT(*) AS jumlah,
ROUND((COUNT(*)::numeric / SUM(COUNT(*))OVER())*100,2) AS persentase
FROM hh_demographic 
GROUP BY kid_category_desc 
ORDER BY CASE kid_category_desc 
	WHEN '1' THEN 1
	WHEN '2' THEN 2
	WHEN '3+' THEN 3
	WHEN 'None/Unknown' THEN 4
	END;

---end of first tabel---


-- ============================================
-- product
-- ============================================
--mengecek apakah ada nilai yang kosong dari pk
SELECT DISTINCT product_id 
FROM product
WHERE product_id IS NULL --tidak ada

---
--manufacturer--
---
--Check nilai kosong
SELECT manufacturer 
FROM product
WHERE manufacturer IS NULL --tidak ada

--check distinct values (berapa banyak manufaktur dengan nilai berbeda)
SELECT DISTINCT manufacturer 
FROM product

--check most manufactur to create product
SELECT manufacturer , 
COUNT(*) AS jumlah_product,
ROUND((COUNT(*)::numeric / SUM(COUNT(*))OVER())*100,2) AS persentase
FROM product 
GROUP BY manufacturer 
ORDER BY jumlah_product DESC;

---
--department--
---
--Check null
SELECT department 
FROM product
WHERE department IS NULL --tidak ada yg kosong

--Check null after trim
SELECT department 
FROM product
WHERE TRIM(department) = '' -- ada 15 data kosong, berarti ada whitespace

--updating data to be null 
UPDATE product
SET department = NULL
WHERE TRIM(department) = '';


--Select distinct
SELECT DISTINCT department 
FROM product

--Mengkategorikan product terbanyak berdasarkan departemen
SELECT department , 
COUNT(*) AS jumlah_product,
ROUND((COUNT(*)::numeric / SUM(COUNT(*))OVER())*100,2) AS persentase
FROM product 
GROUP BY department 
ORDER BY jumlah_product DESC;

---
--brand--
---
--Check null values
SELECT brand
FROM product
WHERE brand IS NULL; --tidak ada

--check for distinct values
SELECT DISTINCT brand 
FROM product


--check for values distinct count by highes number and percentage
SELECT brand, 
COUNT(*) AS jumlah_product,
ROUND((COUNT(*)::numeric / SUM(COUNT(*))OVER())*100,2) AS persentase
FROM product 
GROUP BY brand 
ORDER BY jumlah_product DESC;

---
--commodity_desc--
---
--check null values
SELECT commodity_desc 
FROM product
WHERE brand IS NULL; --tidak ada


--Check null after trim
SELECT commodity_desc 
FROM product
WHERE TRIM(commodity_desc) = '' -- juga ada 15 data kosong

--updating data to be null 
UPDATE product
SET commodity_desc = NULL
WHERE TRIM(commodity_desc) = '';

--check distinct values
SELECT DISTINCT commodity_desc 
FROM product

--check for values distinct count by highes number and percentage
SELECT commodity_desc , 
COUNT(*) AS jumlah_product,
ROUND((COUNT(*)::numeric / SUM(COUNT(*))OVER())*100,2) AS persentase
FROM product 
GROUP BY commodity_desc  
ORDER BY jumlah_product DESC;

---
--sub_commodity_desc--
---
--Check for null
SELECT sub_commodity_desc 
FROM product
WHERE sub_commodity_desc IS NULL;

--check for null after trims
SELECT sub_commodity_desc 
FROM product
WHERE TRIM(sub_commodity_desc) = ''

--update
UPDATE product
SET sub_commodity_desc = NULL
WHERE TRIM(sub_commodity_desc) = '';

--Check for distinct values
SELECT DISTINCT sub_commodity_desc 
FROM product

--check for values distinct count by highes number and percentage
SELECT sub_commodity_desc , 
COUNT(*) AS jumlah_product,
ROUND((COUNT(*)::numeric / SUM(COUNT(*))OVER())*100,2) AS persentase
FROM product 
GROUP BY sub_commodity_desc  
ORDER BY jumlah_product DESC;

---
--curr_size_of_product--
---
--check for nulls
SELECT curr_size_of_product 
FROM product
WHERE curr_size_of_product IS NULL;

--check for null after trims
SELECT curr_size_of_product 
FROM product
WHERE TRIM(curr_size_of_product) = ''

--update
UPDATE product
SET curr_size_of_product = NULL
WHERE TRIM(curr_size_of_product) = '';

--check for values distinct count by highes number and percentage
SELECT curr_size_of_product , 
COUNT(*) AS jumlah_product,
ROUND((COUNT(*)::numeric / SUM(COUNT(*))OVER())*100,2) AS persentase
FROM product 
GROUP BY curr_size_of_product  
ORDER BY jumlah_product DESC;


-- ============================================
-- campaign_desc
-- ============================================

---
--campaign--
---
--Check for null
SELECT campaign
FROM campaign_desc
WHERE campaign IS NULL --tidak ada null

--mengetahui urutan dari paling kecil ke paling besar identifier
SELECT DISTINCT campaign
FROM campaign_desc
ORDER BY campaign ASC

---
--description--
---
--Check for null
SELECT description
FROM campaign_desc
WHERE description IS NULL

--check for null after trims
SELECT description 
FROM campaign_desc
WHERE TRIM(description) = '' --tidak ada yg kosong juga

--CHheck distinct values
SELECT DISTINCT description 
FROM campaign_desc

--check total and percentage of each tipe campaign
SELECT description,
COUNT(*) AS jumlah_kampanye,
ROUND((COUNT(*)::numeric / SUM(COUNT(*))OVER())*100,2) AS persentase
FROM campaign_desc
GROUP BY description
ORDER BY CASE description
			WHEN 'TypeA' THEN 1
			WHEN 'TypeB' THEN 2
			WHEN 'TypeC' THEN 3
			END;

---
--start_day--
---
--check for null
SELECT start_day
FROM campaign_desc
WHERE start_day IS NULL --None

--check for distinct values
SELECT DISTINCT start_day
FROM campaign_desc

--check for same day campaign
SELECT DISTINCT start_day,
COUNT(*) AS Jumlah
FROM campaign_desc
GROUP BY start_day;

---
--end_day--
---
--check for null
SELECT end_day
FROM campaign_desc
WHERE end_day IS NULL

--check for distinct values
SELECT DISTINCT end_day
FROM campaign_desc

--check for same day campaign
SELECT DISTINCT end_day,
COUNT(*) AS Jumlah
FROM campaign_desc
GROUP BY end_day 
ORDER BY end_day ASC


-- ============================================
-- transaction_data
-- ============================================
--check semua tabel
SELECT *
FROM transaction_data

---
--Household_key--
---
--Check for null
SELECT Household_key
FROM transaction_data
WHERE Household_key IS NULL; --TIDAK ADA

--check for distinct values
SELECT DISTINCT Household_key 
FROM transaction_data

--check nilai tertinggi
SELECT MAX(Household_key) FROM transaction_data;

--check nilai terendah
SELECT MIN(Household_key) FROM transaction_data;

--household dengan pembelian terbanyak/tersedikit
SELECT Household_key,
COUNT(*) as Jumlah_belanja,
ROUND((COUNT(*)::numeric / SUM(COUNT(*))OVER())*100,2) AS persentase
From transaction_data
GROUP BY  Household_key
ORDER BY Jumlah_belanja ASC; -- or DESC just change it

---
--basket_id--
---
--check for null
SELECT basket_id
FROM transaction_data
WHERE basket_id IS NULL -- tidak ada null

--check for distinct values
SELECT DISTINCT basket_id
FROM transaction_data

--transaksi dengan jumlah pembelian produk terbanyak
SELECT basket_id,
COUNT(*) as Jumlah_produk,
ROUND((COUNT(*)::numeric / SUM(COUNT(*))OVER())*100,2) AS persentase
From transaction_data
GROUP BY  basket_id
ORDER BY Jumlah_produk DESC;

---
--day--
---
--check for null
SELECT day
FROM transaction_data
WHERE day IS NULL

--check for distinct values
SELECT COUNT(DISTINCT day) AS total_hari
FROM transaction_data

--hari paling awal dan akhir
SELECT MAX(DISTINCT day) --Ganti MIN untuk waktu hari paling awal
FROM transaction_data

--hari dengan jumlah dan persentase baris struk belanja terbanyak / TERSEDIKIT
SELECT day, COUNT(*) AS jumlah,
ROUND((COUNT(*)::numeric / SUM(COUNT(*))OVER())*100,2) AS persentase
FROM transaction_data
GROUP BY day
ORDER BY jumlah ASC --GANTI DESC untuk terbanyak

---
--product_id--
---
--Check for null
SELECT product_id
FROM transaction_data
WHERE product_id IS NULL; --none

--check for distinct values
SELECT DISTINCT product_id
FROM transaction_data

--jumlah baris pembelian produk terbanyak
SELECT product_id, COUNT(*) AS jumlah_baris_pembelian_produk,
ROUND((COUNT(*)::numeric / SUM(COUNT(*))OVER())*100,2) AS persentase
FROM transaction_data
GROUP BY product_id
ORDER BY jumlah_baris_pembelian_produk DESC 

---
--quantity--
---
--check for null
SELECT quantity 
FROM transaction_data
WHERE quantity IS NULL

--total jumlah quantity
SELECT SUM(quantity)
FROM transaction_data

--check for distinct values
SELECT DISTINCT quantity
FROM transaction_data -- kita menemukan kuantitas belanja 0 disini

--check berapa total coupon_disc berdasarkan quantity = 0
SELECT SUM(coupon_disc)
FROM transaction_data
WHERE quantity = 0

--check baris kuantitas 0 di product
SELECT * FROM product WHERE product_id IN (5978656, 5126087, 5126088, 5126106, 5126107);

-- Cek berapa banyak baris quantity=0 yang product_id-nya PUNYA data deskriptif lengkap
-- vs yang NULL semua (seperti 5978648)
SELECT 
    CASE WHEN p.department IS NULL THEN 'Tanpa Kategori (kemungkinan kode kupon)'
         ELSE 'Dengan Kategori (produk asli)'
    END AS jenis_produk,
    COUNT(DISTINCT t.product_id) AS jumlah_product_id_unik,
    COUNT(*) AS jumlah_baris
FROM transaction_data t
JOIN product p ON t.product_id = p.product_id
WHERE t.quantity = 0
GROUP BY CASE WHEN p.department IS NULL THEN 'Tanpa Kategori (kemungkinan kode kupon)'
              ELSE 'Dengan Kategori (produk asli)'
         END;


--Jumlah dan persentase baris terbanyak berdasarkan kuantitas
SELECT DISTINCT quantity,
COUNT(*) AS jumlah,
ROUND((COUNT(*)::numeric / SUM(COUNT(*))OVER())*100,2) AS persentase
FROM transaction_data
GROUP BY quantity
ORDER BY jumlah DESC


---
--sales_value
---
--check for null values
SELECT sales_value
FROM transaction_data
WHERE sales_value IS NULL --tidak ada yg kosong

--select distinct values
SELECT DISTINCT sales_value
FROM transaction_data

--total sales value jika dijumlahkan
SELECT SUM(sales_value)
FROM transaction_data

-- nilai transaksi terbesar dalam satu baris transaksi
SELECT DISTINCT sales_value
FROM transaction_data
ORDER BY sales_value DESC -- ubah ke asc untuk terkecil

--menghitung sales 0 dan kuantitas 0 vs kuantitas > 0 which mean free stuff or esenstialy promo
SELECT 
    CASE 
        WHEN quantity = 0 AND sales_value = 0 THEN 'Qty=0 & Sales=0 (kupon administratif)'
        WHEN quantity > 0 AND sales_value = 0 THEN 'Qty>0 & Sales=0 (barang gratis)'
        ELSE 'Lainnya'
    END AS kategori,
    COUNT(*) AS jumlah
FROM transaction_data
WHERE sales_value = 0
GROUP BY 1;


---
--store_id
---
--Check for null
SELECT store_id
FROM transaction_data
WHERE store_id IS  

--check for different values
SELECT DISTINCT store_id
FROM transaction_data

--toko dengan jumlah dan persentase baris terbanyak
SELECT store_id, COUNT(*) AS jumlah,
ROUND((COUNT(*)::numeric / SUM(COUNT(*))OVER())*100,2) AS persentase
FROM transaction_data
GROUP BY store_id
ORDER BY jumlah ASC --GANTI DESC untuk terbanyak

---
--retail_disc
---
--check for null
SELECT retail_disc
FROM transaction_data
WHERE retail_disc IS NULL

--check nilai unik
SELECT DISTINCT retail_disc
FROM transaction_data

--retail disc jika dijumlahkan
SELECT SUM(retail_disc)
FROM transaction_data

--nilai unik retail_disc tersedikit/terbanyak berdasarkan baris data 
SELECT retail_disc, COUNT(*) AS jumlah,
ROUND((COUNT(*)::numeric / SUM(COUNT(*))OVER())*100,2) AS persentase
FROM transaction_data
GROUP BY retail_disc
ORDER BY jumlah DESC --ganti ASC untuk tersedikit


---
--trans_time
---
--CHECK FOR NULL
SELECT trans_time
FROM transaction_data
WHERE trans_time IS NULL --tidak ada data yang kosong

--check for distinct values
SELECT DISTINCT trans_time
FROM transaction_data

--jumlah jam dengan baris transaksi terbanyak/tersedikit
SELECT trans_time, COUNT(*) AS jumlah,
ROUND((COUNT(*)::numeric / SUM(COUNT(*))OVER())*100,2) AS persentase
FROM transaction_data
GROUP BY trans_time
ORDER BY jumlah ASC

---
--week_no
---
--check for null
SELECT week_no
FROM transaction_data
WHERE week_no IS NULL

--search distinct values
SELECT DISTINCT week_no
FROM transaction_data

--minggu dengan jumlah baris transaction data tersedikit/Terbanyak
SELECT week_no, COUNT(*) AS jumlah,
ROUND((COUNT(*)::numeric / SUM(COUNT(*))OVER())*100,2) AS persentase
FROM transaction_data
GROUP BY week_no
ORDER BY jumlah ASC --ubah jadi DESC untuk terbanyak

---
--coupon_disc
---
--check for null
SELECT coupon_disc
FROM transaction_data
WHERE coupon_disc IS NULL

--Nilai unik
SELECT DISTINCT coupon_disc
FROM transaction_data

--NILAI TERTINGGI DAN TERTENDAH
SELECT DISTINCT MAX(coupon_disc) --TINGGAL GANTI MIN
FROM transaction_data

--total diskon dari produsen
SELECT SUM(coupon_disc)
FROM transaction_data

--angka unik copuon_disc dengan jumlah baris terbanyak
SELECT coupon_disc, COUNT(*) AS jumlah,
ROUND((COUNT(*)::numeric / SUM(COUNT(*))OVER())*100,2) AS persentase
FROM transaction_data
GROUP BY coupon_disc
ORDER BY jumlah DESC 


---
--coupon_disc
---
--check for null
SELECT coupon_match_disc
FROM transaction_data
WHERE coupon_match_disc IS NULL

--check distinct
SELECT DISTINCT coupon_match_disc
FROM transaction_data

--total pencocokan
SELECT SUM(coupon_match_disc)
FROM transaction_data

--nilai unik jumlah pencocokan dengan baris terbanyak
SELECT coupon_match_disc, COUNT(*) AS jumlah,
ROUND((COUNT(*)::numeric / SUM(COUNT(*))OVER())*100,2) AS persentase
FROM transaction_data
GROUP BY coupon_match_disc
ORDER BY jumlah DESC 


-- ============================================
-- campaign_table 
-- ============================================
---
--household_key
---
--check for null
SELECT household_key
FROM campaign_table
WHERE household_key IS NULL

--check for distinct values
SELECT DISTINCT household_key
FROM campaign_table

--rumah tangga yang menerima paling banyak kampanye marketing
SELECT household_key, COUNT(*) AS jumlah,
ROUND((COUNT(*)::numeric / SUM(COUNT(*))OVER())*100,2) AS persentase
FROM campaign_table 
GROUP BY household_key
ORDER BY jumlah DESC 

---
--campaign
---
--tidak ada nilai null
SELECT campaign
FROM campaign_table
WHERE campaign IS NULL

-- check distinct values
SELECT DISTINCT campaign
FROM campaign_table

--ID Kampanye dengan jumlah dan persentase penerima terbanyak dan tersedikit
SELECT campaign, COUNT(*) AS jumlah,
ROUND((COUNT(*)::numeric / SUM(COUNT(*))OVER())*100,2) AS persentase
FROM campaign_table 
GROUP BY campaign
ORDER BY jumlah ASC --ubah jadi desc untuk terbanyak

---
--description
---
--CHECK FOR NULL
SELECT description
FROM campaign_table 
WHERE description IS 

--CHECK FOR DISTINCT
SELECT DISTINCT description
FROM campaign_table 

--Tipe kampanye dan berapa banyak jumlah dan persentase rumah tangga penerima  
SELECT description, COUNT(*) AS jumlah,
ROUND((COUNT(*)::numeric / SUM(COUNT(*))OVER())*100,2) AS persentase
FROM campaign_table 
GROUP BY description
ORDER BY jumlah DESC



-- ============================================
-- coupon 
-- ============================================
--statsitik dasar tabel
SELECT * 
FROM coupon

---
--coupon_upc
---
--check for null
SELECT coupon_upc
FROM coupon
WHERE coupon_upc IS NULL

--trim untuk mencari nilai null dengan basis space
SELECT coupon_upc 
FROM coupon
WHERE TRIM(coupon_upc) = ''

--check distinct
SELECT DISTINCT coupon_upc 
FROM coupon

--kupon yang paling banyak berhubungan dengan produk dan campaign
SELECT coupon_upc, COUNT(*) AS jumlah,
ROUND((COUNT(*)::numeric / SUM(COUNT(*))OVER())*100,2) AS persentase
FROM coupon 
GROUP BY coupon_upc
ORDER BY jumlah DESC

---
--product_id
---
--CHECK FOR NULL
SELECT product_id
FROM coupon
WHERE product_id IS NULL

--CHECK FOR DISTINCT
SELECT DISTINCT product_id
FROM coupon

--produk yang paling sering diikutkan ke dalam program kupon diskon atau memiliki variasi kupon terbanyak 
SELECT product_id, COUNT(*) AS jumlah,
ROUND((COUNT(*)::numeric / SUM(COUNT(*))OVER())*100,2) AS persentase
FROM coupon 
GROUP BY product_id
ORDER BY jumlah DESC 

---
--campaign
---
--CHECK FOR NULL
SELECT campaign
FROM coupon
WHERE campaign IS NULL

--check for distinct value
SELECT DISTINCT campaign
FROM coupon

--campaign yang paling banyak hadir dalam penerbitan kupon! 
SELECT campaign, COUNT(*) AS jumlah,
ROUND((COUNT(*)::numeric / SUM(COUNT(*))OVER())*100,2) AS persentase
FROM coupon 
GROUP BY campaign
ORDER BY jumlah DESC 


-- ============================================
-- coupon_redempt 
-- ============================================
--statsitik dasar tabel
SELECT *
FROM coupon_redempt

---
--household_key
---
--Check for null
SELECT household_key
FROM coupon_redempt
WHERE household_key IS NULL

--check for distinct values
SELECT DISTINCT household_key
FROM coupon_redempt

--rumah tangga terbanyak yang menukar kupon
SELECT household_key, COUNT(*) AS jumlah,
ROUND((COUNT(*)::numeric / SUM(COUNT(*))OVER())*100,2) AS persentase
FROM coupon_redempt 
GROUP BY household_key
ORDER BY jumlah DESC

---
--day
---
--Check for null 
SELECT day 
FROM coupon_redempt
WHERE day IS NULL

--Check for distinct
SELECT DISTINCT day
FROM coupon_redempt

--check for last dan first day
SELECT DISTINCT MIN(day) --just change to MAX 
FROM coupon_redempt

--hari dengan pengguna kupon terbanyak
SELECT day, COUNT(*) AS jumlah,
ROUND((COUNT(*)::numeric / SUM(COUNT(*))OVER())*100,2) AS persentase
FROM coupon_redempt 
GROUP BY day
ORDER BY jumlah DESC


---
--coupon_upc
---
--Check for null
SELECT coupon_upc
FROM coupon_redempt
WHERE coupon_upc IS NULL

--check for distinct values
SELECT DISTINCT coupon_upc
FROM coupon_redempt

--Kupon dengan jumlah penukaran terbanyak
SELECT coupon_upc, COUNT(*) AS jumlah,
ROUND((COUNT(*)::numeric / SUM(COUNT(*))OVER())*100,2) AS persentase
FROM coupon_redempt 
GROUP BY coupon_upc
ORDER BY jumlah DESC

---
--coupon_upc
---
--check for null
SELECT campaign
FROM coupon_redempt
WHERE campaign IS NULL

--Check for distinct values
SELECT DISTINCT campaign
FROM coupon_redempt

--Kampanye dengan kupon paling sedikit/banyak ditukar
SELECT campaign, COUNT(*) AS jumlah,
ROUND((COUNT(*)::numeric / SUM(COUNT(*))OVER())*100,2) AS persentase
FROM coupon_redempt 
GROUP BY campaign
ORDER BY jumlah ASC -- ganti DESC untuk banyak


-- ============================================
-- causal_data
-- ============================================
--statistik dasar
SELECT *
FROM causal_data

---
--product_id
---
--check for null
SELECT product_id
FROM causal_data
WHERE product_id IS NULL

--check for distinct product
SELECT DISTINCT product_id
FROM causal_data

--produk dengan total kemunculan terbanyak dalam baris data
SELECT product_id,
COUNT(*) AS JUMLAH
FROM causal_data
GROUP BY product_id
ORDER BY JUMLAH DESC

---
--store_id
---
--Check for null
SELECT store_id
FROM causal_data
WHERE store_id IS NULL

--check for distinct
SELECT DISTINCT store_id
FROM causal_data

--Toko dengan total kemunculan terbanyak dalam baris data
SELECT store_id,
COUNT(*) AS JUMLAH
FROM causal_data
GROUP BY store_id
ORDER BY JUMLAH DESC
 

---
--week_no
---
--Check for null
SELECT week_no
FROM causal_data
WHERE week_no IS NULL

--check for distinct
SELECT DISTINCT week_no
FROM causal_data

--minggu dengan total kemunculan tersedikit/terbanyak dalam baris data
SELECT week_no,
COUNT(*) AS JUMLAH
FROM causal_data
GROUP BY week_no
ORDER BY JUMLAH ASC --ubah ke DESC untuk terbanyak

---
--display
---
--check for null
SELECT display
FROM causal_data
WHERE display IS NULL

--Check for distinct
SELECT DISTINCT display
FROM causal_data

--peletakan display terbanyak berdasarkan baris data
SELECT display,
COUNT(*) AS JUMLAH
FROM causal_data
GROUP BY display
ORDER BY JUMLAH DESC

---
--mailer
---
--check for null
SELECT mailer
FROM causal_data
WHERE mailer IS NULL

--check for distinct
SELECT DISTINCT mailer
FROM causal_data

--peletakan di dalam iklan terbanyak berdasarkan baris data yang ada
SELECT mailer,
COUNT(*) AS JUMLAH
FROM causal_data
GROUP BY mailer
ORDER BY JUMLAH DESC

