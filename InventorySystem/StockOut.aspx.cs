using System;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;
using Dapper;

namespace InventorySystem
{
    public partial class StockOut : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                GenerateReferenceNumber();
                LoadRecentTransactions();
                LoadProductsDropdown();
            }
        }

        private void LoadProductsDropdown()
        {
            using (var db = DBHelper.GetConnection())
            {
                // 1. Fetch data and immediately project into a List of concrete objects
                // This eliminates 'DapperRow' dynamic issues
                var products = db.Query("SELECT ProductID, ProductName FROM tblProducts WHERE Status = 'Active'")
                                 .Select(p => new {
                                     ID = (int)p.ProductID,
                                     Name = (string)p.ProductName
                                 }).ToList();

                // 2. Bind using the new property names
                ddlProduct.DataSource = products;
                ddlProduct.DataTextField = "Name";  // Maps to 'Name'
                ddlProduct.DataValueField = "ID";   // Maps to 'ID'
                ddlProduct.DataBind();

                ddlProduct.Items.Insert(0, new System.Web.UI.WebControls.ListItem("-- Select a Product --", "0"));
            }
        }

        protected void ddlProduct_SelectedIndexChanged(object sender, EventArgs e)
        {
            int selectedID = Convert.ToInt32(ddlProduct.SelectedValue);
            if (selectedID == 0) { ClearProductDetails(); return; }

            using (var db = DBHelper.GetConnection())
            {
                var p = db.QueryFirstOrDefault(@"
                    SELECT p.ProductID, p.ProductName, p.Barcode AS SKU, p.CurrentQty, p.MinimumQty, c.CategoryName 
                    FROM tblProducts p 
                    INNER JOIN tblCategories c ON p.CategoryID = c.CategoryID 
                    WHERE p.ProductID = @ID", new { ID = selectedID });

                if (p != null)
                {
                    ViewState["CurrentProductID"] = p.ProductID;
                    ViewState["CurrentStock"] = p.CurrentQty;

                    lblProductName.Text = p.ProductName;
                    lblSKU.Text = p.SKU;
                    lblCategory.Text = p.CategoryName;
                    lblCurrentStock.Text = $"{p.CurrentQty} units";
                    lblSummaryCurrent.Text = p.CurrentQty.ToString();
                    UpdateSummaryMath();
                }
            }
        }

        protected void txtQuantity_TextChanged(object sender, EventArgs e) => UpdateSummaryMath();

        private void UpdateSummaryMath()
        {
            if (ViewState["CurrentStock"] != null && int.TryParse(txtQuantity.Text, out int qty))
            {
                int current = (int)ViewState["CurrentStock"];
                lblSummaryRemoving.Text = $"- {qty}";
                lblSummaryNew.Text = $"= {current - qty} units";
            }
        }

        protected void btnConfirm_Click(object sender, EventArgs e)
        {
            if (ViewState["CurrentProductID"] == null || !int.TryParse(txtQuantity.Text, out int qty) || qty <= 0) return;

            using (var db = DBHelper.GetConnection())
            {
                using (var trans = db.BeginTransaction())
                {
                    try
                    {
                        db.Execute(@"INSERT INTO tblStockOut (ProductID, Quantity, ReferenceNo, CreatedBy) VALUES (@PID, @Qty, @Ref, 1);
                                     UPDATE tblProducts SET CurrentQty = CurrentQty - @Qty WHERE ProductID = @PID;",
                                   new { PID = ViewState["CurrentProductID"], Qty = qty, Ref = txtReference.Text }, trans);
                        trans.Commit();
                        Response.Redirect("StockOut.aspx");
                    }
                    catch { trans.Rollback(); }
                }
            }
        }

        private void LoadRecentTransactions()
        {
            using (var db = DBHelper.GetConnection())
            {
                var trans = db.Query(@"SELECT TOP 5 p.ProductName, t.ReferenceNo, t.Quantity, t.CreatedDate AS TransactionTime 
                                       FROM tblStockOut t 
                                       INNER JOIN tblProducts p ON t.ProductID = p.ProductID 
                                       ORDER BY t.CreatedDate DESC").ToList();
                rptRecentTransactions.DataSource = trans;
                rptRecentTransactions.DataBind();
                lblTransactionCount.Text = $"{trans.Count} transactions today";
            }
        }

        private void GenerateReferenceNumber() => txtReference.Text = $"SO-{DateTime.Now:yyyyMMddHHmmss}";
        private void ClearProductDetails() { /* Reset logic here */ }
        protected void btnClear_Click(object sender, EventArgs e) => Response.Redirect("StockOut.aspx");
    }
}