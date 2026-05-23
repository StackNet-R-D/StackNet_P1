<%@ Page Title="Stock Movement Report" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="StockMovementReport.aspx.cs" Inherits="InventorySystem.StockMovementReport" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container-fluid mt-4 px-4">
        
        <%-- Header Section --%>
        <div class="d-flex justify-content-between align-items-center mb-4 pb-2 border-bottom">
            <div>
                <h4 class="fw-normal mb-1 text-dark">Stock Movement Report</h4>
                <div class="text-muted small">Reports / Transaction History</div>
            </div>
            <div class="d-flex gap-2">
                <button type="button" class="btn btn-outline-secondary btn-sm px-3 rounded-2 d-flex align-items-center gap-2" onclick="window.print()">
                    <i class="bi bi-printer"></i> Print Report
                </button>
            </div>
        </div>

        <%-- Filters Section --%>
        <div class="card border border-light shadow-sm p-3 mb-4 rounded-3 bg-white d-print-none">
            <div class="row g-3 align-items-end">
                <div class="col-md-3">
                    <label class="form-label text-muted small fw-bold text-uppercase mb-1">Start Date</label>
                    <asp:TextBox ID="txtStartDate" runat="server" CssClass="form-control form-control-sm" TextMode="Date"></asp:TextBox>
                </div>
                <div class="col-md-3">
                    <label class="form-label text-muted small fw-bold text-uppercase mb-1">End Date</label>
                    <asp:TextBox ID="txtEndDate" runat="server" CssClass="form-control form-control-sm" TextMode="Date"></asp:TextBox>
                </div>
                <div class="col-md-3">
                    <label class="form-label text-muted small fw-bold text-uppercase mb-1">Transaction Type</label>
                    <asp:DropDownList ID="ddlType" runat="server" CssClass="form-select form-select-sm" AutoPostBack="true" OnSelectedIndexChanged="ddlType_SelectedIndexChanged">
                        <asp:ListItem Text="All Movements" Value="ALL" />
                        <asp:ListItem Text="Stock In Only" Value="IN" />
                        <asp:ListItem Text="Stock Out Only" Value="OUT" />
                    </asp:DropDownList>
                </div>
                <div class="col-md-3">
                    <asp:LinkButton ID="btnGenerate" runat="server" CssClass="btn btn-primary btn-sm w-100 fw-bold" OnClick="btnGenerate_Click">
                        <i class="bi bi-filter"></i> Apply Filters
                    </asp:LinkButton>
                </div>
            </div>
        </div>

        <%-- Report Grid Section --%>
        <div class="card border border-light shadow-sm p-0 rounded-3 overflow-hidden bg-white">
            <div class="p-3 bg-light border-bottom d-flex justify-content-between align-items-center">
                <span class="fw-bold text-dark small text-uppercase">Transaction Records</span>
                <asp:Label ID="lblRecordCount" runat="server" CssClass="badge bg-secondary rounded-pill text-white" Text="0 records"></asp:Label>
            </div>
            
            <div class="table-responsive">
                <asp:GridView ID="gvMovementReport" runat="server" AutoGenerateColumns="False" 
                    CssClass="table table-hover align-middle mb-0" 
                    GridLines="None" ShowHeaderWhenEmpty="True">
                    
                    <HeaderStyle CssClass="text-muted small fw-bold text-uppercase border-bottom" BackColor="#ffffff" Height="50px" />
                    <RowStyle Height="50px" CssClass="border-bottom border-light" />
                    
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

                        <asp:BoundField DataField="BalanceQty" HeaderText="Stock Balance" ItemStyle-CssClass="text-dark fw-bold" />
                        <asp:BoundField DataField="Username" HeaderText="Processed By" ItemStyle-CssClass="text-muted small pe-3" />
                    </Columns>
                    
                    <EmptyDataTemplate>
                        <div class="text-center p-5 text-muted">
                            <i class="bi bi-search display-4 text-light mb-3 d-block"></i>
                            <p class="mb-0">No transactions found for the selected date range.</p>
                        </div>
                    </EmptyDataTemplate>
                </asp:GridView>
            </div>
        </div>

    </div>
</asp:Content>