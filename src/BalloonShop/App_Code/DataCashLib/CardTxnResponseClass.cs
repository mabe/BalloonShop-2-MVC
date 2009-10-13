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
  public class CardTxnResponseClass
  {
    [XmlElement("card_scheme")]
    public string CardScheme;

    [XmlElement("country")]
    public string Country;

    [XmlElement("issuer")]
    public string Issuer;

    [XmlElement("authcode")]
    public string AuthCode;
  }
}
