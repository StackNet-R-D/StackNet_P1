using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;
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

        protected void btnSave_Click(object sender, EventArgs e)
        {
            pnlMessage.Visible = false;

            if (string.IsNullOrWhiteSpace(txtFullName.Text) || string.IsNullOrWhiteSpace(txtUsername.Text) || string.IsNullOrWhiteSpace(txtPassword.Text))
            {
                ShowError("Full Name, Username, and Password are required.");
                return;
            }

            try
            {
                using (var db = DBHelper.GetConnection())
                {
                    int count = db.ExecuteScalar<int>("SELECT COUNT(1) FROM tblUsers WHERE Username = @Username", new { Username = txtUsername.Text.Trim() });
                    if (count > 0)
                    {
                        ShowError("Username is already taken. Please choose another.");
                        return;
                    }

                    // Hashes password using BCrypt
                    string passwordHash = BCrypt.Net.BCrypt.HashPassword(txtPassword.Text);

                    string sql = @"
                        INSERT INTO tblUsers (FullName, Username, PasswordHash, RoleID, Status, CreatedDate) 
                        VALUES (@FullName, @Username, @PasswordHash, @RoleID, @Status, GETDATE())";

                    db.Execute(sql, new
                    {
                        FullName = txtFullName.Text.Trim(),
                        Username = txtUsername.Text.Trim(),
                        PasswordHash = passwordHash,
                        RoleID = Convert.ToInt32(ddlRole.SelectedValue),
                        Status = ddlStatus.SelectedValue
                    });

                    Response.Redirect("UserList.aspx", false);
                    Context.ApplicationInstance.CompleteRequest();
                }
            }
            catch (Exception ex)
            {
                ShowError("An error occurred: " + ex.Message);
            }
        }

        private void ShowError(string message)
        {
            pnlMessage.Visible = true;
            lblMessage.Text = message;
        }
    }
}