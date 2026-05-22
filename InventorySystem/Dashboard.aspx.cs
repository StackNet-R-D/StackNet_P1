using System;

namespace InventorySystem
{
    public partial class Dashboard : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Security Check: Kick them back to login if they don't have an active session
            if (Session["UserID"] == null)
            {
                Response.Redirect("~/Login.aspx");
            }
        }
    }
}