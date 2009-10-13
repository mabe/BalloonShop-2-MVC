<%@ Control Language="C#" AutoEventWireup="true" CodeFile="OrderDetailsAdmin.ascx.cs" Inherits="OrderDetailsAdmin" %>
<asp:Label ID="orderIdLabel" runat="server" 
           CssClass="AdminTitle" Text="Order #000" />
<br /><br />
<table class="AdminPageText">
  <tr>
    <td width="130">Total Cost:</td>
    <td><asp:Label ID="totalCostLabel" runat="server"
        CssClass="ProductPrice" /></td>
  </tr>
  <tr>
    <td width="130">Date Created:</td>
    <td><asp:TextBox ID="dateCreatedTextBox" runat="server"
        Width="400px" enabled="false" /></td>
  </tr>
  <tr>
    <td width="130">Date Shipped:</td>
    <td><asp:TextBox ID="dateShippedTextBox" runat="server"
        Width="400px" /></td>
  </tr>
  <tr>
    <td width="130">Status:</td>
    <td><asp:DropDownList ID="statusDropDown" runat="server" /></td>
  </tr>
  <tr>
    <td width="130">Authorization Code:</td>
    <td><asp:TextBox ID="authCodeTextBox" runat="server"
        Width="400px" /></td>
  </tr>
  <tr>
    <td width="130">Reference Number:</td>
    <td><asp:TextBox ID="referenceTextBox" runat="server"
        Width="400px" /></td>
  </tr>
  <tr>
    <td width="130">Comments:</td>
    <td><asp:TextBox ID="commentsTextBox" runat="server"
        Width="400px" /></td>
  </tr>
  <tr>
    <td width="130">Customer Name:</td>
    <td><asp:TextBox ID="customerNameTextBox" runat="server"
        Width="400px" enabled="false" /></td>
  </tr>
  <tr valign="top">
    <td width="130">Shipping Address:</td>
    <td><asp:TextBox ID="shippingAddressTextBox" runat="server"
        Width="400px" Height="200px" TextMode="MultiLine"
        enabled="false" /></td>
  </tr>
  <tr valign="top">
    <td width="130">Shipping Type:</td>
    <td><asp:TextBox ID="shippingTypeTextBox" runat="server"
        Width="400px" enabled="false" /></td>
  </tr>
  <tr>
    <td width="130">Customer Email:</td>
    <td><asp:TextBox ID="customerEmailTextBox" runat="server"
        Width="400px" enabled="false" /></td>
  </tr>
</table>
<br />
<asp:Button ID="editButton" runat="server" CssClass="AdminButtonText"
  Text="Edit" Width="100px" OnClick="editButton_Click" />
<asp:Button ID="updateButton" runat="server"
  CssClass="AdminButtonText" Text="Update" Width="100px"
  OnClick="updateButton_Click" />
<asp:Button ID="cancelButton" runat="server"
  CssClass="AdminButtonText" Text="Cancel" Width="100px"
  OnClick="cancelButton_Click" />
<br />
<asp:Button ID="processOrderButton" runat="server"
  CssClass="AdminButtonText" Text="Process Order"
  Width="310px" OnClick="processOrderButton_Click" />
<br />
<asp:Button ID="cancelOrderButton" runat="server"
  CssClass="AdminButtonText" Text="Cancel Order"
  Width="310px" OnClick="cancelOrderButton_Click" />
<br />
<asp:Label ID="Label13" runat="server" CssClass="AdminPageText" Text="The order contains these items:" />
<br />
<asp:GridView ID="grid" runat="server" AutoGenerateColumns="False" 
BackColor="White" Width="100%">
  <Columns>
    <asp:BoundField DataField="ProductID" HeaderText="Product ID" 
                    ReadOnly="True" SortExpression="ProductID" />
    <asp:BoundField DataField="ProductName" HeaderText="Product Name" 
                    ReadOnly="True" SortExpression="ProductName" />
    <asp:BoundField DataField="Quantity" HeaderText="Quantity" 
                    ReadOnly="True" SortExpression="Quantity" />
    <asp:BoundField DataField="UnitCost" HeaderText="Unit Cost" 
                    ReadOnly="True" SortExpression="UnitCost" />
    <asp:BoundField DataField="Subtotal" HeaderText="Subtotal" 
                    ReadOnly="True" SortExpression="Subtotal" />
  </Columns>
</asp:GridView>
<asp:Label ID="Label1" runat="server" CssClass="AdminPageText"
  Text="Order audit trail:" />
<br />
<asp:GridView ID="auditGrid" runat="server"
  AutoGenerateColumns="False" BackColor="White"
  BorderColor="#E7E7FF" BorderStyle="None" BorderWidth="1px"
  CellPadding="3" GridLines="Horizontal" Width="100%">
  <FooterStyle BackColor="#B5C7DE" ForeColor="#4A3C8C" />
  <RowStyle BackColor="#E7E7FF" ForeColor="#4A3C8C" />
  <Columns>
    <asp:BoundField DataField="AuditID" HeaderText="Audit ID"
      ReadOnly="True" SortExpression="AuditID" />
    <asp:BoundField DataField="DateStamp" HeaderText="Date Stamp"
      ReadOnly="True" SortExpression="DateStamp" />
    <asp:BoundField DataField="MessageNumber"
      HeaderText="Message Number" ReadOnly="True"
      SortExpression="MessageNumber" />
    <asp:BoundField DataField="Message" HeaderText="Message"
      ReadOnly="True" SortExpression="Message" />
  </Columns>
  <PagerStyle BackColor="#E7E7FF" ForeColor="#4A3C8C"
    HorizontalAlign="Right" />
  <SelectedRowStyle BackColor="#738A9C" Font-Bold="True"
    ForeColor="#F7F7F7" />
  <HeaderStyle BackColor="#4A3C8C" Font-Bold="True"
    ForeColor="#F7F7F7" />
  <AlternatingRowStyle BackColor="#F7F7F7" />
</asp:GridView>
