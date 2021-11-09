using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Mvc;
using WebApplication4.Models;

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
            return File(Encoding.ASCII.GetBytes(GridHtml), "application/vnd.ms-excel", ""+name+".xls");
        }
    }
}