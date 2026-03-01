using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ATAW.Application.DTOs
{
    public class LoginDto
    {
        public required string Phone { get; set; }
        public required string Password { get; set; }
    }
}
