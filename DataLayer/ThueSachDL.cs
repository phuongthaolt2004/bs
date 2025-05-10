using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TransferObject;

namespace DataLayer
{
    public class ThueSachDL
    {
        dbConnect db = new dbConnect();
        public DataTable GetSachChoThue()
        {
            return db.GetData("sp_Sach_Select_Thue", null);
        }
        public int InsertPhieuThue(PhieuThueSach obj)
        {
            SqlParameter[] para =
            {
                new SqlParameter("@MaPhieuThue", obj.MaPhieuThue),
                new SqlParameter("@MaKhachHang", obj.MaKhachHang),
                new SqlParameter("@NgayThue", obj.NgayThue),
                new SqlParameter("@NgayTra", obj.NgayTra == DateTime.MinValue ? DBNull.Value : (object)obj.NgayTra),
                new SqlParameter("@TinhTrang", obj.TinhTrang),
                new SqlParameter("@TongTien", obj.TongTien)
            };
                return db.ExecuteSQL("sp_PhieuThue_Insert", para);
        }

        public int InsertChiTietPhieuThue(ChiTietPhieuThue obj)
        {
            SqlParameter[] para =
            {
                new SqlParameter("@MaPhieuThue", obj.MaPhieuThue),
                new SqlParameter("@MaSach", obj.MaSach),
                new SqlParameter("@SoLuong", obj.SoLuong),
                new SqlParameter("@DonGiaTheoNgay", obj.DonGiaTheoNgay),
                //new SqlParameter("@ThanhTien", obj.ThanhTien),
            };
                return db.ExecuteSQL("sp_ChiTietPhieuThue_Insert", para);
        }
        public int CapNhatTongTien(string maHoaDon)
        {
            SqlParameter[] para =
            {
                new SqlParameter("@MaPhieuThue", maHoaDon)
            };
            return db.ExecuteSQL("sp_TongTienPhieuThue_Update", para);
        }
        public Sach GetSachThueByTen(string tenSach)
        {
                if (string.IsNullOrWhiteSpace(tenSach))
                    throw new ArgumentException("Mã sách không được để trống.");

                Sach sach = null;
                using (SqlConnection cnn = db.GetConnection())
                {
                    try
                    {
                        SqlCommand cmd = new SqlCommand("sp_SachThue_GetByTen", cnn);
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.Parameters.AddWithValue("@TenSach", tenSach);

                        cnn.Open();
                        using (SqlDataReader reader = cmd.ExecuteReader())
                        {
                            if (reader.Read())
                            {
                                sach = new Sach
                                {
                                    MaSach = reader["MaSach"].ToString(),
                                    TenSach = reader["TenSach"].ToString(),
                                    GiaBan = Convert.ToDecimal(reader["GiaBan"]),
                                    SoLuongTon = Convert.ToInt32(reader["SoLuongTon"])
                                };
                                Console.WriteLine($"GetSachByMa: MaSach={sach.MaSach}, TenSach={sach.TenSach}, TonKho={sach.SoLuongTon}");
                            }
                        }
                    }
                    catch (Exception ex)
                    {
                        throw new Exception($"Lỗi khi lấy sách: {ex.Message}", ex);
                    }
                    finally
                    {
                        if (cnn.State == ConnectionState.Open)
                            cnn.Close();
                    }
                }
                return sach;
        }

        public bool KiemTraSoLuong(string tenSach, int soLuongThue)
        {
                try
                {
                    Sach sach = GetSachThueByTen(tenSach);
                    if (sach == null || sach.SoLuongTon < soLuongThue)
                    {
                        Console.WriteLine($"Không đủ sách hoặc không tồn tại sách: {tenSach}");
                        return false;
                    }

                    sach.SoLuongTon -= soLuongThue;
                    return UpdateSachSoLuongTon(sach, -soLuongThue);
                }
                catch (Exception ex)
                {
                    throw new Exception($"Lỗi khi kiểm tra số lượng: {ex.Message}", ex);
                }
        }

        public bool UpdateSachSoLuongTon(Sach sach, int soLuong)
        {
                SqlParameter[] para =
                {
                new SqlParameter("@MaSach", sach.MaSach),
                new SqlParameter("@SoLuong", soLuong)
            };

                return db.ExecuteSQL("sp_Sach_UpdateSoLuongTon", para) > 0;
        }
        public bool TraSach(string maKhachHang)
        {
            using (SqlConnection conn = db.GetConnection())
            {
                using (SqlCommand cmd = new SqlCommand("sp_TraSach", conn))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    // Chỉ truyền đúng 2 tham số theo định nghĩa của SP
                    cmd.Parameters.AddWithValue("@MaKhachHang", maKhachHang);
                    cmd.Parameters.AddWithValue("@NgayTra", DateTime.Now);

                    conn.Open();
                    int rowsAffected = cmd.ExecuteNonQuery();
                    return rowsAffected > 0;
                }
            }


        }

        public int XoaPhieuThue(string maPhieuThue)
        {
            SqlParameter[] para =
            {
                new SqlParameter("@MaPhieuThue", maPhieuThue)
            };
            return db.ExecuteSQL("sp_PhieuThue_Delete", para);
        }
        public DataTable GetPhieuThueChiTiet(string maPhieuThue)
        {
            SqlParameter[] para =
            {
                new SqlParameter("@MaPhieuThue", maPhieuThue)
            };
            return db.GetData("sp_PhieuThueChiTiet_Select_All", para);
        }
  

        public KhachHang TimKhachHang(string soDienThoai)
        {
            using (SqlConnection conn = db.GetConnection())
            {
                SqlCommand cmd = new SqlCommand("TimKhachHang", conn);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@keyword", "%" + soDienThoai + "%");
                cmd.Parameters.AddWithValue("@searchType", "SoDienThoai");

                conn.Open();
                SqlDataReader reader = cmd.ExecuteReader();
                if (reader.Read())
                {
                    KhachHang kh = new KhachHang
                    {
                        MaKhachHang = reader["MaKhachHang"].ToString(),
                        TenKhachHang = reader["TenKhachHang"].ToString(),
                        DiaChi = reader["DiaChi"].ToString(),
                        SoDienThoai = reader["SoDienThoai"].ToString()
                    };
                    reader.Close();
                    return kh;
                }
                reader.Close();
            }
            return null;
        }
        public decimal GetTongTienPhieuThue(string maPhieuThue)
        {
            decimal tongTien = 0;
            using (SqlConnection cnn = db.GetConnection())
            {
                SqlCommand cmd = new SqlCommand("sp_GetTongTienPhieuThue", cnn);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@MaPhieuThue", maPhieuThue);

                cnn.Open();
                SqlDataReader reader = cmd.ExecuteReader();
                if (reader.Read())
                {
                    tongTien = Convert.ToDecimal(reader["TongTien"]);
                }
                reader.Close();
            }
            return tongTien;
        }

    }
}

