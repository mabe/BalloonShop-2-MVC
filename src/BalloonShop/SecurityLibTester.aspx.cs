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
using System.Text;
using SecurityLib;

public partial class SecurityLibTester : System.Web.UI.Page
{
  protected void Page_Load(object sender, EventArgs e)
  {

  }

  protected void processButton_Click(object sender, EventArgs e)
  {
    string hash1 = PasswordHasher.Hash(pwdBox1.Text);
    string hash2 = PasswordHasher.Hash(pwdBox2.Text);
    StringBuilder sb = new StringBuilder();
    sb.Append("The hash of the first password is: ");
    sb.Append(hash1);
    sb.Append("<br />The hash of the second password is: ");
    sb.Append(hash2);
    if (hash1 == hash2)
    {
      sb.Append("<br />The passwords match! Welcome!");
    }
    else
    {
      sb.Append("<br />Password invalid. "
        + "Armed guards are on their way.");
    }
    result.Text = sb.ToString();
  }
}
