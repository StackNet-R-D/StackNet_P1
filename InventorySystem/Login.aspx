<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="InventorySystem.Login" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Login - StackNet IMS</title>

    <%-- Bootstrap 5 & Icons --%>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">

    <style>
        body, html {
            height: 100%;
            margin: 0;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #ffffff;
            overflow: hidden;
        }

        .split-left {
            background-color: #121d36;
            background-image:
                radial-gradient(circle at 10% 90%, rgba(255,255,255,0.03) 0%, rgba(255,255,255,0.03) 40%, transparent 40%),
                radial-gradient(circle at 90% 10%, rgba(255,255,255,0.02) 0%, rgba(255,255,255,0.02) 30%, transparent 30%);
            color: white;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            padding: 42px 38px;
            position: relative;
            overflow: hidden;
        }

        .split-right {
            display: flex;
            align-items: center;
            justify-content: center;
            background: #f8f8f8;
            padding: 40px;
        }

        .btn-login {
            border-radius: 5px;
            font-weight: 600;
            border: 1px solid #d9dee7;
            background: white;
            color: #333;
            transition: all 0.2s;
        }

        .btn-login:hover {
            background: #f8f9fa;
            border-color: #ccc;
        }

        .stats-row {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            border-top: 1px solid rgba(255,255,255,0.08);
            padding-top: 20px;
            position: relative;
            z-index: 2;
        }

        .stat-item {
            display: flex;
            flex-direction: column;
        }

        .stat-num {
            font-weight: 800;
            font-size: 2rem;
            color: #ffffff;
            line-height: 1;
        }

        .stat-label {
            font-size: 0.68rem;
            color: #8a94a6;
            text-transform: uppercase;
            letter-spacing: 1px;
            margin-top: 4px;
            line-height: 1.3;
        }

        .brand-icon {
            background: transparent;
            color: #2563eb;
            border-radius: 8px;
            width: 28px;
            height: 28px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1rem;
            border: 1px solid rgba(255,255,255,0.08);
        }

        .hero-text {
            margin-top: auto;
            margin-bottom: auto;
            padding-bottom: 80px;
        }

        .hero-text h1 {
            font-size: 3.4rem;
            line-height: 1.15;
            font-weight: 800;
            color: #ffffff;
        }
    </style>
</head>

<body>
    <form id="form1" runat="server" style="height: 100%;">

        <div class="row g-0 h-100">

            <%-- Left Dark Panel --%>
            <div class="col-md-5 split-left d-none d-md-flex">

                <div style="z-index: 2;">
                    <div class="d-flex align-items-center gap-3 mb-1">
                        <div class="brand-icon">
                            <i class="bi bi-box-seam"></i>
                        </div>

                        <h5 class="fw-bold mb-0 text-white">
                            StackNet IMS
                        </h5>
                    </div>

                    <span class="text-uppercase fw-bold"
                        style="font-size: 0.65rem; color: #8a94a6; letter-spacing: 1px; margin-left: 42px;">
                        Inventory Management
                    </span>
                </div>

                <div class="hero-text" style="z-index:2;">
                    <h1>
                        Manage your<br />
                        <span style="color:#3b82f6;">warehouse</span><br />
                        with precision.
                    </h1>
                </div>

                <div class="stats-row">

                    <div class="stat-item">
                        <asp:Label ID="lblRoleCount" runat="server" CssClass="stat-num">3</asp:Label>

                        <span class="stat-label">
                            User<br />
                            Roles
                        </span>
                    </div>

                    <div class="stat-item">
                        <span class="stat-num">12</span>

                        <span class="stat-label">
                            Modules
                        </span>
                    </div>

                    <div class="stat-item">
                        <span class="stat-num">LAN</span>

                        <span class="stat-label">
                            Network
                        </span>
                    </div>

                </div>

            </div>

            <%-- Right Login Panel --%>
            <div class="col-md-7 split-right">

                <div class="w-100" style="max-width: 480px;">

                    <h3 class="fw-normal text-dark mb-1" style="font-size: 2.4rem;">
                        Sign in to continue
                    </h3>

                    <p class="text-muted mb-4" style="font-size: 1rem;">
                        Enter your credentials to access the system
                    </p>

                    <asp:Panel ID="pnlError" runat="server" Visible="false"
                        CssClass="alert alert-danger small p-2 rounded-2 mb-3">
                        <i class="bi bi-exclamation-circle me-1"></i>
                        <asp:Label ID="lblError" runat="server"></asp:Label>
                    </asp:Panel>

                    <div class="mb-4">

                        <label class="form-label fw-bold text-muted text-uppercase mb-1"
                            style="font-size: 0.75rem; letter-spacing: 1px;">
                            Role
                        </label>

                        <div class="input-group">
                            <span class="input-group-text bg-white text-muted border-end-0 px-3"
                                style="height: 52px;">
                                <i class="bi bi-person-badge"></i>
                            </span>

                            <asp:DropDownList ID="ddlRole" runat="server"
                                CssClass="form-select border-start-0 ps-1"
                                style="height: 52px; font-size: 0.95rem;">
                            </asp:DropDownList>
                        </div>

                    </div>

                    <div class="mb-4">

                        <label class="form-label fw-bold text-muted text-uppercase mb-1"
                            style="font-size: 0.75rem; letter-spacing: 1px;">
                            Username
                        </label>

                        <div class="input-group">
                            <span class="input-group-text bg-white text-muted border-end-0 px-3"
                                style="height: 52px;">
                                <i class="bi bi-person"></i>
                            </span>

                            <asp:TextBox ID="txtUsername" runat="server"
                                CssClass="form-control border-start-0 ps-1"
                                
                                Required="true"
                                style="height: 52px; font-size: 0.95rem;">
                            </asp:TextBox>
                        </div>

                    </div>

                    <div class="mb-5">

                        <label class="form-label fw-bold text-muted text-uppercase mb-1"
                            style="font-size: 0.75rem; letter-spacing: 1px;">
                            Password
                        </label>

                        <div class="input-group">
                            <span class="input-group-text bg-white text-muted border-end-0 px-3"
                                style="height: 52px;">
                                <i class="bi bi-lock"></i>
                            </span>

                            <asp:TextBox ID="txtPassword" runat="server"
                                CssClass="form-control border-start-0 ps-1"
                                TextMode="Password"
                               
                                Required="true"
                                style="height: 52px; font-size: 0.95rem;">
                            </asp:TextBox>
                        </div>

                    </div>

                    <asp:Button ID="btnLogin"
                        runat="server"
                        Text="Sign In →"
                        CssClass="btn w-100 btn-login mb-4"
                        OnClick="btnLogin_Click"
                        style="height: 52px; font-size: 1rem;" />

                    <div class="text-center">
                        <span style="font-size: 0.75rem; color: #8a94a6;">
                            Session expires after 20 min • SHA256 secured
                        </span>
                    </div>

                </div>

            </div>

        </div>

    </form>
</body>
</html>
