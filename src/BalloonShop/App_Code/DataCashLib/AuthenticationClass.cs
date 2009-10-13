using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.Xml.Serialization;

namespace DataCashLib
{
  public class AuthenticationClass
  {
    [XmlElement("password")]
    public string Password;

    [XmlElement("client")]
    public string Client;
  }
}
