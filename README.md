# Analisis RFM untuk Rekomendasi Optimasi Profitabilitas Bisnis Retail

Analisis segmentasi pelanggan menggunakan metode **RFM (Recency, Frequency, Monetary)** pada data transaksi retail Dunnhumby "The Complete Journey", untuk merumuskan rekomendasi bisnis yang dapat meningkatkan profitabilitas melalui strategi Winback, pembentukan kebiasaan belanja, dan diversifikasi kategori produk.

> **Status:** Selesai — 20 Agustus 2026
> **Analis:** Rahel ([@Rahelxv](https://github.com/Rahelxv))

---

## 1. Latar Belakang

Dunnhumby adalah perusahaan data sains pelanggan yang menganalisis data — terutama dari peritel — untuk memberikan wawasan mengenai perilaku dan preferensi pelanggan. Wawasan ini membantu peritel dan perusahaan barang konsumen kemasan (CPG) mengambil keputusan berbasis data terkait penetapan harga, promosi, ragam produk, dan pemasaran yang dipersonalisasi. Dunnhumby dikenal karena kiprahnya dalam program loyalitas dan pemanfaatan data transaksi (Sumble, 2026).

Data yang digunakan merupakan data transaksi retail asli yang telah disamarkan (*anonymization*) oleh Dunnhumby untuk menjaga privasi pelanggan, tersedia secara resmi melalui [dunnhumby Source Files](https://www.dunnhumby.com/source-files/). Karena berasal dari data pengguna asli yang diambil dan diproses secara etis, dataset ini memenuhi standar untuk analisis data yang kredibel.

## 2. Tugas Bisnis (Business Task)

> Mengelompokkan pelanggan retail berdasarkan perilaku belanja (Recency, Frequency, Monetary) sebagai sarana rekomendasi pengambilan keputusan bisnis untuk meningkatkan profitabilitas bisnis retail.

**Pertanyaan yang dijawab:**
- Berapa nilai Recency, Frequency, dan Monetary dari tiap rumah tangga?
- Bagaimana pengelompokan perilaku pelanggan berdasarkan nilai RFM, dan bagaimana profil (rata-rata R, F, M) tiap kelompok tersebut?
- Apa karakteristik demografi pelanggan tiap kategori RFM?
- Apa kategori produk yang paling sering dibeli oleh pelanggan berdasarkan kelompok RFM?
- Tipe kampanye apa yang paling berdampak berdasarkan kategori RFM?

## 3. Metodologi

Project ini menggunakan kerangka kerja **Recency, Frequency, Monetary (RFM) Analysis**, dengan skema skoring *quantile* 1–5 untuk tiap variabel, dilengkapi analisis lanjutan berikut:

| Tahap Analisis | Deskripsi |
| --- | --- |
| **Segmentasi RFM** | Skoring quantile (1–5) untuk Recency, Frequency, Monetary → pembentukan 7 segmen pelanggan |
| **Cohort Analysis** | Menguji hipotesis retensi pelanggan berdasarkan bulan mulai bertransaksi |
| **Affinity Index Analysis** | Mengukur preferensi produk tiap segmen dibanding rata-rata populasi |
| **Analisis Kampanye** | Menghitung *engagement rate* dan efektivitas tiap tipe kampanye per segmen RFM |
| **Rekomendasi Aksi** | Strategi bertahap Winback → Habit-Building → Diversifikasi per segmen |

## 4. Data

| Data | Sumber | Cakupan | Keterangan |
| --- | --- | --- | --- |
| Data transaksi & profil rumah tangga | [Dunnhumby "The Complete Journey"](https://www.dunnhumby.com/source-files/) | 2.500 rumah tangga, ± 2 tahun | CSV bawaan diubah menjadi database PostgreSQL — 8 tabel bawaan + 1 tabel agregasi |

## 5. Ringkasan Temuan Utama

- **3 segmen teratas** (Champion, Loyalist, Potential Loyalist — 41,52% populasi) menyumbang **71,35%** total pendapatan retail.
- **44% populasi** (Occasional Customer, Risk of Losing, Lost) hanya menyumbang **17,45%** pendapatan — bukan karena Average Order Value rendah (justru kompetitif), melainkan karena Frequency dan Recency yang rendah.
- **Cohort analysis** membuktikan retensi bisnis stabil di **77–84%** sepanjang 2 tahun, sehingga hipotesis awal "masalah churn masif" terpatahkan. Arah analisis bergeser ke optimasi segmen yang menunjukkan penurunan aktivitas spesifik.
- **Kampanye TypeA** merupakan kampanye paling efektif dengan *engagement rate* 2x lipat dibanding tipe lain, sementara segmen **Risk of Losing** menunjukkan respons kampanye tinggi sehingga krusial untuk prioritas *re-engagement*.
- Rekomendasi aksi disusun berjenjang mengikuti tiga strategi berurutan: **Winback** (menarik kembali pelanggan tidak aktif) → **Habit-Building** (membangun kebiasaan belanja via Model Hook) → **Diversifikasi** (mendorong belanja kategori seasonal/niche di luar kebutuhan harian).

Detail lengkap perhitungan segmentasi, affinity index, dan rekomendasi per segmen ada di dokumentasi proses dan laporan akhir.

## 6. Struktur Repository

```
.
├── code/      # Query SQL: pembuatan database, pembersihan & pengecekan data, serta analisis RFM
├── picture/   # Visualisasi hasil analisis (RFM, cohort, demografi, kampanye, produk, dashboard)
└── reports/   # Laporan akhir & dokumentasi proses analisis (PDF)
```

| Folder | Isi |
| --- | --- |
| `code/` | `database.sql` (pembuatan struktur database), `query-check-and-clean-data.sql` (pengecekan & pembersihan data), `analyze.sql` (query analisis RFM) |
| `picture/` | Visualisasi: Cohort analysis, Distribusi RFM, RFM visualization, Skema tabel VIZ, Statistics_demographic, Statistics_kampanye, Statistics_product, Dashboard |
| `reports/` | *Laporan Akhir - Analisis RFM untuk Segmentasi dan Profil Demografi Pelanggan Retail*, *Proses - Analisis RFM untuk Rekomendasi Optimasi Profitabilitas Bisnis Retail* |

## 7. Tools & Tech Stack

| Kategori | Tools |
| --- | --- |
| Penyimpanan & Query Data | PostgreSQL, SQL |
| Visualisasi & Dashboard | Tableau Public, Power BI |
| Pengolahan Data Pendukung | Spreadsheet |
| Version Control | GitHub |

## 8. Batasan & Catatan Metodologis

- Data demografi tidak digunakan dalam sebagian analisis karena ditemukan *null* sistematis pada kolom terkait — berpotensi menimbulkan bias jika tetap digunakan.
- *Affinity Index* dihitung dengan filter minimum 100 transaksi per produk (mencegah *small denominator effect*) dan ambang indeks ≥120 (preferensi segmen minimal 1,2x populasi umum).
- *Engagement rate* kampanye mengukur proporsi rumah tangga unik yang melakukan *redeem* terhadap total rumah tangga yang ditargetkan kampanye — bukan *redemption rate* di level kupon, karena keterbatasan data distribusi kupon per rumah tangga.
- Prioritas strategi *winback* difokuskan pada pelanggan dengan Recency < 90 hari; di luar rentang tersebut, ketidakaktifan lebih mungkin disebabkan faktor eksternal (mis. pindah lokasi) sehingga kurang *cost-efficient* untuk ditarget.

## 9. Author

**Rahel** — Data Analyst (portfolio project)
GitHub: [@Rahelxv](https://github.com/Rahelxv)

---

*Project ini dibuat sebagai bagian dari portofolio data analyst.*
