using ATAW.Application.DTOs;
using ATAW.Application.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ATAWApp.Api.Controllers
{
    [ApiController]
    [Route("api/riders")]
    public class RiderController : ControllerBase
    {
        private readonly RiderService _service;

        public RiderController(RiderService service)
        {
            _service = service;
        }

        [HttpPost("register")]
        [Authorize(Roles = "Rider")]
        public async Task<IActionResult> Register(RegisterRiderDto dto)
        {
            await _service.RegisterAsync(dto);
            return Ok();
        }

        [HttpPut("{id}/availability")]
        public async Task<IActionResult> UpdateAvailability(Guid id, bool available)
        {
            await _service.UpdateAvailability(id, available);
            return Ok();
        }

        [HttpPut("{id}/location")]
        public async Task<IActionResult> UpdateLocation(Guid id, double lat, double lng)
        {
            await _service.UpdateLocation(id, lat, lng);
            return Ok();
        }
    }
}
