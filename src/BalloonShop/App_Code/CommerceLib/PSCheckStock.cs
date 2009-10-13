using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.Text;

namespace CommerceLib
{
  /// <summary>
  /// 3rd pipeline stage – used to send a notification email to
  /// the supplier, asking whether goods are available
  /// </summary>
  public class PSCheckStock : IPipelineSection
  {
    private OrderProcessor orderProcessor;

    public void Process(OrderProcessor processor)
    {
      // set processor reference
      orderProcessor = processor;
      // audit
      orderProcessor.CreateAudit("PSCheckStock started.", 20200);

      try
      {
        // send mail to supplier
        orderProcessor.MailSupplier("BalloonShop stock check.",
          GetMailBody());
        // audit
        orderProcessor.CreateAudit(
          "Notification e-mail sent to supplier.", 20202);
        // update order status
        orderProcessor.Order.UpdateStatus(3);
      }
      catch
      {
        // mail sending failure
        throw new OrderProcessorException(
          "Unable to send e-mail to supplier.", 2);
      }
      // audit
      processor.CreateAudit("PSCheckStock finished.", 20201);
    }

    private string GetMailBody()
    {
      // construct message body
      StringBuilder sb = new StringBuilder();
      sb.Append("The following goods have been ordered:\n\n");
      sb.Append(orderProcessor.Order.OrderAsString);
      sb.Append("\n\nPlease check availability and confirm via ");
      sb.Append("http://balloonshop.apress.com/OrdersAdmin.aspx");
      sb.Append("\n\nOrder reference number:\n\n");
      sb.Append(orderProcessor.Order.OrderID.ToString());
      return sb.ToString();
    }
  }
}