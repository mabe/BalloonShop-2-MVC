using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;

namespace CommerceLib
{
  /// <summary>
  /// Standard interface for pipeline sections
  /// </summary>
  public interface IPipelineSection
  {
    void Process(OrderProcessor processor);
  }
}