using System;
using System.Data;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;
using Dapper;

namespace InventorySystem
{
    public partial class ProductList : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadCategoryDropdown();
                LoadProducts();
            }
        }

        // Loads categories specifically for the filter dropdown
        private void LoadCategoryDropdown()
        {
            using (var db = DBHelper.GetConnection())
            {
                // CORRECTED: Using ExecuteReader and DataTable to avoid the DapperRow reflection error
                string sql = "SELECT CategoryID, CategoryName FROM tblCategories ORDER BY CategoryName";

                using (var reader = db.ExecuteReader(sql))
                {
                    DataTable dt = new DataTable();
                    dt.Load(reader);

                    ddlCategory.DataSource = dt;
                    ddlCategory.DataTextField = "CategoryName";
                    ddlCategory.DataValueField = "CategoryID";
                    ddlCategory.DataBind();
                }

                // Add the default "All" option at the top
                ddlCategory.Items.Insert(0, new ListItem("All Categories", ""));
            }
        }

        private void LoadProducts()
        {
            using (var db = DBHelper.GetConnection())
            {
                // Start with a base query
                string sql = @"SELECT p.ProductID, p.ProductName, p.Barcode, c.CategoryName, p.CostPrice, 
                                      p.SellingPrice, p.CurrentQty, p.MinimumQty, p.Status 
                               FROM tblProducts p 
                               LEFT JOIN tblCategories c ON p.CategoryID = c.CategoryID
                               WHERE 1=1 ";

                var parameters = new DynamicParameters();

                // 1. Apply Search Filter
                if (!string.IsNullOrWhiteSpace(txtSearch.Text))
                {
                    sql += " AND (p.ProductName LIKE @Search OR p.Barcode LIKE @Search) ";
                    parameters.Add("@Search", "%" + txtSearch.Text.Trim() + "%");
                }

                // 2. Apply Category Filter
                if (!string.IsNullOrEmpty(ddlCategory.SelectedValue))
                {
                    sql += " AND p.CategoryID = @CategoryID ";
                    parameters.Add("@CategoryID", ddlCategory.SelectedValue);
                }

                // 3. Apply Status Filter
                if (!string.IsNullOrEmpty(ddlStatus.SelectedValue))
                {
                    sql += " AND p.Status = @Status ";
                    parameters.Add("@Status", ddlStatus.SelectedValue);
                }

                // Order by newest first
                sql += " ORDER BY p.ProductID DESC";

                // Execute and Bind using DataTable
                using (var reader = db.ExecuteReader(sql, parameters))
                {
                    DataTable dt = new DataTable();
                    dt.Load(reader);

                    gvProducts.DataSource = dt;
                    gvProducts.DataBind();

                    // Update the Total Products counter on the screen
                    lblTotalProducts.Text = dt.Rows.Count.ToString();
                }
            }
        }

        // This triggers whenever you type in the search or change a dropdown
        protected void Filter_Changed(object sender, EventArgs e)
        {
            gvProducts.PageIndex = 0; // Always jump back to page 1 when filtering
            LoadProducts();
        }

        // This handles clicking the 1, 2, 3 pagination buttons
        protected void gvProducts_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            gvProducts.PageIndex = e.NewPageIndex;
            LoadProducts();
        }

        protected void gvProducts_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandArgument == null || string.IsNullOrEmpty(e.CommandArgument.ToString())) return;

            int productID = Convert.ToInt32(e.CommandArgument);

            if (e.CommandName == "EditProduct")
            {
                Response.Redirect($"ProductEdit.aspx?id={productID}");
            }
            else if (e.CommandName == "DeleteProduct")
            {
                using (var db = DBHelper.GetConnection())
                {
                    db.Execute("DELETE FROM tblProducts WHERE ProductID = @ID", new { ID = productID });
                }
                LoadProducts();
            }
        }
    }
}