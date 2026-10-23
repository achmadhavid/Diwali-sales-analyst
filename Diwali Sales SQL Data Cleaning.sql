/*
Laporan Penjualan Diwali: Pembersihan Data dalam SQL

# Tujuan: Tujuan dari proses ini adalah untuk membersihkan dan menyiapkan kumpulan data mentah penjualan Diwali
untuk analisis dengan mengatasi nilai yang hilang, duplikat, dan inkonsistensi lainnya.

# Langkah yang Diambil
- Hapus kolom yang tidak relevan
- Nilai-nilai standar
- Menangani nilai yang hilang
- Menghapus catatan duplikat


*/
Select * 
From project..Diwali_Sales_Data;


-- Jatuhkan kolom bernama status dan tanpa nama

Alter Table project..Diwali_Sales_Data
Drop column Status;

Alter Table project..Diwali_Sales_Data
Drop column unnamed1;



-- Tambahkan kolom baru 'Shaadi' dan Ganti nilai 0 sebagai 'Tidak' dan 1 sebagai 'Ya'.Hapus kolom Marital_Status
Select Marital_Status,
	case 
		When Marital_Status = 0 Then 'No'
        Else 'Yes'
        End As Shaadi
From project..Diwali_Sales_Data;


Alter Table project..Diwali_Sales_Data
Add Shaadi varchar(5);

UPDATE project..Diwali_Sales_Data
SET Shaadi = CASE
    WHEN Marital_Status = 0 THEN 'No'
    WHEN Marital_Status = 1 THEN 'Yes'
END;

Alter Table project..Diwali_Sales_Data
Drop column Marital_Status;
	

        
-- Ganti nilai kolom Gender menjadi Female dan Male.
Select Gender,
	Case 
		When Gender = 'F' Then 'Female'
		When Gender = 'M' Then 'Male'
		End
From project..Diwali_Sales_Data


update project..Diwali_Sales_Data
Set Gender = Case 
		When Gender = 'F' Then 'Female'
		When Gender = 'M' Then 'Male'
		End;



-- Jatuhkan Baris di mana Jumlahnya Null

Select *
From project..Diwali_Sales_Data
Where Amount is NULL;



Delete from project..Diwali_Sales_Data
Where Amount is Null;



-- Periksa apakah ada nilai duplikat

With duplicate_value as(
Select *,
ROW_NUMBER() over(Partition By User_ID, Cust_name, Product_ID, Gender, Age, Product_Category, Occupation, Orders, Amount, Shaadi
				order by User_ID) Row_num
From project..Diwali_Sales_Data
) Select * 
From duplicate_value
Where Row_num > 1;

-- Kumpulan Data berisi 64 nilai duplikat.Jadi mari kita hapus


With delete_duplicate_value As(
Select *,
ROW_NUMBER() over(Partition By 
						User_ID, Cust_name, Product_ID, Gender, Age, Product_Category, Occupation, Orders, Amount, Shaadi
						order by User_ID) Row_num
From project..Diwali_Sales_Data
)
Delete 
From delete_duplicate_value
Where Row_num > 1;



-- Umur dan Kelompok Umur

Alter Table project..Diwali_Sales_Data
Add Age_Group varchar(10)


update project..Diwali_Sales_Data
Set Age_Group = Case 
		When Age < 18 Then 'Below 18'
		When Age >=18 AND Age <=35 then '18-35'
		When Age > 35 And Age <=50 Then '36-50'
		When Age >50 And Age <= 60 Then '50-60'
		When Age > 60 Then '60+'
		End;

/*
Dengan select_age sebagai(
Pilih Usia,
Kasus
Bila Usia < 18 Maka 'Di Bawah 18'
Jika Usia >=18 DAN Usia <=35 maka '18-35'
Bila Usia > 35 Dan Usia <=50 Maka '36-50'
Bila Usia >50 Dan Usia <= 60 Maka '50-60'
Bila Usia > 60 Maka '60+'
Berakhir Sebagai Age_Group
Dari proyek..Diwali_Sales_Data
)
Pilih *
Dari select_age
Dimana Umur = 18;
*/

Select Age, Age_Group
From project..Diwali_Sales_Data
Where Age = 18 
Or Age = 36;