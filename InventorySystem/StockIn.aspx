<%@ Page Title="Stock In Operation" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="StockIn.aspx.cs" Inherits="InventorySystem.StockIn" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container-fluid mt-4 px-4">
        
        <div class="d-flex justify-content-between align-items-center mb-4 pb-2 border-bottom">
            <div>
                <h4 class="fw-normal mb-1 text-dark">Stock In Receiving</h4>
                <div class="text-muted small">Inventory / Add Stock</div>
            </div>
        </div>

        <div class="row g-4">
            <%-- Left Panel: Scan and Entry --%>
            <div class="col-md-5">
                <div class="card border border-light shadow-sm p-4 rounded-3 bg-white">
                    <h6 class="fw-bold text-dark mb-3"><i class="bi bi-qr-code-scan me-2 text-primary"></i> Scan & Receive</h6>
                    <hr class="mt-0 mb-4 border-light" />

                    <asp:Panel ID="pnlMessage" runat="server" Visible="false" CssClass="alert alert-info mb-3 small fw-semibold">
                        <asp:Label ID="lblMessage" runat="server"></asp:Label>
                    </asp:Panel>

                    <div class="mb-3">
                        <label class="form-label small fw-bold text-muted text-uppercase mb-1">Barcode / SKU <span class="text-danger">*</span></label>
                        <div class="input-group">
                            <span class="input-group-text bg-white text-muted border-end-0"><i class="bi bi-search"></i></span>
                            <asp:TextBox ID="txtBarcode" runat="server" CssClass="form-control border-start-0 ps-0" placeholder="Scan barcode or type item code..." AutoPostBack="true" OnTextChanged="txtBarcode_TextChanged"></asp:TextBox>
                        </div>
                    </div>

                    <div class="mb-3">
                        <label class="form-label small fw-bold text-muted text-uppercase mb-1">Quantity to Add <span class="text-danger">*</span></label>
                        <asp:TextBox ID="txtQty" runat="server" CssClass="form-control" TextMode="Number" min="1" placeholder="Enter quantity"></asp:TextBox>
                    </div>

                    <div class="mb-3">
                        <label class="form-label small fw-bold text-muted text-uppercase mb-1">Receiving Reason <span class="text-danger">*</span></label>
                        <asp:DropDownList ID="ddlReason" runat="server" CssClass="form-select">
                            <asp:ListItem Text="Supplier Delivery (Purchase Order)" Value="Supplier Delivery" />
                            <asp:ListItem Text="Customer Return (Restock)" Value="Customer Return" />
                            <asp:ListItem Text="Stock Discovery (Audit Correction)" Value="Stock Discovery" />
                        </asp:DropDownList>
                    </div>

                    <div class="mb-4">
                        <label class="form-label small fw-bold text-muted text-uppercase mb-1">Reference No / PO No <span class="text-danger">*</span></label>
                        <asp:TextBox ID="txtReference" runat="server" CssClass="form-control" placeholder="e.g. PO-2026-0001"></asp:TextBox>
                    </div>

                    <asp:LinkButton ID="btnConfirm" runat="server" CssClass="btn btn-success w-100 fw-bold py-2 rounded-2 d-flex align-items-center justify-content-center gap-2" OnClick="btnConfirm_Click">
                        <i class="bi bi-box-arrow-down"></i> Confirm Receiving
                    </asp:LinkButton>
                </div>
            </div>

            <%-- Right Panel: Live Context Preview --%>
            <div class="col-md-7">
                <div class="card border border-light shadow-sm p-4 rounded-3 bg-white h-100">
                    <h6 class="fw-bold text-dark mb-3"><i class="bi bi-info-circle me-2 text-secondary"></i> Active Product Details</h6>
                    <hr class="mt-0 mb-4 border-light" />

                    <asp:Panel ID="pnlProductContext" runat="server" Visible="false">
                        <div class="row g-3">
                            <div class="col-6 mb-2">
                                <span class="text-muted d-block small text-uppercase fw-bold" style="font-size:0.7rem;">Product Name</span>
                                <asp:Label ID="lblContextName" runat="server" CssClass="fw-bold text-dark fs-5"></asp:Label>
                            </div>
                            <div class="col-6 mb-2">
                                <span class="text-muted d-block small text-uppercase fw-bold" style="font-size:0.7rem;">Current Stock Balance</span>
                                <asp:Label ID="lblContextCurrentQty" runat="server" CssClass="fw-bold fs-5 text-dark"></asp:Label>
                            </div>
                            <div class="col-6">
                                <span class="text-muted d-block small text-uppercase fw-bold" style="font-size:0.7rem;">Unit Cost Price</span>
                                <asp:Label ID="lblContextCost" runat="server" CssClass="fw-semibold text-secondary"></asp:Label>
                            </div>
                            <div class="col-6">
                                <span class="text-muted d-block small text-uppercase fw-bold" style="font-size:0.7rem;">Unit Retail Price</span>
                                <asp:Label ID="lblContextRetail" runat="server" CssClass="fw-semibold text-secondary"></asp:Label>
                            </div>
                        </div>
                    </asp:Panel>

                    <asp:PlaceHolder ID="phNoProduct" runat="server">
                        <div class="text-center py-5 text-muted my-auto">
                            <i class="bi bi-box-seam display-4 text-light mb-2 d-block"></i>
                            <p class="mb-0 small">Scan an item or enter an SKU code to verify physical inventory before receiving.</p>
                        </div>
                    </asp:PlaceHolder>
                </div>
            </div>
        </div>

    </div>

    <%-- Re-focus input field automatically for rapid hand-held barcode scanning workflows --%>
    <script type="text/javascript">
        document.addEventListener("DOMContentLoaded", function () {
            var input = document.getElementById('<%= txtBarcode.ClientID %>');
            if (input) input.focus();
        });
    </script>
</asp:Content>