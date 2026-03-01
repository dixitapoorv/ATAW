using ATAW.Application.DTOs;
using ATAW.Application.Services;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.InteropServices;
using System.Text;
using System.Threading.Tasks;

namespace ATAWApp.Api.Controllers
{
    [ApiController]
    [Route("api/admin/verticals")]
    public class VerticalController : ControllerBase
    {
        private readonly VerticalService _service;

        public VerticalController(VerticalService service)
        {
            _service = service;
        }

        [HttpPost]
        public async Task<IActionResult> Create(CreateVerticalDto dto)
        {
            await _service.CreateAsync(dto);
            return Ok();
        }
    }
}
