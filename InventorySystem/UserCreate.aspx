<%@ Page Title="Add User" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="UserCreate.aspx.cs" Inherits="InventorySystem.UserCreate" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container-fluid mt-4 px-4" style="max-width: 600px;">

        <div class="card border border-light shadow-sm p-4 rounded-3 bg-white">

            <div class="d-flex justify-content-between align-items-center mb-4 pb-3 border-bottom">
                <div>
                    <h5 class="fw-bold mb-1 text-dark">Add New User</h5>
                    <span class="text-muted small fw-semibold">Admin / Create User</span>
                </div>
                <asp:LinkButton ID="btnBack" runat="server" CssClass="btn btn-light border btn-sm px-3 rounded-2 fw-bold text-dark" PostBackUrl="~/UserList.aspx">
                    <i class="bi bi-arrow-left"></i> Back to List
                </asp:LinkButton>
            </div>

            <asp:Panel ID="pnlMessage" runat="server" Visible="false" CssClass="alert alert-danger mb-4 rounded-2 small fw-semibold">
                <asp:Label ID="lblMessage" runat="server"></asp:Label>
            </asp:Panel>

            <div class="mb-3">
                <label class="form-label small fw-bold text-muted mb-1">Full Name <span class="text-danger">*</span></label>
                <asp:TextBox ID="txtFullName" runat="server" CssClass="form-control border-secondary border-opacity-25 py-2" Required="true" placeholder="e.g. John Doe"></asp:TextBox>
            </div>

            <div class="mb-3">
                <label class="form-label small fw-bold text-muted mb-1">Username <span class="text-danger">*</span></label>
                <asp:TextBox ID="txtUsername" runat="server" CssClass="form-control border-secondary border-opacity-25 py-2" Required="true" placeholder="johndoe"></asp:TextBox>
            </div>

            <div class="mb-4">
                <label class="form-label small fw-bold text-muted mb-1">Password <span class="text-danger">*</span></label>
                <asp:TextBox ID="txtPassword" runat="server" CssClass="form-control border-secondary border-opacity-25 py-2" TextMode="Password" Required="true"></asp:TextBox>
            </div>

            <div class="row g-3 mb-4">
                <div class="col-md-6">
                    <label class="form-label small fw-bold text-muted mb-1">System Role <span class="text-danger">*</span></label>
                    <asp:DropDownList ID="ddlRole" runat="server" CssClass="form-select border-secondary border-opacity-25 py-2">
                    </asp:DropDownList>
                </div>
                <div class="col-md-6">
                    <label class="form-label small fw-bold text-muted mb-1">Account Status</label>
                    <asp:DropDownList ID="ddlStatus" runat="server" CssClass="form-select border-secondary border-opacity-25 py-2">
                        <asp:ListItem Text="Active" Value="Active" />
                        <asp:ListItem Text="Inactive" Value="Inactive" />
                    </asp:DropDownList>
                </div>
            </div>

            <div class="d-flex justify-content-end gap-2 pt-3 border-top">
                <asp:LinkButton ID="btnCancel" runat="server" CssClass="btn btn-light border px-4 py-2 rounded-2 fw-bold text-dark" PostBackUrl="~/UserList.aspx">
                    Cancel
                </asp:LinkButton>
                <asp:LinkButton ID="btnSave" runat="server" CssClass="btn btn-primary px-4 py-2 rounded-2 fw-bold d-flex align-items-center gap-2" OnClick="btnSave_Click">
                    <i class="bi bi-person-check"></i> Save User
                </asp:LinkButton>
            </div>

        </div>
    </div>
</asp:Content>