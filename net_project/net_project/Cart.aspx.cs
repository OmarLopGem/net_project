using System;
using System.Web.UI;
using System.Web.UI.WebControls;
using net_project.Models;

namespace net_project
{
    public partial class Cart : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
                BindCart();
        }

        private void BindCart()
        {
            CartItemList cart = CartItemList.GetCart();

            if (cart.Count == 0)
            {
                pnlCart.Visible = false;
                lblEmpty.Visible = true;
                return;
            }

            pnlCart.Visible = true;
            lblEmpty.Visible = false;

            gvCart.DataSource = cart.GetCartItems();
            gvCart.DataBind();
            lblTotal.Text = cart.Total.ToString("C");
        }

        protected void gvCart_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            int index = Convert.ToInt32(e.CommandArgument);
            CartItemList cart = CartItemList.GetCart();

            if (e.CommandName == "RemoveItem")
            {
                cart.RemoveAt(index);
            }
            else if (e.CommandName == "UpdateQty")
            {
                GridViewRow row = gvCart.Rows[index];
                TextBox txtQty = row.FindControl("txtQty") as TextBox;
                int newQty;

                if (txtQty != null && int.TryParse(txtQty.Text.Trim(), out newQty) && newQty > 0)
                {
                    cart[index].Quantity = newQty;
                }
                else
                {
                    lblError.Text = "Please enter a valid quantity.";
                    lblError.Visible = true;
                }
            }

            BindCart();
        }
    }
}