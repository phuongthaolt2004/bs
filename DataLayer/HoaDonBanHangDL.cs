using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

using TransferObject;

namespace DataLayer
{
    public class HoaDonBanHangDL
    {
        dbConnect db = new dbConnect();

        public DataTable GetSachBan()
        {
            return db.GetData("sp_Sach_Select_Ban", null);
        }
        public int InsertHoaDon(HoaDonBanHang obj)
        {
            SqlParameter[] para =
            {
                new SqlParameter("@MaHoaDon", obj.MaHoaDon),
                new SqlParameter("@MaKhachHang", obj.MaKhachHang),
                new SqlParameter("@NgayBan", obj.NgayBan)
            };
            return db.ExecuteSQL("sp_HoaDon_Insert", para);
        }

        public Sach GetSachByTen(string tenSach)
        {
            if (string.IsNullOrWhiteSpace(tenSach))
            {
                throw new ArgumentException("Tên sách không được để trống.");
            }

            Sach sach = null;
            using (SqlConnection cnn = db.GetConnection())
            {
                try
                {
                    SqlCommand cmd = new SqlCommand("sp_Sach_GetByTen", cnn);
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
                            Console.WriteLine($"GetSachByTen: MaSach={sach.MaSach}, TenSach={sach.TenSach}, GiaBan={sach.GiaBan}, SoLuongTon={sach.SoLuongTon}");
                        }
                        else
                        {
                            Console.WriteLine($"Không tìm thấy sách nào với TenSach={tenSach} và Loai=Ban");
                        }
                    }
                }
                catch (SqlException ex)
                {
                    throw new Exception($"Lỗi SQL khi lấy thông tin sách: {ex.Message} (Error Code: {ex.Number})", ex);
                }
                catch (Exception ex)
                {
                    throw new Exception($"Lỗi không xác định khi lấy thông tin sách: {ex.Message}", ex);
                }
                finally
                {
                    if (cnn.State == ConnectionState.Open)
                        cnn.Close();
                }
            }
            return sach;
        }

        public bool KiemTraSoLuongSach(string tenSach, int soLuongMua)
        {
            try
            {
                Sach sach = GetSachByTen(tenSach);
                if (sach == null)
                {
                    Console.WriteLine($"Không tìm thấy sách: {tenSach}");
                    return false;
                }

                Console.WriteLine($"KiemTraSoLuongSach: MaSach={sach.MaSach}, TenSach={sach.TenSach}, SoLuongTon={sach.SoLuongTon}, SoLuongMua={soLuongMua}");
                if (sach.SoLuongTon < soLuongMua)
                {
                    Console.WriteLine($"Số lượng tồn ({sach.SoLuongTon}) nhỏ hơn số lượng mua ({soLuongMua})");
                    return false;
                }

                sach.SoLuongTon -= soLuongMua;
                UpdateSachSoLuongTon(sach, -soLuongMua);
                return true;
            }
            catch (Exception ex)
            {
                throw new Exception($"Lỗi khi kiểm tra số lượng sách: {ex.Message}", ex);
            }
        }

        public void UpdateSachSoLuongTon(Sach sach, int soLuong)
        {
            SqlParameter[] para =
            {
                new SqlParameter("@MaSach", sach.MaSach),
                new SqlParameter("@SoLuong", soLuong)
            };
            db.ExecuteSQL("sp_Sach_UpdateSoLuongTon", para);
        }

        // Thêm chi tiết hóa đơn
        public int InsertChiTiet(ChiTietHoaDon obj)
        {
            SqlParameter[] para =
            {
                new SqlParameter("@MaHoaDon", obj.MaHoaDon),
                new SqlParameter("@MaSach", obj.MaSach),
                new SqlParameter("@DonGia", obj.DonGia),
                new SqlParameter("@GiamGia", obj.GiamGia),
                new SqlParameter("@SoLuong", obj.SoLuong)
            };
            return db.ExecuteSQL("sp_ChiTietHoaDon_Insert", para);
        }

        // Cập nhật tổng tiền sau khi thêm chi tiết
        public int CapNhatTongTien(string maHoaDon)
        {
            SqlParameter[] para =
            {
                new SqlParameter("@MaHoaDon", maHoaDon)
            };
            return db.ExecuteSQL("sp_TongTienHoaDon_Update", para);
        }

        // Xoá hóa đơn và chi tiết
        public int XoaHoaDon(string maHoaDon)
        {
            SqlParameter[] para =
            {
                new SqlParameter("@MaHoaDon", maHoaDon)
            };
            return db.ExecuteSQL("sp_HoaDon_Delete", para);
        }

        // Lấy đầy đủ thông tin hóa đơn + chi tiết (cho báo cáo / xem chi tiết)
        public DataTable GetHoaDonChiTiet(string maHoaDon)
        {
            SqlParameter[] para =
            {
                new SqlParameter("@MaHoaDon", maHoaDon)
            };
            return db.GetData("sp_HoaDonChiTiet_Select_All", para);
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

        public DataTable TimKiemHoaDon(string maHoaDon, string maKhachHang, DateTime? ngayBan)
        {
            SqlParameter[] para =
            {
            new SqlParameter("@MaHoaDon", (object)maHoaDon ?? DBNull.Value),
        };
            return db.GetData("TimKiemHoaDon", para);
        }

        public decimal GetTongTienHoaDon(string maHoaDon)
        {
            decimal tongTien = 0;
            using (SqlConnection cnn = db.GetConnection())
            {
                SqlCommand cmd = new SqlCommand("sp_GetTongTienHoaDon", cnn);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@MaHoaDon", maHoaDon);

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
