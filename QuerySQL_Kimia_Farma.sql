
-- Membuat tabel analisa dengan kolom-kolom yang dibutuhkan
--CREATE TABLE dataset_rakamin.analisa AS 
--WITH product_laba AS (
    -- Menambahkan persentase laba berdasarkan harga produk
   -- SELECT 
     --   pr.product_id,
     --   pr.product_name,
     --   pr.price AS actual_price,
    --    CASE 
    --        WHEN pr.price <= 50000 THEN 0.10
    --        WHEN pr.price > 50000 AND pr.price <= 100000 THEN 0.15
      --      WHEN pr.price > 100000 AND pr.price <= 300000 THEN 0.20
        --    WHEN pr.price > 300000 AND pr.price <= 500000 THEN 0.25
       --     ELSE 0.30
      --  END AS persentase_gross_laba
    --FROM 
     --   dataset_rakamin.kf_product AS pr
--),
--nett_sales_calc AS (
    -- Menghitung nett sales berdasarkan harga dan diskon
    --SELECT
        --ft.transaction_id,
        --ft.date,
        --ft.branch_id,
        --ft.customer_name,
        --ft.product_id,
        --ft.price AS actual_price,
        --ft.discount_percentage,
       -- ROUND((ft.price - (ft.price * ft.discount_percentage / 100)), 2) AS nett_sales,
     --   ft.rating AS rating_transaksi
   -- FROM 
 --       dataset_rakamin.kf_final_transaction AS ft
--)

-- Gabungkan data dari tabel branch, product_laba, dan nett_sales_calc
--SELECT 
    --ns.transaction_id,
    --ns.date,
    --cb.branch_id,
    --cb.branch_name,
    --cb.kota,
    --cb.provinsi,
   -- cb.rating AS rating_cabang,
  -- ns.customer_name,
   -- ns.product_id,
   -- pl.product_name,
   -- ns.actual_price,
   -- ns.discount_percentage,
   -- pl.persentase_gross_laba,
   -- ns.nett_sales,
   -- ROUND((ns.nett_sales * COALESCE(pl.persentase_gross_laba, 0)), 2) AS nett_profit,
   -- ns.rating_transaksi
--FROM 
 --   nett_sales_calc ns -- Menggunakan dataset_rakamin
--LEFT JOIN 
  --  product_laba pl ON ns.product_id = pl.product_id 
--LEFT JOIN
----    dataset_rakamin.kf_kantor_cabang cb ON ns.branch_id = cb.branch_id;



# Analisis penjualan harian pada bulan mei di provinsi DKI Jakarta
SELECT 
    date, 
    SUM(nett_sales) AS total_sales, 
    AVG(nett_sales) AS avg_sales,   
    MAX(nett_sales) AS max_sales,    
    MIN(nett_sales) AS min_sales     
FROM 
    dataset_rakamin.analisa
WHERE 
    EXTRACT(MONTH FROM date) = 5  
    AND provinsi = 'DKI Jakarta'  
GROUP BY 
    date
ORDER BY 
    date;



#mencari rata-rata penjualan, penjualan terbesar, penjualan terkecil pada setiap nama cabang
SELECT 
    branch_name, 
    kota, 
    provinsi, 
    AVG(nett_sales) AS avg_sales,  -- Rata-rata penjualan
    MAX(nett_sales) AS max_sales,  -- Penjualan terbesar
    MIN(nett_sales) AS min_sales   -- Penjualan terkecil
FROM 
    dataset_rakamin.analisa
GROUP BY 
    branch_name, kota, provinsi
ORDER BY 
    branch_name;



# mencari Top 5 cabang dengan rating tertinggi
SELECT 
    branch_name, 
    kota, 
    provinsi, 
    rating_cabang,
    SUM(nett_sales) AS total_sales, 
    SUM(nett_profit) AS total_profit
FROM 
    dataset_rakamin.analisa
GROUP BY 
    branch_name, kota, provinsi, rating_cabang
ORDER BY 
    rating_cabang DESC
LIMIT 5;


# analisis penjualan mingguan pada bulan Februari 2021
WITH agg_february AS (
    SELECT 
        EXTRACT(week FROM date) AS week_num,  
        SUM(nett_sales) AS total_sales,       
        ROUND(SUM(nett_sales), 2) AS revenue   
    FROM 
        dataset_rakamin.analisa
    WHERE 
        date BETWEEN '2021-02-01' AND '2021-02-28'  
    GROUP BY 
        week_num
    ORDER BY 
        week_num
)

SELECT 
    *,
    CASE 
        WHEN week_num = 5 THEN 'Minggu -1'
        WHEN week_num = 6 THEN 'Minggu -2'
        WHEN week_num = 7 THEN 'Minggu -3'
        WHEN week_num = 8 THEN 'Minggu -4'
        ELSE 'Minggu -5' 
    END AS minggu
FROM 
    agg_february;


# Perbandingan total revenue dari seluruh provinsi
SELECT 
    cb.provinsi,                         
    ROUND(SUM(ns.nett_sales), 2) AS total_revenue  
FROM 
    dataset_rakamin.analisa AS ns
LEFT JOIN 
    dataset_rakamin.kf_kantor_cabang AS cb 
    ON ns.branch_id = cb.branch_id      
GROUP BY 
    cb.provinsi                       
ORDER BY 
    total_revenue DESC;                 



# mencari Pembeli terbanyak di bulan juni  di provinsi jawa barat
WITH pembeli_bulan_juni AS (
    SELECT 
        ft.customer_name,                             
        COUNT(ft.transaction_id) AS jumlah_transaksi   
    FROM 
        dataset_rakamin.kf_final_transaction AS ft
    LEFT JOIN 
        dataset_rakamin.kf_kantor_cabang AS cb 
        ON ft.branch_id = cb.branch_id              
    WHERE 
        cb.provinsi = 'Jawa Barat'                   
        AND ft.date BETWEEN '2022-06-01' AND '2022-06-30' 
    GROUP BY 
        ft.customer_name                              
)

SELECT 
    customer_name, 
    jumlah_transaksi 
FROM 
    pembeli_bulan_juni
ORDER BY 
    jumlah_transaksi DESC
LIMIT 10;


# Total Rating Cabang per Provinsi
SELECT 
    cb.provinsi, 
    AVG(cb.rating) AS avg_rating
FROM 
    dataset_rakamin.kf_kantor_cabang AS cb
GROUP BY 
    cb.provinsi
ORDER BY 
    avg_rating DESC;



# Analisis Penjualan Berdasarkan Tahun
SELECT 
    EXTRACT(YEAR FROM date) AS year,
    SUM(nett_sales) AS total_sales
FROM 
    dataset_rakamin.analisa
GROUP BY 
    year
ORDER BY 
    year;



-- Query lebih lengkap bisa di lihat di Google Big Query




