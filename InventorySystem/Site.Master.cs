using System;
using System.IO;
using System.Web.UI;

namespace InventorySystem
{
    public partial class Site : System.Web.UI.MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // 1. Kick out anyone who isn't logged in at all
            if (Session["UserID"] == null || Session["RoleName"] == null)
            {
                Response.Redirect("Login.aspx");
                return;
            }

            // 2. Set the User Info in the Sidebar
            if (!IsPostBack)
            {
                lblUserName.Text = Session["Username"].ToString();
                lblUserRole.Text = Session["RoleName"].ToString();
            }

            // 3. Enforce the hard security rules defined in the PDF
            EnforcePageSecurity();
        }

        private void EnforcePageSecurity()
        {
            string role = Session["RoleName"].ToString();
            // Get the current page the user is trying to access (e.g., "dashboard.aspx")
            string currentPage = Path.GetFileName(Request.Url.AbsolutePath).ToLower();

            // RULE A: Warehouse Staff Restrictions (No Dashboard, No Reports, No Admin)
            if (role == "Warehouse Staff")
            {
                if (currentPage == "dashboard.aspx" ||
                    currentPage == "inventoryreport.aspx" ||
                    currentPage == "stockmovementreport.aspx" ||
                    currentPage == "userlist.aspx" ||
                    currentPage == "usercreate.aspx" ||
                    currentPage == "useredit.aspx" ||
                    currentPage == "settings.aspx")
                {
                    Response.Redirect("ProductList.aspx");
                }
            }

            // RULE B: Management User Restrictions (No Stock In/Out, No Admin)
            if (role == "Management User")
            {
                if (currentPage == "stockin.aspx" ||
                    currentPage == "stockout.aspx" ||
                    currentPage == "productcreate.aspx" ||
                    currentPage == "productedit.aspx" ||
                    currentPage == "categorycreate.aspx" ||
                    currentPage == "categoryedit.aspx" ||
                    currentPage == "userlist.aspx" ||
                    currentPage == "usercreate.aspx" ||
                    currentPage == "useredit.aspx" ||
                    currentPage == "settings.aspx")
                {
                    Response.Redirect("Dashboard.aspx");
                }
            }
        }
    }
}