<%@ Page Language="C#" MasterPageFile="~/BalloonShop.master" AutoEventWireup="true" CodeFile="AmazonProducts.aspx.cs" Inherits="AmazonProducts" Title="Balloons from Amazon"  %>

<%@ Register Src="UserControls/AmazonProductsList.ascx" TagName="AmazonProductsList"
  TagPrefix="uc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="contentPlaceHolder" Runat="Server">
  <span class="CatalogTitle">Balloons From Amazon</span>
  <br />
  <span class="CatalogDescription">Browse these wonderful balloons that Amazon.com offers: 
    <br />
  </span>
  <br />
  <uc1:AmazonProductsList id="AmazonProductsList1" runat="server">
  </uc1:AmazonProductsList>
</asp:Content>

