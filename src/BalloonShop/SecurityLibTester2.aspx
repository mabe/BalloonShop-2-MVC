<%@ Page Language="C#" MasterPageFile="~/BalloonShop.master" AutoEventWireup="true"
  CodeFile="SecurityLibTester2.aspx.cs" Inherits="SecurityLibTester2" Title="SecurityLib Test Page 2" %>

<asp:Content ID="Content1" ContentPlaceHolderID="contentPlaceHolder" runat="Server">
  Enter data to encrypt:<br />
  <asp:TextBox ID="encryptBox" runat="server" />
  <br />
  Enter data to decrypt:<br />
  <asp:TextBox ID="decryptBox" runat="server" />
  <br />
  <asp:Button ID="processButton" runat="server" Text="Process" OnClick="processButton_Click" />
  <br />
  <asp:Label ID="result" runat="server" />
</asp:Content>
