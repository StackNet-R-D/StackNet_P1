<%@ Page Title="Edit User" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="UserEdit.aspx.cs" Inherits="InventorySystem.UserEdit" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container-fluid mt-4 px-4" style="max-width: 600px;">

        <div class="card border border-light shadow-sm p-4 rounded-3 bg-white">

            <div class="d-flex justify-content-between align-items-center mb-4 pb-3 border-bottom">
                <div>
                    <h5 class="fw-bold mb-1 text-dark">Edit User Account</h5>
                    <span class="text-muted small fw-semibold">Admin / Update User</span>
                </div>
                <asp:LinkButton ID="btnBack" runat="server" CssClass="btn btn-light border btn-sm px-3 rounded-2 fw-bold text-dark" PostBackUrl="~/UserList.aspx">
                    <i class="bi bi-arrow-left"></i> Back to List
                </asp:LinkButton>
            </div>

            <asp:Panel ID="pnlMessage" runat="server" Visible="false" CssClass="alert alert-danger mb-4 rounded-2 small fw-semibold">
                <asp:Label ID="lblMessage" runat="server"></asp:Label>
            </asp:Panel>
            
            <asp:Panel ID="pnlSuccess" runat="server" Visible="false" CssClass="alert alert-success mb-4 rounded-2 small fw-semibold">
                <i class="bi bi-check-circle-fill me-2"></i> User account updated successfully!
            </asp:Panel>

            <asp:HiddenField ID="hfUserID" runat="server" />

            <div class="mb-3">
                <label class="form-label small fw-bold text-muted mb-1">Full Name <span class="text-danger">*</span></label>
                <asp:TextBox ID="txtFullName" runat="server" CssClass="form-control border-secondary border-opacity-25 py-2" Required="true"></asp:TextBox>
            </div>

            <div class="mb-3">
                <label class="form-label small fw-bold text-muted mb-1">Username <span class="text-danger">*</span></label>
                <asp:TextBox ID="txtUsername" runat="server" CssClass="form-control border-secondary border-opacity-25 py-2" Required="true"></asp:TextBox>
            </div>

            <div class="mb-4 p-3 rounded-3" style="background-color: #f8f9fa; border: 1px solid #dee2e6;">
                <label class="form-label small fw-bold text-muted mb-1">Reset Password (Optional)</label>
                <asp:TextBox ID="txtPassword" runat="server" CssClass="form-control border-secondary border-opacity-25 py-2" TextMode="Password" placeholder="Leave blank to keep current password"></asp:TextBox>
                <div class="form-text mt-1" style="font-size: 0.75rem;">Only fill this out if the user needs their password reset.</div>
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
                <asp:LinkButton ID="btnUpdate" runat="server" CssClass="btn btn-primary px-4 py-2 rounded-2 fw-bold d-flex align-items-center gap-2" OnClick="btnUpdate_Click">
                    <i class="bi bi-save"></i> Save Changes
                </asp:LinkButton>
            </div>

        </div>
    </div>
</asp:Content>