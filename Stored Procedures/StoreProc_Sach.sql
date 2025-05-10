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

