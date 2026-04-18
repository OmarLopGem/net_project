<%@ Page Title="Login Page" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="net_project._Default" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="mainPlaceHolder" runat="server">
    <div class="row login-page">
        <div class="col-xs-12 col-sm-8 col-sm-offset-2 col-md-4 col-md-offset-4">
            <asp:ValidationSummary 
                ID="vsErrors" 
                runat="server"
                CssClass="alert alert-danger"
                HeaderText="Please fix the following errors:"
                DisplayMode="BulletList"
                ShowSummary="true" />
            <div class="login-box">
                <h2 class="text-center">FIFA FAN ZONE</h2>
                <p class="text-center  text-muted">Sign in to access tickets, jerseys, and match experiences for the FIFA 2026 World Cup.</p>

                <div class="form-group">
                    <label for="txtEmail">Email</label>
                    <asp:TextBox
                        ID="txtEmail"
                        runat="server"
                        CssClass="form-control"
                        TextMode="Email"
                        placeholder="Enter your email">
                    </asp:TextBox>
                    <asp:RequiredFieldValidator
                        ID="rfvEmail"
                        runat="server"
                        ErrorMessage="Email is required"
                        ControlToValidate="txtEmail"
                        CssClass="text-danger"
                        Display="Dynamic">
                    </asp:RequiredFieldValidator>
                    <asp:RegularExpressionValidator
                        ID="revEmail"
                        runat="server"
                        ControlToValidate="txtEmail"
                        ErrorMessage="Enter a valid email."
                        CssClass="text-danger"
                        Display="Dynamic"
                        ValidationExpression="^\w+([\-+.'']\w+)*@\w+([\-]\w+)*(\.\w+([\-]\w+)*)+$">
                    </asp:RegularExpressionValidator>
                </div>

                <div class="form-group">
                    <label for="<%= txtPassword.ClientID %>">Password</label>
                    <asp:TextBox
                        ID="txtPassword"
                        runat="server"
                        CssClass="form-control"
                        TextMode="Password"
                        placeholder="Enter your password">
                    </asp:TextBox>

                    <asp:RequiredFieldValidator
                        ID="rfvPassword"
                        runat="server"
                        ControlToValidate="txtPassword"
                        ErrorMessage="Password is required."
                        CssClass="text-danger"
                        Display="Dynamic">
                    </asp:RequiredFieldValidator>
                </div>

                <div class="checkbox">
                    <label>
                        <asp:CheckBox ID="chkRememberMe" runat="server" />
                        Remember Me
                    </label>
                </div>

                <div class="form-group">
                    <asp:Button
                        ID="btnLogin"
                        runat="server"
                        Text="Login"
                        CssClass="btn btn-primary btn-block" OnClick="btnLogin_Click" />
                </div>

                <div class="text-center">
                    <asp:Label ID="lblMessage" runat="server"></asp:Label>
                </div>
            </div>
        </div>
    </div>
    
</asp:Content>
