using System;
using System.Data;
using System.Web.UI;
using Dapper;

namespace InventorySystem
{
    public partial class TransactionHistory : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadHistory();
            }
        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            LoadHistory();
        }

        private void LoadHistory()
        {
            using (var db = DBHelper.GetConnection())
            {
                string sql = @"
                    SELECT TOP 100
                        t.CreatedDate AS TransactionTime,
                        t.ReferenceNo,
                        p.ProductName,
                        t.TransactionType,
                        t.Quantity,
                        t.Reason,
                        u.Username
                    FROM tblInventoryTransactions t
                    INNER JOIN tblProducts p ON t.ProductID = p.ProductID
                    INNER JOIN tblUsers u ON t.CreatedBy = u.UserID
                    WHERE 1=1 ";

                var parameters = new DynamicParameters();

                if (!string.IsNullOrWhiteSpace(txtSearch.Text))
                {
                    sql += " AND (t.ReferenceNo LIKE @Search OR p.ProductName LIKE @Search OR t.Reason LIKE @Search) ";
                    parameters.Add("@Search", "%" + txtSearch.Text.Trim() + "%");
                }

                sql += " ORDER BY t.CreatedDate DESC";

                using (var reader = db.ExecuteReader(sql, parameters))
                {
                    DataTable dt = new DataTable();
                    dt.Load(reader);

                    gvHistory.DataSource = dt;
                    gvHistory.DataBind();
                }
            }
        }
    }
}