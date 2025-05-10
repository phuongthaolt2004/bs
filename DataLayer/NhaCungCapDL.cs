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
    public class NhaCungCapDL
    {
        dbConnect db = new dbConnect();

        public DataTable GetData() => db.GetData("sp_NhaCungCap_SelectAll", null);

        public int Insert(NhaCungCap ncc)
        {
            SqlParameter[] para = {
        new SqlParameter("@MaNCC", SqlDbType.NVarChar) { Value = ncc.MaNCC },
        new SqlParameter("@TenNhaCC", SqlDbType.NVarChar) { Value = ncc.TenNhaCC },
        new SqlParameter("@DiaChi", SqlDbType.VarChar) { Value = ncc.DiaChi },
        new SqlParameter("@SoDienThoai", SqlDbType.VarChar) { Value = ncc.SoDienThoai },
        new SqlParameter("@Email", SqlDbType.VarChar) { Value = ncc.Email }
        };
            return db.ExecuteSQL("sp_NhaCungCap_Insert", para);
        }

        public int Update(NhaCungCap ncc)
        {
            SqlParameter[] para = {
            new SqlParameter("@MaNCC", ncc.MaNCC),
            new SqlParameter("@TenNhaCC", ncc.TenNhaCC),
            new SqlParameter("@DiaChi", ncc.DiaChi),
            new SqlParameter("@SoDienThoai", ncc.SoDienThoai),
            new SqlParameter("@Email", ncc.Email)
        };
            return db.ExecuteSQL("sp_NhaCungCap_Update", para);
        }

        public int Delete(string maNCC)
        {
            SqlParameter[] para = {
            new SqlParameter("@MaNCC", maNCC)
        };
            return db.ExecuteSQL("sp_NhaCungCap_Delete", para);
        }

        public DataTable Search(string ten, string sdt)
        {
            SqlParameter[] para = new SqlParameter[]
       {
        new SqlParameter("@TenNhaCC", string.IsNullOrEmpty(ten) ? (object)DBNull.Value : ten),
        new SqlParameter("@SoDienThoai", string.IsNullOrEmpty(sdt) ? (object)DBNull.Value : sdt)
       };
            return db.GetData("sp_NhaCungCap_Search", para);
        }
    }
}
