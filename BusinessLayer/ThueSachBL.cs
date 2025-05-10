using DataLayer;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TransferObject;

namespace BusinessLayer
{
    public class ThueSachBL
    {
        ThueSachDL dl = new ThueSachDL();

        public DataTable GetSachChoThue()
        {
            return dl.GetSachChoThue();
        }

        public KhachHang TimKhachHang(string soDienThoai)
        {
            return dl.TimKhachHang(soDienThoai);
        }
        public bool KiemTraSoLuong(string tenSach, int soLuong)
        {
            return dl.KiemTraSoLuong(tenSach, soLuong);
        }
        public int InsertPhieuThue(PhieuThueSach phieuThue)
        {
            // Thực hiện nghiệp vụ nếu cần
            // Ví dụ: Kiểm tra ngày trả, ...
            return dl.InsertPhieuThue(phieuThue);
        }

        public int InsertChiTietPhieuThue(ChiTietPhieuThue chiTiet)
        {
            return dl.InsertChiTietPhieuThue(chiTiet);
        }
        
        public void UpdateSachSoLuongTon(Sach sach, int soLuong)
        {
            dl.UpdateSachSoLuongTon(sach, soLuong);
        }
        public int XoaPhieuThue(string maHoaDon)
        {
            return dl.XoaPhieuThue(maHoaDon);
        }
        public Sach GetSachThueByTen(string tenSach)
        {
            return dl.GetSachThueByTen(tenSach);
        }
        public int CapNhatTongTien(string maHoaDon)
        {
            return dl.CapNhatTongTien(maHoaDon);
        }
        public decimal GetTongTienPhieuThue(string maHoaDon)
        {
            return dl.GetTongTienPhieuThue(maHoaDon);
        }
        public bool TraSach(string maKhachHang)
        {
            return dl.TraSach(maKhachHang);
        }
    }
}
