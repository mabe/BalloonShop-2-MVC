<%@ Page Language="C#" MasterPageFile="~/BalloonShop.master" AutoEventWireup="true"
  CodeFile="Login.aspx.cs" Inherits="Login" %>

<asp:Content ID="Content1" ContentPlaceHolderID="contentPlaceHolder" runat="Server">
  <asp:Login ID="login" runat="server">
    <LayoutTemplate>
      <table border="0" cellpadding="1">
        <tr class="UserInfoText">
          <td>
            <table border="0" cellpadding="0">
              <tr>
                <td class="CatalogTitle" align="left" colspan="2">
                  Who Are You?<br />
                  <br />
                </td>
              </tr>
              <tr>
                <td align="right">
                  <asp:Label ID="UserNameLabel" runat="server" AssociatedControlID="UserName">User Name:</asp:Label></td>
                <td>
                  <asp:TextBox ID="UserName" runat="server"></asp:TextBox>
                  <asp:RequiredFieldValidator ID="UserNameRequired" runat="server" ControlToValidate="UserName"
                    ErrorMessage="User Name is required." ToolTip="User Name is required." ValidationGroup="Login1">*</asp:RequiredFieldValidator>
                </td>
              </tr>
              <tr>
                <td align="right">
                  <asp:Label ID="PasswordLabel" runat="server" AssociatedControlID="Password">Password:</asp:Label></td>
                <td>
                  <asp:TextBox ID="Password" runat="server" TextMode="Password"></asp:TextBox>
                  <asp:RequiredFieldValidator ID="PasswordRequired" runat="server" ControlToValidate="Password"
                    ErrorMessage="Password is required." ToolTip="Password is required." ValidationGroup="Login1">*</asp:RequiredFieldValidator>
                </td>
              </tr>
              <tr>
                <td colspan="2">
                  <asp:CheckBox ID="RememberMe" runat="server" Text="Remember me next time." />
                </td>
              </tr>
              <tr>
                <td align="center" colspan="2" style="color: red">
                  <asp:Literal ID="FailureText" runat="server" EnableViewState="False"></asp:Literal>
                </td>
              </tr>
              <tr>
                <td align="right" colspan="2">
                  <asp:Button ID="LoginButton" runat="server" CommandName="Login" Text="Log In" ValidationGroup="Login1" />
                </td>
              </tr>
            </table>
          </td>
        </tr>
      </table>
      <span class="InfoText">You must be logged in to place an order. If you aren't yet
        registered with the site, click
        <asp:HyperLink runat="server" ID="registerLink" NavigateUrl="~/Register.aspx" Text="here"
          ToolTip="Go to the registration page" CssClass="UserInfoLink" />. </span>
    </LayoutTemplate>
  </asp:Login>
</asp:Content>
