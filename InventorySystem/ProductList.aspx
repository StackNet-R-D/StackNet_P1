<%@ Page Title="Product Management" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ProductList.aspx.cs" Inherits="InventorySystem.ProductList" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    
    <%-- Tiny CSS block to style the ASP.NET Pager to look like Bootstrap --%>
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
        <div class="card border border-light shadow-sm p-4 rounded-3 bg-white">
            
            <%-- Header Section --%>
            <div class="d-flex justify-content-between align-items-center mb-4 pb-2">
                <div class="d-flex align-items-baseline">
                    <h5 class="fw-bold mb-0 me-3 text-dark">Product Management</h5>
                    <span class="text-muted small fw-semibold">Products / All Products</span>
                </div>
                <div class="d-flex gap-2">
                    <asp:LinkButton ID="btnExport" runat="server" CssClass="btn btn-outline-secondary btn-sm px-3 rounded-2 d-flex align-items-center gap-2 fw-bold text-dark border">
                        <i class="bi bi-download"></i> Export
                    </asp:LinkButton>
                    <asp:LinkButton ID="btnAddProduct" runat="server" CssClass="btn btn-primary btn-sm px-3 rounded-2 d-flex align-items-center gap-2 fw-bold" PostBackUrl="~/ProductCreate.aspx">
                        <i class="bi bi-plus-lg"></i> Add Product
                    </asp:LinkButton>
                </div>
            </div>

            <%-- Toolbar Section (Now Interactive) --%>
            <div class="d-flex justify-content-between align-items-center mb-4">
                <div class="d-flex gap-2 align-items-center">
                    
                    <%-- Search Input --%>
                    <div class="input-group input-group-sm" style="width: 220px;">
                        <span class="input-group-text bg-white text-muted border-end-0"><i class="bi bi-search"></i></span>
                        <asp:TextBox ID="txtSearch" runat="server" CssClass="form-control border-start-0 ps-0 fw-semibold" 
                            placeholder="Search Name or Barcode" AutoPostBack="true" OnTextChanged="Filter_Changed"></asp:TextBox>
                    </div>
                    
                    <button type="button" class="btn btn-sm btn-outline-primary px-3 fw-bold d-flex align-items-center gap-1 border-opacity-50">
                        <i class="bi bi-upc-scan"></i> Scan
                    </button>

                    <%-- Dropdowns --%>
                    <asp:DropDownList ID="ddlCategory" runat="server" CssClass="form-select form-select-sm fw-semibold text-dark" style="width: 160px;"
                        AutoPostBack="true" OnSelectedIndexChanged="Filter_Changed">
                        <%-- Options loaded dynamically from DB --%>
                    </asp:DropDownList>
                    
                    <asp:DropDownList ID="ddlStatus" runat="server" CssClass="form-select form-select-sm fw-semibold text-dark" style="width: 140px;"
                        AutoPostBack="true" OnSelectedIndexChanged="Filter_Changed">
                        <asp:ListItem Text="All Status" Value="" />
                        <asp:ListItem Text="Active" Value="Active" />
                        <asp:ListItem Text="Inactive" Value="Inactive" />
                    </asp:DropDownList>
                </div>

                <%-- Dynamic Product Count --%>
                <div class="text-muted small text-end lh-sm">
                    <span class="fw-bold text-dark fs-6"><asp:Label ID="lblTotalProducts" runat="server" Text="0"></asp:Label></span><br />products
                </div>
            </div>

            <%-- Data Table Section (Now with AllowPaging) --%>
            <div class="table-responsive">
                <asp:GridView ID="gvProducts" runat="server" AutoGenerateColumns="False" 
                    CssClass="table table-hover align-middle mb-0" 
                    GridLines="None" ShowHeaderWhenEmpty="True" BorderStyle="None"
                    OnRowCommand="gvProducts_RowCommand" DataKeyNames="ProductID"
                    AllowPaging="True" PageSize="10" OnPageIndexChanging="gvProducts_PageIndexChanging">
                    
                    <HeaderStyle CssClass="text-muted small text-uppercase border-bottom" BackColor="#fbfbfb" Font-Bold="True" Height="50px" />
                    <RowStyle Height="80px" CssClass="border-bottom" />
                    <PagerStyle CssClass="grid-pager text-end border-top pt-3 mt-2" />
                    
                    <Columns>
                        <asp:TemplateField ItemStyle-Width="40px" ItemStyle-CssClass="text-center">
                            <HeaderTemplate><asp:CheckBox ID="chkSelectAll" runat="server" CssClass="form-check-input" /></HeaderTemplate>
                            <ItemTemplate><asp:CheckBox ID="chkSelect" runat="server" CssClass="form-check-input" /></ItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Product">
                            <ItemTemplate>
                                <div class="d-flex align-items-center gap-3 py-2">
                                    <div class="bg-light border rounded text-secondary d-flex align-items-center justify-content-center" style="width: 45px; height: 45px; font-size: 1.2rem;">
                                        <i class="bi bi-box"></i>
                                    </div>
                                    <div class="fw-bold text-dark" style="max-width: 160px; font-size: 0.85rem; line-height: 1.2;">
                                        <%# DataBinder.Eval(Container.DataItem, "ProductName") %>
                                    </div>
                                </div>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:BoundField DataField="Barcode" HeaderText="Barcode" ItemStyle-CssClass="fw-semibold text-secondary small" />
                        <asp:BoundField DataField="CategoryName" HeaderText="Category" ItemStyle-CssClass="fw-semibold text-dark small" />
                        <asp:BoundField DataField="CostPrice" HeaderText="Cost Price" DataFormatString="Rs. {0:N2}" ItemStyle-CssClass="fw-semibold text-dark small" />
                        <asp:BoundField DataField="SellingPrice" HeaderText="Sell Price" DataFormatString="Rs. {0:N2}" ItemStyle-CssClass="fw-semibold text-dark small" />
                        
                        <asp:TemplateField HeaderText="Current Qty">
                            <ItemTemplate>
                                <span class='<%# Convert.ToInt32(DataBinder.Eval(Container.DataItem, "CurrentQty")) < Convert.ToInt32(DataBinder.Eval(Container.DataItem, "MinimumQty")) ? "text-danger fw-bold small" : "text-success fw-bold small" %>'>
                                    <%# DataBinder.Eval(Container.DataItem, "CurrentQty") %>
                                </span>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Min Qty">
                            <ItemTemplate>
                                <span class="text-secondary fw-semibold small">
                                    <%# string.IsNullOrEmpty(Convert.ToString(Eval("MinimumQty"))) ? "0" : Eval("MinimumQty") %>
                                </span>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Status">
                            <ItemTemplate>
                                <span class='<%# Convert.ToString(DataBinder.Eval(Container.DataItem, "Status")) == "Active" ? "badge bg-success bg-opacity-10 text-success border border-success border-opacity-25 px-3 py-2" : "badge bg-secondary bg-opacity-10 text-secondary border border-secondary border-opacity-25 px-3 py-2" %>'>
                                    <%# DataBinder.Eval(Container.DataItem, "Status") %>
                                </span>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Actions" ItemStyle-Width="130px">
                            <ItemTemplate>
                                <div class="d-flex gap-1">
                                    <asp:LinkButton runat="server" CommandName="ViewProduct" CommandArgument='<%# Eval("ProductID") %>' CssClass="btn btn-sm btn-light border text-muted rounded-2 px-2"><i class="bi bi-eye"></i></asp:LinkButton>
                                    <asp:LinkButton runat="server" CommandName="EditProduct" CommandArgument='<%# Eval("ProductID") %>' CssClass="btn btn-sm btn-light border text-muted rounded-2 px-2"><i class="bi bi-pencil-square"></i></asp:LinkButton>
                                    <asp:LinkButton runat="server" CommandName="DeleteProduct" CommandArgument='<%# Eval("ProductID") %>' CssClass="btn btn-sm btn-light border text-danger rounded-2 px-2" OnClientClick="return confirm('Are you sure you want to delete this product?');"><i class="bi bi-trash"></i></asp:LinkButton>
                                </div>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </div>
        </div>
    </div>
</asp:Content>