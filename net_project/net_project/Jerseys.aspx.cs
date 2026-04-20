// Jerseys.aspx.cs
using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;
using net_project.Models;

namespace net_project
{
    public partial class Jerseys : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
        }

        protected void GridView1_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName != "AddToCart") return;

            int jerseyId = Convert.ToInt32(e.CommandArgument);
            string description;
            decimal unitPrice;

            string connStr = ConfigurationManager.ConnectionStrings["Database1Connection"].ConnectionString;

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();
                SqlCommand cmd = new SqlCommand(
                    "SELECT team_name, size, price FROM jerseys WHERE id = @id", conn);
                cmd.Parameters.AddWithValue("@id", jerseyId);

                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    reader.Read();
                    description = reader["team_name"] + " Jersey - " + reader["size"];
                    unitPrice = (decimal)reader["price"];
                }
            }

            CartItemList cart = CartItemList.GetCart();
            cart.AddItem(jerseyId, "jersey", description, unitPrice, 1);

            lblMessage.Text = "Item added to cart successfully.";
            lblMessage.Visible = true;
        }
    }
}