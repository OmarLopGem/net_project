<%@ Page Title="My Cart" Language="C#" MasterPageFile="~/Site.Master"
    AutoEventWireup="true" CodeBehind="Cart.aspx.cs" Inherits="net_project.Cart" %>

<asp:Content ID="Content1" ContentPlaceHolderID="mainPlaceHolder" runat="server">

<h2>My Cart</h2>

<asp:Label ID="lblError" runat="server" CssClass="text-danger" Visible="false" />
<asp:Label ID="lblEmpty" runat="server" CssClass="text-muted"
    Text="Your cart is empty." Visible="false" />

<asp:Panel ID="pnlCart" runat="server">
    <asp:GridView ID="gvCart" runat="server"
        AutoGenerateColumns="false"
        OnRowCommand="gvCart_RowCommand"
        CssClass="table table-bordered"
        DataKeyNames="ItemId">
        <Columns>
            <asp:BoundField DataField="Description" HeaderText="Item" />
            <asp:BoundField DataField="UnitPrice"   HeaderText="Unit Price" DataFormatString="{0:C}" />
            <asp:TemplateField HeaderText="Qty">
                <ItemTemplate>
                    <asp:TextBox ID="txtQty" runat="server"
                        Text='<%# Eval("Quantity") %>'
                        Width="50px" CssClass="form-control" />
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Subtotal">
                <ItemTemplate>
                    <%# string.Format("{0:C}", (decimal)Eval("UnitPrice") * (int)Eval("Quantity")) %>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="">
                <ItemTemplate>
                    <asp:Button runat="server" Text="Update"
                        CommandName="UpdateQty"
                        CommandArgument='<%# Container.DataItemIndex %>'
                        CssClass="btn btn-default btn-sm" />
                    <asp:Button runat="server" Text="Remove"
                        CommandName="RemoveItem"
                        CommandArgument='<%# Container.DataItemIndex %>'
                        CssClass="btn btn-danger btn-sm" />
                </ItemTemplate>
            </asp:TemplateField>
        </Columns>
    </asp:GridView>

    <h4>Total: <asp:Label ID="lblTotal" runat="server" /></h4>
    <br />
    <a href="Tickets.aspx" class="btn btn-default">Continue Shopping</a>
    <a href="Checkout.aspx" class="btn btn-success">Proceed to Checkout</a>
</asp:Panel>

</asp:Content>
