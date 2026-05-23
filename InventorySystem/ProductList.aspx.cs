using System;
using System.Data;
using System.Web.UI;
using Dapper;

namespace InventorySystem
{
    public partial class ProductList : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadProducts();
            }
        }

        private void LoadProducts()
        {
            using (var db = DBHelper.GetConnection())
            {
                // ADDED p.MinimumQty to the SELECT statement
                string sql = @"SELECT p.ProductName, p.Barcode, c.CategoryName, p.CostPrice, 
                                      p.SellingPrice, p.CurrentQty, p.MinimumQty, p.Status 
                               FROM tblProducts p 
                               LEFT JOIN tblCategories c ON p.CategoryID = c.CategoryID";

                using (var reader = db.ExecuteReader(sql))
                {
                    DataTable dt = new DataTable();
                    dt.Load(reader);

                    gvProducts.DataSource = dt;
                    gvProducts.DataBind();
                }
            }
        }
    }
}