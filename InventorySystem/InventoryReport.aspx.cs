using System;
using System.Data;
using System.Web.UI;
using Dapper;

namespace InventorySystem
{
    public partial class InventoryReport : System.Web.UI.Page
    {
        // Added properties to hold data for the print summary
        public string GeneratedDate { get; set; }
        public string TotalItemsCount { get; set; }
        public string TotalUnitsCount { get; set; }
        public string TotalStockValue { get; set; }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                GeneratedDate = DateTime.Now.ToString("MM/dd/yyyy, hh:mm:ss tt");
                LoadReportData();
            }
        }

        private void LoadReportData()
        {
            using (var db = DBHelper.GetConnection())
            {
                string sql = @"
                    SELECT 
                        c.CategoryName, 
                        p.Barcode AS SKU, 
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

                    int totalItems = dt.Rows.Count; // Distinct products
                    int totalUnits = 0; // Total physical items
                    decimal totalCost = 0;
                    decimal totalRetail = 0;

                    foreach (DataRow row in dt.Rows)
                    {
                        if (row["CurrentQty"] != DBNull.Value)
                            totalUnits += Convert.ToInt32(row["CurrentQty"]);

                        if (row["TotalCostValue"] != DBNull.Value)
                            totalCost += Convert.ToDecimal(row["TotalCostValue"]);

                        if (row["TotalRetailValue"] != DBNull.Value)
                            totalRetail += Convert.ToDecimal(row["TotalRetailValue"]);
                    }

                    // Set values for Screen UI
                    lblTotalItems.Text = totalItems.ToString("N0");
                    lblTotalCost.Text = "Rs. " + totalCost.ToString("N2");
                    lblTotalRetail.Text = "Rs. " + totalRetail.ToString("N2");

                    // Set values for Print Document UI
                    TotalItemsCount = totalItems.ToString("N0");
                    TotalUnitsCount = totalUnits.ToString("N0");
                    TotalStockValue = "Rs. " + totalCost.ToString("N2");
                }
            }
        }
    }
}