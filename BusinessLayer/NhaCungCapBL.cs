using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using DataLayer;
using System.Data;
using TransferObject;

namespace BusinessLayer
{
    public class NhaCungCapBL
    {
        NhaCungCapDL dl = new NhaCungCapDL();

        public DataTable GetData() => dl.GetData();
        public int Insert(NhaCungCap ncc) => dl.Insert(ncc);
        public int Update(NhaCungCap ncc) => dl.Update(ncc);
        public int Delete(string maNCC) => dl.Delete(maNCC);
        public DataTable Search(string ten, string sdt) => dl.Search(ten, sdt);
    }
}
