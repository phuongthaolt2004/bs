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
    public class KhachHangDL
    {
        dbConnect db = new dbConnect();

        public DataTable GetData()
        {
            return db.GetData("sp_KhachHang_Select_All", null);
        }

        public int Insert(KhachHang obj)
        {
            SqlParameter[] para =
            {
                new SqlParameter("@MaKhachHang", obj.MaKhachHang),
                new SqlParameter("@TenKhachHang", obj.TenKhachHang),
                new SqlParameter("@DiaChi", obj.DiaChi),
                new SqlParameter("@SoDienThoai", obj.SoDienThoai)
            };
            return db.ExecuteSQL("sp_KhachHang_Insert", para);
        }

        public int Update(KhachHang obj)
        {
            SqlParameter[] para =
            {
                new SqlParameter("@MaKhachHang", obj.MaKhachHang),
                new SqlParameter("@TenKhachHang", obj.TenKhachHang),
                new SqlParameter("@DiaChi", obj.DiaChi),
                new SqlParameter("@SoDienThoai", obj.SoDienThoai)
            };
            return db.ExecuteSQL("sp_KhachHang_Update", para);
        }

        public int Delete(string MaKhachHang)
        {
            SqlParameter[] para =
            {
                new SqlParameter("@MaKhachHang", MaKhachHang)
            };
            return db.ExecuteSQL("sp_KhachHang_Delete", para);
        }

        public List<KhachHang> TimKhachHang(string keyword, string searchType)
        {
            List<KhachHang> khachHangList = new List<KhachHang>();

            using (SqlConnection conn = db.GetConnection())
            {
                SqlCommand cmd = new SqlCommand("TimKhachHang", conn);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@keyword", "%" + keyword + "%");
                cmd.Parameters.AddWithValue("@searchType", searchType);

                conn.Open();
                SqlDataReader reader = cmd.ExecuteReader();
                while (reader.Read())
                {
                    KhachHang kh = new KhachHang
                    {
                        MaKhachHang = reader["MaKhachHang"].ToString(),
                        TenKhachHang = reader["TenKhachHang"].ToString(),
                        DiaChi = reader["DiaChi"].ToString(),
                        SoDienThoai = reader["SoDienThoai"].ToString()
                    };
                    khachHangList.Add(kh);
                }
            }
            return khachHangList;
        }
    }
}

