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
                string search = "%" + txtSearch.Text + "%";
                string sql = "SELECT * FROM tblCategories WHERE CategoryName LIKE @Search OR Description LIKE @Search";

                using (var reader = db.ExecuteReader(sql, new { Search = search }))
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
            LoadCategories();
        }

        protected void gvCategories_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandArgument == null) return;
            int categoryID = Convert.ToInt32(e.CommandArgument);

            if (e.CommandName == "EditCategory")
            {
                Response.Redirect($"CategoryCreate.aspx?id={categoryID}");
            }
            else if (e.CommandName == "DeleteCategory")
            {
                using (var db = DBHelper.GetConnection())
                {
                    db.Execute("DELETE FROM tblCategories WHERE CategoryID = @ID", new { ID = categoryID });
                }
                LoadCategories();
            }
        }
    }
}