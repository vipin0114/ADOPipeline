using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace WebApplication3.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class HealthController : ControllerBase
    {

        [HttpGet]
        public string health()
        {
            return "API is running "  + DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss");
        }
    }
}
