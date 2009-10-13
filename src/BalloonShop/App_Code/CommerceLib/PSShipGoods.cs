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
  /// 6th pipeline stage – used to send a notification email to
  /// the supplier, stating that goods can be shipped
  /// </summary>
  public class PSShipGoods : IPipelineSection
  {
    private OrderProcessor orderProcessor;

    public void Process(OrderProcessor processor)
    {
      // set processor reference
      orderProcessor = processor;
      // audit
      orderProcessor.CreateAudit("PSShipGoods started.", 20500);
      try
      {
        // send mail to supplier
        orderProcessor.MailSupplier("BalloonShop ship goods.",
          GetMailBody());
        // audit
        orderProcessor.CreateAudit(
          "Ship goods e-mail sent to supplier.", 20502);
        // update order status
        orderProcessor.Order.UpdateStatus(6);
      }
      catch
      {
        // mail sending failure
        throw new OrderProcessorException(
          "Unable to send e-mail to supplier.", 5);
      }
      // audit
      processor.CreateAudit("PSShipGoods finished.", 20501);
    }

    private string GetMailBody()
    {
      // construct message body
      StringBuilder sb = new StringBuilder();
      sb.Append(
        "Payment has been received for the following goods:\n\n");
      sb.Append(orderProcessor.Order.OrderAsString);
      sb.Append("\n\nPlease ship to:\n\n");
      sb.Append(orderProcessor.Order.CustomerAddressAsString);
      sb.Append(
        "\n\nWhen goods have been shipped, please confirm via ");
      sb.Append("http://balloonshop.apress.com/OrdersAdmin.aspx");
      sb.Append("\n\nOrder reference number:\n\n");
      sb.Append(orderProcessor.Order.OrderID.ToString());
      return sb.ToString();
    }
  }
}
