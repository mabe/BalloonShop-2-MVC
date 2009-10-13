<%@ Page Language="C#" MasterPageFile="~/Admin.master" AutoEventWireup="true" CodeFile="OrdersAdmin.aspx.cs"
  Inherits="OrdersAdmin" Title="Untitled Page" %>

<%@ Register Src="UserControls/OrderDetailsAdmin.ascx" TagName="OrderDetailsAdmin"
  TagPrefix="uc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
  <span class="AdminTitle">Orders Admin</span></asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder2" runat="Server">
  <asp:SqlDataSource ID="CustomerNameDS" runat="server"
    ConnectionString="<%$ ConnectionStrings:BalloonShopAspNetDBConnectionString %>"
    SelectCommand="SELECT vw_aspnet_Users.UserName,vw_aspnet_Users.UserId FROM vw_aspnet_Users INNER JOIN aspnet_UsersInRoles ON vw_aspnet_Users.UserId = aspnet_UsersInRoles.UserId INNER JOIN aspnet_Roles ON aspnet_UsersInRoles.RoleId = aspnet_Roles.RoleId WHERE (aspnet_Roles.RoleName = 'Customers')" />

  <span class="AdminPageText">
    Show orders by customer
    <asp:DropDownList ID="userDropDown" runat="server"
      DataSourceID="CustomerNameDS" DataTextField="UserName"
      DataValueField="UserId" />
    <asp:Button ID="byCustomerGo" runat="server"
      CssClass="AdminButtonText" Text="Go"
      OnClick="byCustomerGo_Click" />
    <br />
    Get order by ID
    <asp:TextBox ID="orderIDBox" runat="server" Width="77px" />
    <asp:Button ID="byIDGo" runat="server" CssClass="AdminButtonText"
      Text="Go" OnClick="byIDGo_Click" />
    <br />
    Show the most recent
    <asp:TextBox ID="recentCountTextBox" runat="server" MaxLength="4" 
      Width="40px">20</asp:TextBox>
    orders
    <asp:Button ID="byRecentGo" runat="server"
      CssClass="AdminButtonText" Text="Go"
      OnClick="byRecentGo_Click" />
    <br />
    Show all orders created between
    <asp:TextBox ID="startDateTextBox" runat="server" Width="72px" />
    and
    <asp:TextBox ID="endDateTextBox" runat="server" Width="72px" />
    <asp:Button ID="byDateGo" runat="server"
      CssClass="AdminButtonText" Text="Go" 
      OnClick="byDateGo_Click" />
    <br />
    Show all orders awaiting stock check
    <asp:Button ID="awaitingStockGo" runat="server"
      CssClass="AdminButtonText" Text="Go"
      OnClick="awaitingStockGo_Click" />
    <br />
    Show all orders awaiting shipment
    <asp:Button ID="awaitingShippingGo" runat="server"
      CssClass="AdminButtonText" Text="Go" 
      OnClick="awaitingShippingGo_Click" />
    <br />
    <asp:Label ID="errorLabel" runat="server" CssClass="AdminErrorText" EnableViewState="False"></asp:Label>
    <asp:RangeValidator ID="startDateValidator" runat="server" ControlToValidate="startDateTextBox"
      Display="None" ErrorMessage="Invalid start date" MaximumValue="1/1/2009" MinimumValue="1/1/1999"
      Type="Date"></asp:RangeValidator>
    <asp:RangeValidator ID="endDateValidator" runat="server" ControlToValidate="endDateTextBox"
      Display="None" ErrorMessage="Invalid end date" MaximumValue="1/1/2009" MinimumValue="1/1/1999"
      Type="Date"></asp:RangeValidator>
    <asp:CompareValidator ID="compareDatesValidator" runat="server" ControlToCompare="endDateTextBox"
      ControlToValidate="startDateTextBox" Display="None" ErrorMessage="Start date should be more recent than end date"
      Operator="LessThan" Type="Date"></asp:CompareValidator><br />
    <asp:ValidationSummary ID="ValidationSummary1" runat="server" CssClass="AdminErrorText"
      HeaderText="Please fix these errors before submitting requests:" />
    <br />
    <asp:GridView ID="grid" runat="server" AutoGenerateColumns="False" DataKeyNames="OrderID" OnSelectedIndexChanged="grid_SelectedIndexChanged">
      <Columns>
        <asp:BoundField DataField="OrderID" HeaderText="Order ID"
           ReadOnly="True" SortExpression="OrderID" />
        <asp:BoundField DataField="DateCreated"
          HeaderText="Date Created" ReadOnly="True"
          SortExpression="DateCreated" />
        <asp:BoundField DataField="DateShipped"
          HeaderText="Date Shipped" ReadOnly="True"
          SortExpression="DateShipped" />
        <asp:BoundField DataField="StatusAsString" HeaderText="Status"
          ReadOnly="True" SortExpression="StatusAsString" />
        <asp:BoundField DataField="CustomerName"
          HeaderText="Customer Name" ReadOnly="True"
          SortExpression="CustomerName" />
        <asp:ButtonField CommandName="Select" Text="Select" />
      </Columns>
    </asp:GridView>
    <br />
    <uc1:OrderDetailsAdmin id="orderDetailsAdmin" runat="server">
    </uc1:OrderDetailsAdmin>
  </span>
</asp:Content>
