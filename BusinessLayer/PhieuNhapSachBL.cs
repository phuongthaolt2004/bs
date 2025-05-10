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
    public class PhieuNhapSachBL
    {
        PhieuNhapSachDL dl = new PhieuNhapSachDL();
        public int InsertPhieuNhap(PhieuNhapSach pn) => dl.InsertPhieuNhap(pn);
        public int UpdatePhieuNhap(PhieuNhapSach pn) => dl.UpdatePhieuNhap(pn);
        public int InsertChiTietPhieuNhap(ChiTietPhieuNhap ct) => dl.InsertChiTietPhieuNhap(ct);
    }
}
