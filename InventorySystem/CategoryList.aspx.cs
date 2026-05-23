using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;
using Dapper;

namespace InventorySystem
{
    public partial class CategoryList : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadCategories();
            }
        }

        private void LoadCategories()
        {
            using (var db = DBHelper.GetConnection())
            {
                string sql = "SELECT CategoryID, CategoryName, Description FROM tblCategories WHERE 1=1 ";
                var parameters = new DynamicParameters();

                if (!string.IsNullOrWhiteSpace(txtSearch.Text))
                {
                    sql += " AND (CategoryName LIKE @Search OR Description LIKE @Search) ";
                    parameters.Add("@Search", "%" + txtSearch.Text.Trim() + "%");
                }

                sql += " ORDER BY CategoryID DESC";

                using (var reader = db.ExecuteReader(sql, parameters))
                {
                    DataTable dt = new DataTable();
                    dt.Load(reader);

                    gvCategories.DataSource = dt;
                    gvCategories.DataBind();

                    lblTotalCategories.Text = dt.Rows.Count.ToString();
                }
            }
        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            pnlMessage.Visible = false;
            gvCategories.PageIndex = 0; // Reset to page 1 on new search
            LoadCategories();
        }

        // Handles the Pagination clicks (1, 2, 3...)
        protected void gvCategories_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            gvCategories.PageIndex = e.NewPageIndex;
            LoadCategories();
        }

        protected void gvCategories_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            pnlMessage.Visible = false;

            if (e.CommandArgument == null || string.IsNullOrEmpty(e.CommandArgument.ToString())) return;
            int categoryID = Convert.ToInt32(e.CommandArgument);

            if (e.CommandName == "EditCategory")
            {
                Response.Redirect($"CategoryEdit.aspx?id={categoryID}");
            }
            else if (e.CommandName == "DeleteCategory")
            {
                try
                {
                    using (var db = DBHelper.GetConnection())
                    {
                        db.Execute("DELETE FROM tblCategories WHERE CategoryID = @ID", new { ID = categoryID });
                    }
                    LoadCategories();
                }
                catch (System.Data.SqlClient.SqlException sqlEx)
                {
                    if (sqlEx.Number == 547) // Foreign Key Constraint Violation
                    {
                        pnlMessage.Visible = true;
                        lblMessage.Text = "Cannot delete this category because there are products assigned to it. Please reassign or delete those products first.";
                    }
                    else
                    {
                        pnlMessage.Visible = true;
                        lblMessage.Text = "Database Error: " + sqlEx.Message;
                    }
                }
                catch (Exception ex)
                {
                    pnlMessage.Visible = true;
                    lblMessage.Text = "Error deleting category: " + ex.Message;
                }
            }
        }
    }
}