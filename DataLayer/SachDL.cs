using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

using TransferObject;
using System.Data;
using System.Data.SqlClient;

namespace DataLayer
{
    public class SachDL
    {
        dbConnect db = new dbConnect();

        public DataTable GetData()
        {
            return db.GetData("sp_Sach_Select_All", null);
        }

        public int Insert(Sach obj)
        {
            SqlParameter[] para =
            {
                new SqlParameter("@MaSach", obj.MaSach),
                new SqlParameter("@TenSach", obj.TenSach),
                new SqlParameter("@TacGia", obj.TacGia),
                new SqlParameter("@NhaXuatBan", obj.NhaXuatBan),
                new SqlParameter("@TheLoai", obj.TheLoai),
                new SqlParameter("@GiaBan", obj.GiaBan),
                new SqlParameter("@SoLuongTon", obj.SoLuongTon),
                new SqlParameter("@Loai", obj.Loai)
            };
            return db.ExecuteSQL("sp_Sach_Insert", para);
        }
        public int Update(Sach obj)
        {
            SqlParameter[] para =
            {
                new SqlParameter("@MaSach", obj.MaSach),
                new SqlParameter("@TenSach", obj.TenSach),
                new SqlParameter("@TacGia", obj.TacGia),
                new SqlParameter("@NhaXuatBan", obj.NhaXuatBan),
                new SqlParameter("@TheLoai", obj.TheLoai),
                new SqlParameter("@Loai", obj.Loai),
                new SqlParameter("@GiaBan", obj.GiaBan),
                new SqlParameter("@SoLuongTon", obj.SoLuongTon),
            };
            return db.ExecuteSQL("sp_Sach_Update", para);
        }
        public int Delete(string MaSach)
        {
            SqlParameter[] para =
            {
                new SqlParameter("@MaSach", MaSach)
            };
            return db.ExecuteSQL("sp_Sach_Delete", para);
        }

        public List<Sach> TimSach(string keyword, string searchType)
        {
            List<Sach> sachList = new List<Sach>();

            // Sử dụng kết nối từ dbConnect
            using (SqlConnection conn = db.GetConnection()) // Lấy kết nối từ dbConnect
            {
                SqlCommand cmd = new SqlCommand("TimSach", conn);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@keyword", "%" + keyword + "%");
                cmd.Parameters.AddWithValue("@searchType", searchType);

                conn.Open();

                SqlDataReader reader = cmd.ExecuteReader();
                while (reader.Read())
                {
                    Sach sach = new Sach
                    {
                        MaSach = reader["MaSach"].ToString(),
                        TenSach = reader["TenSach"].ToString(),
                        TacGia = reader["TacGia"].ToString(),
                        NhaXuatBan = reader["NhaXuatBan"].ToString(),
                        TheLoai = reader["TheLoai"].ToString(),
                        GiaBan = Convert.ToDecimal(reader["GiaBan"]),
                        SoLuongTon = Convert.ToInt32(reader["SoLuongTon"]),
                        Loai = reader["Loai"].ToString()
                    };

                    sachList.Add(sach);
                }
            }
            return sachList;
        }

        public List<Sach> GetAll()
        {
            List<Sach> list = new List<Sach>();

            using (SqlConnection conn = db.GetConnection())
            {
                SqlCommand cmd = new SqlCommand("SELECT MaSach, TenSach, GiaBan FROM Sach WHERE Loai = 'Ban'", conn);
                conn.Open();
                SqlDataReader reader = cmd.ExecuteReader();

                while (reader.Read())
                {
                    Sach s = new Sach
                    {
                        MaSach = reader["MaSach"].ToString(),
                        TenSach = reader["TenSach"].ToString(),
                        GiaBan = Convert.ToDecimal(reader["GiaBan"])
                    };
                    list.Add(s);
                }
            }
            return list;
        }

        public string GetMaByTen(string tenSach)
        {
            string sql = "SELECT MaSach FROM Sach WHERE TenSach = @TenSach";
            SqlParameter[] para = {
            new SqlParameter("@TenSach", tenSach)
        };

            DataTable dt = db.GetQuery(sql, para);
            if (dt.Rows.Count > 0)
                return dt.Rows[0]["MaSach"].ToString();
            else
                return null;
        }
        public int GetGiaBan(string maSach)
        {
            string sql = "SELECT GiaBan FROM Sach WHERE MaSach = @MaSach";
            SqlParameter[] para = {
        new SqlParameter("@MaSach", maSach)
        };
            DataTable dt = db.GetData(sql, para);
            if (dt.Rows.Count > 0)
                return Convert.ToInt32(dt.Rows[0]["GiaBan"]);
            return 0;
        }

        public int TangSoLuongTonNeuLaBan(string maSach, int soLuong)
        {
            using (SqlConnection cn = db.GetConnection())
            {
                SqlCommand cmd = new SqlCommand("sp_TangSoLuongTonNeuLaBan", cn);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@MaSach", maSach);
                cmd.Parameters.AddWithValue("@SoLuong", soLuong);
                cn.Open();
                return cmd.ExecuteNonQuery();
            }
        }
    }
}
