USE master
GO

CREATE DATABASE QLCHBanSach
GO

USE QLCHBanSach
GO

CREATE TABLE TaiKhoan (  
    TenDangNhap VARCHAR(50) PRIMARY KEY,  
    MatKhau VARCHAR(50) NOT NULL, 
	LoaiTaiKhoan VARCHAR(50)
);  
GO  

CREATE TABLE Sach (
    MaSach NVARCHAR(100) PRIMARY KEY,
    TenSach NVARCHAR(255) NOT NULL,
    TacGia NVARCHAR(255),
    NhaXuatBan NVARCHAR(255),
    TheLoai NVARCHAR(255),
    GiaBan DECIMAL(10,2) NOT NULL,
    SoLuongTon INT NOT NULL,
    Loai NVARCHAR(10) NOT NULL
);
GO

CREATE TABLE NhaCungCap (
    MaNCC NVARCHAR(100) PRIMARY KEY,
    TenNhaCC NVARCHAR(255),
    DiaChi NVARCHAR(255),
    SoDienThoai VARCHAR(15) NOT NULL,
    Email VARCHAR(255)
);
GO

CREATE TABLE NhanVien (
    MaNhanVien NVARCHAR(100) PRIMARY KEY,
    TenNhanVien NVARCHAR(255) NOT NULL,
    GioiTinh NVARCHAR(10),
    SoDienThoai VARCHAR(15) NOT NULL,
    DiaChi VARCHAR(255)
);
GO

CREATE TABLE PhieuNhapSach (
    MaPhieuNhap NVARCHAR(100) PRIMARY KEY,
    MaNCC NVARCHAR(100),
    MaNhanVien NVARCHAR(100),
    NgayNhap DATETIME,
    TongTien DECIMAL(10, 2) DEFAULT 0, 
    GhiChu NVARCHAR(255),
    FOREIGN KEY (MaNCC) REFERENCES NhaCungCap(MaNCC),
    FOREIGN KEY (MaNhanVien) REFERENCES NhanVien(MaNhanVien)
);
GO

CREATE TABLE ChiTietPhieuNhap (
    MaPhieuNhap NVARCHAR(100),
    MaSach NVARCHAR(100),
    SoLuong INT,
    DonGiaNhap DECIMAL(10,2),
	ThanhTien DECIMAL(10, 2), 
    PRIMARY KEY (MaPhieuNhap, MaSach),
    FOREIGN KEY (MaPhieuNhap) REFERENCES PhieuNhapSach(MaPhieuNhap),
    FOREIGN KEY (MaSach) REFERENCES Sach(MaSach)
);
GO

CREATE TABLE KhachHang (
    MaKhachHang NVARCHAR(100) PRIMARY KEY,
    TenKhachHang NVARCHAR(100) NOT NULL,
    DiaChi NVARCHAR(255),
    SoDienThoai VARCHAR(15) NOT NULL
);
GO

CREATE TABLE HoaDonBanHang (
    MaHoaDon NVARCHAR(100) PRIMARY KEY,
    MaKhachHang NVARCHAR(100),
    NgayBan DATETIME,
    TongTien DECIMAL(10, 2),
    FOREIGN KEY (MaKhachHang) REFERENCES KhachHang(MaKhachHang)
);
GO

CREATE TABLE ChiTietHoaDonBanHang (
    MaHoaDon NVARCHAR(100),
    MaSach NVARCHAR(100),
    DonGia DECIMAL(10, 2),
    GiamGia DECIMAL(10, 2),
    SoLuong INT,
    ThanhTien DECIMAL(10, 2),
    PRIMARY KEY (MaHoaDon, MaSach),
    FOREIGN KEY (MaHoaDon) REFERENCES HoaDonBanHang(MaHoaDon),
    FOREIGN KEY (MaSach) REFERENCES Sach(MaSach)
);
GO

CREATE TABLE PhieuThueSach (
    MaPhieuThue NVARCHAR(100) PRIMARY KEY,
    MaKhachHang NVARCHAR(100),
    NgayThue DATE,
    NgayTra DATE,
    TinhTrang NVARCHAR(50),
    TongTien DECIMAL(10, 2) DEFAULT 0, 
    FOREIGN KEY (MaKhachHang) REFERENCES KhachHang(MaKhachHang)
);
GO

CREATE TABLE ChiTietPhieuThue (
    MaPhieuThue NVARCHAR(100),
    MaSach NVARCHAR(100),
    SoLuong INT,
    DonGiaTheoNgay DECIMAL(10, 2),  
	ThanhTien DECIMAL(10, 2),
    PRIMARY KEY (MaPhieuThue, MaSach),
    FOREIGN KEY (MaPhieuThue) REFERENCES PhieuThueSach(MaPhieuThue),
    FOREIGN KEY (MaSach) REFERENCES Sach(MaSach)
);
GO

INSERT INTO TaiKhoan (TenDangNhap, MatKhau, LoaiTaiKhoan)  
VALUES ('Quản lý', '123', 'Admin'), ('Nhân viên', '111', 'User');   
GO


INSERT INTO Sach (MaSach, TenSach, TacGia, NhaXuatBan, TheLoai, GiaBan, SoLuongTon, Loai)   
VALUES   
('1', N'Harry Potter', N'J.K. Rowling', N'NXB Trẻ', N'Fantasy', 8500.00, 10, N'Thuê'),   
('2', N'Harry Potter', N'J.K. Rowling', N'NXB Trẻ', N'Fantasy', 99000.00, 10, N'Bán'),   
('3', N'Nhà Giả Kim', N'Paulo Coelho', N'NXB Kim Đồng', N'Tiểu thuyết', 120000, 20, N'Bán'),   
('4', N'Nhà Giả Kim', N'Paulo Coelho', N'NXB Kim Đồng', N'Tiểu thuyết', 12000, 5, N'Thuê'),   
('5', N'Số Đỏ', N'Vũ Trọng Phụng', N'NXB Thanh Niên', N'Văn học', 80000, 12, N'Bán'),   
('6', N'Số Đỏ', N'Vũ Trọng Phụng', N'NXB Thanh Niên', N'Văn học', 8000, 5, N'Thuê');   
GO

INSERT INTO NhaCungCap (MaNCC, TenNhaCC, DiaChi, SoDienThoai, Email)  
VALUES 
('1', N'Công ty Phát hành sách A', N'123 Lý Thường Kiệt, Q.10, TP.HCM', '0987654321', 'phsacha@example.com'), 
('2', N'Công ty Văn hóa B', N'456 Nguyễn Trãi, Q.5, TP.HCM', '0978123456', 'vanhoab@example.com'); 
GO

INSERT INTO NhanVien (MaNhanVien, TenNhanVien, SoDienThoai, GioiTinh, DiaChi) 
VALUES  
('1', N'Nguyễn Thị Thùy Dung', '0934567890', N'Nữ', N'123 Đường D, Quận 4, TP.HCM'), 
('2', N'Nguyễn Duy Hòa', '0945678901', N'Nam', N'456 Đường E, Quận 5, TP.HCM'), 
('3', N'Lê Thị Lệ Giang', '0956789012', N'Nữ', N'789 Đường F, Quận 6, TP.HCM'); 
GO

INSERT INTO PhieuNhapSach (MaPhieuNhap, MaNCC, MaNhanVien, NgayNhap, TongTien, GhiChu)  
VALUES 
('1', '1', '1', '2024-04-01', 3000000, N'Nhập đợt đầu'), 
('2', '2', '2', '2024-04-05', 2700000, N'Nhập bổ sung sách văn học'); 
GO

INSERT INTO ChiTietPhieuNhap (MaPhieuNhap, MaSach, SoLuong, DonGiaNhap, ThanhTien)
VALUES
('1', '1', 10, 110000, 1100000),
('1', '3', 5, 95000, 475000),
('2', '5', 15, 60000, 900000),
('2', '6', 8, 50000, 400000);

INSERT INTO KhachHang (MaKhachHang, TenKhachHang, DiaChi, SoDienThoai) 
VALUES  
('1', N'Đặng Quốc Bảo', N'123 Thống Nhất, Gò Vấp, TP.HCM', '0901234567'), 
('2', N'Lưu Ngọc Hưng', N'456 Võ Văn Tần, Quận 3, TP.HCM', '0912345678'), 
('3', N'Lưu Tiến Đạt', N'121 Quang Trung, Gò Vấp, TP.HCM', '0923456789'), 
('4', N'Lưu Thị Phương Thảo', N'Nhà Bè, TP.HCM', '0823512988'),
('5', N'Nguyễn Thùy Ngọc Hân', N'Lê Văn Lương, Nhà Bè, TP.HCM', '0388169644'),
('6', N'Châu Đan Hạnh', N'Nhơn Đức, Nhà Bè, TP.HCM', '0846335668');



GO

INSERT INTO HoaDonBanHang (MaHoaDon, MaKhachHang, NgayBan, TongTien) 
VALUES  
('1', '1', '2024-05-15 10:30:00', 384000), 
('2', '2', '2024-05-16 14:45:00', 1510000); 
GO

INSERT INTO ChiTietHoaDonBanHang (MaHoaDon, MaSach, DonGia, GiamGia, SoLuong, ThanhTien)
VALUES
('1', '1', 150000, 10, 2, 270000),      -- 150000 * 2 * (1 - 0.10) = 270000
('1', '3', 120000, 5, 1, 114000),       -- 120000 * 1 * (1 - 0.05) = 114000
('2', '1', 150000, 0, 1, 150000),       -- 150000 * 1 * (1 - 0) = 150000
('2', '5', 800000, 15, 2, 1360000);     -- 800000 * 2 * (1 - 0.15) = 1360000

INSERT INTO PhieuThueSach (MaPhieuThue, MaKhachHang, NgayThue, NgayTra, TinhTrang, TongTien) 
VALUES  
('1', '1', '2024-04-01', '2024-04-05', N'Đã trả', 28000),   
('2', '2', '2024-04-10', '2024-04-15', N'Chưa trả', 22000); 
GO

INSERT INTO ChiTietPhieuThue (MaPhieuThue, MaSach, SoLuong, DonGiaTheoNgay, ThanhTien)
VALUES
('1', '4', 2, 10000, 20000),      -- 2 * 10000
('1', '6', 1, 8000, 8000),
('2', '1', 1, 12000, 12000),
('2', '4', 1, 10000, 10000);
