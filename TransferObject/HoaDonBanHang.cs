using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TransferObject
{
    public class HoaDonBanHang
    {
        public string MaHoaDon { get; set; }
        public string MaKhachHang { get; set; }
        public DateTime NgayBan { get; set; }
        public decimal TongTien { get; set; }

        public List<ChiTietHoaDon> ChiTietHoaDon { get; set; } = new List<ChiTietHoaDon>();
    }
}
