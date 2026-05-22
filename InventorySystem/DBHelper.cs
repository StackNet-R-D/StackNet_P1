using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace InventorySystem
{
    public static class DBHelper
    {
        // Retrieves the connection string from Web.config
        public static string GetConnectionString()
        {
            return ConfigurationManager.ConnectionStrings["InventoryDB"].ConnectionString;
        }

        // Returns an open SQL connection ready for Dapper to use
        public static IDbConnection GetConnection()
        {
            var connection = new SqlConnection(GetConnectionString());
            connection.Open();
            return connection;
        }
    }
}