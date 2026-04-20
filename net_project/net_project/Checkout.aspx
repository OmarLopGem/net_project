<%@ Page Title="Checkout" Language="C#" MasterPageFile="~/Site.Master"
    AutoEventWireup="true" CodeBehind="Checkout.aspx.cs" Inherits="net_project.Checkout" %>

<asp:Content ID="Content1" ContentPlaceHolderID="mainPlaceHolder" runat="server">

<h2>Checkout</h2>

<asp:Label ID="lblError" runat="server" CssClass="text-danger" Visible="false" />

<asp:ValidationSummary ID="valSummary" runat="server"
    CssClass="alert alert-danger"
    HeaderText="Please fix the following errors:"
    DisplayMode="BulletList" />

<h4>Billing Information</h4>
<div class="row">
    <div class="col-md-6">
        <div class="form-group">
            <asp:TextBox ID="txtFirstName" runat="server" CssClass="form-control" placeholder="First Name" />
            <asp:RequiredFieldValidator runat="server"
                ControlToValidate="txtFirstName"
                ErrorMessage="First name is required."
                Display="Dynamic" CssClass="text-danger" Text="*" />
        </div>
    </div>
    <div class="col-md-6">
        <div class="form-group">
            <asp:TextBox ID="txtLastName" runat="server" CssClass="form-control" placeholder="Last Name" />
            <asp:RequiredFieldValidator runat="server"
                ControlToValidate="txtLastName"
                ErrorMessage="Last name is required."
                Display="Dynamic" CssClass="text-danger" Text="*" />
        </div>
    </div>
</div>
<div class="row">
    <div class="col-md-6">
        <div class="form-group">
            <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" placeholder="Email" />
            <asp:RequiredFieldValidator runat="server"
                ControlToValidate="txtEmail"
                ErrorMessage="Email is required."
                Display="Dynamic" CssClass="text-danger" Text="*" />
            <asp:RegularExpressionValidator runat="server"
                ControlToValidate="txtEmail"
                ValidationExpression="^[^@\s]+@[^@\s]+\.[^@\s]+$"
                ErrorMessage="Please enter a valid email address."
                Display="Dynamic" CssClass="text-danger" Text="*" />
        </div>
    </div>
    <div class="col-md-6">
        <div class="form-group">
            <asp:TextBox ID="txtPhone" runat="server" CssClass="form-control" placeholder="Phone" />
            <asp:RequiredFieldValidator runat="server"
                ControlToValidate="txtPhone"
                ErrorMessage="Phone is required."
                Display="Dynamic" CssClass="text-danger" Text="*" />
            <asp:RegularExpressionValidator runat="server"
                ControlToValidate="txtPhone"
                ValidationExpression="^[\d\s\+\-\(\)]{7,15}$"
                ErrorMessage="Please enter a valid phone number."
                Display="Dynamic" CssClass="text-danger" Text="*" />
        </div>
    </div>
</div>
<div class="form-group">
    <asp:TextBox ID="txtAddress" runat="server" CssClass="form-control" placeholder="Address" />
    <asp:RequiredFieldValidator runat="server"
        ControlToValidate="txtAddress"
        ErrorMessage="Address is required."
        Display="Dynamic" CssClass="text-danger" Text="*" />
</div>
<div class="row">
    <div class="col-md-4">
        <div class="form-group">
            <asp:TextBox ID="txtCity" runat="server" CssClass="form-control" placeholder="City" />
            <asp:RequiredFieldValidator runat="server"
                ControlToValidate="txtCity"
                ErrorMessage="City is required."
                Display="Dynamic" CssClass="text-danger" Text="*" />
        </div>
    </div>
    <div class="col-md-4">
        <div class="form-group">
            <asp:TextBox ID="txtCountry" runat="server" CssClass="form-control" placeholder="Country" />
            <asp:RequiredFieldValidator runat="server"
                ControlToValidate="txtCountry"
                ErrorMessage="Country is required."
                Display="Dynamic" CssClass="text-danger" Text="*" />
        </div>
    </div>
    <div class="col-md-4">
        <div class="form-group">
            <asp:TextBox ID="txtZipCode" runat="server" CssClass="form-control" placeholder="Zip Code" />
            <asp:RequiredFieldValidator runat="server"
                ControlToValidate="txtZipCode"
                ErrorMessage="Zip code is required."
                Display="Dynamic" CssClass="text-danger" Text="*" />
            <asp:RegularExpressionValidator runat="server"
                ControlToValidate="txtZipCode"
                ValidationExpression="^[A-Za-z0-9\s\-]{3,10}$"
                ErrorMessage="Please enter a valid zip code."
                Display="Dynamic" CssClass="text-danger" Text="*" />
        </div>
    </div>
</div>

<hr />
<h4>Order Total: <asp:Label ID="lblTotal" runat="server" CssClass="text-success" /></h4>
<br />
<asp:Button ID="btnConfirm" runat="server" Text="Confirm Order"
    CssClass="btn btn-success" OnClick="btnConfirm_Click" />
<a href="Cart.aspx" class="btn btn-default">Back to Cart</a>

</asp:Content>