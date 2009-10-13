<%@ Page Language="C#" MasterPageFile="~/BalloonShop.master" AutoEventWireup="true" CodeFile="Register.aspx.cs" Inherits="Register" %>
<asp:Content ID="Content1" ContentPlaceHolderID="contentPlaceHolder" Runat="Server">
  <asp:LoginView ID="LoginView1" runat="server">
    <LoggedInTemplate>
      <span class="CodeInline"><span lang="EN-US" style="font-size: 10pt; color: #008000;
        font-family: Courier New; mso-fareast-font-family: 'Times New Roman'; mso-bidi-font-family: 'Times New Roman';
        mso-ansi-language: EN-US; mso-fareast-language: EN-US; mso-bidi-language: AR-SA">
        You are already registered.</span></span>
    </LoggedInTemplate>
    <AnonymousTemplate>
      <asp:CreateUserWizard ID="CreateUserWizard1" runat="server" BackColor="#F7F6F3" BorderColor="#E6E2D8"
        BorderStyle="Solid" BorderWidth="1px" CancelDestinationPageUrl="~/Default.aspx"
        ContinueDestinationPageUrl="~/CustomerDetails.aspx" CreateUserButtonText="Sign Up" Font-Names="Verdana"
        Font-Size="0.8em" OnCreatedUser="CreateUserWizard1_CreatedUser" PasswordRegularExpressionErrorMessage="Your password must be at least 6 characters long.">
        <SideBarStyle BackColor="#5D7B9D" BorderWidth="0px" Font-Size="0.9em" VerticalAlign="Top" />
        <SideBarButtonStyle BorderWidth="0px" Font-Names="Verdana" ForeColor="White" />
        <NavigationButtonStyle BackColor="#FFFBFF" BorderColor="#CCCCCC" BorderStyle="Solid"
          BorderWidth="1px" Font-Names="Verdana" ForeColor="#284775" />
        <HeaderStyle BackColor="#5D7B9D" BorderStyle="Solid" Font-Bold="True" Font-Size="0.9em"
          ForeColor="White" HorizontalAlign="Left" />
        <CreateUserButtonStyle BackColor="#FFFBFF" BorderColor="#CCCCCC" BorderStyle="Solid"
          BorderWidth="1px" Font-Names="Verdana" ForeColor="#284775" />
        <ContinueButtonStyle BackColor="#FFFBFF" BorderColor="#CCCCCC" BorderStyle="Solid"
          BorderWidth="1px" Font-Names="Verdana" ForeColor="#284775" />
        <StepStyle BorderWidth="0px" />
        <TitleTextStyle BackColor="#5D7B9D" Font-Bold="True" ForeColor="White" />
        <WizardSteps>
          <asp:CreateUserWizardStep runat="server">
          </asp:CreateUserWizardStep>
          <asp:CompleteWizardStep runat="server">
          </asp:CompleteWizardStep>
        </WizardSteps>
      </asp:CreateUserWizard>
    </AnonymousTemplate>
  </asp:LoginView>
</asp:Content>

