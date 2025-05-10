CREATE PROCEDURE sp_HoaDon_Insert
    @MaHoaDon NVARCHAR(100),
    @MaKhachHang NVARCHAR(100),
    @NgayBan DATETIME
AS
BEGIN
    INSERT INTO HoaDonBanHang (MaHoaDon, MaKhachHang, NgayBan, TongTien)
    VALUES (@MaHoaDon, @MaKhachHang, @NgayBan, 0);
END
GO

CREATE PROCEDURE sp_TongTienHoaDon_Update
    @MaHoaDon NVARCHAR(100)
AS
BEGIN
    DECLARE @TongTien DECIMAL(10,2)
    SELECT @TongTien = ISNULL(SUM(ThanhTien), 0)
    FROM ChiTietHoaDonBanHang
    WHERE MaHoaDon = @MaHoaDon

    UPDATE HoaDonBanHang
    SET TongTien = @TongTien
    WHERE MaHoaDon = @MaHoaDon
END
GO

CREATE PROCEDURE sp_HoaDon_Delete
    @MaHoaDon NVARCHAR(100)
AS
BEGIN
    IF EXISTS (SELECT 1 FROM HoaDonBanHang WHERE MaHoaDon = @MaHoaDon)
    BEGIN
        DELETE FROM ChiTietHoaDonBanHang WHERE MaHoaDon = @MaHoaDon
        DELETE FROM HoaDonBanHang WHERE MaHoaDon = @MaHoaDon
    END
END
GO

CREATE PROCEDURE sp_HoaDonChiTiet_Select_All
    @MaHoaDon NVARCHAR(100)
AS
BEGIN
    SELECT 
        h.MaHoaDon, h.NgayBan, h.TongTien,
        kh.TenKhachHang, kh.DiaChi, kh.SoDienThoai,
        ct.MaSach, s.TenSach, ct.SoLuong, ct.DonGia, ct.GiamGia, ct.ThanhTien
    FROM HoaDonBanHang h
    JOIN KhachHang kh ON h.MaKhachHang = kh.MaKhachHang
    JOIN ChiTietHoaDonBanHang ct ON h.MaHoaDon = ct.MaHoaDon
    JOIN Sach s ON ct.MaSach = s.MaSach
    WHERE h.MaHoaDon = @MaHoaDon
END
GO

CREATE PROCEDURE sp_ChiTietHoaDon_Insert
    @MaHoaDon NVARCHAR(100),
    @MaSach NVARCHAR(100),
    @DonGia DECIMAL(10,2),
    @GiamGia DECIMAL(10,2),
    @SoLuong INT
AS
BEGIN
    DECLARE @ThanhTien DECIMAL(10,2)
    SET @ThanhTien = @DonGia * @SoLuong * (1 - @GiamGia / 100.0)

    INSERT INTO ChiTietHoaDonBanHang (MaHoaDon, MaSach, DonGia, GiamGia, SoLuong, ThanhTien)
    VALUES (@MaHoaDon, @MaSach, @DonGia, @GiamGia, @SoLuong, @ThanhTien)

    -- Cập nhật TongTien trong HoaDonBanHang
    EXEC sp_TongTienHoaDon_Update @MaHoaDon
END
GO

CREATE PROCEDURE sp_ChiTietHoaDonBanHang_Delete
    @MaHoaDon NVARCHAR(100),
    @MaSach NVARCHAR(100)
AS
BEGIN
    DELETE FROM ChiTietHoaDonBanHang
    WHERE MaHoaDon = @MaHoaDon AND MaSach = @MaSach;

    -- Cập nhật TongTien sau khi xóa
    EXEC sp_TongTienHoaDon_Update @MaHoaDon;
END
GO

CREATE PROCEDURE sp_GetTongTienHoaDon
    @MaHoaDon NVARCHAR(20)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT TongTien
    FROM HoaDonBanHang
    WHERE MaHoaDon = @MaHoaDon;
END
GO

CREATE PROCEDURE TimKiemHoaDon
    @MaHoaDon NVARCHAR(100) = NULL
AS
BEGIN
    SELECT * 
    FROM HoaDonBanHang 
    WHERE (@MaHoaDon IS NULL OR MaHoaDon = @MaHoaDon)
END
GO