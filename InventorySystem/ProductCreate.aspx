<%@ Page Title="Add Product" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ProductCreate.aspx.cs" Inherits="InventorySystem.ProductCreate" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container mt-4">
        <h4>Add New Product</h4>
        <div class="card p-4 shadow-sm border-0">
            <div class="row g-3">
                <div class="col-md-6">
                    <label class="form-label">Product Name</label>
                    <asp:TextBox ID="txtProductName" runat="server" CssClass="form-control" />
                </div>
                <div class="col-md-6">
                    <label class="form-label">Barcode</label>
                    <asp:TextBox ID="txtBarcode" runat="server" CssClass="form-control" />
                </div>
                <div class="col-md-4">
                    <label class="form-label">Category ID</label>
                    <asp:TextBox ID="txtCatId" runat="server" CssClass="form-control" />
                </div>
                <div class="col-md-4">
                    <label class="form-label">Cost Price</label>
                    <asp:TextBox ID="txtCostPrice" runat="server" CssClass="form-control" />
                </div>
                <div class="col-md-4">
                    <label class="form-label">Sell Price</label>
                    <asp:TextBox ID="txtSellPrice" runat="server" CssClass="form-control" />
                </div>
                <div class="col-md-4">
                    <label class="form-label">Min Qty</label>
                    <asp:TextBox ID="txtMinQty" runat="server" CssClass="form-control" />
                </div>
                <div class="col-12 mt-3">
                    <asp:Button ID="btnSave" runat="server" Text="Save Product" CssClass="btn btn-primary" OnClick="btnSave_Click" />
                </div>
            </div>
        </div>
    </div>
</asp:Content>