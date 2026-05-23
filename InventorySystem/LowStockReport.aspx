<%@ Page Title="Low Stock Report" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="LowStockReport.aspx.cs" Inherits="InventorySystem.LowStockReport" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container-fluid mt-4 px-4">
        
        <%-- Header Section --%>
        <div class="d-flex justify-content-between align-items-center mb-4 pb-2 border-bottom">
            <div>
                <h4 class="fw-normal mb-1 text-dark">Low Stock Report</h4>
                <div class="text-muted small">Reports / Items Requiring Attention</div>
            </div>
            <div class="d-flex gap-2">
                <button type="button" class="btn btn-outline-secondary btn-sm px-3 rounded-2 d-flex align-items-center gap-2" onclick="window.print()">
                    <i class="bi bi-printer"></i> Print Report
                </button>
            </div>
        </div>

        <%-- Critical Alert Banner --%>
        <asp:Panel ID="pnlAlert" runat="server" CssClass="alert alert-danger d-flex align-items-center mb-4 border-0 shadow-sm rounded-3">
            <i class="bi bi-exclamation-octagon-fill fs-3 me-3"></i>
            <div>
                <div class="fw-bold">Attention Required</div>
                <div class="small">The following items have fallen below their minimum required stock levels and should be reordered immediately.</div>
            </div>
        </asp:Panel>

        <%-- Report Grid Section --%>
        <div class="card border border-light shadow-sm p-0 rounded-3 overflow-hidden bg-white">
            <div class="p-3 bg-light border-bottom d-flex justify-content-between align-items-center">
                <span class="fw-bold text-dark small text-uppercase">Depleted Inventory</span>
                <asp:Label ID="lblRecordCount" runat="server" CssClass="badge bg-danger rounded-pill text-white" Text="0 items"></asp:Label>
            </div>
            
            <div class="table-responsive">
                <asp:GridView ID="gvLowStock" runat="server" AutoGenerateColumns="False" 
                    CssClass="table table-hover align-middle mb-0" 
                    GridLines="None" ShowHeaderWhenEmpty="True">
                    
                    <HeaderStyle CssClass="text-muted small fw-bold text-uppercase border-bottom" BackColor="#ffffff" Height="50px" />
                    <RowStyle Height="60px" CssClass="border-bottom border-light" />
                    
                    <Columns>
                        <asp:BoundField DataField="CategoryName" HeaderText="Category" ItemStyle-CssClass="fw-semibold text-secondary ps-3" />
                        <asp:BoundField DataField="Barcode" HeaderText="Barcode" ItemStyle-CssClass="text-muted small" />
                        <asp:BoundField DataField="ProductName" HeaderText="Product Name" ItemStyle-CssClass="fw-bold text-dark" />
                        
                        <asp:TemplateField HeaderText="Current Stock">
                            <ItemTemplate>
                                <span class="badge bg-danger bg-opacity-10 text-danger border border-danger border-opacity-25 px-3 py-2 fs-6">
                                    <%# Eval("CurrentQty") %>
                                </span>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:BoundField DataField="MinimumQty" HeaderText="Minimum Required" ItemStyle-CssClass="fw-bold text-secondary" />
                        
                        <asp:TemplateField HeaderText="Deficit">
                            <ItemTemplate>
                                <span class="fw-bold text-danger">
                                    <%# Convert.ToInt32(Eval("MinimumQty")) - Convert.ToInt32(Eval("CurrentQty")) %> units short
                                </span>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                    
                    <EmptyDataTemplate>
                        <div class="text-center p-5 text-muted">
                            <i class="bi bi-shield-check display-4 text-success mb-3 d-block"></i>
                            <p class="mb-0 fw-bold text-dark">All Clear!</p>
                            <p class="small">There are currently no items below their minimum stock limits.</p>
                        </div>
                    </EmptyDataTemplate>
                </asp:GridView>
            </div>
        </div>

    </div>
</asp:Content>