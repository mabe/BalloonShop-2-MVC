<%@ Control Language="C#" AutoEventWireup="true" CodeFile="AmazonProductsList.ascx.cs"
  Inherits="AmazonProductsList" %>
<asp:DataList ID="list" runat="server" RepeatColumns="2" EnableViewState="False">
  <ItemTemplate>
    <table height="100" cellpadding="0" align="left">
      <tr>
        <td valign="top" align="center" width="110">
          <img src='<%# Eval("ProductImageUrl") %>' border="0" />
        </td>
        <td valign="top" width="250">
          <span class="ProductDescription">
            <%# Eval("ProductName") %>
            <br />
            Price: </span><span class="ProductPrice">
            <%# Eval("ProductPrice") %>
            <br /><br />
            <%--<a target="_blank" href="http://www.amazon.com/exec/obidos/ASIN/<%# Eval("ASIN") %>/ref=nosim/<%# BalloonShopConfiguration.AssociateId %>">
                Buy From Amazon 
            </a>--%>
          </span>
        </td>
      </tr>
    </table>
  </ItemTemplate>
</asp:DataList>
