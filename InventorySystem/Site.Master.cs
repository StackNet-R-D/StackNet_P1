using System;

namespace InventorySystem
{
    public partial class Site : System.Web.UI.MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Global Security: Kick out anyone without an active session
            if (Session["UserID"] == null)
            {
                Response.Redirect("~/Login.aspx");
            }

            // Update the sidebar with the logged-in user's actual name
            if (!IsPostBack && Session["FullName"] != null)
            {
                lblUserName.Text = Session["FullName"].ToString();
            }
        }
    }
}