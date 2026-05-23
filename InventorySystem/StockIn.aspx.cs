using System;
using System.Linq;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;
using Dapper;

namespace InventorySystem
{
    public partial class StockIn : System.Web.UI.Page
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
                // 1. Fetch raw data
                var rawData = db.Query("SELECT ProductID, ProductName FROM tblProducts WHERE Status = 'Active'").ToList();

                // 2. Map to a clean list of anonymous objects
                var productList = rawData.Select(p => new {
                    ID = (int)p.ProductID,
                    Name = (string)p.ProductName
                }).ToList();

                // 3. Bind to the clean list
                ddlProduct.DataSource = productList;
                ddlProduct.DataTextField = "Name";  // Matches the new "Name" property
                ddlProduct.DataValueField = "ID";   // Matches the new "ID" property
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
                    lblMinQty.Text = $"{p.MinimumQty} units";
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
                lblSummaryAdding.Text = $"+ {qty}";
                lblSummaryNew.Text = $"= {current + qty} units";
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
                        db.Execute(@"INSERT INTO tblStockIn (ProductID, Quantity, ReferenceNo, CreatedBy) VALUES (@PID, @Qty, @Ref, 1);
                                     UPDATE tblProducts SET CurrentQty = CurrentQty + @Qty WHERE ProductID = @PID;
                                     INSERT INTO tblInventoryTransactions (ProductID, TransactionType, Quantity, BalanceQty, ReferenceNo, CreatedBy) 
                                     VALUES (@PID, 'IN', @Qty, (SELECT CurrentQty FROM tblProducts WHERE ProductID = @PID), @Ref, 1);",
                                   new { PID = ViewState["CurrentProductID"], Qty = qty, Ref = txtReference.Text }, trans);
                        trans.Commit();
                        Response.Redirect("StockIn.aspx");
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
                                       FROM tblInventoryTransactions t 
                                       INNER JOIN tblProducts p ON t.ProductID = p.ProductID 
                                       WHERE t.TransactionType = 'IN' ORDER BY t.CreatedDate DESC").ToList();

                rptRecentTransactions.DataSource = trans;
                rptRecentTransactions.DataBind();
                lblTransactionCount.Text = $"{trans.Count} transactions today";
            }
        }

        private void GenerateReferenceNumber() => txtReference.Text = $"SI-{DateTime.Now:yyyyMMddHHmmss}";
        private void ClearProductDetails() { /* Reset labels to '-' */ }
        protected void btnClear_Click(object sender, EventArgs e) => Response.Redirect("StockIn.aspx");
    }
}