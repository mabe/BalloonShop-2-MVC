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
using System.Text;
using SecurityLib;

public partial class SecurityLibTester2 : System.Web.UI.Page
{
  protected void Page_Load(object sender, EventArgs e)
  {

  }

  protected void processButton_Click(object sender, EventArgs e)
  {
    string stringToEncrypt = encryptBox.Text;
    string stringToDecrypt = decryptBox.Text;
    string encryptedString =
      StringEncryptor.Encrypt(stringToEncrypt);
    if (stringToDecrypt == "")
    {
      stringToDecrypt = encryptedString;
    }
    string decryptedString =
      StringEncryptor.Decrypt(stringToDecrypt);

    StringBuilder sb = new StringBuilder();
    sb.Append("Encrypted data: ");
    sb.Append(encryptedString);
    sb.Append("<br />Decrypted data: ");
    sb.Append(decryptedString);
    result.Text = sb.ToString();
  }
}
