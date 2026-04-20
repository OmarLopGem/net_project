<%@ Page Title="Register" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Register.aspx.cs" Inherits="net_project.Register" %>

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
                <p class="text-center text-muted">Create your account to access tickets, jerseys, and match experiences.</p>

                <div class="form-group">
                    <label for="txtFullName">Full Name</label>
                    <asp:TextBox
                        ID="txtFullName"
                        runat="server"
                        CssClass="form-control"
                        placeholder="Enter your full name" />
                    <asp:RequiredFieldValidator
                        ID="rfvFullName"
                        runat="server"
                        ControlToValidate="txtFullName"
                        ErrorMessage="Full name is required."
                        CssClass="text-danger"
                        Display="Dynamic" />
                </div>

                <div class="form-group">
                    <label for="txtEmail">Email</label>
                    <asp:TextBox
                        ID="txtEmail"
                        runat="server"
                        CssClass="form-control"
                        TextMode="Email"
                        placeholder="Enter your email" />
                    <asp:RequiredFieldValidator
                        ID="rfvEmail"
                        runat="server"
                        ControlToValidate="txtEmail"
                        ErrorMessage="Email is required."
                        CssClass="text-danger"
                        Display="Dynamic" />
                    <asp:RegularExpressionValidator
                        ID="revEmail"
                        runat="server"
                        ControlToValidate="txtEmail"
                        ErrorMessage="Enter a valid email."
                        CssClass="text-danger"
                        Display="Dynamic"
                        ValidationExpression="^\w+([\-+.'']\w+)*@\w+([\-]\w+)*(\.\w+([\-]\w+)*)+$" />
                </div>

                <div class="form-group">
                    <label for="txtPassword">Password</label>
                    <asp:TextBox
                        ID="txtPassword"
                        runat="server"
                        CssClass="form-control"
                        TextMode="Password"
                        placeholder="Enter your password" />
                    <asp:RequiredFieldValidator
                        ID="rfvPassword"
                        runat="server"
                        ControlToValidate="txtPassword"
                        ErrorMessage="Password is required."
                        CssClass="text-danger"
                        Display="Dynamic" />
                </div>

                <div class="form-group">
                    <label for="txtConfirmPassword">Confirm Password</label>
                    <asp:TextBox
                        ID="txtConfirmPassword"
                        runat="server"
                        CssClass="form-control"
                        TextMode="Password"
                        placeholder="Confirm your password" />
                    <asp:RequiredFieldValidator
                        ID="rfvConfirmPassword"
                        runat="server"
                        ControlToValidate="txtConfirmPassword"
                        ErrorMessage="Please confirm your password."
                        CssClass="text-danger"
                        Display="Dynamic" />
                    <asp:CompareValidator
                        ID="cvPasswords"
                        runat="server"
                        ControlToValidate="txtConfirmPassword"
                        ControlToCompare="txtPassword"
                        ErrorMessage="Passwords do not match."
                        CssClass="text-danger"
                        Display="Dynamic" />
                </div>

                <div class="form-group">
                    <asp:Button
                        ID="btnRegister"
                        runat="server"
                        Text="Create Account"
                        CssClass="btn btn-primary btn-block"
                        OnClick="btnRegister_Click" />
                </div>

                <div class="text-center">
                    <asp:Label ID="lblMessage" runat="server" CssClass="text-danger" />
                </div>

                <hr />
                <p class="text-center text-muted">
                    Already have an account? <a href="~/Default.aspx" runat="server">Sign in here</a>
                </p>
            </div>
        </div>
    </div>
</asp:Content>