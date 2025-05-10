using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;


namespace DataLayer
{
    public class ThongKeDL
    {
        dbConnect db = new dbConnect();

        public int GetNhanVienCount()
        {
            return db.ExecuteScalar("sp_NhanVien_Count", null);
            //try
            //{
            //    DataTable dt = db.GetData("sp_NhanVien_Count", null);
            //    Console.WriteLine($"GetNhanVienCount - Columns: {string.Join(", ", dt.Columns.Cast<DataColumn>().Select(c => c.ColumnName))}");
            //    Console.WriteLine($"GetNhanVienCount - Rows: {dt.Rows.Count}, Data: {(dt.Rows.Count > 0 ? dt.Rows[0][0]?.ToString() : "No data")}");
            //    if (dt.Rows.Count > 0 && dt.Columns.Contains("SoNhanVien"))
            //    {
            //        return Convert.ToInt32(dt.Rows[0]["SoNhanVien"]);
            //    }
            //    if (dt.Rows.Count > 0) // Thử lấy cột đầu tiên nếu không tìm thấy SoNhanVien
            //    {
            //        return Convert.ToInt32(dt.Rows[0][0]);
            //    }
            //    return 0;
            //}
            //catch (Exception ex)
            //{
            //    Console.WriteLine($"Error GetNhanVienCount: {ex.Message}");
            //    return 0;
            //}
        }

        public int GetSoLuongBan()
        {
            return GetSoLuongTon("Bán");
        }

        public int GetSoLuongThue()
        {
            return GetSoLuongTon("Thuê");
        }

        public int GetSoLuongTon(string loai)
        {
            SqlParameter[] para = { new SqlParameter("@Loai", loai) };
            return db.ExecuteScalar("sp_Sach_SumSoLuongTon", para);
            //try
            //{
            //    SqlParameter[] para = { new SqlParameter("@Loai", loai) };
            //    DataTable dt = db.GetData("sp_Sach_SumSoLuongTon", para);
            //    Console.WriteLine($"GetSoLuongTon ({loai}) - Columns: {string.Join(", ", dt.Columns.Cast<DataColumn>().Select(c => c.ColumnName))}");
            //    Console.WriteLine($"GetSoLuongTon ({loai}) - Rows: {dt.Rows.Count}, Data: {(dt.Rows.Count > 0 ? dt.Rows[0][0]?.ToString() : "No data")}");
            //    if (dt.Rows.Count > 0 && dt.Columns.Contains("SoLuongTon"))
            //    {
            //        return dt.Rows[0]["SoLuongTon"] != DBNull.Value ? Convert.ToInt32(dt.Rows[0]["SoLuongTon"]) : 0;
            //    }
            //    if (dt.Rows.Count > 0) // Thử lấy cột đầu tiên nếu không tìm thấy SoLuongTon
            //    {
            //        return dt.Rows[0][0] != DBNull.Value ? Convert.ToInt32(dt.Rows[0][0]) : 0;
            //    }
            //    return 0;
            //}
            //catch (Exception ex)
            //{
            //    Console.WriteLine($"Error GetSoLuongTon ({loai}): {ex.Message}");
            //    return 0;
            //}
        }

        public DataTable GetSachHetHang()
        {
            try
            {
                DataTable dt = db.GetData("sp_SachHetHang_Select", null);
                Console.WriteLine($"ThongKeDL - GetSachHetHang - Số hàng: {dt.Rows.Count}");
                return dt;
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Lỗi GetSachHetHang: {ex.Message}");
                return new DataTable();
            }
        }

        public decimal GetDoanhThu(DateTime fromDate, DateTime toDate)
        {
            try
            {
                SqlParameter[] para =
                {
                    new SqlParameter("@FromDate", fromDate),
                    new SqlParameter("@ToDate", toDate)
                };
                DataTable dt = db.GetData("sp_TinhDoanhThu", para);
                Console.WriteLine($"ThongKeDL - GetDoanhThu - Số hàng: {dt.Rows.Count}, Dữ liệu: {(dt.Rows.Count > 0 ? dt.Rows[0]["TongDoanhThu"].ToString() : "Không có dữ liệu")}");
                if (dt.Rows.Count > 0 && dt.Columns.Contains("TongDoanhThu"))
                {
                    return Convert.ToDecimal(dt.Rows[0]["TongDoanhThu"]);
                }
                return 0;
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Lỗi GetDoanhThu: {ex.Message}");
                return 0;
            }
        }
    }
}
