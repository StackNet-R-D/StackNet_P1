using System;
using System.Data;
using System.Web.UI;
using Dapper;

namespace InventorySystem
{
    public partial class InventoryReport : System.Web.UI.Page
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
                // SQL query calculates the math directly in the database for maximum performance
                string sql = @"
                    SELECT 
                        c.CategoryName, 
                        p.Barcode, 
                        p.ProductName, 
                        p.CurrentQty, 
                        p.MinimumQty,
                        p.CostPrice, 
                        p.SellingPrice,
                        (p.CurrentQty * p.CostPrice) AS TotalCostValue,
                        (p.CurrentQty * p.SellingPrice) AS TotalRetailValue
                    FROM tblProducts p
                    LEFT JOIN tblCategories c ON p.CategoryID = c.CategoryID
                    WHERE p.Status = 'Active'
                    ORDER BY c.CategoryName ASC, p.ProductName ASC";

                using (var reader = db.ExecuteReader(sql))
                {
                    DataTable dt = new DataTable();
                    dt.Load(reader);

                    gvInventoryReport.DataSource = dt;
                    gvInventoryReport.DataBind();

                    // Calculate the summary totals for the KPI cards
                    int totalItems = 0;
                    decimal totalCost = 0;
                    decimal totalRetail = 0;

                    foreach (DataRow row in dt.Rows)
                    {
                        totalItems += Convert.ToInt32(row["CurrentQty"]);
                        totalCost += Convert.ToDecimal(row["TotalCostValue"]);
                        totalRetail += Convert.ToDecimal(row["TotalRetailValue"]);
                    }

                    lblTotalItems.Text = totalItems.ToString("N0");
                    lblTotalCost.Text = "Rs. " + totalCost.ToString("N2");
                    lblTotalRetail.Text = "Rs. " + totalRetail.ToString("N2");
                }
            }
        }
    }
}