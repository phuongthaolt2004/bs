using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

using System.Data;
using System.Data.SqlClient;
using TransferObject;

namespace DataLayer
{
    public class TaiKhoanDL
    {
        public TaiKhoan CheckLogin(string username, string password)
        {
            try
            {
                dbConnect db = new dbConnect();
                using (SqlConnection cn = db.GetConnection())
                {
                    cn.Open();
                    using (SqlCommand cmd = new SqlCommand("sp_TaiKhoan_CheckLogin", cn))
                    {
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.Parameters.AddWithValue("@TenDangNhap", username);
                        cmd.Parameters.AddWithValue("@MatKhau", password);

                        using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                        {
                            DataTable dt = new DataTable();
                            da.Fill(dt);

                            if (dt.Rows.Count > 0)
                            {
                                return new TaiKhoan
                                {
                                    TenDangNhap = dt.Rows[0]["TenDangNhap"].ToString(),
                                    MatKhau = dt.Rows[0]["MatKhau"].ToString(),
                                    LoaiTaiKhoan = dt.Rows[0]["LoaiTaiKhoan"].ToString()
                                };
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                throw new Exception("Lỗi khi kiểm tra đăng nhập: " + ex.Message, ex);
            }
            return null;
        }
    }
}