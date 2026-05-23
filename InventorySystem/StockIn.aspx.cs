using System;
using System.Data;
using System.Linq;
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
                // NEW: Check if redirected here after a successful transaction
                if (Request.QueryString["success"] == "true")
                {
                    pnlSuccess.Visible = true;
                }

                txtBarcode.Focus();
                GenerateReferenceNumber();
                LoadRecentTransactions();
                LoadProductsDropdown();
            }
        }

        private void LoadProductsDropdown()
        {
            using (var db = DBHelper.GetConnection())
            {
                using (var reader = db.ExecuteReader("SELECT ProductID, ProductName FROM tblProducts WHERE Status = 'Active' ORDER BY ProductName"))
                {
                    DataTable dt = new DataTable();
                    dt.Load(reader);

                    ddlProduct.DataSource = dt;
                    ddlProduct.DataTextField = "ProductName";
                    ddlProduct.DataValueField = "ProductID";
                    ddlProduct.DataBind();

                    ddlProduct.Items.Insert(0, new ListItem("-- Select a Product --", "0"));
                }
            }
        }

        protected void txtBarcode_TextChanged(object sender, EventArgs e)
        {
            pnlError.Visible = false;
            pnlSuccess.Visible = false;
            string barcode = txtBarcode.Text.Trim();
            if (string.IsNullOrEmpty(barcode)) return;

            using (var db = DBHelper.GetConnection())
            {
                int? productID = db.QueryFirstOrDefault<int?>("SELECT ProductID FROM tblProducts WHERE Barcode = @Barcode", new { Barcode = barcode });

                if (productID != null)
                {
                    ddlProduct.SelectedValue = productID.ToString();
                    LoadProductDetails(productID.Value);
                    txtQuantity.Focus();
                }
                else
                {
                    pnlError.Visible = true;
                    lblError.Text = "Barcode not found in the system.";
                    ClearProductDetails();
                }
                txtBarcode.Text = "";
            }
        }

        protected void ddlProduct_SelectedIndexChanged(object sender, EventArgs e)
        {
            pnlError.Visible = false;
            pnlSuccess.Visible = false;
            int selectedID = Convert.ToInt32(ddlProduct.SelectedValue);

            if (selectedID == 0)
                ClearProductDetails();
            else
                LoadProductDetails(selectedID);
        }

        private void LoadProductDetails(int productID)
        {
            using (var db = DBHelper.GetConnection())
            {
                var p = db.QueryFirstOrDefault(@"
                    SELECT p.ProductID, p.ProductName, p.Barcode AS SKU, p.CurrentQty, c.CategoryName 
                    FROM tblProducts p 
                    INNER JOIN tblCategories c ON p.CategoryID = c.CategoryID 
                    WHERE p.ProductID = @ID", new { ID = productID });

                if (p != null)
                {
                    ViewState["CurrentProductID"] = p.ProductID;
                    ViewState["CurrentStock"] = p.CurrentQty;

                    lblProductName.Text = p.ProductName;
                    lblSKU.Text = p.SKU;
                    lblCategory.Text = p.CategoryName;
                    lblCurrentStock.Text = $"{p.CurrentQty} units";
                    lblSummaryCurrent.Text = p.CurrentQty.ToString();

                    txtQuantity.Text = "";
                    UpdateSummaryMath();
                }
            }
        }

        protected void txtQuantity_TextChanged(object sender, EventArgs e) => UpdateSummaryMath();

        private void UpdateSummaryMath()
        {
            if (ViewState["CurrentStock"] != null)
            {
                int current = (int)ViewState["CurrentStock"];
                int qty = 0;
                int.TryParse(txtQuantity.Text, out qty);

                lblSummaryAdding.Text = $"+ {qty}";
                lblSummaryNew.Text = $"= {current + qty} units";
            }
        }

        protected void btnConfirm_Click(object sender, EventArgs e)
        {
            pnlError.Visible = false;
            pnlSuccess.Visible = false;
            if (ViewState["CurrentProductID"] == null || !int.TryParse(txtQuantity.Text, out int qty) || qty <= 0)
            {
                pnlError.Visible = true;
                lblError.Text = "Please select a product and enter a valid quantity greater than 0.";
                return;
            }

            bool isSuccess = false;

            using (var db = DBHelper.GetConnection())
            {
                using (var trans = db.BeginTransaction())
                {
                    try
                    {
                        db.Execute(@"
                            INSERT INTO tblStockIn (ProductID, Quantity, ReferenceNo, CreatedBy) VALUES (@PID, @Qty, @Ref, 1);
                            UPDATE tblProducts SET CurrentQty = CurrentQty + @Qty WHERE ProductID = @PID;
                            INSERT INTO tblInventoryTransactions (ProductID, TransactionType, Quantity, BalanceQty, ReferenceNo, CreatedBy) 
                            VALUES (@PID, 'IN', @Qty, (SELECT CurrentQty FROM tblProducts WHERE ProductID = @PID), @Ref, 1);",
                        new { PID = ViewState["CurrentProductID"], Qty = qty, Ref = txtReference.Text }, trans);

                        trans.Commit();
                        isSuccess = true;
                    }
                    catch (Exception ex)
                    {
                        trans.Rollback();
                        pnlError.Visible = true;
                        lblError.Text = "Transaction failed: " + ex.Message;
                    }
                }
            }

            if (isSuccess)
            {
                // NEW: Append ?success=true to the URL
                Response.Redirect("StockIn.aspx?success=true", false);
                Context.ApplicationInstance.CompleteRequest();
            }
        }

        private void LoadRecentTransactions()
        {
            using (var db = DBHelper.GetConnection())
            {
                string sql = @"
                    SELECT TOP 5 p.ProductName, t.ReferenceNo, t.Quantity, t.CreatedDate AS TransactionTime 
                    FROM tblInventoryTransactions t 
                    INNER JOIN tblProducts p ON t.ProductID = p.ProductID 
                    WHERE t.TransactionType = 'IN' AND CONVERT(date, t.CreatedDate) = CONVERT(date, GETDATE())
                    ORDER BY t.CreatedDate DESC";

                using (var reader = db.ExecuteReader(sql))
                {
                    DataTable dt = new DataTable();
                    dt.Load(reader);

                    rptRecentTransactions.DataSource = dt;
                    rptRecentTransactions.DataBind();
                    lblTransactionCount.Text = $"{dt.Rows.Count} transactions today";
                }
            }
        }

        private void GenerateReferenceNumber() => txtReference.Text = $"SI-{DateTime.Now:yyyyMMddHHmmss}";

        private void ClearProductDetails()
        {
            ViewState["CurrentProductID"] = null;
            ViewState["CurrentStock"] = null;
            lblProductName.Text = "-";
            lblSKU.Text = "-";
            lblCategory.Text = "-";
            lblCurrentStock.Text = "0 units";
            lblSummaryCurrent.Text = "0";
            txtQuantity.Text = "";
            UpdateSummaryMath();
        }

        protected void btnClear_Click(object sender, EventArgs e) => Response.Redirect("StockIn.aspx");
    }
}