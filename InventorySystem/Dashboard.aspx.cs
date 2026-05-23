using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web.UI;
using Dapper;

namespace InventorySystem
{
    public partial class Dashboard : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadKPIs();
                LoadLowStockAlerts();
                LoadRecentTransactions();
                LoadChartData();
            }
        }

        private void LoadKPIs()
        {
            using (var db = DBHelper.GetConnection())
            {
                // Total Active Products
                int totalProducts = db.ExecuteScalar<int>("SELECT COUNT(*) FROM tblProducts WHERE Status = 'Active'");
                lblTotalProducts.Text = totalProducts.ToString("N0");

                // Stock In Today
                int stockInToday = db.ExecuteScalar<int>(@"
                    SELECT ISNULL(SUM(Quantity), 0) FROM tblInventoryTransactions 
                    WHERE TransactionType = 'IN' AND CONVERT(date, CreatedDate) = CONVERT(date, GETDATE())");
                lblStockInToday.Text = stockInToday.ToString("N0");

                // Stock Out Today
                int stockOutToday = db.ExecuteScalar<int>(@"
                    SELECT ISNULL(SUM(Quantity), 0) FROM tblInventoryTransactions 
                    WHERE TransactionType = 'OUT' AND CONVERT(date, CreatedDate) = CONVERT(date, GETDATE())");
                lblStockOutToday.Text = stockOutToday.ToString("N0");

                // Low Stock Count
                int lowStockCount = db.ExecuteScalar<int>(@"
                    SELECT COUNT(*) FROM tblProducts WHERE CurrentQty < MinimumQty AND Status = 'Active'");
                lblLowStockAlerts.Text = lowStockCount.ToString();
                lblTopLowStockCount.Text = lowStockCount.ToString();

                // Hide the red badge at the top if everything is fine
                if (lowStockCount == 0) pnlTopLowStockAlert.Visible = false;
            }
        }

        private void LoadLowStockAlerts()
        {
            using (var db = DBHelper.GetConnection())
            {
                string sql = @"
                    SELECT TOP 5 p.ProductName, p.CurrentQty, p.MinimumQty, c.CategoryName 
                    FROM tblProducts p
                    INNER JOIN tblCategories c ON p.CategoryID = c.CategoryID
                    WHERE p.CurrentQty < p.MinimumQty AND p.Status = 'Active'
                    ORDER BY p.CurrentQty ASC";

                using (var reader = db.ExecuteReader(sql))
                {
                    DataTable dt = new DataTable();
                    dt.Load(reader);
                    rptLowStockList.DataSource = dt;
                    rptLowStockList.DataBind();
                }
            }
        }

        private void LoadRecentTransactions()
        {
            using (var db = DBHelper.GetConnection())
            {
                string sql = @"
                    SELECT TOP 8 t.ReferenceNo, p.ProductName, t.TransactionType, t.Quantity, t.BalanceQty, u.Username, t.CreatedDate AS TransactionTime
                    FROM tblInventoryTransactions t
                    INNER JOIN tblProducts p ON t.ProductID = p.ProductID
                    INNER JOIN tblUsers u ON t.CreatedBy = u.UserID
                    ORDER BY t.CreatedDate DESC";

                using (var reader = db.ExecuteReader(sql))
                {
                    DataTable dt = new DataTable();
                    dt.Load(reader);
                    gvRecentTransactions.DataSource = dt;
                    gvRecentTransactions.DataBind();
                }
            }
        }

        private void LoadChartData()
        {
            using (var db = DBHelper.GetConnection())
            {
                // Gets IN and OUT totals grouped by day for the last 7 days
                string sql = @"
                    SELECT 
                        CONVERT(date, CreatedDate) as TxDate,
                        TransactionType,
                        SUM(Quantity) as TotalQty
                    FROM tblInventoryTransactions
                    WHERE CreatedDate >= DATEADD(day, -6, CONVERT(date, GETDATE()))
                    GROUP BY CONVERT(date, CreatedDate), TransactionType";

                var rawData = db.Query(sql).ToList();

                List<string> labels = new List<string>();
                List<int> dataIn = new List<int>();
                List<int> dataOut = new List<int>();

                // Build the data array for the last 7 days (ensures missing days show as 0)
                for (int i = 6; i >= 0; i--)
                {
                    DateTime d = DateTime.Today.AddDays(-i);
                    labels.Add(d.ToString("ddd")); // Outputs "Mon", "Tue", etc.

                    // Sum the INs for this day
                    var sumIn = rawData.Where(x => Convert.ToDateTime(x.TxDate) == d && x.TransactionType == "IN")
                                       .Sum(x => (int)x.TotalQty);
                    dataIn.Add(sumIn);

                    // Sum the OUTs for this day
                    var sumOut = rawData.Where(x => Convert.ToDateTime(x.TxDate) == d && x.TransactionType == "OUT")
                                        .Sum(x => (int)x.TotalQty);
                    dataOut.Add(sumOut);
                }

                // Push strings to hidden fields so JS can draw the chart
                hfChartLabels.Value = string.Join(",", labels);
                hfChartDataIn.Value = string.Join(",", dataIn);
                hfChartDataOut.Value = string.Join(",", dataOut);
            }
        }
    }
}