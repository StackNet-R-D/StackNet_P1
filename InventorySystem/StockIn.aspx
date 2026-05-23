<%@ Page Title="Stock In" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="StockIn.aspx.cs" Inherits="InventorySystem.StockIn" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    
    <div class="d-flex justify-content-between align-items-end mb-4 pb-3 border-bottom">
        <div>
            <h4 class="fw-normal mb-1">Stock In</h4>
            <div class="text-muted small">Inventory / Stock In</div>
        </div>
        <div class="text-muted small fw-bold text-uppercase">
            <asp:Label ID="lblTransactionRef" runat="server" Text="REF: Pending..."></asp:Label>
        </div>
    </div>

    <div class="row g-4">
        
        <div class="col-lg-7">
            <div class="card border border-light shadow-sm p-4 rounded-3 h-100 bg-white">
                
                <div class="d-flex align-items-center mb-4">
                    <div class="bg-primary bg-opacity-10 text-primary p-2 rounded-3 me-3">
                        <i class="bi bi-box-seam fs-5"></i>
                    </div>
                    <div>
                        <h6 class="mb-0 fw-bold">Manual Product Selection</h6>
                        <small class="text-muted">Choose an item from the database</small>
                    </div>
                </div>

                <div class="rounded-3 p-3 mb-4 bg-primary bg-opacity-10 d-flex align-items-center justify-content-between" style="border: 2px dashed #0d6efd;">
                    <div class="d-flex align-items-center">
                        <div class="bg-primary text-white p-2 rounded-3 me-3">
                            <i class="bi bi-box-seam fs-5"></i>
                        </div>
                        <div>
                            <div class="fw-bold small text-dark">Select Product</div>
                            <div class="text-muted" style="font-size: 0.75rem;">Manually choose an item</div>
                        </div>
                    </div>
                    <div style="width: 250px;">
                        <asp:DropDownList ID="ddlProduct" runat="server" CssClass="form-select fw-bold border-0 shadow-sm" AutoPostBack="true" OnSelectedIndexChanged="ddlProduct_SelectedIndexChanged">
                        </asp:DropDownList>
                    </div>
                </div>

                <div class="bg-light rounded-3 p-3 mb-4 border">
                    <div class="text-muted small fw-bold text-uppercase mb-3">Product Details</div>
                    <table class="table table-sm table-borderless mb-0 small">
                        <tr>
                            <td class="text-muted pb-2">Name</td>
                            <td class="text-end pb-2">
                                <asp:Label ID="lblProductName" runat="server" CssClass="fw-bold text-dark" Text="-"></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td class="text-muted pb-2">SKU / Barcode</td>
                            <td class="text-end pb-2">
                                <asp:Label ID="lblSKU" runat="server" CssClass="fw-bold text-dark" Text="-"></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td class="text-muted pb-2">Category</td>
                            <td class="text-end pb-2">
                                <asp:Label ID="lblCategory" runat="server" CssClass="fw-bold text-dark" Text="-"></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td class="text-muted pb-2">Current Stock</td>
                            <td class="text-end pb-2">
                                <asp:Label ID="lblCurrentStock" runat="server" CssClass="fw-bold text-danger" Text="0 units"></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td class="text-muted">Minimum Qty</td>
                            <td class="text-end">
                                <asp:Label ID="lblMinQty" runat="server" CssClass="fw-bold text-dark" Text="0 units"></asp:Label>
                            </td>
                        </tr>
                    </table>
                </div>

                <div class="row g-3 mb-3">
                    <div class="col-md-5">
                        <label class="form-label text-muted small fw-bold text-uppercase">Quantity To Add</label>
                        <asp:TextBox ID="txtQuantity" runat="server" CssClass="form-control fw-bold" TextMode="Number" AutoPostBack="true" OnTextChanged="txtQuantity_TextChanged"></asp:TextBox>
                    </div>
                    <div class="col-md-7">
                        <label class="form-label text-muted small fw-bold text-uppercase">Reference No.</label>
                        <asp:TextBox ID="txtReference" runat="server" CssClass="form-control" placeholder="e.g. PO-2026-0085"></asp:TextBox>
                    </div>
                </div>

                <div class="mb-4">
                    <label class="form-label text-muted small fw-bold text-uppercase">Notes (Optional)</label>
                    <asp:TextBox ID="txtNotes" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="3" placeholder="Supplier delivery batch, GRN ref..."></asp:TextBox>
                </div>

                <div class="bg-light rounded-3 p-3 mb-4 border">
                    <div class="d-flex justify-content-between mb-2 small">
                        <span class="text-muted">Current stock</span>
                        <asp:Label ID="lblSummaryCurrent" runat="server" CssClass="fw-bold text-dark" Text="0"></asp:Label>
                    </div>
                    <div class="d-flex justify-content-between mb-2 small pb-2 border-bottom">
                        <span class="text-muted">Adding</span>
                        <asp:Label ID="lblSummaryAdding" runat="server" CssClass="fw-bold text-primary" Text="+ 0"></asp:Label>
                    </div>
                    <div class="d-flex justify-content-between mt-2">
                        <span class="text-muted small">New balance</span>
                        <asp:Label ID="lblSummaryNew" runat="server" CssClass="fw-bold text-success" Text="= 0 units"></asp:Label>
                    </div>
                </div>

                <div class="d-flex gap-3">
                    <asp:Button ID="btnClear" runat="server" Text="Clear" CssClass="btn btn-outline-secondary w-50 py-2 rounded-3 fw-bold" OnClick="btnClear_Click" />
                    <asp:LinkButton ID="btnConfirm" runat="server" CssClass="btn btn-outline-dark w-50 py-2 rounded-3 fw-bold d-flex align-items-center justify-content-center gap-2" OnClick="btnConfirm_Click">
                        <i class="bi bi-check2"></i> Confirm Stock In
                    </asp:LinkButton>
                </div>
            </div>
        </div>

        <div class="col-lg-5">
            <div class="card border border-light shadow-sm p-4 rounded-3 h-100 bg-white">
                
                <div class="d-flex align-items-center mb-4 pb-3 border-bottom">
                    <div class="bg-success bg-opacity-10 text-success p-2 rounded-3 me-3">
                        <i class="bi bi-clock-history fs-5"></i>
                    </div>
                    <div>
                        <h6 class="mb-0 fw-bold">Today's Stock In</h6>
                        <asp:Label ID="lblTransactionCount" runat="server" CssClass="text-muted small" Text="0 transactions so far"></asp:Label>
                    </div>
                </div>

                <div class="d-flex flex-column gap-3">
                    <asp:ListView ID="rptRecentTransactions" runat="server">
                        <LayoutTemplate>
                            <asp:PlaceHolder ID="itemPlaceholder" runat="server" />
                        </LayoutTemplate>

                        <ItemTemplate>
                            <div class="d-flex justify-content-between align-items-center border-bottom pb-3 mb-3">
                                <div>
                                    <div class="fw-bold text-dark" style="font-size: 0.9rem;"><%# Eval("ProductName") %></div>
                                    <div class="text-muted" style="font-size: 0.75rem;"><%# Eval("ReferenceNo") %></div>
                                </div>
                                <div class="text-end">
                                    <div class="fw-bold text-success small">+<%# Eval("Quantity") %></div>
                                    <div class="text-muted" style="font-size: 0.75rem;"><%# Eval("TransactionTime", "{0:HH:mm}") %></div>
                                </div>
                            </div>
                        </ItemTemplate>

                        <EmptyDataTemplate>
                            <div class="text-center text-muted p-4">
                                <i class="bi bi-inbox fs-3 d-block mb-2" style="color: #dee2e6;"></i>
                                No stock in transactions recorded today.
                            </div>
                        </EmptyDataTemplate>
                    </asp:ListView>
                </div>

            </div>
        </div>

    </div>

</asp:Content>