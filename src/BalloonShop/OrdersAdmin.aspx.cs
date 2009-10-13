using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Collections.Generic;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;

public partial class OrdersAdmin : System.Web.UI.Page
{
  protected void Page_Load(object sender, EventArgs e)
  {
    // Set the title of the page
    this.Title = BalloonShopConfiguration.SiteName +
                  " : Orders Admin";
    // associate the check boxes with their buttons
    Utilities.TieButton(this.Page, orderIDBox, byIDGo);
    Utilities.TieButton(this.Page, recentCountTextBox, byRecentGo);
    Utilities.TieButton(this.Page, startDateTextBox, byDateGo);
    Utilities.TieButton(this.Page, endDateTextBox, byDateGo);
  }

  // Display orders by customer
  protected void byCustomerGo_Click(object sender, EventArgs e)
  {
    try
    {
      List<CommerceLibOrderInfo> orders =
        CommerceLibAccess.GetOrdersByCustomer(
        userDropDown.SelectedValue);
      grid.DataSource = orders;
      if (orders.Count == 0)
      {
        errorLabel.Text =
          "<br />Selected customer has made no orders.";
      }
    }
    catch
    {
      errorLabel.Text = "<br />Couldn't get the requested orders!";
    }
    finally
    {
      grid.DataBind();
    }
  }

  // Display single order only
  protected void byIDGo_Click(object sender, EventArgs e)
  {
    try
    {
      // clear order list with empty order list
      List<CommerceLibOrderInfo> orders =
        new List<CommerceLibOrderInfo>();
      grid.DataSource = orders;
      // Save the ID of the selected order in the session
      Session["AdminOrderID"] = orderIDBox.Text;
      // Display the order details admin control
      orderDetailsAdmin.Visible = true;
    }
    catch
    {
      errorLabel.Text = "<br />Couldn't get the requested order!";
    }
    finally
    {
      grid.DataBind();
    }
  }

  // Display the most recent orders
  protected void byRecentGo_Click(object sender, EventArgs e)
  {
    try
    {
      int recordCount = Int32.Parse(recentCountTextBox.Text);
      List<CommerceLibOrderInfo> orders =
        CommerceLibAccess.GetOrdersByRecent(recordCount);
      grid.DataSource = orders;
      if (orders.Count == 0)
      {
        errorLabel.Text = "<br />No orders to get.";
      }
    }
    catch
    {
      errorLabel.Text = "<br />Couldn't get the requested orders!";
    }
    finally
    {
      grid.DataBind();
    }
  }

  // Display orders that happened in a specified period of time
  protected void byDateGo_Click(object sender, EventArgs e)
  {
    try
    {
      string startDate = startDateTextBox.Text;
      string endDate = endDateTextBox.Text;
      List<CommerceLibOrderInfo> orders =
        CommerceLibAccess.GetOrdersByDate(startDate, endDate);
      grid.DataSource = orders;
      if (orders.Count == 0)
      {
        errorLabel.Text =
          "<br />No orders between selected dates.";
      }
    }
    catch
    {
      errorLabel.Text = "<br />Couldn't get the requested orders!";
    }
    finally
    {
      grid.DataBind();
    }
  }

  // Display orders awaiting stock
  protected void awaitingStockGo_Click(object sender, EventArgs e)
  {
    try
    {
      List<CommerceLibOrderInfo> orders =
        CommerceLibAccess.GetOrdersByStatus(3);
      grid.DataSource = orders;
      if (orders.Count == 0)
      {
        errorLabel.Text = "<br />No orders awaiting stock check.";
      }
    }
    catch
    {
      errorLabel.Text = "<br />Couldn't get the requested orders!";
    }
    finally
    {
      grid.DataBind();
    }
  }

  // Display orders awaiting shipping
  protected void awaitingShippingGo_Click(object sender, EventArgs e)
  {
    try
    {
      List<CommerceLibOrderInfo> orders =
        CommerceLibAccess.GetOrdersByStatus(6);
      grid.DataSource = orders;
      if (orders.Count == 0)
      {
        errorLabel.Text = "<br />No orders awaiting shipment.";
      }
    }
    catch
    {
      errorLabel.Text = "<br />Couldn't get the requested orders!";
    }
    finally
    {
      grid.DataBind();
    }
  }

  // Load the details of the selected order
  protected void grid_SelectedIndexChanged(object sender, EventArgs e)
  {
    // Save the ID of the selected order in the session
    Session["AdminOrderID"] = grid.DataKeys[grid.SelectedIndex].Value.ToString();

    // Display order if it's not already being displayed
    orderDetailsAdmin.Visible = true;
  }
}
