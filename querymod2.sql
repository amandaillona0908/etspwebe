-- Amanda Illona Farrel --
-- 5025221103 --
-- Sistem Basis Data (G) --
-- Modul Pendahuluan 2 --

-- 1 --
#membuat database Kedai Kopi Nuri
CREATE DATABASE nuri_mod2

#membuat tabel entitas Customer
CREATE TABLE Customer (
	ID_customer CHAR(6) NOT NULL PRIMARY KEY,
	Nama_customer VARCHAR(100)
);

#membuat tabel entitas Pegawai
CREATE TABLE Pegawai (
	NIK CHAR(16) NOT NULL PRIMARY KEY,
	Nama_pegawai VARCHAR(100),
	Jenis_kelamin CHAR(1),
	Email VARCHAR(50),
	Umur INT
);

#membuat tabel entitas Transaksi
CREATE TABLE Transaksi (
	ID_transaksi CHAR(10) NOT NULL PRIMARY KEY,
	Tanggal_transaksi DATE,
	Metode_pembayaran VARCHAR(15),
	ID_customer CHAR(6),
	NIK CHAR(16),
	CONSTRAINT Transaksi_Customer_FK FOREIGN KEY (ID_customer) REFERENCES Customer(ID_customer),
	CONSTRAINT Transaksi_Pegawai_FK FOREIGN KEY (NIK) REFERENCES Pegawai(NIK)
);

#membuat tabel entitas Menu_Minuman
CREATE TABLE Menu_minuman (
	ID_minuman CHAR(6) NOT NULL PRIMARY KEY,
	Nama_minuman VARCHAR(50),
	Harga_minuman FLOAT(2)
);

#membuat tabel entitas Telepon
CREATE TABLE Telepon (
	No_telp_pegawai VARCHAR(15) NOT NULL PRIMARY KEY,
	NIK CHAR(16),
	CONSTRAINT Telepon_Pegawai_FK FOREIGN KEY (NIK) REFERENCES pegawai(NIK)
);

#membuat tabel entitas Transaksi_minuman
CREATE TABLE Transaksi_minuman (
	TM_Menu_minuman_ID CHAR(6),
	TM_Transaksi_ID CHAR(10),
	Jumlah_cup INT,
	CONSTRAINT Transaksi_minuman_PK PRIMARY KEY (TM_Menu_minuman_ID, TM_Transaksi_ID),
	CONSTRAINT TM_ID_Menu_minuman_FK FOREIGN KEY (TM_Menu_minuman_ID) REFERENCES Menu_minuman(ID_minuman),
	CONSTRAINT TM_ID_Transaksi_FK FOREIGN KEY (TM_Transaksi_ID) REFERENCES Transaksi(ID_transaksi)
);

-- 2 --
#membuat tabel entitas membership
CREATE TABLE Membership (
	ID_membership CHAR(6),
	No_telepon_customer VARCHAR(15),
	Alamat_customer VARCHAR(100),
	Tanggal_pembuatan_kartu_membership DATE,
	Tanggal_kadaluwarsa_kartu_membership DATE,
	Total_poin INT,
	ID_customer CHAR(6)
);

-- 2 A --
#membuat ID_membership sebagai primary key
ALTER TABLE Membership ADD CONSTRAINT Membership_PK PRIMARY KEY (ID_membership);

-- 2 B --
#menjadikan ID_customer FK (tabel Membership dari tabel Customer)
#bisa update  otomatis
#tidak bisa dihapus ketika sudah jadi member
#restrict (jika id tabel A dihapus, pada tabel B tidak diperbolehkan ada id yang berelasi)
ALTER TABLE Membership
ADD CONSTRAINT Membership_Customer_FK FOREIGN KEY (ID_customer) REFERENCES customer(ID_customer)
ON UPDATE CASCADE
ON DELETE RESTRICT;

-- 2 C --
#karena tadi di awal saya langsung mengFKkan sesuai gambar, maka saya drop dulu 
ALTER TABLE Transaksi
DROP CONSTRAINT Transaksi_Customer_FK

#menjadikan ID_customer FK (tabel transaksi dari tabel customer)
#menjadikannya kondisi ON UPDATE CASCADE & ON DELETE CASCADE
#cascade (anak akan berubah sesuai induknya, entah itu dihapus atau diupdate)
ALTER TABLE Transaksi
ADD CONSTRAINT Transaksi_Cusomer_FK FOREIGN KEY (ID_customer) REFERENCES customer(ID_customer)
ON UPDATE CASCADE
ON DELETE CASCADE;

-- 2 D --
#menjadikan nilai default (tanggal sekarang) pada tanggal_pembuatan_kartu_membership dg fungsi build-in
ALTER TABLE Membership
MODIFY Tanggal_pembuatan_kartu_membership DATE DEFAULT CURDATE();

-- 2 E --
#menambahkan constraint pada total_poin dengan pengecekan bersyarat lebih dari atau sama dengan 0
ALTER TABLE Membership
ADD CONSTRAINT Check_Total_poin CHECK (Total_poin>=0); 

-- 2 F --
#mengganti length menjadi 140 dan maksimal 150 pada Alamat_customer
#varchar (boleh diisi berapapun, ada maksimalnya sesuai length yang dikasih)
#char (panjangnya harus segitu)
ALTER TABLE Membership
MODIFY Alamat_customer VARCHAR (150);

-- 3 --
#menghapus tabel Telepon dan 
DROP TABLE Telepon

#menambahkan atribut nomor telepon pada tabel pegawai
ALTER TABLE pegawai
ADD No_telp_pegawai VARCHAR(15);

-- 4 --
#memasukkan data ke tabel Customer
INSERT INTO Customer
VALUES
('CTR001', 'Budi Santoso'),
('CTR002', 'Sisil Triana'),
('CTR003', 'Davi Liam'),
('CTRo04', 'Sutris Ten An'),
('CTR005', 'Hendra Asto');

#memasukkan data ke tabel Membership
INSERT INTO Membership
VALUES
('MBR001', '08123456789', 'Jl. Imam Bonjol', '2023-10-24', '2023-11-30', '0', 'CTR001'),
('MBR002', '0812345678', 'Jl. Kelinci', '2023-10-24', '2023-11-30', '3', 'CTR002'),
('MBR003', '081234567890', 'Jl. Abah Ojak', '2023-10-25', '2023-12-01', '2', 'CTR003'),
('MBR004', '08987654321', 'Jl. Kenangan', '2023-10-26', '2023-12-02', '6', 'CTR005');

#memasukkan data ke tabel Pegawai
INSERT INTO Pegawai
VALUES
('1234567890123456', 'Naufal Raf', 'L', 'nuafal@gmail.com', '19', '62123456789'),
('2345678901234561', 'Surinala', 'P', 'surinala@gmail.com', '24', '621234567890'),
('3456789012345612', 'Ben John', 'L', 'benjohn@gmail.com', '22', '6212345678');

#memasukkan data ke tabel Transaksi
INSERT INTO Transaksi (ID_transaksi, Tanggal_transaksi, Metode_pembayaran, NIK, ID_customer)
VALUES
('TRX0000001', '2023-10-01', 'Kartu kredit', '2345678901234561', 'CTR002'),
('TRX0000002', '2023-10-03', 'Transfer bank', '3456789012345612', 'CTRo04'),
('TRX0000003', '2023-10-05', 'Tunai', '3456789012345612', 'CTR001'),
('TRX0000004', '2023-10-15', 'Kartu debit', '1234567890123456', 'CTR003'),
('TRX0000005', '2023-10-15', 'E-wallet', '1234567890123456', 'CTRo04'),
('TRX0000006', '2023-10-21', 'Tunai', '2345678901234561', 'CTR001');

#memasukkan data ke tabel Menu_minuman
INSERT INTO Menu_minuman
VALUES
('MNM001', 'Expresso', '18000'),
('MNM002', 'Cappuccino', '20000'),
('MNM003', 'Latte', '21000'),
('MNM004', 'Americano', '19000'),
('MNM005', 'Mocha', '22000'),
('MNM006', 'Macchiato', '23000'),
('MNM007', 'Cold Brew', '21000'),
('MNM008', 'Iced Coffee', '18000'),
('MNM009', 'Affogato', '23000'),
('MNM010', 'Coffee Frappe', '22000');

#memasukkan data ke tabel Transaksi_minuman
INSERT INTO Transaksi_minuman (TM_Transaksi_ID, TM_Menu_minuman_ID, Jumlah_cup)
VALUES
('TRX0000005', 'MNM006', '2'),
('TRX0000001', 'MNM010', '1'),
('TRX0000002', 'MNM005', '1'),
('TRX0000005', 'MNM009', '1'),
('TRX0000003', 'MNM001', '3'),
('TRX0000006', 'MNM003', '2'),
('TRX0000004', 'MNM004', '2'),
('TRX0000004', 'MNM010', '1'),
('TRX0000002', 'MNM003', '2'),
('TRX0000001', 'MNM007', '1'),
('TRX0000005', 'MNM001', '1'),
('TRX0000003', 'MNM003', '1');

-- 5 --
#input 3 okt 2023, id pembeli CTRo04, metode pembayaran transfer bank, pesan 1 minuman MNM005, pegawai surinala
INSERT INTO Transaksi (ID_transaksi, Tanggal_transaksi, Metode_pembayaran, NIK, ID_customer)
VALUES
('TRX0000007', '2023-11-03', 'Transfer bank', '2345678901234561', 'CTRo04');

INSERT INTO Transaksi_minuman
VALUES
('MNM005', 'TRX0000007', '1');

-- 6 --
#input pegawai NIK 1111222233334444, nama pegawai Maimunah, dan umur 25 tahun
INSERT INTO Pegawai (NIK, Nama_pegawai, Umur)
VALUES 
('1111222233334444', 'Maimunah', '25');

-- 7 --
#update id customer CTRo04 menjadi CTR004
UPDATE Customer
SET ID_customer = 'CTR004'
WHERE ID_customer = 'CTRo04'

-- 8 --
#update pegawai Maimunah perempuan, telp 621234567, email maimunah@gmail.com
UPDATE pegawai
SET Jenis_kelamin = 'P', No_telp_pegawai = '621234567', Email = 'maimunah@gmail.com'
WHERE NIK = '1111222233334444'; 

-- 9 --
#reset total_poin menjadi 0 saat awal bulan
#update semua total_poin membership dengan tanggal_kedaluarsa sebelum bulan desember
UPDATE Membership
SET Total_poin = 0
WHERE DATE_FORMAT(NOW(), '%Y-%m-01') = '2023-12-01';

UPDATE Membership
SET Total_poin = 0
WHERE DATE_FORMAT(Tanggal_kadaluwarsa_kartu_membership, '%Y-%m-01') < '2023-12-01';

-- 10 --
#menghapus semua data membership
DELETE FROM membership

-- 11 --
#menghapus data pegawai maimunah
DELETE FROM Pegawai WHERE Nama_pegawai = 'Maimunah'