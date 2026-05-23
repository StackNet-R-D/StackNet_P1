using System;
using System.Data;
using System.Web.UI;
using Dapper;

namespace InventorySystem
{
    public partial class LowStockReport : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadReportData();
            }
        }

        private void LoadReportData()
        {
            using (var db = DBHelper.GetConnection())
            {
                // Query strictly filters for products where CurrentQty is less than MinimumQty
                string sql = @"
                    SELECT 
                        c.CategoryName, 
                        p.Barcode, 
                        p.ProductName, 
                        p.CurrentQty, 
                        p.MinimumQty
                    FROM tblProducts p
                    LEFT JOIN tblCategories c ON p.CategoryID = c.CategoryID
                    WHERE p.Status = 'Active' AND p.CurrentQty < p.MinimumQty
                    ORDER BY (p.MinimumQty - p.CurrentQty) DESC"; // Orders by highest deficit first

                using (var reader = db.ExecuteReader(sql))
                {
                    DataTable dt = new DataTable();
                    dt.Load(reader);

                    gvLowStock.DataSource = dt;
                    gvLowStock.DataBind();

                    lblRecordCount.Text = $"{dt.Rows.Count} critical items";

                    // Hide the big red alert banner if there are no low stock items
                    if (dt.Rows.Count == 0)
                    {
                        pnlAlert.Visible = false;
                    }
                }
            }
        }
    }
}