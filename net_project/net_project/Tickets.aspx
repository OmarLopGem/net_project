<%@ Page Title="Tickets Page" Language="C#" AutoEventWireup="true" MasterPageFile="~/Site.Master" CodeBehind="Tickets.aspx.cs" Inherits="net_project.Tickets" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="mainPlaceHolder" runat="server">
    <div class="tickets-hero text-center">
        <h1>Match Tickets</h1>
        <p class="text-muted">Choose your match and book your FIFA World Cup 2026 experience.</p>
    </div>

    <div class="row">
        <div class="col-md-3">
            <div class="panel panel-default">
                <div class="panel-heading">
                    <h4 class="panel-title">Filter Tickets</h4>
                </div>
                <div class="panel-body">
                    <div class="form-group">
                        <label for="<%= ddlCity.ClientID %>">City</label>
                        <asp:DropDownList ID="ddlCity" runat="server" CssClass="form-control" AutoPostBack="true" OnSelectedIndexChanged="ddlCity_SelectedIndexChanged">
                            <asp:ListItem Text="All Cities" Value="" />
                        </asp:DropDownList>
                    </div>

                    <div class="form-group">
                        <label for="<%= txtTeam.ClientID %>">Team</label>
                        <asp:TextBox ID="txtTeam" runat="server" CssClass="form-control" placeholder="Search by team"></asp:TextBox>
                    </div>

                    <div class="form-group">
                        <asp:Button ID="btnSearch" runat="server" Text="Search" CssClass="btn btn-primary btn-block" OnClick="btnSearch_Click" />
                    </div>
                </div>
            </div>
        </div>

        <div class="col-md-9">
            <asp:Label ID="lblMessage" runat="server" CssClass="text-success"></asp:Label>

            <asp:GridView 
                ID="gvTickets" 
                runat="server" 
                AutoGenerateColumns="False"
                CssClass="table table-striped table-bordered table-hover"
                DataKeyNames="ticket_id"
                OnRowCommand="gvTickets_RowCommand">
                <Columns>
                    <asp:BoundField DataField="home_team" HeaderText="Home Team" />
                    <asp:BoundField DataField="away_team" HeaderText="Away Team" />
                    <asp:BoundField DataField="match_date" HeaderText="Date" DataFormatString="{0:MMM dd, yyyy hh:mm tt}" />
                    <asp:BoundField DataField="stadium" HeaderText="Stadium" />
                    <asp:BoundField DataField="city" HeaderText="City" />
                    <asp:BoundField DataField="ticket_type" HeaderText="Ticket Type" />
                    <asp:BoundField DataField="price" HeaderText="Price" DataFormatString="{0:C}" />
                    <asp:BoundField DataField="available_quantity" HeaderText="Available" />

                    <asp:TemplateField HeaderText="Quantity">
                        <ItemTemplate>
                            <asp:DropDownList ID="ddlQuantity" runat="server" CssClass="form-control input-sm">
                                <asp:ListItem Text="1" Value="1" />
                                <asp:ListItem Text="2" Value="2" />
                                <asp:ListItem Text="3" Value="3" />
                                <asp:ListItem Text="4" Value="4" />
                            </asp:DropDownList>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Action">
                        <ItemTemplate>
                            <asp:Button 
                                ID="btnAddToCart" 
                                runat="server" 
                                Text="Add to Cart"
                                CssClass="btn btn-success btn-sm"
                                CommandName="AddToCart"
                                CommandArgument='<%# Eval("ticket_id") %>' />
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
        </div>
    </div>

</asp:Content>