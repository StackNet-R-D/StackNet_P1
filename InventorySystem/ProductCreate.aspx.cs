using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;
using Dapper;

namespace InventorySystem
{
    public partial class ProductCreate : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadCategories();
            }
        }

        private void LoadCategories()
        {
            try
            {
                using (var db = DBHelper.GetConnection())
                {
                    string sql = "SELECT CategoryID, CategoryName FROM tblCategories ORDER BY CategoryName";

                    // Use ExecuteReader and a DataTable to fix the DapperRow binding error
                    using (var reader = db.ExecuteReader(sql))
                    {
                        DataTable dt = new DataTable();
                        dt.Load(reader);

                        ddlCategory.DataSource = dt;
                        ddlCategory.DataTextField = "CategoryName";
                        ddlCategory.DataValueField = "CategoryID";
                        ddlCategory.DataBind();
                    }

                    ddlCategory.Items.Insert(0, new ListItem("-- Select Category --", ""));
                }
            }
            catch (Exception ex)
            {
                ShowError("Error loading categories: " + ex.Message);
            }
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            // Reset the error panel on every click
            pnlMessage.Visible = false;

            // Basic Validation
            if (string.IsNullOrWhiteSpace(txtProductName.Text) || string.IsNullOrWhiteSpace(txtBarcode.Text))
            {
                ShowError("Product Name and Barcode are required.");
                return;
            }

            // Category Validation to prevent the NULL insertion database crash
            if (string.IsNullOrEmpty(ddlCategory.SelectedValue))
            {
                ShowError("Please select a Category.");
                return;
            }

            // Now we know it's safe to convert
            int categoryId = Convert.ToInt32(ddlCategory.SelectedValue);

            // Parse numbers safely
            decimal.TryParse(txtCostPrice.Text, out decimal costPrice);
            decimal.TryParse(txtSellingPrice.Text, out decimal sellingPrice);
            int.TryParse(txtCurrentQty.Text, out int currentQty);
            int.TryParse(txtMinQty.Text, out int minQty);

            try
            {
                using (var db = DBHelper.GetConnection())
                {
                    // 1. Check if Barcode already exists to prevent duplicates
                    string checkSql = "SELECT COUNT(1) FROM tblProducts WHERE Barcode = @Barcode";
                    int count = db.ExecuteScalar<int>(checkSql, new { Barcode = txtBarcode.Text.Trim() });

                    if (count > 0)
                    {
                        ShowError("A product with this Barcode already exists. Please use a unique Barcode.");
                        return;
                    }

                    // 2. Insert the new product
                    string sql = @"
                        INSERT INTO tblProducts 
                        (Barcode, ProductName, CategoryID, CostPrice, SellingPrice, MinimumQty, CurrentQty, Status, CreatedDate) 
                        VALUES 
                        (@Barcode, @ProductName, @CategoryID, @CostPrice, @SellingPrice, @MinimumQty, @CurrentQty, @Status, GETDATE())";

                    var parameters = new
                    {
                        Barcode = txtBarcode.Text.Trim(),
                        ProductName = txtProductName.Text.Trim(),
                        CategoryID = categoryId, // Guaranteed to be an integer now
                        CostPrice = costPrice,
                        SellingPrice = sellingPrice,
                        MinimumQty = minQty,
                        CurrentQty = currentQty,
                        Status = ddlStatus.SelectedValue
                    };

                    db.Execute(sql, parameters);

                    // Redirect back to the list upon success
                    Response.Redirect("ProductList.aspx");
                }
            }
            catch (Exception ex)
            {
                ShowError("An error occurred while saving: " + ex.Message);
            }
        }

        private void ShowError(string message)
        {
            pnlMessage.Visible = true;
            lblMessage.Text = message;
        }
    }
}