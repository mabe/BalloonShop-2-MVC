<%@ Control Language="C#" AutoEventWireup="true" CodeFile="DepartmentsList.ascx.cs" Inherits="DepartmentsList" %>
<asp:DataList ID="list" runat="server" Width="200px" CssClass="DepartmentListContent">
  <ItemTemplate>
    &nbsp;&raquo;
    <asp:HyperLink 
      ID="HyperLink1" 
      Runat="server" 
      NavigateUrl='<%# "../Catalog.aspx?DepartmentID=" + Eval("DepartmentID")%>'
      Text='<%# Eval("Name") %>'
      ToolTip='<%# Eval("Description") %>'
      CssClass='<%# Eval("DepartmentID").ToString() == Request.QueryString["DepartmentID"] ? "DepartmentSelected" : "DepartmentUnselected" %>'>
    </asp:HyperLink>
    &nbsp;&laquo;
 </ItemTemplate>
  <HeaderTemplate>
    Choose a Department
  </HeaderTemplate>
  <HeaderStyle CssClass="DepartmentListHead" />
    <FooterTemplate>
    &nbsp;&raquo;
      <a href="AmazonProducts.aspx" 
class='<%# Request.AppRelativeCurrentExecutionFilePath == "~/AmazonProducts.aspx" ? "DepartmentSelected" : "DepartmentUnselected" %>' >
        Amazon Balloons
      </a>
    &nbsp;&laquo; 
  </FooterTemplate>
  <FooterStyle CssClass="DepartmentListContent" />
</asp:DataList>
