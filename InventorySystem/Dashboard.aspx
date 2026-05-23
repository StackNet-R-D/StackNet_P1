<%@ Page Title="Dashboard" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Dashboard.aspx.cs" Inherits="InventorySystem.Dashboard" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container-fluid mt-4 px-4">
        
        <%-- Header --%>
        <div class="d-flex justify-content-between align-items-center mb-4 pb-2 border-bottom">
            <h4 class="fw-normal mb-0 text-dark">Dashboard Overview</h4>
            <div class="d-flex align-items-center gap-3">
                <span class="text-muted small fw-bold text-uppercase"><%= DateTime.Now.ToString("ddd dd MMM yyyy • HH:mm") %></span>
                <asp:Panel ID="pnlTopLowStockAlert" runat="server" CssClass="badge bg-danger bg-opacity-10 text-danger border border-danger border-opacity-25 px-3 py-2 d-flex align-items-center gap-2">
                    <i class="bi bi-exclamation-triangle-fill"></i>
                    <asp:Label ID="lblTopLowStockCount" runat="server" Text="0"></asp:Label> Low Stock
                </asp:Panel>
            </div>
        </div>

        <%-- Row 1: KPI Cards --%>
        <div class="row g-4 mb-4">
            <div class="col-md-3">
                <div class="card border border-light shadow-sm p-3 rounded-3 h-100 bg-white">
                    <div class="text-muted small fw-bold text-uppercase mb-2">Total Products</div>
                    <h2 class="fw-bold text-dark mb-1"><asp:Label ID="lblTotalProducts" runat="server" Text="0"></asp:Label></h2>
                    <div class="text-success small fw-semibold"><i class="bi bi-arrow-up-short"></i> Active items</div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card border border-light shadow-sm p-3 rounded-3 h-100 bg-white">
                    <div class="text-muted small fw-bold text-uppercase mb-2">Stock In Today</div>
                    <h2 class="fw-bold text-dark mb-1"><asp:Label ID="lblStockInToday" runat="server" Text="0"></asp:Label></h2>
                    <div class="text-muted small">units received</div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card border border-light shadow-sm p-3 rounded-3 h-100 bg-white">
                    <div class="text-muted small fw-bold text-uppercase mb-2">Stock Out Today</div>
                    <h2 class="fw-bold text-dark mb-1"><asp:Label ID="lblStockOutToday" runat="server" Text="0"></asp:Label></h2>
                    <div class="text-muted small">units dispatched</div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card border border-light shadow-sm p-3 rounded-3 h-100 bg-white">
                    <div class="text-muted small fw-bold text-uppercase mb-2">Low Stock Alerts</div>
                    <h2 class="fw-bold text-danger mb-1"><asp:Label ID="lblLowStockAlerts" runat="server" Text="0"></asp:Label></h2>
                    <div class="text-danger small">requires attention</div>
                </div>
            </div>
        </div>

        <%-- Row 2: Chart & Low Stock List --%>
        <div class="row g-4 mb-4">
            <div class="col-lg-8">
                <div class="card border border-light shadow-sm p-4 rounded-3 h-100 bg-white">
                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <div class="text-muted small fw-bold text-uppercase">Weekly Stock Movement</div>
                        <div class="text-muted small fw-bold text-uppercase">Units</div>
                    </div>
                    <asp:HiddenField ID="hfChartLabels" runat="server" />
                    <asp:HiddenField ID="hfChartDataIn" runat="server" />
                    <asp:HiddenField ID="hfChartDataOut" runat="server" />
                    <div style="height: 300px;">
                        <canvas id="movementChart"></canvas>
                    </div>
                </div>
            </div>

            <div class="col-lg-4">
                <div class="card border border-light shadow-sm p-4 rounded-3 h-100 bg-white">
                    <%-- ADDED: View All Link to Low Stock Report --%>
                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <div class="text-muted small fw-bold text-uppercase">Low Stock Alerts</div>
                        <a href="LowStockReport.aspx" class="btn btn-sm btn-light text-danger fw-bold border py-0 px-2 rounded-2" style="font-size: 0.75rem;">View All</a>
                    </div>
                    
                    <div class="d-flex flex-column gap-2">
                        <asp:ListView ID="rptLowStockList" runat="server">
                            <ItemTemplate>
                                <div class="p-3 rounded-3 mb-2" style="background-color: #fff8f8; border-left: 4px solid #dc3545;">
                                    <div class="d-flex justify-content-between align-items-start">
                                        <div>
                                            <div class="fw-bold text-dark" style="font-size: 0.9rem;"><%# Eval("ProductName") %></div>
                                            <div class="text-muted" style="font-size: 0.75rem;"><%# Eval("CategoryName") %> • Min: <%# Eval("MinimumQty") %></div>
                                        </div>
                                        <div class="text-end">
                                            <div class="fw-bold text-danger"><%# Eval("CurrentQty") %> <span class="text-muted fw-normal">/</span></div>
                                        </div>
                                    </div>
                                </div>
                            </ItemTemplate>
                            <EmptyDataTemplate>
                                <div class="text-center text-muted p-4">
                                    <i class="bi bi-check-circle fs-3 text-success d-block mb-2"></i>
                                    All stock levels look good!
                                </div>
                            </EmptyDataTemplate>
                        </asp:ListView>
                    </div>
                </div>
            </div>
        </div>

        <%-- Row 3: Recent Transactions --%>
        <div class="card border border-light shadow-sm p-4 rounded-3 mb-4 bg-white">
            <%-- ADDED: View All Link to Stock Movement Report --%>
            <div class="d-flex justify-content-between align-items-center mb-4">
                <div class="text-muted small fw-bold text-uppercase">Recent Transactions</div>
                <a href="StockMovementReport.aspx" class="btn btn-sm btn-light text-primary fw-bold border py-0 px-2 rounded-2" style="font-size: 0.75rem;">View All</a>
            </div>

            <div class="table-responsive">
                <asp:GridView ID="gvRecentTransactions" runat="server" AutoGenerateColumns="False" 
                    CssClass="table table-borderless align-middle mb-0" 
                    GridLines="None" ShowHeaderWhenEmpty="True">
                    
                    <HeaderStyle CssClass="text-muted small fw-bold text-uppercase border-bottom" BackColor="#ffffff" Height="40px" />
                    <RowStyle Height="50px" CssClass="border-bottom border-light" />
                    
                    <Columns>
                        <asp:BoundField DataField="ReferenceNo" HeaderText="Ref No" ItemStyle-CssClass="fw-semibold text-dark small" />
                        <asp:BoundField DataField="ProductName" HeaderText="Product" ItemStyle-CssClass="fw-bold text-dark" />
                        
                        <asp:TemplateField HeaderText="Type">
                            <ItemTemplate>
                                <span class='<%# Eval("TransactionType").ToString() == "IN" ? "badge bg-success bg-opacity-10 text-success" : "badge bg-danger bg-opacity-10 text-danger" %>'>
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

                        <asp:BoundField DataField="BalanceQty" HeaderText="Balance" ItemStyle-CssClass="text-dark fw-bold" />
                        <asp:BoundField DataField="Username" HeaderText="By" ItemStyle-CssClass="text-muted small fw-semibold" />
                        <asp:BoundField DataField="TransactionTime" HeaderText="Time" DataFormatString="{0:dd MMM HH:mm}" ItemStyle-CssClass="text-muted small" />
                    </Columns>
                    <EmptyDataTemplate>
                        <div class="text-center text-muted p-4">No recent transactions.</div>
                    </EmptyDataTemplate>
                </asp:GridView>
            </div>
        </div>

    </div>

    <script>
        document.addEventListener("DOMContentLoaded", function () {
            const labelsStr = document.getElementById('<%= hfChartLabels.ClientID %>').value;
            const dataInStr = document.getElementById('<%= hfChartDataIn.ClientID %>').value;
            const dataOutStr = document.getElementById('<%= hfChartDataOut.ClientID %>').value;

            if (labelsStr) {
                const labels = labelsStr.split(',');
                const dataIn = dataInStr.split(',').map(Number);
                const dataOut = dataOutStr.split(',').map(Number);

                const ctx = document.getElementById('movementChart').getContext('2d');
                new Chart(ctx, {
                    type: 'bar',
                    data: {
                        labels: labels,
                        datasets: [
                            {
                                label: 'Stock In',
                                data: dataIn,
                                backgroundColor: '#0d6efd',
                                borderRadius: 4
                            },
                            {
                                label: 'Stock Out',
                                data: dataOut,
                                backgroundColor: '#ffc107',
                                borderRadius: 4
                            }
                        ]
                    },
                    options: {
                        responsive: true,
                        maintainAspectRatio: false,
                        plugins: {
                            legend: { position: 'bottom', align: 'start' }
                        },
                        scales: {
                            y: { beginAtZero: true, grid: { borderDash: [2, 4], color: '#f0f0f0' } },
                            x: { grid: { display: false } }
                        }
                    }
                });
            }
        });
    </script>
</asp:Content>