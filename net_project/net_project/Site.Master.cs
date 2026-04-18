using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace net_project
{
    public partial class SiteMaster : MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            bool loggedIn = Session["UserId"] != null;
            bool isAdmin = Session["IsAdmin"] != null && (bool)Session["IsAdmin"];

            phGuest.Visible = !loggedIn;
            phUser.Visible = loggedIn;
            phAdmin.Visible = loggedIn && isAdmin;
        }
    }
}