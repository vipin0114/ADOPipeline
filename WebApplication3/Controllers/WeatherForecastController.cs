using Azure.Identity;
using Azure.Messaging.EventHubs;
using Azure.Messaging.EventHubs.Producer;
using Microsoft.AspNetCore.Mvc;
using System.Text;

namespace WebApplication2.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class WeatherForecastController : ControllerBase
    {
        private readonly ILogger<WeatherForecastController> _logger;

        public WeatherForecastController(ILogger<WeatherForecastController> logger)
        {
            _logger = logger;
        }

        [HttpGet(Name = "GetWeatherForecast")]
        public async Task<IActionResult> Get([FromQuery] bool isDelta)
        {
            if (isDelta)
            {
                var model = new ResponseModel { Id = 1, Name = "Success" };
                return Ok(model);
            }

            int numOfEvents = 100;
            await using var producerClient = new EventHubProducerClient(
                "myeventhubvipin.servicebus.windows.net",
                "eventhub0114",
                new DefaultAzureCredential());

            using EventDataBatch eventBatch = await producerClient.CreateBatchAsync();

            for (int i = 1; i <= numOfEvents; i++)
            {
                if (!eventBatch.TryAdd(new EventData(Encoding.UTF8.GetBytes($"Event {i}"))))
                {
                    throw new Exception($"Event {i} is too large for the batch and cannot be sent.");
                }
            }

            await producerClient.SendAsync(eventBatch);
            return NoContent();
        }

        [HttpGet("hello")]
        public string GetHello()
        {
            return "Hello World!";
        }
    }

    public class ResponseModel
    {
        public int Id { get; set; }
        public string Name { get; set; }
    }
}
