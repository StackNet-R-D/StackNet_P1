<%@ Page Title="User Management" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="UserList.aspx.cs" Inherits="InventorySystem.UserList" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container-fluid mt-4 px-4">
        
        <div class="d-flex justify-content-between align-items-center mb-4 pb-2 border-bottom">
            <h4 class="fw-normal mb-0 text-dark">User Management</h4>
            <div class="d-flex gap-2">
                <asp:LinkButton ID="btnAddUser" runat="server" CssClass="btn btn-primary btn-sm px-3 rounded-2 d-flex align-items-center gap-2" PostBackUrl="~/UserCreate.aspx">
                    <i class="bi bi-person-plus"></i> Add New User
                </asp:LinkButton>
            </div>
        </div>

        <asp:Panel ID="pnlMessage" runat="server" Visible="false" CssClass="alert alert-danger mb-4 rounded-2 small fw-semibold">
            <asp:Label ID="lblMessage" runat="server"></asp:Label>
        </asp:Panel>

        <div class="card border border-light shadow-sm p-3 mb-4 rounded-3 bg-white">
            <div class="row g-2 align-items-center">
                <div class="col-md-5">
                    <div class="input-group input-group-sm">
                        <span class="input-group-text bg-white text-muted border-end-0"><i class="bi bi-search"></i></span>
                        <asp:TextBox ID="txtSearch" runat="server" CssClass="form-control border-start-0 ps-0" 
                            placeholder="Search by name or username..." AutoPostBack="true" OnTextChanged="btnSearch_Click"></asp:TextBox>
                        <asp:Button ID="btnSearch" runat="server" Text="Search" CssClass="btn btn-light border" OnClick="btnSearch_Click" />
                    </div>
                </div>
                <div class="col-md-7 text-end text-muted small">
                    <span class="fw-bold">Total Users:</span> 
                    <asp:Label ID="lblTotalUsers" runat="server" Text="0" CssClass="badge bg-secondary rounded-pill"></asp:Label>
                </div>
            </div>
        </div>

        <div class="card border border-light shadow-sm p-0 rounded-3 overflow-hidden bg-white">
            <div class="table-responsive">
                <asp:GridView ID="gvUsers" runat="server" AutoGenerateColumns="False" 
                    CssClass="table table-borderless table-hover align-middle mb-0" 
                    GridLines="None" ShowHeaderWhenEmpty="True" 
                    OnRowCommand="gvUsers_RowCommand" DataKeyNames="UserID">
                    
                    <HeaderStyle CssClass="text-muted small text-uppercase border-bottom" BackColor="#f8f9fa" Font-Bold="True" Height="50px" />
                    <RowStyle Height="60px" CssClass="border-bottom border-light" />
                    
                    <Columns>
                        <asp:BoundField DataField="UserID" HeaderText="ID" ItemStyle-CssClass="text-muted fw-bold ps-3" ItemStyle-Width="60px" />
                        
                        <asp:TemplateField HeaderText="User Profile">
                            <ItemTemplate>
                                <div class="d-flex align-items-center gap-3">
                                    <div class="bg-primary bg-opacity-10 text-primary rounded-circle d-flex align-items-center justify-content-center fw-bold" style="width: 40px; height: 40px;">
                                        <%# Eval("FullName").ToString().Substring(0, 1).ToUpper() %>
                                    </div>
                                    <div>
                                        <div class="fw-bold text-dark"><%# Eval("FullName") %></div>
                                        <div class="text-muted small">@<%# Eval("Username") %></div>
                                    </div>
                                </div>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:BoundField DataField="RoleName" HeaderText="System Role" ItemStyle-CssClass="fw-semibold text-secondary" />
                        
                        <asp:TemplateField HeaderText="Status">
                            <ItemTemplate>
                                <span class='<%# Eval("Status").ToString() == "Active" ? "badge bg-success bg-opacity-10 text-success" : "badge bg-secondary bg-opacity-10 text-secondary" %>'>
                                    <%# Eval("Status") %>
                                </span>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:BoundField DataField="CreatedDate" HeaderText="Joined" DataFormatString="{0:MMM dd, yyyy}" ItemStyle-CssClass="text-muted small" />

                        <asp:TemplateField HeaderText="Actions" ItemStyle-CssClass="text-end pe-3" ItemStyle-Width="120px" HeaderStyle-CssClass="text-end pe-3">
                            <ItemTemplate>
                                <asp:LinkButton runat="server" CommandName="EditUser" CommandArgument='<%# Eval("UserID") %>' CssClass="btn btn-sm btn-light text-primary me-1 border" ToolTip="Edit">
                                    <i class="bi bi-pencil-square"></i>
                                </asp:LinkButton>
                                <asp:LinkButton runat="server" CommandName="DeleteUser" CommandArgument='<%# Eval("UserID") %>' CssClass="btn btn-sm btn-light text-danger border" ToolTip="Delete" OnClientClick="return confirm('WARNING: Are you sure you want to deactivate/delete this user?');">
                                    <i class="bi bi-trash"></i>
                                </asp:LinkButton>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                    
                    <EmptyDataTemplate>
                        <div class="text-center p-5 text-muted">
                            <i class="bi bi-people display-4 text-light mb-3 d-block"></i>
                            <p class="mb-0">No users found.</p>
                        </div>
                    </EmptyDataTemplate>
                </asp:GridView>
            </div>
        </div>

    </div>
</asp:Content>