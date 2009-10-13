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
  public class TxnDetailsClass
  {
    [XmlElement("merchantreference")]
    public string MerchantReference;

    [XmlElement("amount")]
    public AmountClass Amount = new AmountClass();
  }
}