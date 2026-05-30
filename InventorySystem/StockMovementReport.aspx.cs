using System;
using System.Data;
using System.Web.UI;
using Dapper;

namespace InventorySystem
{
    public partial class StockMovementReport : System.Web.UI.Page
    {
        // Public properties to pass data to the frontend Print Headers
        public string GeneratedDate { get; set; }
        public string PrintDateRange { get; set; }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Default to last 7 days for the MVP
                txtStartDate.Text = DateTime.Now.AddDays(-7).ToString("yyyy-MM-dd");
                txtEndDate.Text = DateTime.Now.ToString("yyyy-MM-dd");
                LoadReport();
            }
        }

        protected void btnFilter_Click(object sender, EventArgs e)
        {
            LoadReport();
        }

        private void LoadReport()
        {
            // Set the print header variables
            GeneratedDate = DateTime.Now.ToString("MM/dd/yyyy, hh:mm:ss tt");
            PrintDateRange = $"{txtStartDate.Text} to {txtEndDate.Text}";

            using (var db = DBHelper.GetConnection())
            {
                string sql = @"
                    SELECT 
                        t.CreatedDate AS TransactionTime,
                        t.ReferenceNo,
                        p.ProductName,
                        t.TransactionType,
                        t.Quantity,
                        t.Reason,
                        t.BalanceQty,
                        u.Username
                    FROM tblInventoryTransactions t
                    INNER JOIN tblProducts p ON t.ProductID = p.ProductID
                    INNER JOIN tblUsers u ON t.CreatedBy = u.UserID
                    WHERE CAST(t.CreatedDate AS DATE) >= @StartDate 
                      AND CAST(t.CreatedDate AS DATE) <= @EndDate ";

                var parameters = new DynamicParameters();
                parameters.Add("@StartDate", txtStartDate.Text);
                parameters.Add("@EndDate", txtEndDate.Text);

                if (ddlType.SelectedValue != "ALL")
                {
                    sql += " AND t.TransactionType = @Type ";
                    parameters.Add("@Type", ddlType.SelectedValue);
                }

                sql += " ORDER BY t.CreatedDate DESC";

                using (var reader = db.ExecuteReader(sql, parameters))
                {
                    DataTable dt = new DataTable();
                    dt.Load(reader);

                    gvMovementReport.DataSource = dt;
                    gvMovementReport.DataBind();

                    lblRecordCount.Text = dt.Rows.Count.ToString();
                }
            }
        }
    }
}