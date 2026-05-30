<%@ Page Title="Inventory Report" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="InventoryReport.aspx.cs" Inherits="InventorySystem.InventoryReport" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        /* This hides the formal document stuff when viewing on screen */
        .print-document-only { display: none; }

        /* --- MAGIC PRINT STYLES --- */
        @media print {
            /* 1. Setup Page and hide Web UI */
            @page { size: A4 portrait; margin: 1.5cm; }
            body { background-color: #ffffff !important; }
            .sidebar, .navbar, .d-print-none, .screen-kpi-cards, title { display: none !important; }
            
            /* 2. Expand content area to full width */
            .main-content { width: 100% !important; margin: 0 !important; padding: 0 !important; flex: none !important; background: white !important; }
            
            /* 3. Remove card borders and shadows */
            .card { border: none !important; box-shadow: none !important; }
            .card-header, .bg-light { background: transparent !important; border: none !important; }
            
            /* 4. Show the formal document headers */
            .print-document-only { display: block; }
            
            /* 5. Professional Table Formatting */
            .table-responsive { overflow: visible !important; }
            table { width: 100% !important; border-collapse: collapse !important; font-family: 'Segoe UI', Arial, sans-serif !important; font-size: 10pt !important; }
            th { border-bottom: 2px solid #000 !important; color: #000 !important; padding: 8px 4px !important; text-align: left !important; }
            td { border-bottom: 1px solid #ccc !important; color: #000 !important; padding: 8px 4px !important; }
            
            /* Override Bootstrap text colors for print */
            .text-success, .text-warning, .text-danger, .text-muted, .text-secondary, .badge { color: #000 !important; background: transparent !important; border: none !important; font-weight: normal !important; }
            .badge { padding: 0 !important; }
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container-fluid mt-4 px-4 w-100">
        
        <%-- ========================================== --%>
        <%-- SCREEN UI (Hidden during print)            --%>
        <%-- ========================================== --%>
        <div class="d-print-none d-flex justify-content-between align-items-center mb-4 pb-2 border-bottom">
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

        <div class="row g-4 mb-4 screen-kpi-cards d-print-none">
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

        <%-- ========================================== --%>
        <%-- PRINT DOCUMENT UI (Matches CEO Photo)      --%>
        <%-- ========================================== --%>
        <div class="print-document-only mb-4" style="font-family: Arial, sans-serif;">
            
            <div style="display: flex; justify-content: space-between; border-bottom: 2px solid #000; padding-bottom: 10px; margin-bottom: 20px;">
                <div>
                    <h3 style="margin: 0; font-weight: bold; font-size: 14pt;">INVENTORY & BILLING SYSTEM</h3>
                    <div style="font-size: 9pt; color: #555; margin-top: 5px;">Shop: All Shops</div>
                    <div style="font-size: 9pt; color: #555;">Generated On: <%= GeneratedDate %></div>
                </div>
                <div style="text-align: right; font-size: 9pt; color: #555; padding-top: 20px;">
                    Date Range: N/A to N/A
                </div>
            </div>

            <h2 style="margin: 0 0 30px 0; font-size: 16pt; font-weight: bold;">Stock Report</h2>

            <div style="display: flex; justify-content: space-between; margin-bottom: 30px; font-size: 10pt;">
                <div>Prepared By: __________________________</div>
                <div>Approved By: __________________________</div>
            </div>

            <div style="border: 1px solid #ccc; padding: 15px; margin-bottom: 30px; font-size: 10pt; line-height: 1.6;">
                <strong style="display: block; margin-bottom: 10px; text-transform: uppercase;">Report Summary</strong>
                <div>• Report Scope: All Shops</div>
                <div>• Category: All Categories</div>
                <div>• Generated On: <%= GeneratedDate %></div>
                <div>• Total Items Listed: <%= TotalItemsCount %></div>
                <div>• Total Physical Units: <%= TotalUnitsCount %></div>
                <div>• Total Stock Value: <%= TotalStockValue %></div>
            </div>
        </div>

        <%-- ========================================== --%>
        <%-- SHARED DATA GRID                           --%>
        <%-- ========================================== --%>
        <div class="card border border-light shadow-sm p-0 rounded-3 overflow-hidden bg-white">
            <div class="p-3 bg-light border-bottom d-flex justify-content-between align-items-center d-print-none">
                <span class="fw-bold text-dark small text-uppercase">Stock Breakdown by Category</span>
            </div>
            
            <div class="print-document-only mb-2" style="font-weight: bold; font-size: 11pt; text-transform: uppercase;">
                Stock Breakdown
            </div>

            <div class="table-responsive">
                <asp:GridView ID="gvInventoryReport" runat="server" AutoGenerateColumns="False" 
                    CssClass="table table-hover align-middle mb-0" 
                    GridLines="None" ShowHeaderWhenEmpty="True">
                    
                    <HeaderStyle CssClass="text-muted small fw-bold text-uppercase border-bottom" BackColor="#ffffff" Height="50px" />
                    <RowStyle Height="45px" CssClass="border-bottom border-light" />
                    
                    <Columns>
                        <asp:BoundField DataField="CategoryName" HeaderText="Category" ItemStyle-CssClass="fw-semibold text-secondary ps-2" />
                        <asp:BoundField DataField="SKU" HeaderText="SKU" ItemStyle-CssClass="text-muted small" />
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
                        <asp:BoundField DataField="TotalRetailValue" HeaderText="Total Retail Value" DataFormatString="Rs. {0:N2}" ItemStyle-CssClass="fw-bold text-warning pe-2" />
                    </Columns>
                    <EmptyDataTemplate>
                        <div class="text-center p-5 text-muted">No active inventory found.</div>
                    </EmptyDataTemplate>
                </asp:GridView>
            </div>
        </div>

    </div>
</asp:Content>