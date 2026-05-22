<%@ Page Title="Dashboard" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Dashboard.aspx.cs" Inherits="InventorySystem.Dashboard" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    
    <div class="d-flex justify-content-between align-items-center mb-4 pb-2 border-bottom">
        <h4 class="fw-normal mb-0">Dashboard Overview</h4>
        <div class="d-flex align-items-center text-muted small fw-bold text-uppercase">
            <span class="me-3">FRI 22 MAY 2026 • 09:41</span>
            <span class="badge bg-danger bg-opacity-10 text-danger border border-danger p-2 rounded-pill">
                <i class="bi bi-exclamation-triangle"></i> 4 Low Stock
            </span>
        </div>
    </div>

    <div class="row g-3 mb-4">
        <div class="col-md-3">
            <div class="card border border-light shadow-sm p-3 h-100 rounded-3">
                <div class="text-muted small text-uppercase fw-bold mb-2">Total Products</div>
                <h2 class="fw-bold mb-1">247</h2>
                <div class="text-success small fw-bold"><i class="bi bi-arrow-up"></i> 12 this month</div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="card border border-light shadow-sm p-3 h-100 rounded-3">
                <div class="text-muted small text-uppercase fw-bold mb-2">Stock In Today</div>
                <h2 class="fw-bold mb-1">1,840</h2>
                <div class="text-muted small">units received</div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="card border border-light shadow-sm p-3 h-100 rounded-3">
                <div class="text-muted small text-uppercase fw-bold mb-2">Stock Out Today</div>
                <h2 class="fw-bold mb-1">963</h2>
                <div class="text-danger small fw-bold"><i class="bi bi-arrow-down"></i> 18% vs yesterday</div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="card border border-light shadow-sm p-3 h-100 rounded-3">
                <div class="text-muted small text-uppercase fw-bold mb-2">Low Stock Alerts</div>
                <h2 class="fw-bold text-danger mb-1">4</h2>
                <div class="text-danger small">requires attention</div>
            </div>
        </div>
    </div>

    <div class="row g-3 mb-4">
        <div class="col-md-8">
            <div class="card border border-light shadow-sm p-4 h-100 rounded-3">
                <div class="d-flex justify-content-between mb-4">
                    <span class="text-muted small text-uppercase fw-bold">Weekly Stock Movement</span>
                    <span class="text-muted small text-uppercase fw-bold">Units</span>
                </div>
                
                <div class="flex-grow-1 d-flex flex-column justify-content-end" style="min-height: 200px;">
                    <div class="d-flex text-muted small text-uppercase" style="font-size: 0.7rem;">
                        <div class="flex-fill">Mon</div>
                        <div class="flex-fill">Tue</div>
                        <div class="flex-fill">Wed</div>
                        <div class="flex-fill">Thu</div>
                        <div class="flex-fill">Fri</div>
                    </div>
                </div>

                <div class="d-flex mt-3 small fw-bold">
                    <div class="me-4"><i class="bi bi-square-fill text-primary me-1"></i> Stock In</div>
                    <div><i class="bi bi-square-fill text-warning me-1"></i> Stock Out</div>
                </div>
            </div>
        </div>

        <div class="col-md-4">
            <div class="card border border-light shadow-sm p-4 h-100 rounded-3">
                <span class="text-muted small text-uppercase fw-bold mb-3">Low Stock Alerts</span>
                
                <div class="border-start border-danger border-3 p-2 mb-2 bg-white shadow-sm rounded d-flex justify-content-between align-items-center">
                    <div><div class="fw-bold small text-dark">M8 Hex</div><div class="small text-muted" style="font-size: 0.75rem;">Bolts 50mm</div></div>
                    <div class="text-end"><div class="fw-bold text-danger small">2 /</div><div class="text-muted" style="font-size: 0.7rem;">min 10</div></div>
                </div>

                <div class="border-start border-danger border-3 p-2 mb-2 bg-white shadow-sm rounded d-flex justify-content-between align-items-center">
                    <div><div class="fw-bold small text-dark">PVC Pipe</div><div class="small text-muted" style="font-size: 0.75rem;">1/2"</div></div>
                    <div class="text-end"><div class="fw-bold text-danger small">5 /</div><div class="text-muted" style="font-size: 0.7rem;">min 20</div></div>
                </div>

                <div class="border-start border-danger border-3 p-2 mb-2 bg-white shadow-sm rounded d-flex justify-content-between align-items-center">
                    <div><div class="fw-bold small text-dark">Cable Ties</div><div class="small text-muted" style="font-size: 0.75rem;">300mm</div></div>
                    <div class="text-end"><div class="fw-bold text-danger small">8 /</div><div class="text-muted" style="font-size: 0.7rem;">min 50</div></div>
                </div>

                <div class="border-start border-danger border-3 p-2 mb-0 bg-white shadow-sm rounded d-flex justify-content-between align-items-center">
                    <div><div class="fw-bold small text-dark">Safety</div><div class="small text-muted" style="font-size: 0.75rem;">Gloves L</div></div>
                    <div class="text-end"><div class="fw-bold text-danger small">3 /</div><div class="text-muted" style="font-size: 0.7rem;">min 15</div></div>
                </div>

            </div>
        </div>
    </div>

    <div class="card border border-light shadow-sm p-4 rounded-3">
        <span class="text-muted small text-uppercase fw-bold mb-3">Recent Transactions</span>
        <div class="table-responsive">
            <table class="table table-borderless table-hover align-middle mb-0" style="font-size: 0.85rem;">
                <thead class="text-muted small text-uppercase" style="border-bottom: 2px dashed #dee2e6;">
                    <tr>
                        <th class="py-2">Ref No</th>
                        <th class="py-2">Product</th>
                        <th class="py-2">Type</th>
                        <th class="py-2">Qty</th>
                        <th class="py-2">Balance</th>
                        <th class="py-2">By</th>
                        <th class="py-2 text-end">Time</th>
                    </tr>
                </thead>
                <tbody class="fw-bold text-secondary">
                    <tr style="border-bottom: 1px dashed #dee2e6;">
                        <td class="py-3">TXN-00891</td>
                        <td class="text-dark">Copper Wire 2.5mm</td>
                        <td><span class="badge bg-success bg-opacity-25 text-success px-2 py-1">IN</span></td>
                        <td class="text-dark">+500</td>
                        <td>1,248</td>
                        <td>staff01</td>
                        <td class="text-end">09:21</td>
                    </tr>
                    <tr style="border-bottom: 1px dashed #dee2e6;">
                        <td class="py-3">TXN-00890</td>
                        <td class="text-dark">M8 Hex Bolts 50mm</td>
                        <td><span class="badge bg-danger bg-opacity-25 text-danger px-2 py-1">OUT</span></td>
                        <td class="text-dark">-15</td>
                        <td>2</td>
                        <td>staff02</td>
                        <td class="text-end">08:55</td>
                    </tr>
                    <tr>
                        <td class="py-3">TXN-00889</td>
                        <td class="text-dark">Safety Helmet Yellow</td>
                        <td><span class="badge bg-success bg-opacity-25 text-success px-2 py-1">IN</span></td>
                        <td class="text-dark">+30</td>
                        <td>87</td>
                        <td>staff01</td>
                        <td class="text-end">08:30</td>
                    </tr>
                </tbody>
            </table>
        </div>
    </div>

</asp:Content>