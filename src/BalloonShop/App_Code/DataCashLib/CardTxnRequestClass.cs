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
  public class CardTxnRequestClass
  {
    [XmlElement("method")]
    public string Method;

    [XmlElement("Card")]
    public CardClass Card = new CardClass();
  }
}