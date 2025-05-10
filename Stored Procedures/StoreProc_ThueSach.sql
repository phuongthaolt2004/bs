-- SP Thêm Phiếu Thuê Sách
CREATE PROCEDURE sp_PhieuThue_Insert
    @MaPhieuThue NVARCHAR(100),
    @MaKhachHang NVARCHAR(100),
    @NgayThue DATETIME,
	@TinhTrang VARCHAR(50),
    @NgayTraDuKien DATETIME
AS
BEGIN
    INSERT INTO PhieuThueSach (MaPhieuThue, MaKhachHang, NgayThue, NgayTra, TinhTrang, TongTien)
    VALUES (@MaPhieuThue, @MaKhachHang, @NgayThue, @NgayTraDuKien, @TinhTrang, 0);
END
GO

-- SP Cập Nhật Tổng Tiền Thuê
CREATE PROCEDURE sp_TongTienThue_Update
    @MaPhieuThue NVARCHAR(100)
AS
BEGIN
    DECLARE @TongTienThue DECIMAL(10,2)
    SELECT @TongTienThue = ISNULL(SUM(ThanhTien), 0)
    FROM ChiTietPhieuThue
    WHERE MaPhieuThue = @MaPhieuThue

    UPDATE PhieuThueSach
    SET TongTien = @TongTienThue
    WHERE MaPhieuThue = @MaPhieuThue
END
GO

-- SP Xóa Phiếu Thuê Sách
CREATE PROCEDURE sp_PhieuThue_Delete
    @MaPhieuThue NVARCHAR(100)
AS
BEGIN
    IF EXISTS (SELECT 1 FROM PhieuThueSach WHERE MaPhieuThue = @MaPhieuThue)
    BEGIN
        DELETE FROM ChiTietPhieuThue WHERE MaPhieuThue = @MaPhieuThue
        DELETE FROM PhieuThueSach WHERE MaPhieuThue = @MaPhieuThue
    END
END
GO

-- SP Lấy Chi Tiết Phiếu Thuê
CREATE PROCEDURE sp_ChiTietPhieuThue_Select_All
    @MaPhieuThue NVARCHAR(100)
AS
BEGIN
    SELECT
        pt.MaPhieuThue, pt.NgayThue, pt.NgayTra, pt.TongTien,
        kh.TenKhachHang, kh.DiaChi, kh.SoDienThoai,
        ct.MaSach, s.TenSach, ct.SoLuong, ct.DonGiaTheoNgay, ct.ThanhTien
    FROM PhieuThueSach pt
    JOIN KhachHang kh ON pt.MaKhachHang = kh.MaKhachHang
    JOIN ChiTietPhieuThue ct ON pt.MaPhieuThue = ct.MaPhieuThue
    JOIN Sach s ON ct.MaSach = s.MaSach
    WHERE pt.MaPhieuThue = @MaPhieuThue
END
GO

-- SP Thêm Chi Tiết Phiếu Thuê
CREATE PROCEDURE sp_ChiTietPhieuThue_Insert
    @MaPhieuThue NVARCHAR(100),
    @MaSach NVARCHAR(100),
    @DonGiaThue DECIMAL(10,2),
    @SoLuongThue INT
AS
BEGIN
    DECLARE @ThanhTienThue DECIMAL(10,2)
    SET @ThanhTienThue = @DonGiaThue * @SoLuongThue

    INSERT INTO ChiTietPhieuThue (MaPhieuThue, MaSach, DonGiaTheoNgay, SoLuong, ThanhTien)
    VALUES (@MaPhieuThue, @MaSach, @DonGiaThue, @SoLuongThue, @ThanhTienThue)

    -- Cập nhật TongTienThue trong PhieuThueSach
    EXEC sp_TongTienThue_Update @MaPhieuThue
END
GO

-- SP Xóa Chi Tiết Phiếu Thuê
CREATE PROCEDURE sp_ChiTietPhieuThue_Delete
    @MaPhieuThue NVARCHAR(100),
    @MaSach NVARCHAR(100)
AS
BEGIN
    DELETE FROM ChiTietPhieuThue
    WHERE MaPhieuThue = @MaPhieuThue AND MaSach = @MaSach;

    -- Cập nhật TongTienThue sau khi xóa
    EXEC sp_TongTienThue_Update @MaPhieuThue;
END
GO

-- SP Lấy Tổng Tiền Thuê
CREATE PROCEDURE sp_GetTongTienThue
    @MaPhieuThue NVARCHAR(20)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT TongTien
    FROM PhieuThueSach
    WHERE MaPhieuThue = @MaPhieuThue;
END
GO

-- SP Lấy Danh Sách Sách Cho Thuê (cần điều chỉnh truy vấn nếu có trường trạng thái)
CREATE PROCEDURE sp_Sach_Select_ChoThue
AS
BEGIN
    SELECT MaSach, TenSach, GiaBan, SoLuongTon -- Giả sử có trường GiaThue
    FROM Sach
    WHERE SoLuongTon > 0; -- Ví dụ: chỉ sách còn tồn mới cho thuê
END
GO

-- SP Cập Nhật Số Lượng Tồn Sau Thuê/Trả
CREATE PROCEDURE sp_Sach_UpdateSoLuongTon
    @MaSach NVARCHAR(100),
    @SoLuong INT -- Số lượng thay đổi (âm khi thuê, dương khi trả)
AS
BEGIN
    UPDATE Sach
    SET SoLuongTon = SoLuongTon + @SoLuong
    WHERE MaSach = @MaSach;
END
GO