using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;
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

                // Get the UserID from the URL
                if (Request.QueryString["id"] != null && int.TryParse(Request.QueryString["id"], out int userId))
                {
                    hfUserID.Value = userId.ToString();
                    LoadUserData(userId);
                }
                else
                {
                    Response.Redirect("UserList.aspx");
                }
            }
        }

        private void LoadRoles()
        {
            try
            {
                using (var db = DBHelper.GetConnection())
                {
                    using (var reader = db.ExecuteReader("SELECT RoleID, RoleName FROM tblRoles ORDER BY RoleID"))
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
                ShowError("Error loading roles: " + ex.Message);
            }
        }

        private void LoadUserData(int userId)
        {
            try
            {
                using (var db = DBHelper.GetConnection())
                {
                    string sql = "SELECT FullName, Username, RoleID, Status FROM tblUsers WHERE UserID = @ID";
                    var user = db.QueryFirstOrDefault(sql, new { ID = userId });

                    if (user != null)
                    {
                        txtFullName.Text = user.FullName;
                        txtUsername.Text = user.Username;

                        if (user.RoleID != null)
                        {
                            ddlRole.SelectedValue = user.RoleID.ToString();
                        }
                        if (user.Status != null)
                        {
                            ddlStatus.SelectedValue = user.Status.ToString();
                        }

                        // Prevent locking out the main admin account by accident
                        if (userId == 1)
                        {
                            ddlStatus.Enabled = false;
                            ddlRole.Enabled = false;
                        }
                    }
                    else
                    {
                        ShowError("User not found.");
                        btnUpdate.Enabled = false;
                    }
                }
            }
            catch (Exception ex)
            {
                ShowError("Error loading user data: " + ex.Message);
            }
        }

        protected void btnUpdate_Click(object sender, EventArgs e)
        {
            pnlMessage.Visible = false;
            pnlSuccess.Visible = false;

            if (string.IsNullOrWhiteSpace(txtFullName.Text) || string.IsNullOrWhiteSpace(txtUsername.Text))
            {
                ShowError("Full Name and Username are required.");
                return;
            }

            int userId = Convert.ToInt32(hfUserID.Value);

            try
            {
                using (var db = DBHelper.GetConnection())
                {
                    // Check for duplicate username (ignoring the current user's own ID)
                    int count = db.ExecuteScalar<int>("SELECT COUNT(1) FROM tblUsers WHERE Username = @Username AND UserID != @ID",
                        new { Username = txtUsername.Text.Trim(), ID = userId });

                    if (count > 0)
                    {
                        ShowError("Another user is already using this Username.");
                        return;
                    }

                    // Logic to handle optional password change
                    if (!string.IsNullOrWhiteSpace(txtPassword.Text))
                    {
                        // Update everything INCLUDING the new hashed password
                        string passwordHash = BCrypt.Net.BCrypt.HashPassword(txtPassword.Text);
                        string sql = @"
                            UPDATE tblUsers SET 
                                FullName = @FullName, 
                                Username = @Username, 
                                PasswordHash = @PasswordHash, 
                                RoleID = @RoleID, 
                                Status = @Status 
                            WHERE UserID = @ID";

                        db.Execute(sql, new
                        {
                            ID = userId,
                            FullName = txtFullName.Text.Trim(),
                            Username = txtUsername.Text.Trim(),
                            PasswordHash = passwordHash,
                            RoleID = Convert.ToInt32(ddlRole.SelectedValue),
                            Status = ddlStatus.SelectedValue
                        });
                    }
                    else
                    {
                        // Update everything EXCEPT the password
                        string sql = @"
                            UPDATE tblUsers SET 
                                FullName = @FullName, 
                                Username = @Username, 
                                RoleID = @RoleID, 
                                Status = @Status 
                            WHERE UserID = @ID";

                        db.Execute(sql, new
                        {
                            ID = userId,
                            FullName = txtFullName.Text.Trim(),
                            Username = txtUsername.Text.Trim(),
                            RoleID = Convert.ToInt32(ddlRole.SelectedValue),
                            Status = ddlStatus.SelectedValue
                        });
                    }

                    pnlSuccess.Visible = true;
                }
            }
            catch (Exception ex)
            {
                ShowError("An error occurred while updating: " + ex.Message);
            }
        }

        private void ShowError(string message)
        {
            pnlMessage.Visible = true;
            lblMessage.Text = message;
        }
    }
}