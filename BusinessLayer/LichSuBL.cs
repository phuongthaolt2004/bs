using DataLayer.DataLayer;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using DataLayer;
namespace BusinessLayer
{
    public class LichSuBL
    {
     
            LichSuDL lichSuDL = new LichSuDL();

            /// Lọc hóa đơn bán hàng theo tên khách hàng
            public DataTable LocHoaDonBan(string tenKH)
            {
                // Có thể thêm validation ở đây nếu cần, ví dụ kiểm tra độ dài tên KH
                if (string.IsNullOrWhiteSpace(tenKH))
                {
                    // Nếu muốn trả về tất cả khi không nhập gì
                    return lichSuDL.GetAllHoaDonBan();
                    // Hoặc trả về bảng rỗng nếu yêu cầu phải nhập để tìm
                    //return new DataTable();
                }
                try
                {
                    return lichSuDL.GetHoaDonBan_ByTenKhachHang(tenKH.Trim()); // Trim() để loại bỏ khoảng trắng thừa
                }
                catch (Exception ex)
                {
                    // Ghi log lỗi
                    Console.WriteLine("Loi BL LocHoaDonBan: " + ex.Message);
                    throw; // Ném lại lỗi để UI xử lý
                }
            }

            /// Lọc phiếu thuê theo tên khách hàng
            public DataTable LocPhieuThueTheoKhachHang(string tenKH)
            {
                if (string.IsNullOrWhiteSpace(tenKH))
                {
                     return lichSuDL.GetAllPhieuThue(); // Hoặc trả về tất cả
                   // return new DataTable(); // Hoặc trả về bảng rỗng
                }
                try
                {
                    return lichSuDL.GetPhieuThue_ByTenKhachHang(tenKH.Trim());
                }
                catch (Exception ex)
                {
                    Console.WriteLine("Loi BL LocPhieuThueTheoKhachHang: " + ex.Message);
                    throw;
                }
            }
            /// Lọc phiếu thuê theo tên sách
            public DataTable LocPhieuThueTheoTenSach(string tenSach)
            {
                if (string.IsNullOrWhiteSpace(tenSach))
                {
                    // return lichSuDL.GetAllPhieuThue(); // Hoặc trả về tất cả
                    return new DataTable(); // Hoặc trả về bảng rỗng
                }
                try
                {
                    return lichSuDL.GetPhieuThue_ByTenSach(tenSach.Trim());
                }
                catch (Exception ex)
                {
                    Console.WriteLine("Loi BL LocPhieuThueTheoTenSach: " + ex.Message);
                    throw;
                }
            }

            /// <summary>
            /// (Tùy chọn) Lấy tất cả hóa đơn bán
            /// </summary>
            public DataTable GetAllHoaDonBan()
            {
                try
                {
                    return lichSuDL.GetAllHoaDonBan();
                }
                catch (Exception ex)
                {
                    Console.WriteLine("Loi BL GetAllHoaDonBan: " + ex.Message);
                    throw;
                }
            }

            /// <summary>
            /// (Tùy chọn) Lấy tất cả phiếu thuê
            /// </summary>
            public DataTable GetAllPhieuThue()
            {
                try
                {
                    return lichSuDL.GetAllPhieuThue();
                }
                catch (Exception ex)
                {
                    Console.WriteLine("Loi BL GetAllPhieuThue: " + ex.Message);
                    throw;
                }
            }
        }
    }


