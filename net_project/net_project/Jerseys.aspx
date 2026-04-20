<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Jerseys.aspx.cs" Inherits="net_project.Jerseys" %>
<asp:Content ID="Content1" ContentPlaceHolderID="headPlaceholder" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="mainPlaceHolder" runat="server">
    <p>
        <asp:Label ID="lblMessage" runat="server" CssClass="text-success"></asp:Label>
        <asp:GridView 
            ID="GridView1" 
            runat="server" 
            AutoGenerateColumns="False" 
            CssClass="table table-striped table-bordered table-hover"
            DataKeyNames="id" DataSourceID="SqlDataSource1" OnRowCommand="GridView1_RowCommand">
            <Columns>
                <asp:BoundField DataField="id" HeaderText="id" InsertVisible="False" ReadOnly="True" SortExpression="id" />
                <asp:BoundField DataField="team_name" HeaderText="team_name" SortExpression="team_name" />
                <asp:BoundField DataField="price" HeaderText="price" SortExpression="price" />
                <asp:BoundField DataField="stock" HeaderText="stock" SortExpression="stock" />
                <asp:BoundField DataField="size" HeaderText="size" SortExpression="size" />
                <asp:TemplateField HeaderText="">
                <ItemTemplate>
                    <asp:Button runat="server" Text="Add to Cart"
                        CommandName="AddToCart"
                        CommandArgument='<%# Eval("id") %>'
                        CssClass="btn btn-primary btn-sm" />
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
        </asp:GridView>
        <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:Database1Connection %>" SelectCommand="SELECT [id], [team_name], [price], [stock], [size] FROM [jerseys]"></asp:SqlDataSource>
    </p>
</asp:Content>
