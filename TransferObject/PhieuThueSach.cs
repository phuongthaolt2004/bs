using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TransferObject
{
    public class PhieuThueSach
    {
        public string MaPhieuThue { get; set; }
        public string MaKhachHang { get; set; }
        public DateTime NgayThue { get; set; }
        public DateTime NgayTra { get; set; }
        public string TinhTrang { get; set; }
        public decimal TongTien { get; set; }

        public List<ChiTietPhieuThue> ChiTietPhieuThues { get; set; } = new List<ChiTietPhieuThue>();
    }
}
