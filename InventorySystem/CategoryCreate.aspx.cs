using System;
using System.Web.UI;
using Dapper;

namespace InventorySystem
{
    public partial class CategoryCreate : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Nothing needed on initial load for a blank form
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            // Reset error panel
            pnlMessage.Visible = false;

            // Basic Validation
            if (string.IsNullOrWhiteSpace(txtCategoryName.Text))
            {
                ShowError("Category Name is required.");
                return;
            }

            try
            {
                using (var db = DBHelper.GetConnection())
                {
                    // 1. Prevent duplicate categories
                    string checkSql = "SELECT COUNT(1) FROM tblCategories WHERE CategoryName = @Name";
                    int count = db.ExecuteScalar<int>(checkSql, new { Name = txtCategoryName.Text.Trim() });

                    if (count > 0)
                    {
                        ShowError("A category with this name already exists.");
                        return;
                    }

                    // 2. Insert the new category into the database
                    string sql = "INSERT INTO tblCategories (CategoryName, Description) VALUES (@Name, @Description)";

                    var parameters = new
                    {
                        Name = txtCategoryName.Text.Trim(),
                        Description = txtDescription.Text.Trim()
                    };

                    db.Execute(sql, parameters);

                    // Redirect back to the Category List upon success
                    Response.Redirect("CategoryList.aspx");
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