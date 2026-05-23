using System;
using System.Data;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;
using Dapper;

namespace InventorySystem
{
    public partial class ProductEdit : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadCategories();

                // Get the ID from the URL (e.g., ?id=13)
                if (Request.QueryString["id"] != null && int.TryParse(Request.QueryString["id"], out int productId))
                {
                    hfProductID.Value = productId.ToString();
                    LoadProductData(productId);
                }
                else
                {
                    // If no valid ID is provided, send them back to the list
                    Response.Redirect("ProductList.aspx");
                }
            }
        }

        private void LoadCategories()
        {
            try
            {
                using (var db = DBHelper.GetConnection())
                {
                    string sql = "SELECT CategoryID, CategoryName FROM tblCategories ORDER BY CategoryName";
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

        private void LoadProductData(int productId)
        {
            try
            {
                using (var db = DBHelper.GetConnection())
                {
                    string sql = "SELECT * FROM tblProducts WHERE ProductID = @ID";

                    // Using Dapper to fetch a single dynamic row
                    var product = db.QueryFirstOrDefault(sql, new { ID = productId });

                    if (product != null)
                    {
                        txtProductName.Text = product.ProductName;
                        txtBarcode.Text = product.Barcode;

                        if (product.CategoryID != null)
                        {
                            ddlCategory.SelectedValue = product.CategoryID.ToString();
                        }

                        txtCostPrice.Text = product.CostPrice.ToString("0.00");
                        txtSellingPrice.Text = product.SellingPrice.ToString("0.00");
                        txtCurrentQty.Text = product.CurrentQty.ToString();
                        txtMinQty.Text = product.MinimumQty.ToString();

                        if (product.Status != null)
                        {
                            ddlStatus.SelectedValue = product.Status.ToString();
                        }
                    }
                    else
                    {
                        ShowError("Product not found.");
                        btnUpdate.Enabled = false;
                    }
                }
            }
            catch (Exception ex)
            {
                ShowError("Error loading product: " + ex.Message);
            }
        }

        protected void btnUpdate_Click(object sender, EventArgs e)
        {
            pnlMessage.Visible = false;
            pnlSuccess.Visible = false;

            if (string.IsNullOrWhiteSpace(txtProductName.Text) || string.IsNullOrWhiteSpace(txtBarcode.Text))
            {
                ShowError("Product Name and Barcode are required.");
                return;
            }

            if (string.IsNullOrEmpty(ddlCategory.SelectedValue))
            {
                ShowError("Please select a Category.");
                return;
            }

            int productId = Convert.ToInt32(hfProductID.Value);
            int categoryId = Convert.ToInt32(ddlCategory.SelectedValue);

            decimal.TryParse(txtCostPrice.Text, out decimal costPrice);
            decimal.TryParse(txtSellingPrice.Text, out decimal sellingPrice);
            int.TryParse(txtMinQty.Text, out int minQty);

            try
            {
                using (var db = DBHelper.GetConnection())
                {
                    // Check for duplicate barcode, BUT ignore the current product's ID
                    string checkSql = "SELECT COUNT(1) FROM tblProducts WHERE Barcode = @Barcode AND ProductID != @ID";
                    int count = db.ExecuteScalar<int>(checkSql, new { Barcode = txtBarcode.Text.Trim(), ID = productId });

                    if (count > 0)
                    {
                        ShowError("Another product is already using this Barcode.");
                        return;
                    }

                    // Update the product. (Notice we DO NOT update CurrentQty here. 
                    // Stock should only be updated via the Stock In/Out modules).
                    string sql = @"
                        UPDATE tblProducts SET 
                            Barcode = @Barcode, 
                            ProductName = @ProductName, 
                            CategoryID = @CategoryID, 
                            CostPrice = @CostPrice, 
                            SellingPrice = @SellingPrice, 
                            MinimumQty = @MinimumQty, 
                            Status = @Status
                        WHERE ProductID = @ID";

                    var parameters = new
                    {
                        ID = productId,
                        Barcode = txtBarcode.Text.Trim(),
                        ProductName = txtProductName.Text.Trim(),
                        CategoryID = categoryId,
                        CostPrice = costPrice,
                        SellingPrice = sellingPrice,
                        MinimumQty = minQty,
                        Status = ddlStatus.SelectedValue
                    };

                    db.Execute(sql, parameters);

                    pnlSuccess.Visible = true;
                }
            }
            catch (Exception ex)
            {
                ShowError("An error occurred while updating: " + ex.Message);
            }
        }

        private void ShowError(string message)
        {
            pnlMessage.Visible = true;
            lblMessage.Text = message;
        }
    }
}