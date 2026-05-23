<%@ Page Title="Categories" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="CategoryList.aspx.cs" Inherits="InventorySystem.CategoryList" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    
    <div class="d-flex justify-content-between align-items-center mb-4 pb-2 border-bottom">
        <h4 class="fw-normal mb-0">Category Management</h4>
        <div class="d-flex gap-2">
            <asp:LinkButton ID="btnExport" runat="server" CssClass="btn btn-outline-secondary btn-sm px-3 rounded-pill d-flex align-items-center gap-2">
                <i class="bi bi-download"></i> Export
            </asp:LinkButton>
            <asp:LinkButton ID="btnAddCategory" runat="server" CssClass="btn btn-primary btn-sm px-3 rounded-pill d-flex align-items-center gap-2" PostBackUrl="~/CategoryCreate.aspx">
                <i class="bi bi-plus-lg"></i> Add Category
            </asp:LinkButton>
        </div>
    </div>

    <div class="card border border-light shadow-sm p-3 mb-4 rounded-3 bg-white">
        <div class="row g-2 align-items-center">
            <div class="col-md-5">
                <div class="input-group input-group-sm">
                    <span class="input-group-text bg-white text-muted border-end-0"><i class="bi bi-search"></i></span>
                    <asp:TextBox ID="txtSearch" runat="server" CssClass="form-control border-start-0 ps-0" placeholder="Search categories by name..."></asp:TextBox>
                    <asp:Button ID="btnSearch" runat="server" Text="Search" CssClass="btn btn-light border" />
                </div>
            </div>
            <div class="col-md-7 text-end text-muted small">
                <span class="fw-bold">Total Categories:</span> 
                <asp:Label ID="lblTotalCategories" runat="server" Text="0" CssClass="badge bg-secondary rounded-pill"></asp:Label>
            </div>
        </div>
    </div>

    <div class="card border border-light shadow-sm p-0 rounded-3 overflow-hidden">
        <div class="table-responsive">
            <asp:GridView ID="gvCategories" runat="server" AutoGenerateColumns="False" 
                CssClass="table table-borderless table-hover align-middle mb-0" 
                GridLines="None" ShowHeaderWhenEmpty="True">
                
                <HeaderStyle CssClass="text-muted small text-uppercase" BackColor="#f8f9fa" Font-Bold="True" />
                <RowStyle BorderColor="#dee2e6" BorderStyle="Dashed" BorderWidth="1px" />
                
                <Columns>
                    <asp:BoundField DataField="CategoryID" HeaderText="ID" ItemStyle-CssClass="py-3 text-muted fw-bold" ItemStyle-Width="80px" />
                    
                    <asp:BoundField DataField="CategoryName" HeaderText="Category Name" ItemStyle-CssClass="text-dark fw-bold" />
                    
                    <asp:BoundField DataField="Description" HeaderText="Description" ItemStyle-CssClass="text-secondary" />
                    
                    <asp:TemplateField HeaderText="Actions" ItemStyle-CssClass="text-end" ItemStyle-Width="120px" HeaderStyle-CssClass="text-end">
                        <ItemTemplate>
                            <asp:LinkButton ID="btnEdit" runat="server" CommandName="EditCategory" CommandArgument='<%# Eval("CategoryID") %>' CssClass="btn btn-sm btn-light text-primary me-1 border" ToolTip="Edit">
                                <i class="bi bi-pencil-square"></i>
                            </asp:LinkButton>
                            <asp:LinkButton ID="btnDelete" runat="server" CommandName="DeleteCategory" CommandArgument='<%# Eval("CategoryID") %>' CssClass="btn btn-sm btn-light text-danger border" ToolTip="Delete" OnClientClick="return confirm('Are you sure you want to delete this category?');">
                                <i class="bi bi-trash"></i>
                            </asp:LinkButton>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
                
                <EmptyDataTemplate>
                    <div class="text-center p-5 text-muted">
                        <i class="bi bi-tags display-4 text-light mb-3 d-block"></i>
                        <p class="mb-0">No categories found. Click 'Add Category' to create your first one.</p>
                    </div>
                </EmptyDataTemplate>
                
            </asp:GridView>
        </div>
    </div>

</asp:Content>