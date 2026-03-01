using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ATAW.Application.DTOs
{
    public class AuthResponseDto
    {
        public required string Token { get; set; }
        public required string Role { get; set; }
    }
}
