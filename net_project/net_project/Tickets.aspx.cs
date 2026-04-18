using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
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
            if (e.CommandName == "AddToCart")
            {
                int ticketId = Convert.ToInt32(e.CommandArgument);

                GridViewRow row = ((Button)e.CommandSource).NamingContainer as GridViewRow;
                DropDownList ddlQuantity = row.FindControl("ddlQuantity") as DropDownList;
                int quantity = Convert.ToInt32(ddlQuantity.SelectedValue);

                string matchName = row.Cells[0].Text + " vs " + row.Cells[1].Text;
                decimal price = Convert.ToDecimal(row.Cells[5].Text.Replace("$", "").Replace(",", ""));

                List<CartItem> cart = Session["Cart"] as List<CartItem>;
                if (cart == null)
                {
                    cart = new List<CartItem>();
                }

                CartItem existingItem = cart.Find(x => x.ProductId == ticketId && x.ProductType == "Ticket");

                if (existingItem != null)
                {
                    existingItem.Quantity += quantity;
                }
                else
                {
                    cart.Add(new CartItem
                    {
                        ProductId = ticketId,
                        ProductType = "Ticket",
                        Name = matchName,
                        Price = price,
                        Quantity = quantity
                    });
                }

                Session["Cart"] = cart;
                lblMessage.Text = "Ticket added to cart successfully.";
            }
        }
    }
}