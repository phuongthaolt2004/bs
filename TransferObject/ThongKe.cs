using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TransferObject
{
    public class ThongKe
    {
        public int SoNhanVien { get; set; }
        public int SoLuongBan { get; set; }
        public int SoLuongThue { get; set; }
        public decimal TongDoanhThu { get; set; }
        public List<dynamic> SachHetHang { get; set; }
    }
}
