using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;

public partial class CustomerDetailsEdit : System.Web.UI.UserControl
{
  protected void Page_Load(object sender, EventArgs e)
  {

  }

  public bool Editable
  {
    get
    {
      if (ViewState["editable"] != null)
      {
        return (bool)ViewState["editable"];
      }
      else
      {
        return true;
      }
    }
    set
    {
      ViewState["editable"] = value;
    }
  }

  public string Title
  {
    get
    {
      if (ViewState["title"] != null)
      {
        return ViewState["title"] as string;
      }
      else
      {
        return "Edit User Details";
      }
    }
    set
    {
      ViewState["title"] = value;
    }
  }

  protected override void OnPreRender(EventArgs e)
  {
    // Find and set title text
    Label TitleLabel =
       FormView1.FindControl("TitleLabel") as Label;
    if (TitleLabel != null)
    {
      TitleLabel.Text = Title;
    }

    // Find and set edit button visibility
    Button EditButton =
       FormView1.FindControl("EditButton") as Button;
    if (EditButton != null)
    {
      EditButton.Visible = Editable;
    }
  }
}
