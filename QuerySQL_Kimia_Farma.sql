-- Membuat tabel analisa dengan kolom-kolom yang dibutuhkan
--CREATE  TABLE `dataset_rakamin.tabel_analisis` AS
--SELECT 
   -- ft.transaction_id,
   -- ft.date,
  --  ft.branch_id,
 --   cb.branch_name,
  --  cb.kota,
  --  cb.provinsi,
 --   cb.rating AS rating_cabang,
  --  ft.customer_name,
 --   ft.product_id,
  --  pr.product_name,
  --  pr.price AS actual_price,
  --  ft.discount_percentage,
    
 --   CASE
     --   WHEN pr.price <= 50000 THEN 0.10
     --   WHEN pr.price > 50000 AND pr.price <= 100000 THEN 0.15
      --  WHEN pr.price > 100000 AND pr.price <= 300000 THEN 0.20
      --  WHEN pr.price > 300000 AND pr.price <= 500000 THEN 0.25
       -- ELSE 0.30
  --  END AS persentase_gross_laba,
--
    --(pr.price * (1 - ft.discount_percentage)) AS nett_sales,
    --((pr.price * (1 - ft.discount_percentage)) * 
       -- CASE
           -- WHEN pr.price <= 50000 THEN 0.10
            -- WHEN pr.price > 50000 AND pr.price <= 100000 THEN 0.15
            -- WHEN pr.price > 100000 AND pr.price <= 300000 THEN 0.20
          --  WHEN pr.price > 300000 AND pr.price <= 500000 THEN 0.25
        --    ELSE 0.30
      --  END
    --) AS nett_profit,

  --  ft.rating AS rating_transaksi

--FROM 
  --  `dataset_rakamin.kf_final_transaction` ft
--LEFT JOIN 
  --  `dataset_rakamin.kf_kantor_cabang` cb ON ft.branch_id = cb.branch_id
--LEFT JOIN 
 --   `dataset_rakamin.kf_product` pr ON ft.product_id = pr.product_id;





 # Total Penjualan Percabang
SELECT 
    branch_name, 
    kota, 
    provinsi, 
    SUM(nett_sales) AS total_sales
FROM 
    `dataset_rakamin.tabel_analisis`
GROUP BY 
    branch_name, 
    kota, 
    provinsi
ORDER BY 
    total_sales DESC;


# Total Laba per cabang
SELECT 
    branch_name, 
    kota, 
    provinsi, 
    SUM(nett_profit) AS total_profit
FROM 
    `dataset_rakamin.tabel_analisis`
GROUP BY 
    branch_name, 
    kota, 
    provinsi
ORDER BY 
    total_profit DESC;




# Pengaruh Diskon terhadap Penjualan
SELECT 
    discount_percentage, 
    COUNT(transaction_id) AS jumlah_transaksi, 
    SUM(nett_sales) AS total_sales,
    SUM(nett_profit) AS total_profit
FROM 
    `dataset_rakamin.tabel_analisis`
GROUP BY 
    discount_percentage
ORDER BY 
    total_sales DESC;



# Mencari Pembeli Terbanyak di Bulan Juni di Provinsi Jawa Barat
SELECT 
    customer_name, 
    COUNT(transaction_id) AS jumlah_transaksi
FROM 
    `dataset_rakamin.tabel_analisis`
WHERE 
    EXTRACT(MONTH FROM date) = 6 
    AND provinsi = 'Jawa Barat'
GROUP BY 
    customer_name
ORDER BY 
    jumlah_transaksi DESC
LIMIT 5;



# Rata-rata Penjualan, Penjualan Terbesar, Penjualan Terkecil pada Setiap Nama Cabang
SELECT 
    branch_name, 
    kota, 
    provinsi,
    AVG(nett_sales) AS avg_sales,
    MAX(nett_sales) AS max_sales,
    MIN(nett_sales) AS min_sales
FROM 
    `dataset_rakamin.tabel_analisis`
GROUP BY 
    branch_name, 
    kota, 
    provinsi
ORDER BY 
    avg_sales DESC;



-- Query lebih lengkap bisa di lihat di Google Big Query




