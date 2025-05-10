using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

using TransferObject;

namespace DataLayer
{
    public class PhieuNhapSachDL
    {
        dbConnect db = new dbConnect();

        //public int InsertPhieuNhap(PhieuNhapSach pn)
        //{
        //    throw new NotImplementedException();
        //}

        //public int InsertChiTietPhieuNhap(ChiTietPhieuNhap ct)
        //{
        //    throw new NotImplementedException();
        //}

        public int InsertPhieuNhap(PhieuNhapSach pn)
        {
            SqlParameter[] para = new SqlParameter[]
            {
            new SqlParameter("@MaPhieuNhap", pn.MaPhieuNhap),
            new SqlParameter("@MaNCC", pn.MaNCC),
            new SqlParameter("@MaNhanVien", pn.MaNhanVien),
            new SqlParameter("@NgayNhap", pn.NgayNhap),
            new SqlParameter("@TongTien", pn.TongTien),
            new SqlParameter("@GhiChu", pn.GhiChu)
            };
            return db.ExecuteSQL("sp_Insert_PhieuNhap", para);
        }

        public int UpdatePhieuNhap(PhieuNhapSach pn)
        {
            SqlParameter[] para = new SqlParameter[]
            {
            new SqlParameter("@MaPhieuNhap", pn.MaPhieuNhap),
            new SqlParameter("@MaNCC", pn.MaNCC),
            new SqlParameter("@MaNhanVien", pn.MaNhanVien),
            new SqlParameter("@NgayNhap", pn.NgayNhap),
            new SqlParameter("@TongTien", pn.TongTien),
            new SqlParameter("@GhiChu", pn.GhiChu)
            };
            return db.ExecuteSQL("sp_Update_PhieuNhap", para);
        }

        public int InsertChiTietPhieuNhap(ChiTietPhieuNhap ct)
        {
            SqlParameter[] para = new SqlParameter[]
            {
            new SqlParameter("@MaPhieuNhap", ct.MaPhieuNhap),
            new SqlParameter("@MaSach", ct.MaSach),
            new SqlParameter("@SoLuong", ct.SoLuong),
            new SqlParameter("@DonGiaNhap", ct.DonGiaNhap)
            };
            return db.ExecuteSQL("sp_Insert_CT_PhieuNhap", para);
        }

        public bool IsMaPhieuNhapExists(string maPhieuNhap)
        {
            using (SqlConnection cn = db.GetConnection())
            {
                string sql = @"SELECT COUNT(*) FROM PhieuNhapSach AS p WHERE p.MaPhieuNhap = @MaPhieuNhap
                       UNION ALL
                       SELECT COUNT(*) FROM ChiTietPhieuNhap AS c WHERE c.MaPhieuNhap = @MaPhieuNhap";
                //string sql = "SELECT COUNT(*) FROM PhieuNhapSach WHERE MaPhieuNhap = @MaPhieuNhap";
                SqlCommand cmd = new SqlCommand(sql, cn);
                cmd.Parameters.AddWithValue("@MaPhieuNhap", maPhieuNhap);
                cn.Open();
                int totalCount = 0;
                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        totalCount += reader.GetInt32(0);
                    }
                }

                return totalCount > 0;
                //int count = (int)cmd.ExecuteScalar();
                //return count > 0;
            }
        }
    }
}
