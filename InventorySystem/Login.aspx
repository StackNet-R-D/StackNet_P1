<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="InventorySystem.Login" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>StackNet IMS - Login</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet" />
    <style>
        body, html { height: 100%; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }
        .bg-navy { background-color: #1a2235; }
        .text-blue { color: #3b82f6; }
        .form-label { font-size: 0.75rem; font-weight: 600; color: #6c757d; letter-spacing: 0.5px; text-transform: uppercase; }
        .input-group-text { background-color: transparent; border-right: none; color: #6c757d; }
        .form-control, .form-select { border-left: none; padding-left: 0; }
        .form-control:focus, .form-select:focus { box-shadow: none; border-color: #dee2e6; }
        .input-group:focus-within { box-shadow: 0 0 0 0.25rem rgba(59, 130, 246, 0.25); border-radius: 0.375rem; }
        .input-group:focus-within .input-group-text, .input-group:focus-within .form-control { border-color: #86b7fe; }
        .btn-outline-custom { border: 1px solid #dee2e6; color: #212529; font-weight: 500; }
        .btn-outline-custom:hover { background-color: #f8f9fa; }
        .stats-divider { border-top: 1px solid rgba(255, 255, 255, 0.1); margin-bottom: 1.5rem; }
    </style>
</head>
<body>
    <form id="form1" runat="server" class="h-100">
        <div class="row g-0 h-100">
            
            <div class="col-md-5 d-none d-md-flex flex-column justify-content-between bg-navy text-white p-5">
                <div>
                    <h5 class="fw-bold d-flex align-items-center gap-2">
                        <i class="bi bi-box-seam text-blue fs-4"></i> 
                        <div>
                            StackNet IMS<br />
                            <small class="text-secondary" style="font-size: 0.65rem; letter-spacing: 1px;">INVENTORY MANAGEMENT</small>
                        </div>
                    </h5>
                </div>
                
                <div>
                    <h1 class="fw-bold display-5 mb-0">Manage your</h1>
                    <h1 class="fw-bold display-5 text-blue mb-0">warehouse</h1>
                    <h1 class="fw-bold display-5">with precision.</h1>
                </div>

                <div>
                    <div class="stats-divider"></div>
                    <div class="d-flex justify-content-between text-uppercase" style="font-size: 0.75rem; font-weight: 600; color: #94a3b8;">
                        <div>
                            <span class="fs-4 fw-bold text-white d-block lh-1 mb-1">3</span>
                            User<br />Roles
                        </div>
                        <div>
                            <span class="fs-4 fw-bold text-white d-block lh-1 mb-1">12</span>
                            Modules
                        </div>
                        <div>
                            <span class="fs-4 fw-bold text-white d-block lh-1 mb-1">LAN</span>
                            Network
                        </div>
                    </div>
                </div>
            </div>

            <div class="col-md-7 d-flex align-items-center justify-content-center p-5 bg-white">
                <div style="width: 100%; max-width: 400px;">
                    <h3 class="fw-normal mb-1">Sign in to continue</h3>
                    <p class="text-muted small mb-4">Enter your credentials to access the system</p>

                    <div class="mb-3">
                        <label class="form-label">Role</label>
                        <div class="input-group border rounded">
                            <span class="input-group-text border-0"><i class="bi bi-person-badge"></i></span>
                            <asp:DropDownList ID="ddlRole" runat="server" CssClass="form-select border-0">
                                <asp:ListItem Text="Administrator" Value="1"></asp:ListItem>
                                <asp:ListItem Text="Warehouse Staff" Value="2"></asp:ListItem>
                                <asp:ListItem Text="Management User" Value="3"></asp:ListItem>
                            </asp:DropDownList>
                        </div>
                    </div>

                    <div class="mb-3">
                        <label class="form-label">Username</label>
                        <div class="input-group border rounded">
                            <span class="input-group-text border-0"><i class="bi bi-person"></i></span>
                            <asp:TextBox ID="txtUsername" runat="server" CssClass="form-control border-0" placeholder="admin"></asp:TextBox>
                        </div>
                    </div>

                    <div class="mb-4">
                        <label class="form-label">Password</label>
                        <div class="input-group border rounded">
                            <span class="input-group-text border-0"><i class="bi bi-lock"></i></span>
                            <asp:TextBox ID="txtPassword" runat="server" CssClass="form-control border-0" TextMode="Password" placeholder="••••••"></asp:TextBox>
                        </div>
                    </div>

                    <asp:Button ID="btnLogin" runat="server" Text="Sign In &rarr;" CssClass="btn btn-outline-custom w-100 py-2 mb-4" OnClick="btnLogin_Click" />
                    
                    <asp:Label ID="lblMessage" runat="server" CssClass="text-danger d-block text-center mb-3" style="font-size: 0.85rem;"></asp:Label>

                    <div class="text-center text-muted" style="font-family: monospace; font-size: 0.75rem;">
                        Session expires after 20 min • SHA256 secured
                    </div>
                </div>
            </div>

        </div>
    </form>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>