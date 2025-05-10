using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

using System.Data;
using System.Data.SqlClient;

namespace DataLayer
{
    public class dbConnect
    {
        private SqlConnection cnn;
        public dbConnect()
        {
            cnn = new SqlConnection(@"Data Source=.;Initial Catalog=QLCHBanSach;Integrated Security=True");
        }

        public DataTable GetDataTable(string strSQL) //select
        {
            DataTable dt = new DataTable();
            SqlDataAdapter da = new SqlDataAdapter(strSQL, cnn);
            cnn.Open();
            da.Fill(dt);
            cnn.Close();
            return dt;
        }

        public SqlConnection GetConnection()
        {
            return new SqlConnection(@"Data Source=.;Initial Catalog=QLCHBanSach;Integrated Security=True");
        }

        public DataTable GetData(string procName, SqlParameter[] para)
        {
            DataTable dt = new DataTable();
            SqlCommand cmd = new SqlCommand();
            cmd.CommandText = procName;
            cmd.CommandType = CommandType.StoredProcedure;
            if (para != null)
                cmd.Parameters.AddRange(para);
            cmd.Connection = cnn;
            SqlDataAdapter da = new SqlDataAdapter();
            da.SelectCommand = cmd;
            cnn.Open();
            da.Fill(dt);
            cnn.Close();
            return dt;
        }

        internal void CloseConnection(SqlConnection cn)
        {
            throw new NotImplementedException();
        }

        public int ExecuteSQL(string strSQL)
        {
            SqlCommand cmd = new SqlCommand(strSQL, cnn);
            cnn.Open();
            int row = cmd.ExecuteNonQuery();
            cnn.Close();
            return row;
        }

        public int ExecuteSQL(string procName, SqlParameter[] para)
        {
            SqlCommand cmd = new SqlCommand();
            cmd.CommandText = procName;
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Connection = cnn;
            if (para != null)
                cmd.Parameters.AddRange(para);
            cnn.Open();
            int row = cmd.ExecuteNonQuery();
            cnn.Close();
            return row;
        }

        public DataTable GetQuery(string sql, SqlParameter[] para)
        {
            DataTable dt = new DataTable();
            SqlCommand cmd = new SqlCommand(sql, cnn);
            cmd.CommandType = CommandType.Text; // 👈 dùng CommandType.Text để chạy SQL thường
            if (para != null)
                cmd.Parameters.AddRange(para);
            SqlDataAdapter da = new SqlDataAdapter(cmd);
            cnn.Open();
            da.Fill(dt);
            cnn.Close();
            return dt;
        }

        public int ExecuteScalar(string procName, SqlParameter[] para)
        {
            try
            {
                SqlCommand cmd = new SqlCommand(procName, cnn);
                cmd.CommandType = CommandType.StoredProcedure;
                if (para != null)
                    cmd.Parameters.AddRange(para);
                cnn.Open();
                object result = cmd.ExecuteScalar();
                cnn.Close();
                return result != null ? Convert.ToInt32(result) : 0;
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error ExecuteScalar: {ex.Message}");
                if (cnn.State == ConnectionState.Open) cnn.Close();
                return 0;
            }
        }
    }
}
