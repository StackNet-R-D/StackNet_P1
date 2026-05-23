<%@ Page Title="Edit Product" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ProductEdit.aspx.cs" Inherits="InventorySystem.ProductEdit" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container-fluid mt-4 px-4" style="max-width: 900px;">
        
        <div class="card border border-light shadow-sm p-4 rounded-3 bg-white">
            
            <%-- Header Section --%>
            <div class="d-flex justify-content-between align-items-center mb-4 pb-3 border-bottom">
                <div>
                    <h5 class="fw-bold mb-1 text-dark">Edit Product</h5>
                    <span class="text-muted small fw-semibold">Products / Update Product</span>
                </div>
                <asp:LinkButton ID="btnBack" runat="server" CssClass="btn btn-light border btn-sm px-3 rounded-2 fw-bold text-dark" PostBackUrl="~/ProductList.aspx">
                    <i class="bi bi-arrow-left"></i> Back to List
                </asp:LinkButton>
            </div>

            <%-- Alert Messages --%>
            <asp:Panel ID="pnlMessage" runat="server" Visible="false" CssClass="alert alert-danger mb-4 rounded-2 small fw-semibold">
                <asp:Label ID="lblMessage" runat="server"></asp:Label>
            </asp:Panel>
            
            <asp:Panel ID="pnlSuccess" runat="server" Visible="false" CssClass="alert alert-success mb-4 rounded-2 small fw-semibold">
                Product updated successfully!
            </asp:Panel>

            <%-- Hidden Field to store Product ID --%>
            <asp:HiddenField ID="hfProductID" runat="server" />

            <%-- Form Section --%>
            <div class="row g-4">
                
                <%-- Left Column: Basic Info --%>
                <div class="col-md-7">
                    <h6 class="fw-bold text-dark mb-3">Basic Information</h6>
                    
                    <div class="mb-3">
                        <label class="form-label small fw-bold text-muted mb-1">Product Name <span class="text-danger">*</span></label>
                        <asp:TextBox ID="txtProductName" runat="server" CssClass="form-control form-control-sm border-secondary border-opacity-25 py-2" Required="true"></asp:TextBox>
                    </div>

                    <div class="row mb-3 g-3">
                        <div class="col-md-6">
                            <label class="form-label small fw-bold text-muted mb-1">Barcode / SKU <span class="text-danger">*</span></label>
                            <div class="input-group input-group-sm">
                                <span class="input-group-text bg-light border-secondary border-opacity-25"><i class="bi bi-upc-scan"></i></span>
                                <asp:TextBox ID="txtBarcode" runat="server" CssClass="form-control border-secondary border-opacity-25 py-2" Required="true"></asp:TextBox>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label small fw-bold text-muted mb-1">Category <span class="text-danger">*</span></label>
                            <asp:DropDownList ID="ddlCategory" runat="server" CssClass="form-select form-select-sm border-secondary border-opacity-25 py-2">
                            </asp:DropDownList>
                        </div>
                    </div>
                    
                    <div class="mb-3">
                        <label class="form-label small fw-bold text-muted mb-1">Status</label>
                        <asp:DropDownList ID="ddlStatus" runat="server" CssClass="form-select form-select-sm border-secondary border-opacity-25 py-2" style="width: 150px;">
                            <asp:ListItem Text="Active" Value="Active" />
                            <asp:ListItem Text="Inactive" Value="Inactive" />
                        </asp:DropDownList>
                    </div>
                </div>

                <%-- Right Column: Pricing & Inventory --%>
                <div class="col-md-5">
                    <div class="bg-light p-4 rounded-3 border border-secondary border-opacity-10">
                        <h6 class="fw-bold text-dark mb-3">Pricing & Inventory</h6>
                        
                        <div class="mb-3">
                            <label class="form-label small fw-bold text-muted mb-1">Cost Price (Rs.)</label>
                            <asp:TextBox ID="txtCostPrice" runat="server" CssClass="form-control form-control-sm border-secondary border-opacity-25 py-2" TextMode="Number" step="0.01"></asp:TextBox>
                        </div>
                        
                        <div class="mb-3">
                            <label class="form-label small fw-bold text-muted mb-1">Selling Price (Rs.) <span class="text-danger">*</span></label>
                            <asp:TextBox ID="txtSellingPrice" runat="server" CssClass="form-control form-control-sm border-secondary border-opacity-25 py-2" TextMode="Number" step="0.01" Required="true"></asp:TextBox>
                        </div>
                        
                        <hr class="border-secondary border-opacity-25 my-4" />
                        
                        <div class="row g-3">
                            <div class="col-6">
                                <label class="form-label small fw-bold text-muted mb-1">Current Qty</label>
                                <%-- Disabled because stock should only be changed via Stock In/Out transactions --%>
                                <asp:TextBox ID="txtCurrentQty" runat="server" CssClass="form-control form-control-sm border-secondary border-opacity-25 py-2 bg-white" Enabled="false"></asp:TextBox>
                            </div>
                            <div class="col-6">
                                <label class="form-label small fw-bold text-muted mb-1">Minimum Qty</label>
                                <asp:TextBox ID="txtMinQty" runat="server" CssClass="form-control form-control-sm border-secondary border-opacity-25 py-2" TextMode="Number"></asp:TextBox>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <%-- Action Buttons --%>
            <div class="d-flex justify-content-end gap-2 mt-5 pt-3 border-top">
                <asp:LinkButton ID="btnCancel" runat="server" CssClass="btn btn-light border px-4 py-2 rounded-2 fw-bold text-dark" PostBackUrl="~/ProductList.aspx">
                    Cancel
                </asp:LinkButton>
                <asp:LinkButton ID="btnUpdate" runat="server" CssClass="btn btn-primary px-4 py-2 rounded-2 fw-bold d-flex align-items-center gap-2" OnClick="btnUpdate_Click">
                    <i class="bi bi-save"></i> Save Changes
                </asp:LinkButton>
            </div>

        </div>
    </div>
</asp:Content>