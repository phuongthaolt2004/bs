using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

using DataLayer;
using TransferObject;
using System.Data;
using System.Data.SqlClient;

namespace BusinessLayer
{
    public class HoaDonBanHangBL
    {
        HoaDonBanHangDL dl = new HoaDonBanHangDL();

        public DataTable GetSachBan()
        {
            return dl.GetSachBan();
        }

        public int InsertHoaDon(HoaDonBanHang hoaDon)
        {
            return dl.InsertHoaDon(hoaDon);
        }

        public Sach GetSachByTen(string tenSach)
        {
            return dl.GetSachByTen(tenSach);
        }

        public void UpdateSachSoLuongTon(Sach sach, int soLuongDaBan)
        {
            dl.UpdateSachSoLuongTon(sach, soLuongDaBan);
        }

        public int InsertChiTiet(ChiTietHoaDon chiTiet)
        {
            return dl.InsertChiTiet(chiTiet);
        }

        public int CapNhatTongTien(string maHoaDon)
        {
            return dl.CapNhatTongTien(maHoaDon);
        }

        public int XoaHoaDon(string maHoaDon)
        {
            return dl.XoaHoaDon(maHoaDon);
        }

        public DataTable GetHoaDonChiTiet(string maHoaDon)
        {
            return dl.GetHoaDonChiTiet(maHoaDon);
        }

        public KhachHang TimKhachHang(string soDienThoai)
        {
            return dl.TimKhachHang(soDienThoai);
        }

        public bool KiemTraSoLuongSach(string tenSach, int soLuong)
        {
            return dl.KiemTraSoLuongSach(tenSach, soLuong);
        }

        public decimal GetTongTienHoaDon(string maHoaDon)
        {
            return dl.GetTongTienHoaDon(maHoaDon);
        }

        public DataTable TimKiemHoaDon(string maHoaDon, string maKhachHang, DateTime? ngayBan)
        {
            return dl.TimKiemHoaDon(maHoaDon, maKhachHang, ngayBan);
        }

    }
}

            // Thêm phương thức CreateKey
            //public string CreateKey(string tiento)
            //{
            //    string key = tiento;
            //    string[] partsDay = DateTime.Now.ToShortDateString().Split('/');
            //    string d = String.Format("{0}{1}{2}", partsDay[0], partsDay[1], partsDay[2]);
            //    key = key + d;
            //    string[] partsTime = DateTime.Now.ToLongTimeString().Split(':');
            //    if (partsTime[2].Substring(3, 2) == "PM")
            //        partsTime[0] = ConvertTimeTo24(partsTime[0]);
            //    if (partsTime[2].Substring(3, 2) == "AM")
            //        if (partsTime[0].Length == 1)
            //            partsTime[0] = "0" + partsTime[0];
            //    partsTime[2] = partsTime[2].Remove(2, 3);
            //    string t = String.Format("_{0}{1}{2}", partsTime[0], partsTime[1], partsTime[2]);
            //    key = key + t;
            //    return key;
            //}

            // Thêm phương thức ConvertTimeTo24 (hỗ trợ cho CreateKey)
            //private string ConvertTimeTo24(string hour)
            //{
            //    string h = "";
            //    switch (hour)
            //    {
            //        case "1": h = "13"; break;
            //        case "2": h = "14"; break;
            //        case "3": h = "15"; break;
            //        case "4": h = "16"; break;
            //        case "5": h = "17"; break;
            //        case "6": h = "18"; break;
            //        case "7": h = "19"; break;
            //        case "8": h = "20"; break;
            //        case "9": h = "21"; break;
            //        case "10": h = "22"; break;
            //        case "11": h = "23"; break;
            //        case "12": h = "0"; break;
            //    }
            //    return h;
            //}


