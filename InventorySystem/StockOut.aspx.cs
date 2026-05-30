using System;
using System.Web.UI;
using Dapper;

namespace InventorySystem
{
    public partial class StockOut : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                txtReference.Text = "SO-" + DateTime.Now.ToString("yyyyMMddHHmmss");
            }
        }

        protected void txtBarcode_TextChanged(object sender, EventArgs e)
        {
            pnlMessage.Visible = false;
            string barcode = txtBarcode.Text.Trim();

            if (string.IsNullOrEmpty(barcode)) return;

            using (var db = DBHelper.GetConnection())
            {
                var product = db.QueryFirstOrDefault("SELECT * FROM tblProducts WHERE Barcode = @Barcode AND Status = 'Active'", new { Barcode = barcode });
                if (product != null)
                {
                    pnlProductContext.Visible = true;
                    phNoProduct.Visible = false;

                    lblContextName.Text = product.ProductName;
                    lblContextCurrentQty.Text = Convert.ToInt32(product.CurrentQty).ToString("N0") + " units";
                    lblContextCost.Text = "Rs. " + Convert.ToDecimal(product.CostPrice).ToString("N2");
                    lblContextRetail.Text = "Rs. " + Convert.ToDecimal(product.SellingPrice).ToString("N2");

                    txtQty.Focus();
                }
                else
                {
                    ResetContext();
                    ShowAlert("Product not found or is currently marked inactive.", "alert-danger");
                }
            }
        }

        protected void btnConfirm_Click(object sender, EventArgs e)
        {
            pnlMessage.Visible = false;
            string barcode = txtBarcode.Text.Trim();
            string qtyText = txtQty.Text.Trim();
            string reference = txtReference.Text.Trim();
            string reason = ddlReason.SelectedValue;

            if (string.IsNullOrEmpty(barcode) || string.IsNullOrEmpty(qtyText) || string.IsNullOrEmpty(reference))
            {
                ShowAlert("All highlighted tracking metrics are required to execute a dispatch operation.", "alert-warning");
                return;
            }

            int qtyToRemove = Convert.ToInt32(qtyText);
            int userId = Session["UserID"] != null ? Convert.ToInt32(Session["UserID"]) : 1;

            using (var db = DBHelper.GetConnection())
            {
                var product = db.QueryFirstOrDefault("SELECT * FROM tblProducts WHERE Barcode = @Barcode AND Status = 'Active'", new { Barcode = barcode });
                if (product == null)
                {
                    ShowAlert("Transaction failed: Target item target reference identifier invalid.", "alert-danger");
                    return;
                }

                int currentQty = Convert.ToInt32(product.CurrentQty);
                if (currentQty < qtyToRemove)
                {
                    ShowAlert($"Insufficient stock level. Total requested: {qtyToRemove}, available structural reserve: {currentQty}.", "alert-danger");
                    return;
                }

                // Calculate updated structural balancing index
                int newBalanceQty = currentQty - qtyToRemove;

                // 1. Execute direct stock subtraction loop
                db.Execute("UPDATE tblProducts SET CurrentQty = @NewQty WHERE ProductID = @PID", new { NewQty = newBalanceQty, PID = product.ProductID });

                // 2. Write tracking log inside standard structural log ledger
                db.Execute(@"INSERT INTO tblStockOut (ProductID, Quantity, ReferenceNo, Reason, CreatedBy, CreatedDate) 
                             VALUES (@ProductID, @Quantity, @ReferenceNo, @Reason, @CreatedBy, GETDATE())",
                             new { ProductID = product.ProductID, Quantity = qtyToRemove, ReferenceNo = reference, Reason = reason, CreatedBy = userId });

                // 3. Populate business intelligence data context inside time-series ledger
                db.Execute(@"INSERT INTO tblInventoryTransactions (ProductID, TransactionType, Quantity, BalanceQty, ReferenceNo, Reason, CreatedBy, CreatedDate) 
                             VALUES (@ProductID, 'OUT', @Quantity, @BalanceQty, @ReferenceNo, @Reason, @CreatedBy, GETDATE())",
                             new { ProductID = product.ProductID, Quantity = qtyToRemove, BalanceQty = newBalanceQty, ReferenceNo = reference, Reason = reason, CreatedBy = userId });

                ShowAlert($"Dispatched {qtyToRemove} units of '{product.ProductName}' successfully under '{reason}' reason code.", "alert-success");
                ResetContext();
            }
        }

        private void ResetContext()
        {
            txtBarcode.Text = "";
            txtQty.Text = "";
            txtReference.Text = "SO-" + DateTime.Now.ToString("yyyyMMddHHmmss");
            pnlProductContext.Visible = false;
            phNoProduct.Visible = true;
            txtBarcode.Focus();
        }

        private void ShowAlert(string text, string cssClass)
        {
            // FIXED: Now properly applies text to the new Label inside the Panel
            pnlMessage.Visible = true;
            pnlMessage.CssClass = "alert " + cssClass + " mb-3 small fw-semibold";
            lblMessage.Text = text;
        }
    }
}