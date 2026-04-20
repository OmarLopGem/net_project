// Tickets.aspx.cs
using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;
using net_project.Models;

namespace net_project
{
    public partial class Tickets : System.Web.UI.Page
    {
        string connectionString = ConfigurationManager.ConnectionStrings["Database1Connection"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserId"] == null)
            {
                Response.Redirect("~/Default.aspx");
            }
            if (!IsPostBack)
            {
                LoadTickets();
            }
        }

        private void LoadTickets(string team = "")
        {
            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();
                string query = @"
                    SELECT 
                        t.id,
                        m.home_team,
                        m.away_team,
                        m.match_date,
                        m.venue,
                        t.category,
                        t.price,
                        t.stock
                    FROM tickets t
                    INNER JOIN matches m ON t.match_id = m.id
                    WHERE (
                        @team = '' 
                        OR m.home_team LIKE '%' + @team + '%'
                        OR m.away_team LIKE '%' + @team + '%'
                    )
                    ORDER BY m.match_date";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@team", team);
                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        DataTable dt = new DataTable();
                        da.Fill(dt);
                        gvTickets.DataSource = dt;
                        gvTickets.DataBind();
                    }
                }
            }
        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            LoadTickets(txtTeam.Text.Trim());
        }

        protected void gvTickets_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName != "AddToCart") return;

            int ticketId = Convert.ToInt32(e.CommandArgument);

            GridViewRow row = ((Button)e.CommandSource).NamingContainer as GridViewRow;
            DropDownList ddlQuantity = row.FindControl("ddlQuantity") as DropDownList;
            int quantity = Convert.ToInt32(ddlQuantity.SelectedValue);

            string description;
            decimal unitPrice;

            using (SqlConnection conn = new SqlConnection(connectionString))
            {
                conn.Open();
                SqlCommand cmd = new SqlCommand(@"
                    SELECT t.category, t.price, m.home_team, m.away_team
                    FROM tickets t
                    INNER JOIN matches m ON t.match_id = m.id
                    WHERE t.id = @id", conn);
                cmd.Parameters.AddWithValue("@id", ticketId);

                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    reader.Read();
                    description = reader["home_team"] + " vs " + reader["away_team"]
                                + " - " + reader["category"];
                    unitPrice = (decimal)reader["price"];
                }
            }

            CartItemList cart = CartItemList.GetCart();
            cart.AddItem(ticketId, "ticket", description, unitPrice, quantity);

            lblMessage.Text = "Ticket added to cart successfully.";
        }
    }
}