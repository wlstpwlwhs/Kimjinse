using System;
using System.Data;
using System.Data.SqlClient;


namespace Study
{
	public class Database
	{

		private SqlConnection dbcon;

		public Database()
		{
			dbcon = 
			new SqlConnection("server=notebook-PC\\STUDY;user id=sa;password=1121;database=aspnet;");
		}

		private void DBOpen()
		{
			if(dbcon.State != ConnectionState.Open)
				dbcon.Open();
		}

		private void DBClose()
		{
			if(dbcon.State != ConnectionState.Closed)
				dbcon.Close();
		}


		public void ExecuteQuery(string query)
		{
			SqlCommand cmd = new SqlCommand(query, dbcon);

			DBOpen();
				cmd.ExecuteNonQuery();
			DBClose();
		}

		public object ExecuteQueryResult(string query)
		{
			object return_val = null;

			SqlCommand cmd = new SqlCommand(query, dbcon);

			DBOpen();
				return_val = cmd.ExecuteScalar();
			DBClose();

			return return_val;

		}

		public DataTable ExecuteQueryDataTable(string query)
		{
			DataSet ds = new DataSet();
			DBOpen();

				SqlDataAdapter da = new SqlDataAdapter(query, dbcon);
				da.Fill(ds, "tmp");

			DBClose();

			return ds.Tables[0];			

		}


	}
	
}


