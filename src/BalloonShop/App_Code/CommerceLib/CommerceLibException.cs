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
  /// Standard exception for order processor
  /// </summary>
  public class OrderProcessorException : ApplicationException
  {
    private int sourceStage;

    public OrderProcessorException(string message,
      int exceptionSourceStage)
      : base(message)
    {
      sourceStage = exceptionSourceStage;
    }

    public int SourceStage
    {
      get
      {
        return sourceStage;
      }
    }
  }
}