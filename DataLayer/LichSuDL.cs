using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DataLayer
{
    using System;
    using System.Data;
    using System.Data.SqlClient;

    namespace DataLayer
    {
        public class LichSuDL
        {
            dbConnect db = new dbConnect();
            /// Lấy danh sách Hóa đơn bán hàng theo tên khách hàng
            public DataTable GetHoaDonBan_ByTenKhachHang(string tenKH)
            {
                SqlParameter[] para = { new SqlParameter("@TenKhachHang", tenKH ?? (object)DBNull.Value) }; 
                return db.GetData("sp_HoaDonBanHang_Select_ByTenKhachHang", para);
            }
            /// Lấy danh sách Phiếu thuê sách theo tên khách hàng
            public DataTable GetPhieuThue_ByTenKhachHang(string tenKH)
            {
                SqlParameter[] para = { new SqlParameter("@TenKhachHang", tenKH ?? (object)DBNull.Value) };
                return db.GetData("sp_PhieuThueSach_Select_ByTenKhachHang", para);
            }

            /// Lấy danh sách Phiếu thuê sách theo tên sách
            public DataTable GetPhieuThue_ByTenSach(string tenSach)
            {
                SqlParameter[] para = { new SqlParameter("@TenSach", tenSach ?? (object)DBNull.Value) };
                return db.GetData("sp_PhieuThueSach_Select_ByTenSach", para);
            }
            /// (Tùy chọn) Lấy tất cả hóa đơn bán hàng
            public DataTable GetAllHoaDonBan()
            {
                return db.GetData("sp_HoaDonBanHang_Select_All", null);
            }
            /// (Tùy chọn) Lấy tất cả phiếu thuê
            public DataTable GetAllPhieuThue()
            {
                return db.GetData("sp_PhieuThueSach_Select_All", null);
            }

        }
    }
}
