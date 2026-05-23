<%@ Page Title="System Settings" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Settings.aspx.cs" Inherits="InventorySystem.Settings" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container-fluid mt-4 px-4" style="max-width: 800px;">
        
        <div class="d-flex justify-content-between align-items-center mb-4 pb-2 border-bottom">
            <div>
                <h4 class="fw-normal mb-1 text-dark">System Settings</h4>
                <div class="text-muted small">Admin / Configuration</div>
            </div>
        </div>

        <asp:Panel ID="pnlMessage" runat="server" Visible="false" CssClass="alert alert-info mb-4 rounded-2 small fw-semibold">
            <asp:Label ID="lblMessage" runat="server"></asp:Label>
        </asp:Panel>

        <div class="row g-4">
            <%-- Change Password Section --%>
            <div class="col-md-12">
                <div class="card border border-light shadow-sm p-4 rounded-3 bg-white">
                    <h6 class="fw-bold text-dark mb-3"><i class="bi bi-shield-lock me-2 text-primary"></i> Security Settings</h6>
                    <hr class="mt-0 mb-4 border-light" />
                    
                    <div class="row g-3">
                        <div class="col-md-4">
                            <label class="form-label small fw-bold text-muted mb-1">Current Password</label>
                            <asp:TextBox ID="txtCurrentPassword" runat="server" CssClass="form-control border-secondary border-opacity-25" TextMode="Password"></asp:TextBox>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label small fw-bold text-muted mb-1">New Password</label>
                            <asp:TextBox ID="txtNewPassword" runat="server" CssClass="form-control border-secondary border-opacity-25" TextMode="Password"></asp:TextBox>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label small fw-bold text-muted mb-1">Confirm New Password</label>
                            <asp:TextBox ID="txtConfirmPassword" runat="server" CssClass="form-control border-secondary border-opacity-25" TextMode="Password"></asp:TextBox>
                        </div>
                    </div>
                    <div class="d-flex justify-content-end mt-4">
                        <asp:LinkButton ID="btnUpdatePassword" runat="server" CssClass="btn btn-primary btn-sm px-4 fw-bold" OnClick="btnUpdatePassword_Click">
                            Update Password
                        </asp:LinkButton>
                    </div>
                </div>
            </div>

            <%-- System Info Section --%>
            <div class="col-md-12">
                <div class="card border border-light shadow-sm p-4 rounded-3 bg-white">
                    <h6 class="fw-bold text-dark mb-3"><i class="bi bi-info-circle me-2 text-primary"></i> System Information</h6>
                    <hr class="mt-0 mb-3 border-light" />
                    
                    <table class="table table-borderless table-sm small text-muted mb-0">
                        <tr><td style="width: 150px;" class="fw-bold">System Name</td><td>StackNet IMS (MVP Version)</td></tr>
                        <tr><td class="fw-bold">Version</td><td>1.0.0</td></tr>
                        <tr><td class="fw-bold">Database Server</td><td>SQL Server Express 2019</td></tr>
                        <tr><td class="fw-bold">Session Timeout</td><td>20 Minutes (SHA256 Secured)</td></tr>
                    </table>
                </div>
            </div>
        </div>

    </div>
</asp:Content>