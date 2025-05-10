using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using DataLayer;
using TransferObject;
using System.Data;

namespace BusinessLayer
{
    public class ThongKeBL
    {
        ThongKeDL dl = new ThongKeDL();

        public int GetNhanVienCount()
        {
            return dl.GetNhanVienCount();
        }

        public int GetSoLuongBan()
        {
            return dl.GetSoLuongBan(); // Sử dụng phương thức từ ThongKeDL
        }

        public int GetSoLuongThue()
        {
            return dl.GetSoLuongThue(); // Sử dụng phương thức từ ThongKeDL
        }

        public DataTable GetSachHetHang()
        {
            return dl.GetSachHetHang();
        }

        public decimal TinhDoanhThu(DateTime fromDate, DateTime toDate)
        {
            if (fromDate > toDate)
                throw new ArgumentException("Ngày bắt đầu phải trước hoặc bằng ngày kết thúc.");
            return dl.GetDoanhThu(fromDate, toDate);
        }
    }
}
