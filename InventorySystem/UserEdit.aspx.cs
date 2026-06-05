using System;
using System.Data;
using System.Data.SqlClient;
using Dapper;

namespace InventorySystem
{
    public partial class UserEdit : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadRoles();

                if (Request.QueryString["id"] != null)
                {
                    int userId = Convert.ToInt32(Request.QueryString["id"]);
                    hfUserID.Value = userId.ToString();
                    LoadUserData(userId);
                }
                else
                {
                    Response.Redirect("~/UserList.aspx");
                }
            }
        }

        private void LoadRoles()
        {
            using (var db = DBHelper.GetConnection())
            {
                // FIX: Use ExecuteReader and DataTable to avoid the DapperRow error
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

        private void LoadUserData(int userId)
        {
            using (var db = DBHelper.GetConnection())
            {
                var user = db.QueryFirstOrDefault("SELECT * FROM tblUsers WHERE UserID = @ID", new { ID = userId });
                if (user != null)
                {
                    txtFullName.Text = user.FullName;
                    txtUsername.Text = user.Username;
                    ddlRole.SelectedValue = user.RoleID.ToString();
                    ddlStatus.SelectedValue = user.Status;
                }
            }
        }

        protected void btnUpdate_Click(object sender, EventArgs e)
        {
            try
            {
                int userId = Convert.ToInt32(hfUserID.Value);
                string fullName = txtFullName.Text.Trim();
                string username = txtUsername.Text.Trim();
                int roleId = Convert.ToInt32(ddlRole.SelectedValue);
                string status = ddlStatus.SelectedValue;
                string newPassword = txtPassword.Text.Trim();

                using (var db = DBHelper.GetConnection())
                {
                    // Check if username exists for a DIFFERENT user
                    var existing = db.QueryFirstOrDefault("SELECT UserID FROM tblUsers WHERE Username = @Username AND UserID != @ID", new { Username = username, ID = userId });
                    if (existing != null)
                    {
                        pnlMessage.Visible = true;
                        pnlSuccess.Visible = false;
                        lblMessage.Text = "Username is already taken by another user.";
                        return;
                    }

                    if (!string.IsNullOrEmpty(newPassword))
                    {
                        // Update WITH new hashed password
                        string hashedPassword = BCrypt.Net.BCrypt.HashPassword(newPassword);
                        string sql = @"UPDATE tblUsers SET FullName = @FullName, Username = @Username, 
                                       PasswordHash = @Hash, RoleID = @RoleID, Status = @Status WHERE UserID = @ID";

                        db.Execute(sql, new { FullName = fullName, Username = username, Hash = hashedPassword, RoleID = roleId, Status = status, ID = userId });
                    }
                    else
                    {
                        // Update WITHOUT changing password
                        string sql = @"UPDATE tblUsers SET FullName = @FullName, Username = @Username, 
                                       RoleID = @RoleID, Status = @Status WHERE UserID = @ID";

                        db.Execute(sql, new { FullName = fullName, Username = username, RoleID = roleId, Status = status, ID = userId });
                    }
                }

                pnlSuccess.Visible = true;
                pnlMessage.Visible = false;
            }
            catch (Exception ex)
            {
                pnlMessage.Visible = true;
                pnlSuccess.Visible = false;
                lblMessage.Text = "Error updating user: " + ex.Message;
            }
        }
    }
}