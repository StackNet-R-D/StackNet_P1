<%@ Page Title="Add Category" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="CategoryCreate.aspx.cs" Inherits="InventorySystem.CategoryCreate" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container-fluid mt-4 px-4" style="max-width: 600px;">
        
        <div class="card border border-light shadow-sm p-4 rounded-3 bg-white">
            
            <%-- Header Section --%>
            <div class="d-flex justify-content-between align-items-center mb-4 pb-3 border-bottom">
                <div>
                    <h5 class="fw-bold mb-1 text-dark">Add New Category</h5>
                    <span class="text-muted small fw-semibold">Categories / Create Category</span>
                </div>
                <asp:LinkButton ID="btnBack" runat="server" CssClass="btn btn-light border btn-sm px-3 rounded-2 fw-bold text-dark" PostBackUrl="~/CategoryList.aspx">
                    <i class="bi bi-arrow-left"></i> Back to List
                </asp:LinkButton>
            </div>

            <%-- Alert Message Panel --%>
            <asp:Panel ID="pnlMessage" runat="server" Visible="false" CssClass="alert alert-danger mb-4 rounded-2 small fw-semibold">
                <asp:Label ID="lblMessage" runat="server"></asp:Label>
            </asp:Panel>

            <%-- Form Fields --%>
            <div class="mb-3">
                <label class="form-label small fw-bold text-muted mb-1">Category Name <span class="text-danger">*</span></label>
                <asp:TextBox ID="txtCategoryName" runat="server" CssClass="form-control border-secondary border-opacity-25 py-2" placeholder="e.g. Power Tools" Required="true"></asp:TextBox>
            </div>

            <div class="mb-4">
                <label class="form-label small fw-bold text-muted mb-1">Description (Optional)</label>
                <asp:TextBox ID="txtDescription" runat="server" CssClass="form-control border-secondary border-opacity-25 py-2" TextMode="MultiLine" Rows="4" placeholder="Brief description of the items in this category..."></asp:TextBox>
            </div>

            <%-- Action Buttons --%>
            <div class="d-flex justify-content-end gap-2 pt-3 border-top">
                <asp:LinkButton ID="btnCancel" runat="server" CssClass="btn btn-light border px-4 py-2 rounded-2 fw-bold text-dark" PostBackUrl="~/CategoryList.aspx">
                    Cancel
                </asp:LinkButton>
                <asp:LinkButton ID="btnSave" runat="server" CssClass="btn btn-primary px-4 py-2 rounded-2 fw-bold d-flex align-items-center gap-2" OnClick="btnSave_Click">
                    <i class="bi bi-check2-circle"></i> Save Category
                </asp:LinkButton>
            </div>

        </div>
    </div>
</asp:Content>