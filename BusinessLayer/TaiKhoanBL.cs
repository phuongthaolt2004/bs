using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

using DataLayer;
using TransferObject;

namespace BusinessLayer
{
    public class TaiKhoanBL
    {
        private TaiKhoanDL taiKhoanDL = new TaiKhoanDL();

        public TaiKhoan Login(TaiKhoan tk, string expectedLoaiTaiKhoan)
        {
            if (tk == null)
                throw new ArgumentNullException(nameof(tk), "Tài khoản không được null");

            if (string.IsNullOrEmpty(tk.TenDangNhap) || string.IsNullOrEmpty(tk.MatKhau))
                throw new ArgumentException("Tên đăng nhập và mật khẩu không được để trống");

            if (string.IsNullOrEmpty(expectedLoaiTaiKhoan))
                throw new ArgumentException("Loại tài khoản mong đợi không được để trống");

            TaiKhoan taiKhoan = taiKhoanDL.CheckLogin(tk.TenDangNhap, tk.MatKhau);

            if (taiKhoan != null && taiKhoan.LoaiTaiKhoan == expectedLoaiTaiKhoan)
            {
                return taiKhoan;
            }

            return null;
        }
    }
}
