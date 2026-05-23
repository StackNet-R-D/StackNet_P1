using System;
using System.Data;
using System.Web.UI;
using Dapper;

namespace InventorySystem
{
    public partial class ProductCreate : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e) { }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            try
            {
                int catId, minQty;
                decimal cost, sell;

                if (!int.TryParse(txtCatId.Text, out catId) ||
                    !decimal.TryParse(txtCostPrice.Text, out cost) ||
                    !decimal.TryParse(txtSellPrice.Text, out sell) ||
                    !int.TryParse(txtMinQty.Text, out minQty))
                {
                    throw new Exception("Please enter valid numeric values.");
                }

                using (IDbConnection db = DBHelper.GetConnection())
                {
                    string sql = @"INSERT INTO tblProducts (ProductName, Barcode, CategoryID, CostPrice, SellingPrice, CurrentQty, MinimumQty, Status) 
                                   VALUES (@Name, @Barcode, @CatId, @Cost, @Sell, 0, @MinQty, 'Active')";

                    db.Execute(sql, new
                    {
                        Name = txtProductName.Text,
                        Barcode = txtBarcode.Text,
                        CatId = catId,
                        Cost = cost,
                        Sell = sell,
                        MinQty = minQty
                    });
                }
                Response.Redirect("~/ProductList.aspx");
            }
            catch (Exception ex)
            {
                ClientScript.RegisterStartupScript(this.GetType(), "alert", "alert('Error: " + ex.Message.Replace("'", "") + "');", true);
            }
        }
    }
}