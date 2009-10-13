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

public partial class OrderPlaced : System.Web.UI.Page
{
  protected override void OnInit(EventArgs e)
  {
    (Master as BalloonShop).EnforceSSL = true;
    base.OnInit(e);
  }

  protected void Page_Load(object sender, EventArgs e)
  {
    // Set the title of the page
    this.Title = BalloonShopConfiguration.SiteName +
                  " : Order Placed";
  }
}
