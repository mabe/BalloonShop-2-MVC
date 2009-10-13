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
  public class CardClass
  {
    [XmlElement("pan")]
    public string CardNumber;

    [XmlElement("expirydate")]
    public string ExpiryDate;

    [XmlElement("startdate")]
    public string StartDate;

    [XmlElement("issuenumber")]
    public string IssueNumber;
  }
}