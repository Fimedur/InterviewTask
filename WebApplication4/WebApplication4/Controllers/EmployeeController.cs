using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Mvc;
using WebApplication4.Models;
using iTextSharp.text;
using iTextSharp.text.pdf;
using iTextSharp.tool.xml;
using iTextSharp.text.html.simpleparser;

namespace WebApplication4.Controllers
{
    
    public class EmployeeController : Controller
    {
        TestDb2Entities db = new TestDb2Entities();
        public ActionResult AllEmployeeDetails(string id)          
        {
            //string x = id;
 
           int  rId = Convert.ToInt32(id);

            var nID = (from m in db.Maps
                       where m.Id == rId
                       select new
                       {
                           m.RootManagerID
                       }).FirstOrDefault();
            int X = 0;
            if (nID != null)
            {
                 X = Convert.ToInt32(nID.RootManagerID);
            }
            
            var item = db.View_2.Where(v => v.RootManagerID == X).ToList();
            return View(item);
        }

        // Exel Export

        [HttpPost]
        [ValidateInput(false)]
        public FileResult Export(string GridHtml)
        {
            string name = DateTime.Now.ToString("dd-MM-yyyy");
            return File(Encoding.ASCII.GetBytes(GridHtml), "application/vnd.ms-excel", "" + name + ".xls");
        }

        //PDF export 

        [HttpPost]
        [ValidateInput(false)]
        public FileResult ExportPdf(string GridHtml)
        {
            string name = DateTime.Now.ToString("dd-MM-yyyy");

            using (MemoryStream stream = new System.IO.MemoryStream())
            {
                StringReader sr = new StringReader(GridHtml);
                Document pdfDoc = new Document(PageSize.A4.Rotate(), 10f, 10f, 100f, 0f);
                PdfWriter writer = PdfWriter.GetInstance(pdfDoc, stream);
                pdfDoc.Open();
                XMLWorkerHelper.GetInstance().ParseXHtml(writer, pdfDoc, sr);
                pdfDoc.Close();
                return File(stream.ToArray(), "application/pdf", "" + name + ".pdf");
            }
        }
    }
}