using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TransferObject
{
    public class PhieuNhapSach
    {
            public string MaPhieuNhap { get; set; }
            public string MaNCC { get; set; }
            public string MaNhanVien { get; set; }
            public DateTime NgayNhap { get; set; }
            public decimal TongTien { get; set; }
            public string GhiChu { get; set; }

            public List<ChiTietPhieuNhap> ChiTietPhieuNhap { get; set; } = new List<ChiTietPhieuNhap>();
    }
}
