using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using WebApplication4.Models;

namespace WebApplication4.Controllers
{
    
    public class ManagerController : Controller
    {
        TestDb2Entities db = new TestDb2Entities();
        // GET: Manager
        public ActionResult Index()
        {
            return View();
        }

       [HttpPost]
        public ActionResult AddManager(tblManagerMap mg)
        {
            try
            {
                return Json(new{ msg = "Successfully added " + mg.Id},JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
    }
}