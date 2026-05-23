using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;
using Dapper;

namespace InventorySystem
{
    public partial class Login : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                Session.Clear();
                Session.Abandon();

                LoadRoles();
                LoadDynamicStats(); // <-- Fetches the real numbers for the bottom left
            }
        }

        private void LoadDynamicStats()
        {
            try
            {
                using (var db = DBHelper.GetConnection())
                {
                    // Count how many roles actually exist in the database
                    int roleCount = db.ExecuteScalar<int>("SELECT COUNT(*) FROM tblRoles");
                    lblRoleCount.Text = roleCount.ToString();
                }
            }
            catch
            {
                lblRoleCount.Text = "0"; // Fallback if DB is unreachable
            }
        }

        private void LoadRoles()
        {
            try
            {
                using (var db = DBHelper.GetConnection())
                {
                    string sql = "SELECT RoleID, RoleName FROM tblRoles ORDER BY RoleID";
                    using (var reader = db.ExecuteReader(sql))
                    {
                        DataTable dt = new DataTable();
                        dt.Load(reader);

                        ddlRole.DataSource = dt;
                        ddlRole.DataTextField = "RoleName";
                        ddlRole.DataValueField = "RoleID";
                        ddlRole.DataBind();
                    }
                }
            }
            catch (Exception ex)
            {
                ShowError("Database connection failed. Is SQL Server running?");
            }
        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            pnlError.Visible = false;

            string username = txtUsername.Text.Trim();
            string password = txtPassword.Text;
            int selectedRoleID = Convert.ToInt32(ddlRole.SelectedValue);

            if (string.IsNullOrEmpty(username) || string.IsNullOrEmpty(password))
            {
                ShowError("Please enter both username and password.");
                return;
            }

            try
            {
                using (var db = DBHelper.GetConnection())
                {
                    string sql = @"
                        SELECT u.UserID, u.FullName, u.Username, u.PasswordHash, u.RoleID, u.Status, r.RoleName
                        FROM tblUsers u
                        INNER JOIN tblRoles r ON u.RoleID = r.RoleID
                        WHERE u.Username = @Username";

                    var user = db.QueryFirstOrDefault(sql, new { Username = username });

                    if (user == null)
                    {
                        ShowError("Invalid username or password.");
                        return;
                    }

                    if (user.Status != "Active")
                    {
                        ShowError("This account has been deactivated. Please contact an administrator.");
                        return;
                    }

                    if (user.RoleID != selectedRoleID)
                    {
                        ShowError($"The user '{username}' is not assigned to the selected role.");
                        return;
                    }

                    bool isPasswordValid = BCrypt.Net.BCrypt.Verify(password, user.PasswordHash);

                    if (!isPasswordValid)
                    {
                        ShowError("Invalid username or password.");
                        return;
                    }

                    Session["UserID"] = user.UserID;
                    Session["Username"] = user.Username;
                    Session["FullName"] = user.FullName;
                    Session["RoleName"] = user.RoleName;

                    db.Execute("INSERT INTO tblSystemLogs (UserID, Action, LogDate) VALUES (@UID, 'User logged into the system', GETDATE())",
                        new { UID = user.UserID });

                    // Role-Based Routing
                    if (user.RoleName == "Administrator" || user.RoleName == "Management User")
                    {
                        Response.Redirect("Dashboard.aspx", false);
                    }
                    else if (user.RoleName == "Warehouse Staff")
                    {
                        Response.Redirect("ProductList.aspx", false);
                    }

                    Context.ApplicationInstance.CompleteRequest();
                }
            }
            catch (Exception ex)
            {
                ShowError("System error during login: " + ex.Message);
            }
        }

        private void ShowError(string message)
        {
            pnlError.Visible = true;
            lblError.Text = message;
        }
    }
}