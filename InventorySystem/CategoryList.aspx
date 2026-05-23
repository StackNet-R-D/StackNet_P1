<%@ Page Title="Category Management" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="CategoryList.aspx.cs" Inherits="InventorySystem.CategoryList" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    
    <%-- CSS block to style the ASP.NET Pager to look like Bootstrap --%>
    <style>
        .grid-pager table { margin-left: auto; margin-top: 15px; }
        .grid-pager td { padding: 0; }
        .grid-pager a, .grid-pager span {
            display: inline-block; padding: 6px 12px; margin-left: 4px;
            border: 1px solid #dee2e6; border-radius: 4px;
            color: #212529; text-decoration: none; font-weight: bold; font-size: 14px;
        }
        .grid-pager a:hover { background-color: #f8f9fa; }
        .grid-pager span { background-color: #212529; color: white; border-color: #212529; }
    </style>

    <div class="container-fluid mt-4 px-4">
        
        <div class="d-flex justify-content-between align-items-center mb-4 pb-2 border-bottom">
            <h4 class="fw-normal mb-0 text-dark">Category Management</h4>
            <div class="d-flex gap-2">
                <asp:LinkButton ID="btnExport" runat="server" CssClass="btn btn-outline-secondary btn-sm px-3 rounded-2 d-flex align-items-center gap-2">
                    <i class="bi bi-download"></i> Export
                </asp:LinkButton>
                <asp:LinkButton ID="btnAddCategory" runat="server" CssClass="btn btn-primary btn-sm px-3 rounded-2 d-flex align-items-center gap-2" PostBackUrl="~/CategoryCreate.aspx">
                    <i class="bi bi-plus-lg"></i> Add Category
                </asp:LinkButton>
            </div>
        </div>

        <%-- Error Message Panel --%>
        <asp:Panel ID="pnlMessage" runat="server" Visible="false" CssClass="alert alert-danger mb-4 rounded-2 small fw-semibold">
            <asp:Label ID="lblMessage" runat="server"></asp:Label>
        </asp:Panel>

        <div class="card border border-light shadow-sm p-3 mb-4 rounded-3 bg-white">
            <div class="row g-2 align-items-center">
                <div class="col-md-5">
                    <div class="input-group input-group-sm">
                        <span class="input-group-text bg-white text-muted border-end-0"><i class="bi bi-search"></i></span>
                        <asp:TextBox ID="txtSearch" runat="server" CssClass="form-control border-start-0 ps-0" 
                            placeholder="Search categories by name..." AutoPostBack="true" OnTextChanged="btnSearch_Click"></asp:TextBox>
                        <asp:Button ID="btnSearch" runat="server" Text="Search" CssClass="btn btn-light border" OnClick="btnSearch_Click" />
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
                    GridLines="None" ShowHeaderWhenEmpty="True" 
                    OnRowCommand="gvCategories_RowCommand" DataKeyNames="CategoryID"
                    AllowPaging="True" PageSize="10" OnPageIndexChanging="gvCategories_PageIndexChanging">
                    
                    <%-- FIXED: Removed the invalid BorderSide property --%>
                    <HeaderStyle CssClass="text-muted small text-uppercase border-bottom" BackColor="#f8f9fa" Font-Bold="True" Height="50px" />
                    <RowStyle Height="60px" CssClass="border-bottom" />
                    <PagerStyle CssClass="grid-pager text-end border-top pt-3 mt-2 pe-3 pb-3" />
                    
                    <Columns>
                        <asp:BoundField DataField="CategoryID" HeaderText="ID" ItemStyle-CssClass="text-muted fw-bold ps-3" ItemStyle-Width="80px" />
                        <asp:BoundField DataField="CategoryName" HeaderText="Category Name" ItemStyle-CssClass="text-dark fw-bold" />
                        <asp:BoundField DataField="Description" HeaderText="Description" ItemStyle-CssClass="text-secondary" />
                        
                        <asp:TemplateField HeaderText="Actions" ItemStyle-CssClass="text-end pe-3" ItemStyle-Width="120px" HeaderStyle-CssClass="text-end pe-3">
                            <ItemTemplate>
                                <asp:LinkButton runat="server" CommandName="EditCategory" CommandArgument='<%# Eval("CategoryID") %>' CssClass="btn btn-sm btn-light text-primary me-1 border" ToolTip="Edit">
                                    <i class="bi bi-pencil-square"></i>
                                </asp:LinkButton>
                                <asp:LinkButton runat="server" CommandName="DeleteCategory" CommandArgument='<%# Eval("CategoryID") %>' CssClass="btn btn-sm btn-light text-danger border" ToolTip="Delete" OnClientClick="return confirm('Are you sure you want to delete this category?');">
                                    <i class="bi bi-trash"></i>
                                </asp:LinkButton>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                    
                    <EmptyDataTemplate>
                        <div class="text-center p-5 text-muted">
                            <i class="bi bi-tags display-4 text-light mb-3 d-block"></i>
                            <p class="mb-0">No categories found.</p>
                        </div>
                    </EmptyDataTemplate>
                </asp:GridView>
            </div>
        </div>

    </div>
</asp:Content>