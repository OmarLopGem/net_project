using System;
using System.Data.SqlClient;
using System.IO;
using System.Web;
using System.Web.Optimization;
using System.Web.Routing;
using System.Web.SessionState;

namespace net_project
{
    public class Global : HttpApplication
    {
        void Application_Start(object sender, EventArgs e)
        {
            // Código que se ejecuta al iniciar la aplicación
            RouteConfig.RegisterRoutes(RouteTable.Routes);
            BundleConfig.RegisterBundles(BundleTable.Bundles);
            InitializeDatabase();
        }


        private void InitializeDatabase()
        {
            string mdfPath = Server.MapPath("~/App_Data/Database1.mdf");

            if (!File.Exists(mdfPath))
                throw new Exception("No se encontró la base de datos: " + mdfPath);

            string connectionString = $@"Data Source=(LocalDB)\MSSQLLocalDB;AttachDbFilename={mdfPath};Integrated Security=True;Connect Timeout=30;Encrypt=False";

            using (var conn = new SqlConnection(connectionString))
            {
                conn.Open();

                var checkCmd = new SqlCommand(
                    "SELECT COUNT(*) FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'users'",
                    conn
                );

                int tableCount = (int)checkCmd.ExecuteScalar();
                if (tableCount > 0) return;

                string scriptPath = Server.MapPath("~/App_Data/SQLQuery1.sql");
                string script = File.ReadAllText(scriptPath);

                var commands = script.Split(
                    new[] { "\r\nGO", "\nGO", "\r\ngo", "\ngo" },
                    StringSplitOptions.RemoveEmptyEntries
                );

                foreach (var sql in commands)
                {
                    if (string.IsNullOrWhiteSpace(sql)) continue;

                    using (var cmd = new SqlCommand(sql, conn))
                    {
                        cmd.ExecuteNonQuery();
                    }
                }
            }
        }
    }
}