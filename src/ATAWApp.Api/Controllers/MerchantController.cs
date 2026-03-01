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
    [Route("api/merchants")]
    public class MerchantController : ControllerBase
    {
        private readonly MerchantService _service;

        public MerchantController(MerchantService service)
        {
            _service = service;
        }

        [Authorize(Roles = "MerchantOwner")]
        [HttpPost("register")]
        public async Task<IActionResult> Register(RegisterMerchantDto dto)
        {
            await _service.RegisterAsync(dto);
            return Ok();
        }

        [Authorize(Roles = "Admin")]
        [HttpPut("{id}/approve")]
        public async Task<IActionResult> Approve(Guid id, bool approve)
        {
            await _service.ApproveAsync(id, approve);
            return Ok();
        }
    }
}
