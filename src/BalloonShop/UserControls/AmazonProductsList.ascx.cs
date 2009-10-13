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

public partial class AmazonProductsList : System.Web.UI.UserControl
{
  protected void Page_Load(object sender, EventArgs e)
  {
    if (!IsPostBack)
    {
      // fill the DataList with Amazon products. Calling any of
      // GetAmazonDataWithRest or GetAmazonDataWithSoap should return
      // the same results
	  //list.DataSource = AmazonAccess.GetAmazonDataWithRest();
	  //list.DataBind();
    }
  }
}
