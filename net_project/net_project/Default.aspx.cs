using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Web;
using System.Web.UI;


namespace net_project
{
    public partial class _Default : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                lblMessage.Text = "";
            }
        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid)
            {
                return;
            }

            string email = txtEmail.Text.Trim();
            string password = txtPassword.Text.Trim();

            string connectionString = ConfigurationManager.ConnectionStrings["Database1Connection"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();

                string query = "SELECT id, full_name, email, password_hash, is_admin FROM users WHERE email = @email";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@email", email);

                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            string storedPasswword = reader["password_hash"].ToString();

                            if (password == storedPasswword)
                            {
                                Session["UserId"] = reader["id"].ToString();
                                Session["FullName"] = reader["full_name"].ToString();
                                Session["Email"] = reader["email"].ToString();
                                Session["IsAdmin"] = Convert.ToBoolean(reader["is_admin"]);

                                if (chkRememberMe.Checked)
                                {
                                    HttpCookie userCookie = new HttpCookie("UserEmail");
                                    userCookie.Value = reader["email"].ToString();
                                    userCookie.Expires = DateTime.Now.AddDays(7);
                                    Response.Cookies.Add(userCookie);
                                }

                                Response.Redirect("~/Tickets.aspx");
                            }
                            else
                            {
                                lblMessage.Text = "Invalid email or password.";
                            }
                        }
                        else
                        {
                            lblMessage.Text = "Invalid email or password.";
                        }
                    }
                }
            }
        }
    }
}