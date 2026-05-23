using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;
using Dapper;

namespace InventorySystem
{
    public partial class UserList : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadUsers();
            }
        }

        private void LoadUsers()
        {
            using (var db = DBHelper.GetConnection())
            {
                string sql = @"
                    SELECT u.UserID, u.FullName, u.Username, r.RoleName, u.Status, u.CreatedDate 
                    FROM tblUsers u
                    INNER JOIN tblRoles r ON u.RoleID = r.RoleID
                    WHERE 1=1 ";

                var parameters = new DynamicParameters();

                if (!string.IsNullOrWhiteSpace(txtSearch.Text))
                {
                    sql += " AND (u.FullName LIKE @Search OR u.Username LIKE @Search) ";
                    parameters.Add("@Search", "%" + txtSearch.Text.Trim() + "%");
                }

                sql += " ORDER BY u.UserID ASC";

                using (var reader = db.ExecuteReader(sql, parameters))
                {
                    DataTable dt = new DataTable();
                    dt.Load(reader);

                    gvUsers.DataSource = dt;
                    gvUsers.DataBind();

                    lblTotalUsers.Text = dt.Rows.Count.ToString();
                }
            }
        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            pnlMessage.Visible = false;
            LoadUsers();
        }

        protected void gvUsers_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            pnlMessage.Visible = false;

            if (e.CommandArgument == null || string.IsNullOrEmpty(e.CommandArgument.ToString())) return;
            int userID = Convert.ToInt32(e.CommandArgument);

            if (userID == 1 && e.CommandName == "DeleteUser")
            {
                pnlMessage.Visible = true;
                lblMessage.Text = "Security Restriction: You cannot delete the primary System Administrator account.";
                return;
            }

            if (e.CommandName == "EditUser")
            {
                Response.Redirect($"UserEdit.aspx?id={userID}");
            }
            else if (e.CommandName == "DeleteUser")
            {
                try
                {
                    using (var db = DBHelper.GetConnection())
                    {
                        db.Execute("UPDATE tblUsers SET Status = 'Inactive' WHERE UserID = @ID", new { ID = userID });
                    }
                    LoadUsers();
                }
                catch (Exception ex)
                {
                    pnlMessage.Visible = true;
                    lblMessage.Text = "Error updating user: " + ex.Message;
                }
            }
        }
    }
}