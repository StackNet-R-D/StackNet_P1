<%@ Page Title="Product Management" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ProductList.aspx.cs" Inherits="InventorySystem.ProductList" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
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

            <%-- Toolbar Section --%>
            <div class="d-flex justify-content-between align-items-center mb-4">
                <div class="d-flex gap-2 align-items-center">
                    <div class="input-group input-group-sm" style="width: 220px;">
                        <span class="input-group-text bg-white text-muted border-end-0"><i class="bi bi-search"></i></span>
                        <asp:TextBox ID="txtSearch" runat="server" CssClass="form-control border-start-0 ps-0 fw-semibold" placeholder="Search..."></asp:TextBox>
                    </div>
                    
                    <button type="button" class="btn btn-sm btn-outline-primary px-3 fw-bold d-flex align-items-center gap-1 border-opacity-50">
                        <i class="bi bi-upc-scan"></i> Scan
                    </button>

                    <asp:DropDownList ID="ddlCategory" runat="server" CssClass="form-select form-select-sm fw-semibold text-dark" style="width: 160px;">
                        <asp:ListItem Text="All Categories" Value="" />
                    </asp:DropDownList>
                    
                    <asp:DropDownList ID="ddlStatus" runat="server" CssClass="form-select form-select-sm fw-semibold text-dark" style="width: 140px;">
                        <asp:ListItem Text="All Status" Value="" />
                    </asp:DropDownList>
                </div>

                <div class="text-muted small text-end lh-sm">
                    <span class="fw-bold text-dark fs-6">247</span><br />products
                </div>
            </div>

            <%-- Data Table Section --%>
            <div class="table-responsive">
                <asp:GridView ID="gvProducts" runat="server" AutoGenerateColumns="False" 
                    CssClass="table table-hover align-middle mb-0" 
                    GridLines="None" ShowHeaderWhenEmpty="True" BorderStyle="None">
                    
                    <HeaderStyle CssClass="text-muted small text-uppercase border-bottom" BackColor="#fbfbfb" Font-Bold="True" Height="50px" />
                    <RowStyle Height="80px" CssClass="border-bottom" />
                    
                    <Columns>
                        <asp:TemplateField ItemStyle-Width="40px" ItemStyle-CssClass="text-center">
                            <HeaderTemplate>
                                <asp:CheckBox ID="chkSelectAll" runat="server" CssClass="form-check-input" />
                            </HeaderTemplate>
                            <ItemTemplate>
                                <asp:CheckBox ID="chkSelect" runat="server" CssClass="form-check-input" />
                            </ItemTemplate>
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
                                <span class='<%# Convert.ToInt32(DataBinder.Eval(Container.DataItem, "CurrentQty")) < 20 ? "text-danger fw-bold small" : "text-success fw-bold small" %>'>
                                    <%# DataBinder.Eval(Container.DataItem, "CurrentQty") %>
                                </span>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <%-- Fixed Minimum Qty Binding --%>
                        <asp:TemplateField HeaderText="Min Qty">
                            <ItemTemplate>
                                <span class="text-secondary fw-semibold small">
                                    <%# string.IsNullOrEmpty(Convert.ToString(Eval("MinimumQty"))) ? "10" : Eval("MinimumQty") %>
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
                                    <asp:LinkButton runat="server" CssClass="btn btn-sm btn-light border text-muted rounded-2 px-2"><i class="bi bi-eye"></i></asp:LinkButton>
                                    <asp:LinkButton runat="server" CssClass="btn btn-sm btn-light border text-muted rounded-2 px-2"><i class="bi bi-pencil-square"></i></asp:LinkButton>
                                    <asp:LinkButton runat="server" CssClass="btn btn-sm btn-light border text-danger rounded-2 px-2"><i class="bi bi-trash"></i></asp:LinkButton>
                                </div>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </div>

            <%-- Pagination Footer --%>
            <div class="d-flex justify-content-between align-items-center mt-3 pt-3 border-top">
                <span class="text-muted small fw-semibold">Showing 1-20 of 247 products</span>
                <nav>
                    <ul class="pagination pagination-sm mb-0 gap-1">
                        <li class="page-item disabled"><a class="page-link rounded border text-muted" href="#"><i class="bi bi-chevron-left"></i></a></li>
                        <li class="page-item active"><a class="page-link rounded bg-dark border-dark text-white fw-bold" href="#">1</a></li>
                        <li class="page-item"><a class="page-link rounded border text-dark fw-bold" href="#">2</a></li>
                        <li class="page-item"><a class="page-link rounded border text-dark fw-bold" href="#">3</a></li>
                        <li class="page-item disabled"><a class="page-link rounded border-0 text-muted" href="#">...</a></li>
                        <li class="page-item"><a class="page-link rounded border text-dark fw-bold" href="#">13</a></li>
                        <li class="page-item"><a class="page-link rounded border text-muted" href="#"><i class="bi bi-chevron-right"></i></a></li>
                    </ul>
                </nav>
            </div>

        </div>
    </div>
</asp:Content>