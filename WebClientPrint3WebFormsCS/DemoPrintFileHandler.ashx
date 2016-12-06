<%@ WebHandler Language="C#" Class="DemoPrintFileHandler" %>

using System;
using System.Web;

    using Neodynamic.SDK.Web;

public class DemoPrintFileHandler : IHttpHandler {
    
    /*############### IMPORTANT!!! ############
    If your website requires AUTHENTICATION, then you MUST configure THIS Handler file
    to be ANONYMOUS access allowed!!!
      ######################################### */

    public void ProcessRequest (HttpContext context) {

        if (WebClientPrint.ProcessPrintJob(context.Request.Url.Query))
        {
            bool useDefaultPrinter = (context.Request["useDefaultPrinter"] == "checked");
            string printerName = context.Server.UrlDecode(context.Request["printerName"]);

            string fileName = Guid.NewGuid().ToString("N") + "." + context.Request["filetype"];
            string filePath = null;
            switch (context.Request["filetype"])
            {
                case "PDF":
                    filePath = "~/files/LoremIpsum.pdf";
                    break;
                case "TXT":
                    filePath = "~/files/LoremIpsum.txt";
                    break;
                case "DOC":
                    filePath = "~/files/LoremIpsum.doc";
                    break;
                case "XLS":
                    filePath = "~/files/SampleSheet.xls";
                    break;
                case "JPG":
                    filePath = "~/files/penguins300dpi.jpg";
                    break;
                case "PNG":
                    filePath = "~/files/SamplePngImage.png";
                    break;
                case "TIF":
                    filePath = "~/files/patent2pages.tif";
                    break;
            }

            if (filePath != null)
            {
                PrintFile file = new PrintFile(context.Server.MapPath(filePath), fileName);
                ClientPrintJob cpj = new ClientPrintJob();
                cpj.PrintFile = file;
                if (useDefaultPrinter || printerName == "null")
                    cpj.ClientPrinter = new DefaultPrinter();
                else
                    cpj.ClientPrinter = new InstalledPrinter(printerName);
                
                context.Response.ContentType = "application/octet-stream";
                context.Response.BinaryWrite(cpj.GetContent());
                context.Response.End();
            }

            
        }
        
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }

}