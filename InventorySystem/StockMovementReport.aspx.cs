using System;
using System.Data;
using System.Web.UI;
using System.Globalization; // Required for exact date parsing
using Dapper;

namespace InventorySystem
{
    public partial class StockMovementReport : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Set default date range: Last 7 days to Today
                txtStartDate.Text = DateTime.Now.AddDays(-7).ToString("yyyy-MM-dd");
                txtEndDate.Text = DateTime.Now.ToString("yyyy-MM-dd");

                LoadReportData();
            }
        }

        protected void btnGenerate_Click(object sender, EventArgs e)
        {
            LoadReportData();
        }

        // Added this so the dropdown automatically filters when changed
        protected void ddlType_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadReportData();
        }

        private void LoadReportData()
        {
            using (var db = DBHelper.GetConnection())
            {
                string sql = @"
                    SELECT 
                        t.CreatedDate AS TransactionTime,
                        t.ReferenceNo,
                        p.ProductName,
                        t.TransactionType,
                        t.Quantity,
                        t.BalanceQty,
                        u.Username
                    FROM tblInventoryTransactions t
                    INNER JOIN tblProducts p ON t.ProductID = p.ProductID
                    INNER JOIN tblUsers u ON t.CreatedBy = u.UserID
                    WHERE 1=1 "; // 1=1 makes adding dynamic AND clauses easy

                var parameters = new DynamicParameters();

                // FIX: Safely parse HTML5 dates regardless of your Windows regional settings
                if (DateTime.TryParseExact(txtStartDate.Text, "yyyy-MM-dd", CultureInfo.InvariantCulture, DateTimeStyles.None, out DateTime startDate))
                {
                    sql += " AND CONVERT(date, t.CreatedDate) >= @StartDate ";
                    parameters.Add("@StartDate", startDate);
                }

                if (DateTime.TryParseExact(txtEndDate.Text, "yyyy-MM-dd", CultureInfo.InvariantCulture, DateTimeStyles.None, out DateTime endDate))
                {
                    sql += " AND CONVERT(date, t.CreatedDate) <= @EndDate ";
                    parameters.Add("@EndDate", endDate);
                }

                // Apply IN/OUT filter if selected
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

                    lblRecordCount.Text = $"{dt.Rows.Count} records";
                }
            }
        }
    }
}