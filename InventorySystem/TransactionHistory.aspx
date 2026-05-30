<%@ Page Title="Transaction Logs" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="TransactionHistory.aspx.cs" Inherits="InventorySystem.TransactionHistory" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container-fluid mt-4 px-4">
        
        <div class="d-flex justify-content-between align-items-center mb-4 pb-2 border-bottom">
            <div>
                <h4 class="fw-normal mb-1 text-dark">Transaction Logs</h4>
                <div class="text-muted small">Inventory / Recent Movements</div>
            </div>
        </div>

        <div class="card border border-light shadow-sm p-3 mb-4 rounded-3 bg-white">
            <div class="row g-2 align-items-center">
                <div class="col-md-6">
                    <div class="input-group input-group-sm">
                        <span class="input-group-text bg-white text-muted border-end-0"><i class="bi bi-search"></i></span>
                        <asp:TextBox ID="txtSearch" runat="server" CssClass="form-control border-start-0 ps-0" 
                            placeholder="Search by Reference No, Reason or Product Name..." AutoPostBack="true" OnTextChanged="btnSearch_Click"></asp:TextBox>
                        <asp:Button ID="btnSearch" runat="server" Text="Search Logs" CssClass="btn btn-light border fw-bold" OnClick="btnSearch_Click" />
                    </div>
                </div>
                <div class="col-md-6 text-end text-muted small">
                    Displaying trailing 100 system operations ledger entries
                </div>
            </div>
        </div>

        <div class="card border border-light shadow-sm p-0 rounded-3 overflow-hidden bg-white">
            <div class="table-responsive">
                <asp:GridView ID="gvHistory" runat="server" AutoGenerateColumns="False" 
                    CssClass="table table-hover align-middle mb-0" 
                    GridLines="None" ShowHeaderWhenEmpty="True">
                    
                    <HeaderStyle CssClass="text-muted small fw-bold text-uppercase border-bottom" BackColor="#f8f9fa" Height="50px" />
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

                        <asp:TemplateField HeaderText="Context / Reason">
                            <ItemTemplate>
                                <span class="text-dark fw-semibold small">
                                    <%# Eval("Reason") != DBNull.Value && !string.IsNullOrEmpty(Eval("Reason").ToString()) ? Eval("Reason") : "<span class='text-muted fw-normal'>Supplier Intake</span>" %>
                                </span>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:BoundField DataField="Username" HeaderText="Processed By" ItemStyle-CssClass="text-muted small pe-3" />
                    </Columns>
                    
                    <EmptyDataTemplate>
                        <div class="text-center p-5 text-muted">
                            <p class="mb-0">No matching log data recorded inside target window filter limits.</p>
                        </div>
                    </EmptyDataTemplate>
                </asp:GridView>
            </div>
        </div>

    </div>
</asp:Content>