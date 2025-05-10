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
    public class NhanVienDL
    {
        dbConnect db = new dbConnect();

        public DataTable GetData()
        {
            return db.GetData("sp_NhanVien_Select_All", null);
        }

        public int Insert(NhanVien obj)
        {
            SqlParameter[] para =
            {
                new SqlParameter("@MaNhanVien", obj.MaNhanVien),
                new SqlParameter("@TenNhanVien", obj.TenNhanVien),
                new SqlParameter("@GioiTinh", obj.GioiTinh),
                new SqlParameter("@SoDienThoai", obj.SoDienThoai),
                new SqlParameter("@DiaChi", obj.DiaChi)
            };
            return db.ExecuteSQL("sp_NhanVien_Insert", para);
        }

        public int Update(NhanVien obj)
        {
            SqlParameter[] para =
            {
                new SqlParameter("@MaNhanVien", obj.MaNhanVien),
                new SqlParameter("@TenNhanVien", obj.TenNhanVien),
                new SqlParameter("@GioiTinh", obj.GioiTinh),
                new SqlParameter("@SoDienThoai", obj.SoDienThoai),
                new SqlParameter("@DiaChi", obj.DiaChi)
            };
            return db.ExecuteSQL("sp_NhanVien_Update", para);
        }

        public int Delete(string MaNhanVien)
        {
            SqlParameter[] para =
            {
                new SqlParameter("@MaNhanVien", MaNhanVien)
            };
            return db.ExecuteSQL("sp_NhanVien_Delete", para);
        }

        public List<NhanVien> TimNhanVien(string keyword, string searchType)
        {
            List<NhanVien> nhanVienList = new List<NhanVien>();

            using (SqlConnection conn = db.GetConnection())
            {
                SqlCommand cmd = new SqlCommand("sp_NhanVien_Search", conn);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@keyword", "%" + keyword + "%");
                cmd.Parameters.AddWithValue("@searchType", searchType);

                conn.Open();
                SqlDataReader reader = cmd.ExecuteReader();
                while (reader.Read())
                {
                    NhanVien nv = new NhanVien
                    {
                        MaNhanVien = reader["MaNhanVien"].ToString(),
                        TenNhanVien = reader["TenNhanVien"].ToString(),
                        GioiTinh = reader["GioiTinh"].ToString(),
                        SoDienThoai = reader["SoDienThoai"].ToString(),
                        DiaChi = reader["DiaChi"].ToString()
                    };
                    nhanVienList.Add(nv);
                }
            }
            return nhanVienList;
        }

        public string GetTenNhanVien(string maNV)
        {
            string sql = "SELECT TenNhanVien FROM NhanVien WHERE MaNhanVien = @MaNV";
            SqlParameter[] para = { new SqlParameter("@MaNV", maNV) };
            DataTable dt = db.GetQuery(sql, para);
            if (dt.Rows.Count > 0)
                return dt.Rows[0]["TenNhanVien"].ToString();
            return "";
        }
    }
}

