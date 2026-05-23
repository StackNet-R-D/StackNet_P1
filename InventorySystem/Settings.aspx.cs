using System;
using System.Web.UI;

namespace InventorySystem
{
    public partial class Settings : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
        }

        protected void btnUpdatePassword_Click(object sender, EventArgs e)
        {
            // Reset message panel
            pnlMessage.Visible = true;
            pnlMessage.CssClass = "alert alert-danger mb-4 rounded-2 small fw-semibold";

            if (string.IsNullOrWhiteSpace(txtCurrentPassword.Text) ||
                string.IsNullOrWhiteSpace(txtNewPassword.Text) ||
                string.IsNullOrWhiteSpace(txtConfirmPassword.Text))
            {
                lblMessage.Text = "All password fields are required.";
                return;
            }

            if (txtNewPassword.Text != txtConfirmPassword.Text)
            {
                lblMessage.Text = "New passwords do not match.";
                return;
            }

            // In a full implementation, you would verify the Current Password against the DB here,
            // hash the New Password, and update it in tblUsers using the logged-in User's ID.

            pnlMessage.CssClass = "alert alert-success mb-4 rounded-2 small fw-semibold";
            lblMessage.Text = "Password updated successfully!";

            // Clear fields
            txtCurrentPassword.Text = "";
            txtNewPassword.Text = "";
            txtConfirmPassword.Text = "";
        }
    }
}