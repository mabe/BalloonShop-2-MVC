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

public partial class Admin : System.Web.UI.MasterPage
{
  protected override void OnInit(EventArgs e)
  {
    if (!Request.IsSecureConnection)
    {
      Response.Redirect(Request.Url.AbsoluteUri.ToLower().Replace(
        "http://", "https://"), true);
    }
    base.OnInit(e);
  }

  protected void Page_Load(object sender, EventArgs e)
  {
  }
}
