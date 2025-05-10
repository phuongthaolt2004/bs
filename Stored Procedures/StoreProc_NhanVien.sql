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

