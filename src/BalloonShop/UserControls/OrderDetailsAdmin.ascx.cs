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
using CommerceLib;

public partial class OrderDetailsAdmin : System.Web.UI.UserControl
{
  // edit mode by default is false
  private bool editMode = false;

  protected void Page_Load(object sender, EventArgs e)
  {
    // populate statuses if necessary
    if (!IsPostBack)
    {
      for (int index = 0; index <
        CommerceLibAccess.OrderStatuses.Length; index++)
      {
        statusDropDown.Items.Add(
          new ListItem(CommerceLibAccess.OrderStatuses[index],
          index.ToString()));
      }
    }
  }

  // set up the form
  protected void Page_PreRender(object sender, EventArgs e)
  {
    // check if we must display order details       
    if (Session["AdminOrderID"] != null)
    {
      // fill constituent controls with data
      PopulateControls();
      // set edit mode
      SetEditMode(editMode);
    }
    else
    {
      this.Visible = false;
    }
  }

  // populate the form with data
  private void PopulateControls()
  {
    // obtain order ID from the session
    string orderId = Session["AdminOrderID"].ToString();
    // obtain order info
    CommerceLibOrderInfo orderInfo =
      CommerceLibAccess.GetOrder(orderId);
    // populate labels and text boxes with order info
    orderIdLabel.Text = "Displaying Order #" + orderId;
    totalCostLabel.Text = String.Format("{0:c} ",
      orderInfo.TotalCost);
    dateCreatedTextBox.Text = orderInfo.DateCreated.ToString();
    dateShippedTextBox.Text = orderInfo.DateShipped.ToString();
    statusDropDown.SelectedIndex = orderInfo.Status;
    authCodeTextBox.Text = orderInfo.AuthCode;
    referenceTextBox.Text = orderInfo.Reference;
    commentsTextBox.Text = orderInfo.Comments;
    customerNameTextBox.Text = orderInfo.CustomerName;
    shippingAddressTextBox.Text = orderInfo.CustomerAddressAsString;
    shippingTypeTextBox.Text = orderInfo.Shipping.ShippingType;
    customerEmailTextBox.Text = orderInfo.Customer.Email;
    // Decide which one of the buttons should
    // be enabled and which should be disabled
    switch (orderInfo.Status)
    {
      case 8:
      case 9:
        // if the order was canceled or completed...
        processOrderButton.Text = "Process Order";
        processOrderButton.Enabled = false;
        cancelOrderButton.Enabled = false;
        break;
      case 3:
        // if the order is awaiting a stock check...
        processOrderButton.Text = "Confirm Stock for Order";
        processOrderButton.Enabled = true;
        cancelOrderButton.Enabled = true;
        break;
      case 6:
        // if the order is awaiting shipment...
        processOrderButton.Text = "Confirm Order Shipment";
        processOrderButton.Enabled = true;
        cancelOrderButton.Enabled = true;
        break;
      default:
        // otherwise...
        processOrderButton.Text = "Process Order";
        processOrderButton.Enabled = true;
        cancelOrderButton.Enabled = true;
        break;
    }
    // fill the data grid with order details
    grid.DataSource = orderInfo.OrderDetails;
    grid.DataBind();

    // fill the audit data grid with audit trail
    auditGrid.DataSource = orderInfo.AuditTrail;
    auditGrid.DataBind();
  }

  // enable or disable edit mode
  private void SetEditMode(bool enable)
  {
    dateShippedTextBox.Enabled = enable;
    statusDropDown.Enabled = enable;
    authCodeTextBox.Enabled = enable;
    referenceTextBox.Enabled = enable;
    commentsTextBox.Enabled = enable;
    editButton.Enabled = !enable;
    updateButton.Enabled = enable;
    cancelButton.Enabled = enable;
  }

  // enter edit mode
  protected void editButton_Click(object sender, EventArgs e)
  {
    editMode = true;
  }

  // cancel edit mode
  protected void cancelButton_Click(object sender, EventArgs e)
  {
    // don't need to do anything, editMode will be set to false by default
  }

  // update order information
  protected void updateButton_Click(object sender, EventArgs e)
  {
    try
    {
      // Get new order data
      int orderID = int.Parse(Session["AdminOrderID"].ToString());
      string dateCreated = dateCreatedTextBox.Text;
      string dateShipped = dateShippedTextBox.Text;
      int status = int.Parse(statusDropDown.SelectedValue);
      string authCode = authCodeTextBox.Text;
      string reference = referenceTextBox.Text;
      string comments = commentsTextBox.Text;
      // Update the order
      CommerceLibAccess.UpdateOrder(orderID, dateCreated,
        dateShipped, status, authCode, reference, comments);
    }
    catch
    {
      // In case of an error, we simply ignore it
    }
    // Exit edit mode and populate the form again
    SetEditMode(false);
    PopulateControls();
    Page.DataBind();
  }

  // continue order processing
  protected void processOrderButton_Click(object sender, EventArgs e)
  {
    string orderId = Session["AdminOrderID"].ToString();
    OrderProcessor processor = new OrderProcessor(orderId);
    processor.Process();
    PopulateControls();
  }

  // cancel order
  protected void cancelOrderButton_Click(object sender, EventArgs e)
  {
    string orderId = Session["AdminOrderID"].ToString();
    CommerceLibAccess.UpdateOrderStatus(int.Parse(orderId), 9);
    PopulateControls();
  }
}
