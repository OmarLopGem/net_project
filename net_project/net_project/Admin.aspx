<%@ Page Title="Admin Panel" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Admin.aspx.cs" Inherits="net_project.Admin" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="mainPlaceHolder" runat="server">

    <div class="container admin-page">
        <div class="page-header">
            <h1>Admin Panel</h1>
            <p class="text-muted">Manage jerseys and tickets for the FIFA 2026 Fan Zone.</p>
        </div>

        <asp:Label ID="lblAdminMessage" runat="server" CssClass="text-success"></asp:Label>

        <div class="panel panel-primary">
            <div class="panel-heading">
                <h3 class="panel-title">Manage Jerseys</h3>
            </div>
            <div class="panel-body">

                <h4>Add New Jersey</h4>

                <asp:ValidationSummary
                    ID="vsJersey"
                    runat="server"
                    CssClass="alert alert-danger"
                    ValidationGroup="InsertJersey"
                    HeaderText="Please fix the following jersey errors:" />

                <asp:DetailsView
                    ID="dvJerseyInsert"
                    runat="server"
                    DefaultMode="Insert"
                    AutoGenerateRows="False"
                    DataSourceID="sqlJerseys"
                    CssClass="table table-bordered">

                    <Fields>
                        <asp:TemplateField HeaderText="Team Name">
                            <InsertItemTemplate>
                                <asp:TextBox ID="txtTeamName" runat="server" CssClass="form-control"
                                    Text='<%# Bind("team_name") %>'></asp:TextBox>
                                <asp:RequiredFieldValidator
                                    ID="rfvTeamName"
                                    runat="server"
                                    ControlToValidate="txtTeamName"
                                    ErrorMessage="Team name is required."
                                    CssClass="text-danger"
                                    Display="Dynamic"
                                    ValidationGroup="InsertJersey" />
                            </InsertItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Size">
                            <InsertItemTemplate>
                                <asp:TextBox ID="txtSize" runat="server" CssClass="form-control"
                                    Text='<%# Bind("size") %>'></asp:TextBox>
                                <asp:RequiredFieldValidator
                                    ID="rfvSize"
                                    runat="server"
                                    ControlToValidate="txtSize"
                                    ErrorMessage="Size is required."
                                    CssClass="text-danger"
                                    Display="Dynamic"
                                    ValidationGroup="InsertJersey" />
                            </InsertItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Price">
                            <InsertItemTemplate>
                                <asp:TextBox ID="txtPrice" runat="server" CssClass="form-control"
                                    Text='<%# Bind("price") %>'></asp:TextBox>
                                <asp:RequiredFieldValidator
                                    ID="rfvPrice"
                                    runat="server"
                                    ControlToValidate="txtPrice"
                                    ErrorMessage="Price is required."
                                    CssClass="text-danger"
                                    Display="Dynamic"
                                    ValidationGroup="InsertJersey" />
                                <asp:RegularExpressionValidator
                                    ID="revPrice"
                                    runat="server"
                                    ControlToValidate="txtPrice"
                                    ValidationExpression="^\d+(\.\d{1,2})?$"
                                    ErrorMessage="Enter a valid price."
                                    CssClass="text-danger"
                                    Display="Dynamic"
                                    ValidationGroup="InsertJersey" />
                            </InsertItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Stock">
                            <InsertItemTemplate>
                                <asp:TextBox ID="txtStock" runat="server" CssClass="form-control"
                                    Text='<%# Bind("stock") %>'></asp:TextBox>
                                <asp:RequiredFieldValidator
                                    ID="rfvStock"
                                    runat="server"
                                    ControlToValidate="txtStock"
                                    ErrorMessage="Stock is required."
                                    CssClass="text-danger"
                                    Display="Dynamic"
                                    ValidationGroup="InsertJersey" />
                                <asp:RegularExpressionValidator
                                    ID="revStock"
                                    runat="server"
                                    ControlToValidate="txtStock"
                                    ValidationExpression="^\d+$"
                                    ErrorMessage="Stock must be a whole number."
                                    CssClass="text-danger"
                                    Display="Dynamic"
                                    ValidationGroup="InsertJersey" />
                            </InsertItemTemplate>
                        </asp:TemplateField>

                        <asp:CommandField ShowInsertButton="True" InsertText="Add Jersey" ValidationGroup="InsertJersey" />
                    </Fields>
                </asp:DetailsView>

                <hr />

                <asp:GridView
                    ID="gvJerseys"
                    runat="server"
                    CssClass="table table-striped table-bordered table-hover"
                    AutoGenerateColumns="False"
                    DataKeyNames="id"
                    DataSourceID="sqlJerseys"
                    AllowPaging="true"
                    PageSize="5">
                    <Columns>
                        <asp:BoundField DataField="id" HeaderText="ID" ReadOnly="True" InsertVisible="False" SortExpression="id" />
                        <asp:BoundField DataField="team_name" HeaderText="Team Name" SortExpression="team_name" />
                        <asp:BoundField DataField="size" HeaderText="Size" SortExpression="size" />
                        <asp:BoundField DataField="price" HeaderText="Price" SortExpression="price" />
                        <asp:BoundField DataField="stock" HeaderText="Stock" SortExpression="stock" />
                        <asp:BoundField DataField="created_at" HeaderText="Created At" ReadOnly="True" SortExpression="created_at" />
                        <asp:CommandField ShowEditButton="True" ShowDeleteButton="True" />
                    </Columns>
                </asp:GridView>

                <asp:SqlDataSource
                    ID="sqlJerseys"
                    runat="server"
                    ConnectionString="<%$ ConnectionStrings:Database1Connection %>"
                    SelectCommand="SELECT id, team_name, size, price, stock, created_at FROM jerseys ORDER BY id DESC"
                    UpdateCommand="UPDATE jerseys SET team_name = @team_name, size = @size, price = @price, stock = @stock WHERE id = @id"
                    DeleteCommand="DELETE FROM jerseys WHERE id = @id"
                    InsertCommand="INSERT INTO jerseys (team_name, size, price, stock, created_at) VALUES (@team_name, @size, @price, @stock, GETDATE())">
                    <UpdateParameters>
                        <asp:Parameter Name="team_name" Type="String" />
                        <asp:Parameter Name="size" Type="String" />
                        <asp:Parameter Name="price" Type="Decimal" />
                        <asp:Parameter Name="stock" Type="Int32" />
                        <asp:Parameter Name="id" Type="Int32" />
                    </UpdateParameters>
                    <DeleteParameters>
                        <asp:Parameter Name="id" Type="Int32" />
                    </DeleteParameters>
                    <InsertParameters>
                        <asp:Parameter Name="team_name" Type="String" />
                        <asp:Parameter Name="size" Type="String" />
                        <asp:Parameter Name="price" Type="Decimal" />
                        <asp:Parameter Name="stock" Type="Int32" />
                    </InsertParameters>
                </asp:SqlDataSource>

            </div>
        </div>

        <div class="panel panel-warning">
            <div class="panel-heading">
                <h3 class="panel-title">Manage Tickets</h3>
            </div>
            <div class="panel-body">

                <h4>Add New Ticket</h4>

                <asp:ValidationSummary
                    ID="vsTicket"
                    runat="server"
                    CssClass="alert alert-danger"
                    ValidationGroup="InsertTicket"
                    HeaderText="Please fix the following ticket errors:" />

                <asp:DetailsView
                    ID="dvTicketInsert"
                    runat="server"
                    DefaultMode="Insert"
                    AutoGenerateRows="False"
                    DataSourceID="sqlTickets"
                    CssClass="table table-bordered">

                    <Fields>
                        <asp:TemplateField HeaderText="Match ID">
                            <InsertItemTemplate>
                                <asp:TextBox ID="txtMatchId" runat="server" CssClass="form-control"
                                    Text='<%# Bind("match_id") %>'></asp:TextBox>
                                <asp:RequiredFieldValidator
                                    ID="rfvMatchId"
                                    runat="server"
                                    ControlToValidate="txtMatchId"
                                    ErrorMessage="Match ID is required."
                                    CssClass="text-danger"
                                    Display="Dynamic"
                                    ValidationGroup="InsertTicket" />
                                <asp:RegularExpressionValidator
                                    ID="revMatchId"
                                    runat="server"
                                    ControlToValidate="txtMatchId"
                                    ValidationExpression="^\d+$"
                                    ErrorMessage="Match ID must be a whole number."
                                    CssClass="text-danger"
                                    Display="Dynamic"
                                    ValidationGroup="InsertTicket" />
                            </InsertItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Category">
                            <InsertItemTemplate>
                                <asp:TextBox ID="txtCategory" runat="server" CssClass="form-control"
                                    Text='<%# Bind("category") %>'></asp:TextBox>
                                <asp:RequiredFieldValidator
                                    ID="rfvCategory"
                                    runat="server"
                                    ControlToValidate="txtCategory"
                                    ErrorMessage="Category is required."
                                    CssClass="text-danger"
                                    Display="Dynamic"
                                    ValidationGroup="InsertTicket" />
                            </InsertItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Price">
                            <InsertItemTemplate>
                                <asp:TextBox ID="txtTicketPrice" runat="server" CssClass="form-control"
                                    Text='<%# Bind("price") %>'></asp:TextBox>
                                <asp:RequiredFieldValidator
                                    ID="rfvTicketPrice"
                                    runat="server"
                                    ControlToValidate="txtTicketPrice"
                                    ErrorMessage="Price is required."
                                    CssClass="text-danger"
                                    Display="Dynamic"
                                    ValidationGroup="InsertTicket" />
                                <asp:RegularExpressionValidator
                                    ID="revTicketPrice"
                                    runat="server"
                                    ControlToValidate="txtTicketPrice"
                                    ValidationExpression="^\d+(\.\d{1,2})?$"
                                    ErrorMessage="Enter a valid price."
                                    CssClass="text-danger"
                                    Display="Dynamic"
                                    ValidationGroup="InsertTicket" />
                            </InsertItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Stock">
                            <InsertItemTemplate>
                                <asp:TextBox ID="txtTicketStock" runat="server" CssClass="form-control"
                                    Text='<%# Bind("stock") %>'></asp:TextBox>
                                <asp:RequiredFieldValidator
                                    ID="rfvTicketStock"
                                    runat="server"
                                    ControlToValidate="txtTicketStock"
                                    ErrorMessage="Stock is required."
                                    CssClass="text-danger"
                                    Display="Dynamic"
                                    ValidationGroup="InsertTicket" />
                                <asp:RegularExpressionValidator
                                    ID="revTicketStock"
                                    runat="server"
                                    ControlToValidate="txtTicketStock"
                                    ValidationExpression="^\d+$"
                                    ErrorMessage="Stock must be a whole number."
                                    CssClass="text-danger"
                                    Display="Dynamic"
                                    ValidationGroup="InsertTicket" />
                            </InsertItemTemplate>
                        </asp:TemplateField>

                        <asp:CommandField ShowInsertButton="True" InsertText="Add Ticket" ValidationGroup="InsertTicket" />
                    </Fields>
                </asp:DetailsView>

                <hr />

                <asp:GridView
                    ID="gvTicketsAdmin"
                    runat="server"
                    CssClass="table table-striped table-bordered table-hover"
                    AutoGenerateColumns="False"
                    DataKeyNames="id"
                    DataSourceID="sqlTickets"
                    AllowPaging="true"
                    PageSize="5">
                    <Columns>
                        <asp:BoundField DataField="id" HeaderText="ID" ReadOnly="True" InsertVisible="False" SortExpression="id" />
                        <asp:BoundField DataField="match_id" HeaderText="Match ID" SortExpression="match_id" />
                        <asp:BoundField DataField="category" HeaderText="Category" SortExpression="category" />
                        <asp:BoundField DataField="price" HeaderText="Price" SortExpression="price" />
                        <asp:BoundField DataField="stock" HeaderText="Stock" SortExpression="stock" />
                        <asp:BoundField DataField="created_at" HeaderText="Created At" ReadOnly="True" SortExpression="created_at" />
                        <asp:CommandField ShowEditButton="True" ShowDeleteButton="True" />
                    </Columns>
                </asp:GridView>

                <asp:SqlDataSource
                    ID="sqlTickets"
                    runat="server"
                    ConnectionString="<%$ ConnectionStrings:Database1Connection %>"
                    SelectCommand="SELECT id, match_id, category, price, stock, created_at FROM tickets ORDER BY id DESC"
                    UpdateCommand="UPDATE tickets SET match_id = @match_id, category = @category, price = @price, stock = @stock WHERE id = @id"
                    DeleteCommand="DELETE FROM tickets WHERE id = @id"
                    InsertCommand="INSERT INTO tickets (match_id, category, price, stock, created_at) VALUES (@match_id, @category, @price, @stock, GETDATE())">
                    <UpdateParameters>
                        <asp:Parameter Name="match_id" Type="Int32" />
                        <asp:Parameter Name="category" Type="String" />
                        <asp:Parameter Name="price" Type="Decimal" />
                        <asp:Parameter Name="stock" Type="Int32" />
                        <asp:Parameter Name="id" Type="Int32" />
                    </UpdateParameters>
                    <DeleteParameters>
                        <asp:Parameter Name="id" Type="Int32" />
                    </DeleteParameters>
                    <InsertParameters>
                        <asp:Parameter Name="match_id" Type="Int32" />
                        <asp:Parameter Name="category" Type="String" />
                        <asp:Parameter Name="price" Type="Decimal" />
                        <asp:Parameter Name="stock" Type="Int32" />
                    </InsertParameters>
                </asp:SqlDataSource>

            </div>
        </div>
    </div>

</asp:Content>