---Sach
CREATE PROC sp_Sach_Insert
    @MaSach NVARCHAR(100),
    @TenSach NVARCHAR(255),
    @TacGia NVARCHAR(255),
    @NhaXuatBan NVARCHAR(255),
    @TheLoai NVARCHAR(255),
    @GiaBan DECIMAL(10,2),
    @SoLuongTon INT,
    @Loai NVARCHAR(10)
AS
BEGIN
    IF EXISTS (SELECT 1 FROM Sach WHERE MaSach = @MaSach)
    BEGIN
        RAISERROR ('Mã sách đã tồn tại!', 16, 1);
        RETURN;
    END
    INSERT INTO Sach (MaSach, TenSach, TacGia, NhaXuatBan, TheLoai, GiaBan, SoLuongTon, Loai)
    VALUES (@MaSach, @TenSach, @TacGia, @NhaXuatBan, @TheLoai, @GiaBan, @SoLuongTon, @Loai);
END;
GO

CREATE PROC sp_Sach_Update
	@MaSach NVARCHAR(100),
    @TenSach NVARCHAR(255),
    @TacGia NVARCHAR(255),
    @NhaXuatBan NVARCHAR(255),
    @TheLoai NVARCHAR(255),
    @GiaBan DECIMAL(10,2),
    @SoLuongTon INT,
    @Loai NVARCHAR(10)
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Sach WHERE MaSach = @MaSach)
    BEGIN
        RAISERROR ('Mã sách không tồn tại!', 16, 1);
        RETURN;
    END
    UPDATE Sach
    SET TenSach = @TenSach,
        TacGia = @TacGia,
        NhaXuatBan = @NhaXuatBan,
        TheLoai = @TheLoai,
        GiaBan = @GiaBan,
        SoLuongTon = @SoLuongTon,
        Loai = @Loai
    WHERE MaSach = @MaSach;
END;
GO

CREATE PROC sp_Sach_Delete
	@MaSach NVARCHAR(100)
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Sach WHERE MaSach = @MaSach)
    BEGIN
        RAISERROR ('Mã sách không tồn tại!', 16, 1);
        RETURN;
    END
    DELETE FROM Sach WHERE MaSach = @MaSach;
END;
GO

CREATE PROC sp_Sach_Select_All
AS
BEGIN
   SELECT MaSach, TenSach, TacGia, NhaXuatBan, TheLoai, GiaBan, SoLuongTon, Loai
   FROM Sach
   ORDER BY TenSach; -- Sắp xếp theo tên sách để dễ nhìn
END
GO

CREATE PROCEDURE TimSach
    @keyword NVARCHAR(255), -- Từ khóa tìm kiếm
    @searchType NVARCHAR(50) -- Tiêu chí tìm kiếm: 'MaSach', 'TenSach', 'TacGia', 'NhaXuatBan', 'TheLoai'
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @sql NVARCHAR(MAX);
    
    -- Xây dựng câu lệnh SQL động tùy theo tiêu chí tìm kiếm
    SET @sql = 'SELECT MaSach, TenSach, TacGia, NhaXuatBan, TheLoai, GiaBan, SoLuongTon, Loai 
                FROM Sach 
                WHERE ';

    IF @searchType = 'MaSach'
    BEGIN
        SET @sql = @sql + 'MaSach LIKE @keyword';
    END
    ELSE IF @searchType = 'TenSach'
    BEGIN
        SET @sql = @sql + 'TenSach LIKE @keyword';
    END
    ELSE IF @searchType = 'TacGia'
    BEGIN
        SET @sql = @sql + 'TacGia LIKE @keyword';
    END
    ELSE IF @searchType = 'NhaXuatBan'
    BEGIN
        SET @sql = @sql + 'NhaXuatBan LIKE @keyword';
    END
    ELSE IF @searchType = 'TheLoai'
    BEGIN
        SET @sql = @sql + 'TheLoai LIKE @keyword';
    END
    ELSE
    BEGIN
        RAISERROR('Tiêu chí tìm kiếm không hợp lệ', 16, 1);
        RETURN;
    END

    -- Thực thi câu lệnh SQL động
    EXEC sp_executesql @sql, N'@keyword NVARCHAR(255)', @keyword;
END
GO

CREATE PROCEDURE sp_Sach_Select_Ban
AS
BEGIN
    SELECT MaSach, TenSach, TacGia, NhaXuatBan, TheLoai, GiaBan, SoLuongTon
    FROM Sach
    WHERE Loai = 'Bán';
END
GO

CREATE PROCEDURE sp_Sach_Select_Thue
AS
BEGIN
    SELECT MaSach, TenSach, TacGia, NhaXuatBan, TheLoai, GiaBan, SoLuongTon
    FROM Sach
    WHERE Loai = 'Thuê';
END
GO

CREATE PROCEDURE sp_Sach_GetByTen
    @TenSach NVARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;
    SELECT TOP 1 MaSach, TenSach, GiaBan, SoLuongTon
    FROM Sach
    WHERE TenSach = @TenSach AND Loai = 'Bán'
    ORDER BY MaSach DESC; -- Lấy bản ghi mới nhất
END
GO

CREATE PROCEDURE sp_SachThue_GetByTen
    @TenSach NVARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;
    SELECT TOP 1 MaSach, TenSach, GiaBan, SoLuongTon
    FROM Sach
    WHERE TenSach = @TenSach AND Loai = 'Thuê'
    ORDER BY MaSach DESC; -- Lấy bản ghi mới nhất
END
GO

CREATE PROCEDURE sp_Sach_UpdateSoLuongTon
    @MaSach NVARCHAR(100),
    @SoLuong INT
AS
BEGIN
    UPDATE Sach
    SET SoLuongTon = SoLuongTon - @SoLuong
    WHERE MaSach = @MaSach;
END
GO

--TaiKhoan
CREATE PROC sp_TaiKhoan_CheckLogin
    @TenDangNhap VARCHAR(50),
    @MatKhau VARCHAR(50)
AS
BEGIN
    SELECT TenDangNhap, MatKhau, LoaiTaiKhoan
    FROM TaiKhoan
    WHERE TenDangNhap = @TenDangNhap 
        AND MatKhau = @MatKhau
END
GO

--NhanVien
CREATE PROC sp_NhanVien_Insert
    @MaNhanVien NVARCHAR(100),
    @TenNhanVien NVARCHAR(255),
    @GioiTinh NVARCHAR(10),
    @SoDienThoai VARCHAR(15),
    @DiaChi VARCHAR(255)
AS
BEGIN
    IF EXISTS (SELECT 1 FROM NhanVien WHERE MaNhanVien = @MaNhanVien)
    BEGIN
        RAISERROR ('Mã nhân viên đã tồn tại!', 16, 1);
        RETURN;
    END
    INSERT INTO NhanVien (MaNhanVien, TenNhanVien, GioiTinh, SoDienThoai, DiaChi)
    VALUES (@MaNhanVien, @TenNhanVien, @GioiTinh, @SoDienThoai, @DiaChi);
END;
GO

CREATE PROC sp_NhanVien_Update
    @MaNhanVien NVARCHAR(100),
    @TenNhanVien NVARCHAR(255),
    @GioiTinh NVARCHAR(10),
    @SoDienThoai VARCHAR(15),
    @DiaChi VARCHAR(255)
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM NhanVien WHERE MaNhanVien = @MaNhanVien)
    BEGIN
        RAISERROR ('Mã nhân viên không tồn tại!', 16, 1);
        RETURN;
    END
    UPDATE NhanVien
    SET TenNhanVien = @TenNhanVien,
        GioiTinh = @GioiTinh,
        SoDienThoai = @SoDienThoai,
        DiaChi = @DiaChi
    WHERE MaNhanVien = @MaNhanVien;
END;
GO

CREATE PROC sp_NhanVien_Delete
    @MaNhanVien NVARCHAR(100)
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM NhanVien WHERE MaNhanVien = @MaNhanVien)
    BEGIN
        RAISERROR ('Mã nhân viên không tồn tại!', 16, 1);
        RETURN;
    END
    DELETE FROM NhanVien WHERE MaNhanVien = @MaNhanVien;
END;
GO

CREATE PROC sp_NhanVien_Select_All
AS
BEGIN
    SELECT MaNhanVien, TenNhanVien, GioiTinh, SoDienThoai, DiaChi
    FROM NhanVien
    ORDER BY TenNhanVien;
END;
GO

CREATE PROCEDURE sp_NhanVien_Search
    @keyword NVARCHAR(255),       
    @searchType NVARCHAR(50)      -- Tiêu chí tìm kiếm: 'MaNhanVien', 'TenNhanVien', 'SoDienThoai'
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @sql NVARCHAR(MAX);   -- Biến chứa câu lệnh SQL động

    -- Khởi tạo câu truy vấn cơ bản
    SET @sql = 'SELECT MaNhanVien, TenNhanVien, GioiTinh, SoDienThoai, DiaChi FROM NhanVien WHERE ';

    -- Xây dựng điều kiện truy vấn theo tiêu chí tìm kiếm
    IF @searchType = 'MaNhanVien'
        SET @sql += 'MaNhanVien LIKE @keyword';
    ELSE IF @searchType = 'TenNhanVien'
        SET @sql += 'TenNhanVien LIKE @keyword';
    ELSE IF @searchType = 'SoDienThoai'
        SET @sql += 'SoDienThoai LIKE @keyword';
    ELSE
    BEGIN
        RAISERROR('Tiêu chí tìm kiếm không hợp lệ. Chỉ cho phép: MaNhanVien, TenNhanVien, SoDienThoai.', 16, 1);
        RETURN;
    END

    -- Thực thi câu lệnh SQL động với tham số
    EXEC sp_executesql @sql, N'@keyword NVARCHAR(255)', @keyword;
END;
GO

--KhachHang
CREATE PROCEDURE sp_KhachHang_Insert
    @MaKhachHang NVARCHAR(100),
    @TenKhachHang NVARCHAR(100),
    @DiaChi VARCHAR(255),
    @SoDienThoai VARCHAR(15)
AS
BEGIN
    INSERT INTO KhachHang (MaKhachHang, TenKhachHang, DiaChi, SoDienThoai)
    VALUES (@MaKhachHang, @TenKhachHang, @DiaChi, @SoDienThoai);
END
GO

CREATE PROCEDURE sp_KhachHang_Update
    @MaKhachHang NVARCHAR(100),
    @TenKhachHang NVARCHAR(100),
    @DiaChi VARCHAR(255),
    @SoDienThoai VARCHAR(15)
AS
BEGIN
    UPDATE KhachHang
    SET 
        TenKhachHang = @TenKhachHang,
        DiaChi = @DiaChi,
        SoDienThoai = @SoDienThoai
    WHERE MaKhachHang = @MaKhachHang;
END
GO

CREATE PROCEDURE sp_KhachHang_Delete
    @MaKhachHang NVARCHAR(100)
AS
BEGIN
    DELETE FROM KhachHang
    WHERE MaKhachHang = @MaKhachHang;
END
GO

CREATE PROCEDURE sp_KhachHang_Select_All
AS
BEGIN
    SELECT MaKhachHang, TenKhachHang, DiaChi, SoDienThoai
    FROM KhachHang;
END
GO

CREATE PROCEDURE TimKhachHang
    @keyword NVARCHAR(255), -- Từ khóa tìm kiếm
    @searchType NVARCHAR(50) -- Tiêu chí tìm kiếm: 'TenKhachHang' hoặc 'SoDienThoai'
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @sql NVARCHAR(MAX);
    
    -- Xây dựng câu lệnh SQL động theo tiêu chí tìm kiếm
    SET @sql = 'SELECT MaKhachHang, TenKhachHang, DiaChi, SoDienThoai
                FROM KhachHang
                WHERE ';

    IF @searchType = 'TenKhachHang'
    BEGIN
        SET @sql = @sql + 'TenKhachHang LIKE @keyword';
    END
    ELSE IF @searchType = 'SoDienThoai'
    BEGIN
        SET @sql = @sql + 'SoDienThoai LIKE @keyword';
    END
    ELSE
    BEGIN
        RAISERROR('Tiêu chí tìm kiếm không hợp lệ', 16, 1);
        RETURN;
    END

    -- Thực thi SQL động
    EXEC sp_executesql @sql, N'@keyword NVARCHAR(255)', @keyword;
END
GO

CREATE PROCEDURE sp_TimKhachHang
    @keyword NVARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT TOP 1 
        MaKhachHang,
        TenKhachHang,
        DiaChi,
        SoDienThoai
    FROM KhachHang
    WHERE SoDienThoai LIKE @keyword;
END
GO

--HoaDon_ChiTietHD
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

--ThueSach
-- SP Thêm Phiếu Thuê Sách
CREATE PROCEDURE sp_PhieuThue_Insert
    @MaPhieuThue NVARCHAR(100),
    @MaKhachHang NVARCHAR(100),
    @NgayThue DATETIME,
    @NgayTra DATETIME = NULL,              -- Cho phép null nếu chưa có giá trị
    @TinhTrang NVARCHAR(50) = N'Chưa trả',    -- Giá trị mặc định nếu không truyền vào
    @TongTien DECIMAL(10,2) = 0              -- Giá trị mặc định là 0
AS
BEGIN
    INSERT INTO PhieuThueSach (MaPhieuThue, MaKhachHang, NgayThue, NgayTra, TinhTrang, TongTien)
    VALUES (@MaPhieuThue, @MaKhachHang, @NgayThue, @NgayTra, @TinhTrang, @TongTien);
END
GO

-- SP Cập Nhật Tổng Tiền Thuê
CREATE PROCEDURE sp_TongTienPhieuThue_Update
    @MaPhieuThue NVARCHAR(100)
AS
BEGIN
    DECLARE @TongTien DECIMAL(10,2)

    SELECT @TongTien = ISNULL(SUM(ThanhTien), 0)
    FROM ChiTietPhieuThue
    WHERE MaPhieuThue = @MaPhieuThue

    UPDATE PhieuThueSach
    SET TongTien = @TongTien
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
CREATE PROCEDURE sp_PhieuThueChiTiet_Select_All
    @MaPhieuThue NVARCHAR(100)
AS
BEGIN
    SELECT 
        p.MaPhieuThue, p.NgayThue, p.TongTien,
        kh.TenKhachHang, kh.DiaChi, kh.SoDienThoai,
        ct.MaSach, s.TenSach, ct.SoLuong, ct.DonGiaTheoNgay, ct.ThanhTien
    FROM PhieuThueSach p
    JOIN KhachHang kh ON p.MaKhachHang = kh.MaKhachHang
    JOIN ChiTietPhieuThue ct ON p.MaPhieuThue = ct.MaPhieuThue
    JOIN Sach s ON ct.MaSach = s.MaSach
    WHERE p.MaPhieuThue = @MaPhieuThue
END
GO

-- SP Thêm Chi Tiết Phiếu Thuê
CREATE PROCEDURE sp_ChiTietPhieuThue_Insert
    @MaPhieuThue NVARCHAR(100),
    @MaSach NVARCHAR(100),
    @DonGiaTheoNgay DECIMAL(10,2),
    @SoLuong INT
AS
BEGIN
    DECLARE @ThanhTien DECIMAL(10,2)
    SET @ThanhTien = @DonGiaTheoNgay * @SoLuong

    INSERT INTO ChiTietPhieuThue (MaPhieuThue, MaSach, DonGiaTheoNgay, SoLuong, ThanhTien)
    VALUES (@MaPhieuThue, @MaSach, @DonGiaTheoNgay, @SoLuong, @ThanhTien)

    -- Cập nhật TongTienThue trong PhieuThueSach
    EXEC sp_TongTienPhieuThue_Update @MaPhieuThue
END
GO

-- SP Xóa Phiếu Thuê
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

-- SP Lấy Tổng Tiền Thuê
CREATE PROCEDURE sp_GetTongTienPhieuThue
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

CREATE PROCEDURE sp_TraSach
    @MaKhachHang NVARCHAR(100),
    @NgayTra DATETIME
AS
BEGIN
    DECLARE @MaPhieuThue NVARCHAR(100)

    -- Cập nhật tình trạng và ngày trả
    UPDATE PhieuThueSach
    SET TinhTrang = N'Đã trả',
        NgayTra = @NgayTra
    WHERE MaKhachHang = @MaKhachHang AND TinhTrang = N'Chưa trả'

    -- Lặp qua các phiếu thuê chưa trả để cập nhật số lượng tồn
    DECLARE cur CURSOR FOR
    SELECT ct.MaSach, ct.SoLuong
    FROM ChiTietPhieuThue ct
    JOIN PhieuThueSach pt ON ct.MaPhieuThue = pt.MaPhieuThue
    WHERE pt.MaKhachHang = @MaKhachHang AND pt.TinhTrang = N'Đã trả' AND pt.NgayTra = @NgayTra

    DECLARE @MaSach NVARCHAR(100), @SoLuong INT

    OPEN cur
    FETCH NEXT FROM cur INTO @MaSach, @SoLuong

    WHILE @@FETCH_STATUS = 0
    BEGIN
        UPDATE Sach
        SET SoLuongTon = SoLuongTon + @SoLuong
        WHERE MaSach = @MaSach

        FETCH NEXT FROM cur INTO @MaSach, @SoLuong
    END

    CLOSE cur
    DEALLOCATE cur
END
GO

--LichSu
-- Lấy Hóa đơn bán hàng theo Tên Khách hàng (tìm kiếm gần đúng)
CREATE PROC sp_HoaDonBanHang_Select_ByTenKhachHang
    @TenKhachHang NVARCHAR(100)
AS
BEGIN
    SELECT
        hd.MaHoaDon,
        hd.NgayBan,
        kh.MaKhachHang,
        hd.TongTien
    FROM HoaDonBanHang hd
    JOIN KhachHang kh ON hd.MaKhachHang = kh.MaKhachHang
    WHERE kh.TenKhachHang LIKE '%' + @TenKhachHang + '%' -- Tìm kiếm gần đúng
    ORDER BY hd.NgayBan DESC;
END
GO

-- Lấy Phiếu thuê sách theo Tên Khách hàng (tìm kiếm gần đúng)
CREATE PROC sp_PhieuThueSach_Select_ByTenKhachHang
    @TenKhachHang NVARCHAR(100)
AS
BEGIN
    SELECT DISTINCT -- Dùng DISTINCT vì một phiếu có thể có nhiều chi tiết sách
        pt.MaPhieuThue,
        pt.NgayThue,
        pt.NgayTra,
        kh.MaKhachHang,
        kh.TenKhachHang,
        pt.TinhTrang,
        pt.TongTien
    FROM PhieuThueSach pt
    JOIN KhachHang kh ON pt.MaKhachHang = kh.MaKhachHang
    WHERE kh.TenKhachHang LIKE '%' + @TenKhachHang + '%' -- Tìm kiếm gần đúng
    ORDER BY pt.NgayThue DESC;
END
GO

-- Lấy Phiếu thuê sách theo Tên Sách (tìm kiếm gần đúng)
CREATE PROC sp_PhieuThueSach_Select_ByTenSach
    @TenSach NVARCHAR(255)
AS
BEGIN
    SELECT DISTINCT -- Dùng DISTINCT vì một phiếu có thể có nhiều chi tiết sách, hoặc 1 sách thuộc nhiều phiếu
        pt.MaPhieuThue,
        pt.NgayThue,
        pt.NgayTra,
        kh.MaKhachHang,
        kh.TenKhachHang,
        pt.TinhTrang,
        pt.TongTien
    FROM PhieuThueSach pt
    JOIN KhachHang kh ON pt.MaKhachHang = kh.MaKhachHang
    JOIN ChiTietPhieuThue ctpt ON pt.MaPhieuThue = ctpt.MaPhieuThue
    JOIN Sach s ON ctpt.MaSach = s.MaSach
    WHERE s.TenSach LIKE '%' + @TenSach + '%' -- Tìm kiếm gần đúng trong tên sách
    ORDER BY pt.NgayThue DESC;
END
GO

-- (Tùy chọn) Stored Procedure để lấy tất cả hóa đơn bán (cho nút Reset)
CREATE PROC sp_HoaDonBanHang_Select_All
AS
BEGIN
    SELECT
        hd.MaHoaDon,
        hd.NgayBan,
        kh.MaKhachHang,
        kh.TenKhachHang,
        hd.TongTien
    FROM HoaDonBanHang hd
    JOIN KhachHang kh ON hd.MaKhachHang = kh.MaKhachHang
    ORDER BY hd.NgayBan DESC;
END
GO



CREATE PROC sp_PhieuThueSach_Select_All
AS
BEGIN
   SELECT pt.MaPhieuThue, pt.MaKhachHang, kh.TenKhachHang, pt.NgayThue, pt.NgayTra, pt.TinhTrang, pt.TongTien
   FROM PhieuThueSach pt
   JOIN KhachHang kh ON pt.MaKhachHang = kh.MaKhachHang
   ORDER BY pt.NgayThue DESC;
END
GO

CREATE PROCEDURE sp_NhanVien_Count
AS
BEGIN
    SELECT COUNT(*) AS SoNhanVien
    FROM NhanVien;
END;
GO

CREATE PROCEDURE sp_Sach_SumSoLuongTon
    @Loai NVARCHAR(50)
AS
BEGIN
    IF EXISTS (SELECT 1 FROM Sach WHERE Loai = @Loai)
    BEGIN
        SELECT SUM(SoLuongTon) AS SoLuongTon
        FROM Sach
        WHERE Loai = @Loai;
    END
    ELSE
    BEGIN
        SELECT 0 AS SoLuongTon; -- Trả về 0 thay vì PRINT
    END
END;
GO

CREATE PROCEDURE sp_SachHetHang_Select
AS
BEGIN
    SELECT MaSach, TenSach, SoLuongTon, GiaBan, Loai
    FROM Sach
    WHERE SoLuongTon = 0;

    IF NOT EXISTS (SELECT 1 FROM Sach WHERE SoLuongTon = 0)
    BEGIN
        PRINT 'Không có sách nào hết hàng.';
    END
END;
GO

CREATE PROCEDURE sp_TinhDoanhThu
    @FromDate DATETIME,
    @ToDate DATETIME
AS
BEGIN
    IF @FromDate > @ToDate
    BEGIN
        PRINT 'Ngày bắt đầu không thể lớn hơn ngày kết thúc.';
        RETURN;
    END

    DECLARE @DoanhThuBan DECIMAL(10, 2) = 0;
    DECLARE @DoanhThuThue DECIMAL(10, 2) = 0;

    -- Doanh thu từ bán sách
    SELECT @DoanhThuBan = ISNULL(SUM(TongTien), 0)
    FROM HoaDonBanHang
    WHERE NgayBan BETWEEN @FromDate AND @ToDate;

    -- Doanh thu từ thuê sách
    SELECT @DoanhThuThue = ISNULL(SUM(TongTien), 0)
    FROM PhieuThueSach
    WHERE NgayThue >= @FromDate AND NgayTra <= @ToDate;

    -- Trả về tổng doanh thu
    SELECT (@DoanhThuBan + @DoanhThuThue) AS TongDoanhThu;
END;
GO
