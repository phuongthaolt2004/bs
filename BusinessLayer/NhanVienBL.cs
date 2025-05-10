using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

using TransferObject;
using DataLayer;
using System.Data;

namespace BusinessLayer
{
    public class NhanVienBL
    {
        NhanVienDL nhanVienDL = new NhanVienDL();

        public DataTable GetData()
        {
            return nhanVienDL.GetData();
        }

        public int Insert(NhanVien nv)
        {
            return nhanVienDL.Insert(nv);
        }

        public int Update(NhanVien nv)
        {
            return nhanVienDL.Update(nv);
        }

        public int Delete(string MaNhanVien)
        {
            return nhanVienDL.Delete(MaNhanVien);
        }

        public List<NhanVien> SearchNhanVien(string keyword, string searchType)
        {
            if (string.IsNullOrEmpty(keyword) || string.IsNullOrEmpty(searchType))
            {
                throw new ArgumentException("Từ khóa tìm kiếm và tiêu chí không được để trống");
            }
            NhanVienDL nhanVienDL = new NhanVienDL();
            return nhanVienDL.TimNhanVien(keyword, searchType);
        }

        public string GetTenNhanVien(string maNV)
        {
            return nhanVienDL.GetTenNhanVien(maNV);
        }

    }
}

