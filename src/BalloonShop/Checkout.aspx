<%@ Page Language="C#" MasterPageFile="~/BalloonShop.master" AutoEventWireup="true"
  CodeFile="Checkout.aspx.cs" Inherits="Checkout" Title="BalloonShop : Checkout" %>

<%@ Register TagPrefix="uc1" TagName="CustomerDetailsEdit" Src="UserControls/CustomerDetailsEdit.ascx" %>
<asp:Content ID="Content1" ContentPlaceHolderID="contentPlaceHolder" runat="Server">
  <asp:Label ID="titleLabel" runat="server" CssClass="ShoppingCartTitle" Text="Your Shopping Cart" />&nbsp;<br />
  <br />
  <asp:GridView ID="grid" runat="server" AutoGenerateColumns="False" DataKeyNames="ProductID"
    BorderWidth="1px" Width="100%">
    <Columns>
      <asp:BoundField DataField="Name" HeaderText="Product Name" ReadOnly="True" SortExpression="Name" />
      <asp:BoundField DataField="Price" DataFormatString="{0:c}" HeaderText="Price" ReadOnly="True"
        SortExpression="Price" />
      <asp:BoundField DataField="Quantity" HeaderText="Quantity" ReadOnly="True" SortExpression="Quantity" />
      <asp:BoundField DataField="Subtotal" DataFormatString="{0:c}" HeaderText="Subtotal"
        ReadOnly="True" SortExpression="Subtotal" />
    </Columns>
  </asp:GridView>
  <asp:Label ID="Label2" runat="server" Text="Total amount: " CssClass="ProductDescription"></asp:Label>
  <asp:Label ID="totalAmountLabel" runat="server" Text="Label" CssClass="ProductPrice"></asp:Label>
  <br />
  <br />
  <uc1:CustomerDetailsEdit ID="CustomerDetailsEdit1" runat="server" Editable="false"
    Title="User Details" />
  <br />
  <asp:Label ID="InfoLabel" runat="server" CssClass="InfoText" />
  <br />
  <br />
  <span class="InfoText">Shipping type: <asp:DropDownList ID="shippingSelection" runat="server" /></span>
  <br />
  <br />
  <asp:Button ID="placeOrderButton" runat="server" CssClass="ButtonText" Text="Place order"
    OnClick="placeOrderButton_Click" />
</asp:Content>
