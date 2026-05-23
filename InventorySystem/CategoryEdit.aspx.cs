using System;
using System.Web.UI;
using Dapper;

namespace InventorySystem
{
    public partial class CategoryEdit : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Request.QueryString["id"] != null && int.TryParse(Request.QueryString["id"], out int categoryId))
                {
                    hfCategoryID.Value = categoryId.ToString();
                    LoadCategoryData(categoryId);
                }
                else
                {
                    Response.Redirect("CategoryList.aspx");
                }
            }
        }

        private void LoadCategoryData(int categoryId)
        {
            try
            {
                using (var db = DBHelper.GetConnection())
                {
                    string sql = "SELECT CategoryName, Description FROM tblCategories WHERE CategoryID = @ID";
                    var category = db.QueryFirstOrDefault(sql, new { ID = categoryId });

                    if (category != null)
                    {
                        txtCategoryName.Text = category.CategoryName;
                        txtDescription.Text = category.Description;
                    }
                    else
                    {
                        ShowError("Category not found.");
                        btnUpdate.Enabled = false;
                    }
                }
            }
            catch (Exception ex)
            {
                ShowError("Error loading category: " + ex.Message);
            }
        }

        protected void btnUpdate_Click(object sender, EventArgs e)
        {
            pnlMessage.Visible = false;
            pnlSuccess.Visible = false;

            if (string.IsNullOrWhiteSpace(txtCategoryName.Text))
            {
                ShowError("Category Name is required.");
                return;
            }

            int categoryId = Convert.ToInt32(hfCategoryID.Value);

            try
            {
                using (var db = DBHelper.GetConnection())
                {
                    // Check for duplicates (ignoring current category)
                    string checkSql = "SELECT COUNT(1) FROM tblCategories WHERE CategoryName = @Name AND CategoryID != @ID";
                    int count = db.ExecuteScalar<int>(checkSql, new { Name = txtCategoryName.Text.Trim(), ID = categoryId });

                    if (count > 0)
                    {
                        ShowError("Another category with this name already exists.");
                        return;
                    }

                    string sql = "UPDATE tblCategories SET CategoryName = @Name, Description = @Description WHERE CategoryID = @ID";
                    db.Execute(sql, new
                    {
                        ID = categoryId,
                        Name = txtCategoryName.Text.Trim(),
                        Description = txtDescription.Text.Trim()
                    });

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