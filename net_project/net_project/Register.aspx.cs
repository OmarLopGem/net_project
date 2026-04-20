using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Web;
using System.Web.UI;

namespace net_project
{
    public partial class Register : Page
    {
        private string ConnStr
        {
            get { return ConfigurationManager.ConnectionStrings["Database1Connection"].ConnectionString; }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                lblMessage.Text = "";
            }
        }

        protected void btnRegister_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid)
                return;

            string fullName = txtFullName.Text.Trim();
            string email = txtEmail.Text.Trim();
            string password = txtPassword.Text.Trim();

            using (SqlConnection conn = new SqlConnection(ConnStr))
            {
                conn.Open();

                string checkSql = "SELECT COUNT(1) FROM users WHERE email = @email";
                using (SqlCommand checkCmd = new SqlCommand(checkSql, conn))
                {
                    checkCmd.Parameters.AddWithValue("@email", email);
                    int exists = (int)checkCmd.ExecuteScalar();
                    if (exists > 0)
                    {
                        lblMessage.Text = "An account with that email already exists.";
                        return;
                    }
                }

                string insertSql = @"
                    INSERT INTO users (full_name, email, password_hash, is_admin)
                    VALUES (@fullName, @email, @password, 0);
                    SELECT SCOPE_IDENTITY();";

                using (SqlCommand insertCmd = new SqlCommand(insertSql, conn))
                {
                    insertCmd.Parameters.AddWithValue("@fullName", fullName);
                    insertCmd.Parameters.AddWithValue("@email", email);
                    insertCmd.Parameters.AddWithValue("@password", password);

                    int newUserId = Convert.ToInt32(insertCmd.ExecuteScalar());

                    Session["UserId"] = newUserId.ToString();
                    Session["FullName"] = fullName;
                    Session["Email"] = email;
                    Session["IsAdmin"] = false;
                }
            }

            Response.Redirect("~/Tickets.aspx");
        }
    }
}