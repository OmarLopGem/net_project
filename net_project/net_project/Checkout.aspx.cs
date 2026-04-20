using net_project.Models;
using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Web.UI;
using WebGrease.Activities;

namespace net_project
{
    public partial class Checkout : Page
    {
        private string ConnStr
        {
        get { return ConfigurationManager.ConnectionStrings["Database1Connection"].ConnectionString; }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                CartItemList cart = CartItemList.GetCart();

                if (cart.Count == 0)
                {
                    Response.Redirect("~/Cart.aspx");
                    return;
                }

                lblTotal.Text = cart.Total.ToString("C");
            }
        }

        protected void btnConfirm_Click(object sender, EventArgs e)
        {
            CartItemList cart = CartItemList.GetCart();

            if (cart.Count == 0)
            {
                lblError.Text = "Your cart is empty.";
                lblError.Visible = true;
                return;
            }

            using (SqlConnection conn = new SqlConnection(ConnStr))
            {
                conn.Open();

                foreach (CartItem item in cart.GetCartItems())
                {
                    string table = item.ItemType == "ticket" ? "tickets" : "jerseys";
                    SqlCommand stockCmd = new SqlCommand(
                        "SELECT stock FROM " + table + " WHERE id = @id", conn);
                    stockCmd.Parameters.AddWithValue("@id", item.ItemId);

                    int stock = (int)stockCmd.ExecuteScalar();
                    if (stock < item.Quantity)
                    {
                        lblError.Text = "Not enough stock for: " + item.Description
                                         + ". Available: " + stock + ".";
                        lblError.Visible = true;
                        return;
                    }
                }

                SqlCommand orderCmd = new SqlCommand(@"
                    INSERT INTO orders (user_id, status, total, created_at, updated_at)
                    VALUES (1, 'confirmed', @total, GETUTCDATE(), GETUTCDATE());
                    SELECT SCOPE_IDENTITY();", conn);
                orderCmd.Parameters.AddWithValue("@total", cart.Total);
                int orderId = Convert.ToInt32(orderCmd.ExecuteScalar());

                foreach (CartItem item in cart.GetCartItems())
                {
                    string insertSql = item.ItemType == "ticket"
                        ? @"INSERT INTO order_items
                                (order_id, ticket_id, jersey_id, quantity, unit_price, redeemed)
                            VALUES (@orderId, @itemId, NULL, @qty, @price, 0)"
                        : @"INSERT INTO order_items
                                (order_id, ticket_id, jersey_id, quantity, unit_price, redeemed)
                            VALUES (@orderId, NULL, @itemId, @qty, @price, 0)";

                    using (SqlCommand itemCmd = new SqlCommand(insertSql, conn))
                    {
                        itemCmd.Parameters.AddWithValue("@orderId", orderId);
                        itemCmd.Parameters.AddWithValue("@itemId", item.ItemId);
                        itemCmd.Parameters.AddWithValue("@qty", item.Quantity);
                        itemCmd.Parameters.AddWithValue("@price", item.UnitPrice);
                        itemCmd.ExecuteNonQuery();
                    }

                    string table = item.ItemType == "ticket" ? "tickets" : "jerseys";
                    using (SqlCommand stockCmd = new SqlCommand(
                        "UPDATE " + table + " SET stock = stock - @qty WHERE id = @id", conn))
                    {
                        stockCmd.Parameters.AddWithValue("@qty", item.Quantity);
                        stockCmd.Parameters.AddWithValue("@id", item.ItemId);
                        stockCmd.ExecuteNonQuery();
                    }
                }
            }

            cart.Clear();
            Response.Redirect("~/Jerseys");
        }
    }
}