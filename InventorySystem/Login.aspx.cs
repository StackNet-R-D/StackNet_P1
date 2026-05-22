using System;
using System.Data;
using System.Linq;
using System.Web.UI;
using Dapper;
using BCrypt.Net;

namespace InventorySystem
{
    public partial class Login : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Clear session on load to ensure user is fully logged out
                Session.Clear();
            }
        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            // 1. Grab inputs from the UI
            int roleId = int.Parse(ddlRole.SelectedValue);
            string username = txtUsername.Text.Trim();
            string password = txtPassword.Text.Trim();

            if (string.IsNullOrEmpty(username) || string.IsNullOrEmpty(password))
            {
                lblMessage.Text = "Please enter both username and password.";
                return;
            }

            try
            {
                // 2. Open SQL Connection using our DBHelper
                using (IDbConnection db = DBHelper.GetConnection())
                {
                    // 3. Query the database for the user using Dapper
                    string query = "SELECT * FROM tblUsers WHERE Username = @Username AND RoleID = @RoleID AND Status = 'Active'";
                    var user = db.QueryFirstOrDefault(query, new { Username = username, RoleID = roleId });

                    if (user != null)
                    {
                        // --- BOOTSTRAP TRICK: Fix the placeholder hash from our SQL script ---
                        if (user.PasswordHash == "HASH_PLACEHOLDER")
                        {
                            string newHash = BCrypt.Net.BCrypt.HashPassword(password);
                            db.Execute("UPDATE tblUsers SET PasswordHash = @Hash WHERE UserID = @Id", new { Hash = newHash, Id = user.UserID });
                            user.PasswordHash = newHash; // Update local variable so login succeeds
                        }
                        // ----------------------------------------------------------------------

                        // 4. Verify the password using BCrypt
                        bool isPasswordValid = BCrypt.Net.BCrypt.Verify(password, user.PasswordHash);

                        if (isPasswordValid)
                        {
                            // 5. Success! Set Session variables
                            Session["UserID"] = user.UserID;
                            Session["Username"] = user.Username;
                            Session["FullName"] = user.FullName;
                            Session["RoleID"] = user.RoleID;

                            // 6. Route users based on their RoleID from the MVP document
                            int currentRole = Convert.ToInt32(user.RoleID);

                            if (currentRole == 1 || currentRole == 3)
                            {
                                // Administrator (1) and Management (3) go to the Dashboard
                                Response.Redirect("~/Dashboard.aspx", false);
                            }
                            else if (currentRole == 2)
                            {
                                // Warehouse Staff (2) bypass the dashboard to Inventory Operations
                                Response.Redirect("~/StockIn.aspx", false);
                            }

                            Context.ApplicationInstance.CompleteRequest();
                        }
                        else
                        {
                            lblMessage.Text = "Invalid password.";
                        }
                    }
                    else
                    {
                        lblMessage.Text = "Invalid username or role selection.";
                    }
                }
            }
            catch (Exception ex)
            {
                // In a real app we'd log this, but for now we just show it
                lblMessage.Text = "Database Error: " + ex.Message;
            }
        }
    }
}