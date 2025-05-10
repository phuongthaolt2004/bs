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