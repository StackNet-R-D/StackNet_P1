<%@ Page Title="Inventory Report" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="InventoryReport.aspx.cs" Inherits="InventorySystem.InventoryReport" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container-fluid mt-4 px-4">
        
        <%-- Header Section --%>
        <div class="d-flex justify-content-between align-items-center mb-4 pb-2 border-bottom">
            <div>
                <h4 class="fw-normal mb-1 text-dark">Inventory Summary Report</h4>
                <div class="text-muted small">Reports / Current Valuation</div>
            </div>
            <div class="d-flex gap-2">
                <button type="button" class="btn btn-outline-secondary btn-sm px-3 rounded-2 d-flex align-items-center gap-2" onclick="window.print()">
                    <i class="bi bi-printer"></i> Print Report
                </button>
            </div>
        </div>

        <%-- Summary KPI Cards --%>
        <div class="row g-4 mb-4">
            <div class="col-md-4">
                <div class="card border border-light shadow-sm p-4 rounded-3 h-100 bg-white" style="border-left: 4px solid #0d6efd !important;">
                    <div class="text-muted small fw-bold text-uppercase mb-2">Total Items in Stock</div>
                    <h2 class="fw-bold text-dark mb-0"><asp:Label ID="lblTotalItems" runat="server" Text="0"></asp:Label></h2>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card border border-light shadow-sm p-4 rounded-3 h-100 bg-white" style="border-left: 4px solid #198754 !important;">
                    <div class="text-muted small fw-bold text-uppercase mb-2">Total Cost Valuation</div>
                    <h2 class="fw-bold text-success mb-0"><asp:Label ID="lblTotalCost" runat="server" Text="Rs. 0.00"></asp:Label></h2>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card border border-light shadow-sm p-4 rounded-3 h-100 bg-white" style="border-left: 4px solid #ffc107 !important;">
                    <div class="text-muted small fw-bold text-uppercase mb-2">Total Retail Valuation</div>
                    <h2 class="fw-bold text-warning mb-0"><asp:Label ID="lblTotalRetail" runat="server" Text="Rs. 0.00"></asp:Label></h2>
                </div>
            </div>
        </div>

        <%-- Data Grid --%>
        <div class="card border border-light shadow-sm p-0 rounded-3 overflow-hidden bg-white">
            <div class="p-3 bg-light border-bottom d-flex justify-content-between align-items-center">
                <span class="fw-bold text-dark small text-uppercase">Stock Breakdown by Category</span>
            </div>
            <div class="table-responsive">
                <asp:GridView ID="gvInventoryReport" runat="server" AutoGenerateColumns="False" 
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
                                <span class='<%# Convert.ToInt32(Eval("CurrentQty")) < Convert.ToInt32(Eval("MinimumQty")) ? "badge bg-danger bg-opacity-10 text-danger border border-danger border-opacity-25 px-2" : "fw-bold text-dark" %>'>
                                    <%# Eval("CurrentQty") %>
                                </span>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:BoundField DataField="CostPrice" HeaderText="Unit Cost" DataFormatString="Rs. {0:N2}" ItemStyle-CssClass="text-muted small" />
                        <asp:BoundField DataField="TotalCostValue" HeaderText="Total Cost Value" DataFormatString="Rs. {0:N2}" ItemStyle-CssClass="fw-bold text-success" />
                        <asp:BoundField DataField="TotalRetailValue" HeaderText="Total Retail Value" DataFormatString="Rs. {0:N2}" ItemStyle-CssClass="fw-bold text-warning pe-3" ItemStyle-HorizontalAlign="Right" HeaderStyle-CssClass="text-end pe-3" />
                    </Columns>
                    <EmptyDataTemplate>
                        <div class="text-center p-5 text-muted">No active inventory found.</div>
                    </EmptyDataTemplate>
                </asp:GridView>
            </div>
        </div>

    </div>
</asp:Content>