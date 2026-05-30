<%@ Page Title="Stock Movement Report" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="StockMovementReport.aspx.cs" Inherits="InventorySystem.StockMovementReport" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        /* Hide formal document elements on screen */
        .print-document-only { display: none; }

        /* --- MAGIC PRINT STYLES --- */
        @media print {
            @page { size: A4 portrait; margin: 1.5cm; }
            body { background-color: #ffffff !important; }
            
            /* Hide the web UI elements */
            .sidebar, .navbar, .d-print-none, title, .filter-card { display: none !important; }
            
            /* Expand content to full page */
            .main-content { width: 100% !important; margin: 0 !important; padding: 0 !important; flex: none !important; background: white !important; }
            
            /* Remove web shadows and borders */
            .card { border: none !important; box-shadow: none !important; background: transparent !important; }
            
            /* Show the formal print headers */
            .print-document-only { display: block; }
            
            /* Clean Table Formatting for Printers */
            .table-responsive { overflow: visible !important; }
            table { width: 100% !important; border-collapse: collapse !important; font-family: 'Segoe UI', Arial, sans-serif !important; font-size: 9pt !important; }
            th { border-bottom: 2px solid #000 !important; color: #000 !important; padding: 8px 4px !important; text-align: left !important; }
            td { border-bottom: 1px solid #ccc !important; color: #000 !important; padding: 6px 4px !important; }
            
            /* Remove bootstrap colors for a clean B&W document */
            .badge { padding: 0 !important; font-weight: bold !important; color: #000 !important; background: transparent !important; border: none !important; }
            .text-success, .text-danger, .text-muted, .text-secondary { color: #000 !important; }
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container-fluid mt-4 px-4 w-100">
        
        <%-- ========================================== --%>
        <%-- SCREEN UI: Header (Hidden in Print)        --%>
        <%-- ========================================== --%>
        <div class="d-print-none d-flex justify-content-between align-items-center mb-4 pb-2 border-bottom">
            <div>
                <h4 class="fw-normal mb-1 text-dark">Stock Movement Report</h4>
                <div class="text-muted small">Reports / Transaction History</div>
            </div>
            <div>
                <button type="button" class="btn btn-outline-secondary btn-sm px-3 rounded-2 d-flex align-items-center gap-2" onclick="window.print()">
                    <i class="bi bi-printer"></i> Print Report
                </button>
            </div>
        </div>

        <%-- ========================================== --%>
        <%-- SCREEN UI: Filters (Hidden in Print)       --%>
        <%-- ========================================== --%>
        <div class="card filter-card border border-light shadow-sm p-3 mb-4 rounded-3 bg-white d-print-none">
            <div class="row g-3 align-items-end">
                <div class="col-md-3">
                    <label class="form-label small fw-bold text-muted text-uppercase mb-1">Start Date</label>
                    <asp:TextBox ID="txtStartDate" runat="server" CssClass="form-control form-control-sm" TextMode="Date"></asp:TextBox>
                </div>
                <div class="col-md-3">
                    <label class="form-label small fw-bold text-muted text-uppercase mb-1">End Date</label>
                    <asp:TextBox ID="txtEndDate" runat="server" CssClass="form-control form-control-sm" TextMode="Date"></asp:TextBox>
                </div>
                <div class="col-md-3">
                    <label class="form-label small fw-bold text-muted text-uppercase mb-1">Transaction Type</label>
                    <asp:DropDownList ID="ddlType" runat="server" CssClass="form-select form-select-sm">
                        <asp:ListItem Text="All Movements" Value="ALL" />
                        <asp:ListItem Text="Stock In Only" Value="IN" />
                        <asp:ListItem Text="Stock Out Only" Value="OUT" />
                    </asp:DropDownList>
                </div>
                <div class="col-md-3">
                    <asp:Button ID="btnFilter" runat="server" Text="Filter Records" CssClass="btn btn-primary btn-sm w-100 fw-bold" OnClick="btnFilter_Click" />
                </div>
            </div>
        </div>

        <%-- ========================================== --%>
        <%-- PRINT DOCUMENT UI (Formal Headers)         --%>
        <%-- ========================================== --%>
        <div class="print-document-only mb-4" style="font-family: Arial, sans-serif;">
            <div style="display: flex; justify-content: space-between; border-bottom: 2px solid #000; padding-bottom: 10px; margin-bottom: 20px;">
                <div>
                    <h3 style="margin: 0; font-weight: bold; font-size: 14pt;">INVENTORY & BILLING SYSTEM</h3>
                    <div style="font-size: 9pt; color: #555; margin-top: 5px;">Shop: All Shops</div>
                    <div style="font-size: 9pt; color: #555;">Generated On: <%= GeneratedDate %></div>
                </div>
                <div style="text-align: right; font-size: 9pt; color: #555; padding-top: 20px;">
                    Date Range: <%= PrintDateRange %>
                </div>
            </div>

            <h2 style="margin: 0 0 30px 0; font-size: 16pt; font-weight: bold;">Stock Movement Ledger</h2>

            <div style="display: flex; justify-content: space-between; margin-bottom: 20px; font-size: 10pt;">
                <div>Prepared By: __________________________</div>
                <div>Approved By: __________________________</div>
            </div>
        </div>

        <%-- ========================================== --%>
        <%-- SHARED DATA GRID                           --%>
        <%-- ========================================== --%>
        <div class="card border border-light shadow-sm p-0 rounded-3 overflow-hidden bg-white">
            <div class="p-3 bg-light border-bottom d-flex justify-content-between align-items-center d-print-none">
                <span class="fw-bold text-dark small text-uppercase">Transaction Records</span>
                <span class="badge bg-secondary"><asp:Label ID="lblRecordCount" runat="server" Text="0"></asp:Label> records</span>
            </div>

            <div class="table-responsive">
                <asp:GridView ID="gvMovementReport" runat="server" AutoGenerateColumns="False" 
                    CssClass="table table-hover align-middle mb-0" 
                    GridLines="None" ShowHeaderWhenEmpty="True">
                    
                    <HeaderStyle CssClass="text-muted small fw-bold text-uppercase border-bottom" BackColor="#ffffff" Height="50px" />
                    <RowStyle Height="45px" CssClass="border-bottom border-light" />
                    
                    <Columns>
                        <asp:BoundField DataField="TransactionTime" HeaderText="Date & Time" DataFormatString="{0:dd MMM yyyy HH:mm}" ItemStyle-CssClass="text-secondary small ps-3" />
                        <asp:BoundField DataField="ReferenceNo" HeaderText="Ref No" ItemStyle-CssClass="fw-semibold text-dark small" />
                        <asp:BoundField DataField="ProductName" HeaderText="Product Name" ItemStyle-CssClass="fw-bold text-dark" />
                        
                        <asp:TemplateField HeaderText="Type">
                            <ItemTemplate>
                                <span class='<%# Eval("TransactionType").ToString() == "IN" ? "badge bg-success bg-opacity-10 text-success border border-success border-opacity-25" : "badge bg-danger bg-opacity-10 text-danger border border-danger border-opacity-25" %>'>
                                    <%# Eval("TransactionType") %>
                                </span>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Qty">
                            <ItemTemplate>
                                <span class='<%# Eval("TransactionType").ToString() == "IN" ? "text-success fw-bold" : "text-danger fw-bold" %>'>
                                    <%# Eval("TransactionType").ToString() == "IN" ? "+" : "-" %><%# Eval("Quantity") %>
                                </span>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <%-- NEW REASON COLUMN FOR BUSINESS LOGIC --%>
                        <asp:TemplateField HeaderText="Reason / Context">
                            <ItemTemplate>
                                <span class="text-dark small">
                                    <%# Eval("Reason") != DBNull.Value && !string.IsNullOrEmpty(Eval("Reason").ToString()) ? Eval("Reason") : "<span class='text-muted'>Standard Operation</span>" %>
                                </span>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:BoundField DataField="BalanceQty" HeaderText="Balance" ItemStyle-CssClass="fw-bold text-dark" />
                        <asp:BoundField DataField="Username" HeaderText="Processed By" ItemStyle-CssClass="text-muted small pe-3" />
                    </Columns>
                    
                    <EmptyDataTemplate>
                        <div class="text-center p-5 text-muted">
                            <p class="mb-0">No transaction records found for the selected date range.</p>
                        </div>
                    </EmptyDataTemplate>
                </asp:GridView>
            </div>
        </div>

    </div>
</asp:Content>