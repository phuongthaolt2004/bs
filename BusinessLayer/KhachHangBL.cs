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
    public class KhachHangBL
    {
        KhachHangDL khachHangDL = new KhachHangDL();

        public DataTable GetData()
        {
            return khachHangDL.GetData();
        }

        public int Insert(KhachHang kh)
        {
            return khachHangDL.Insert(kh);
        }

        public int Update(KhachHang kh)
        {
            return khachHangDL.Update(kh);
        }

        public int Delete(string MaKhachHang)
        {
            return khachHangDL.Delete(MaKhachHang);
        }

        public List<KhachHang> SearchKhachHang(string keyword, string searchType)
        {
            if (string.IsNullOrEmpty(keyword) || string.IsNullOrEmpty(searchType))
            {
                throw new ArgumentException("Từ khóa tìm kiếm và tiêu chí không được để trống");
            }

            // Khởi tạo đối tượng SachDL và gọi phương thức TimSach
            KhachHangDL khachHangDL = new KhachHangDL();
            return khachHangDL.TimKhachHang(keyword, searchType);
        }
    }
}
