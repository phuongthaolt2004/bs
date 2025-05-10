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
    public class SachBL
    {

        SachDL dl = new SachDL();

        public DataTable GetData()
        {
            return dl.GetData();
        }
        public int Insert(Sach obj)
        {
            return dl.Insert(obj);
        }
        public int Update(Sach obj)
        {
            return dl.Update(obj);
        }
        public int Delete(string MaSach)
        {
            return dl.Delete(MaSach);
        }


        public List<Sach> SearchBooks(string keyword, string searchType)
        {
            if (string.IsNullOrEmpty(keyword) || string.IsNullOrEmpty(searchType))
            {
                throw new ArgumentException("Từ khóa tìm kiếm và tiêu chí không được để trống");
            }

            // Khởi tạo đối tượng SachDL và gọi phương thức TimSach
            SachDL sachDL = new SachDL();
            return sachDL.TimSach(keyword, searchType);
        }

        public List<Sach> GetAll()
        {
            return dl.GetAll();
        }

        public string GetMaByTen(string tenSach)
        {
            return dl.GetMaByTen(tenSach);
        }

        public int TangSoLuongTonNeuLaBan(string maSach, int soLuong)
        {
            return dl.TangSoLuongTonNeuLaBan(maSach, soLuong);
        }
    }
}

 


