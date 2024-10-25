-- Membuat tabel analisa dengan kolom-kolom yang dibutuhkan
--CREATE TABLE dataset_rakamin.table_analisis AS
--SELECT
--  t.transaction_id,
--  t.date,
--  c.branch_id,
--  c.branch_category,
 -- c.branch_name,
--  c.kota,
--  c.provinsi,
--  c.rating AS rating_cabang,
--  t.customer_name,
--  p.product_id,
--  p.product_name,
--  t.price AS actual_price,
--  t.discount_percentage,
 -- CASE
   -- WHEN t.price <= 50000 THEN 0.10
   -- WHEN t.price > 50000 AND t.price <= 100000 THEN 0.15
   -- WHEN t.price > 100000 AND t.price <= 300000 THEN 0.20
  --  WHEN t.price > 300000 AND t.price <= 500000 THEN 0.25
  --  ELSE 0.30
 -- END AS persentase_gross_laba,
 -- (t.price - (t.price * t.discount_percentage)) AS nett_sales,
 -- ((t.price - (t.price * t.discount_percentage)) * 
  --  CASE
   --   WHEN t.price <= 50000 THEN 0.10
   --   WHEN t.price > 50000 AND t.price <= 100000 THEN 0.15
   --   WHEN t.price > 100000 AND t.price <= 300000 THEN 0.20
  --    WHEN t.price > 300000 AND t.price <= 500000 THEN 0.25
   --   ELSE 0.30
 --   END) AS nett_profit,
--  t.rating AS rating_transaksi,
--  i.opname_stock AS Inventory  
--FROM
--  `projectbasedintern.dataset_rakamin.kf_final_transaction` AS t
--JOIN
 -- `projectbasedintern.dataset_rakamin.kf_kantor_cabang` AS c ON t.branch_id = c.branch_id
--JOIN
--  `projectbasedintern.dataset_rakamin.kf_product` AS p ON t.product_id = p.product_id
--JOIN
  --`projectbasedintern.dataset_rakamin.kf_inventory` AS i ON t.branch_id = i.branch_id AND t.product_id = i.product_id
--ORDER BY RAND()  






# Rata-rata Rating per Cabang
SELECT 
    branch_name, 
    ROUND(AVG(rating_transaksi), 2) AS avg_rating_transaksi
FROM 
    projectbasedintern.dataset_rakamin.table_analisis
GROUP BY 
    branch_name
ORDER BY 
    avg_rating_transaksi DESC;

# 5 Cabang dengan Laba Bersih Tertinggi
SELECT 
    branch_name, 
    provinsi, 
    ROUND(SUM(nett_profit), 2) AS total_nett_profit
FROM 
    projectbasedintern.dataset_rakamin.table_analisis
GROUP BY 
    branch_name, provinsi
ORDER BY 
    total_nett_profit DESC
LIMIT 5;

# Total Penjualan per Produk
SELECT 
    product_name, 
    ROUND(SUM(nett_sales), 2) AS total_sales
FROM 
    projectbasedintern.dataset_rakamin.table_analisis
GROUP BY 
    product_name
ORDER BY 
    total_sales DESC;

# Performa Cabang Berdasarkan Kategori
SELECT 
    branch_category, 
    ROUND(SUM(nett_profit), 2) AS total_nett_profit
FROM 
    projectbasedintern.dataset_rakamin.table_analisis
GROUP BY 
    branch_category
ORDER BY 
    total_nett_profit DESC;

# Analisis Margin Laba Kotor
SELECT 
    branch_name, 
    ROUND(AVG(persentase_gross_laba), 2) AS avg_gross_profit_margin
FROM 
    projectbasedintern.dataset_rakamin.table_analisis
GROUP BY 
    branch_name
ORDER BY 
    avg_gross_profit_margin DESC;

# Analisis Penjualan Tahunan Berdasarkan Provinsi (2020-2023)
SELECT 
    b.provinsi, 
    EXTRACT(YEAR FROM t.date) AS tahun, 
    ROUND(SUM(t.nett_sales), 2) AS total_penjualan_tahunan
FROM 
    projectbasedintern.dataset_rakamin.table_analisis t
LEFT JOIN 
    projectbasedintern.dataset_rakamin.kf_kantor_cabang b ON t.branch_id = b.branch_id
WHERE 
    EXTRACT(YEAR FROM t.date) BETWEEN 2020 AND 2023  
GROUP BY 
    b.provinsi, 
    EXTRACT(YEAR FROM t.date)
ORDER BY 
    b.provinsi, 
    tahun
LIMIT 10;


-- Query lebih lengkap bisa di lihat di Google Big Query




