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