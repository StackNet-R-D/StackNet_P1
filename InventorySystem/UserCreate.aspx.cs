using System;
using System.Data;
using System.Data.SqlClient;
using Dapper;

namespace InventorySystem
{
    public partial class UserCreate : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadRoles();
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

        protected void btnSave_Click(object sender, EventArgs e)
        {
            try
            {
                string fullName = txtFullName.Text.Trim();
                string username = txtUsername.Text.Trim();
                string rawPassword = txtPassword.Text.Trim();
                int roleId = Convert.ToInt32(ddlRole.SelectedValue);
                string status = ddlStatus.SelectedValue;

                // Hash the password securely
                string hashedPassword = BCrypt.Net.BCrypt.HashPassword(rawPassword);

                using (var db = DBHelper.GetConnection())
                {
                    // Check if username already exists
                    var existingUser = db.QueryFirstOrDefault("SELECT UserID FROM tblUsers WHERE Username = @Username", new { Username = username });
                    if (existingUser != null)
                    {
                        pnlMessage.Visible = true;
                        lblMessage.Text = "Username is already taken. Please choose another.";
                        return;
                    }

                    string sql = @"INSERT INTO tblUsers (FullName, Username, PasswordHash, RoleID, Status) 
                                   VALUES (@FullName, @Username, @PasswordHash, @RoleID, @Status)";

                    db.Execute(sql, new
                    {
                        FullName = fullName,
                        Username = username,
                        PasswordHash = hashedPassword,
                        RoleID = roleId,
                        Status = status
                    });
                }

                Response.Redirect("~/UserList.aspx");
            }
            catch (Exception ex)
            {
                pnlMessage.Visible = true;
                lblMessage.Text = "Error saving user: " + ex.Message;
            }
        }
    }
} 