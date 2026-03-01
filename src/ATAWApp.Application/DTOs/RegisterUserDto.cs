using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ATAW.Application.DTOs
{
    public class RegisterUserDto
    {
        public required string FullName { get; set; }
        public required string Phone { get; set; }
        public required string Password { get; set; }
        public required string Role { get; set; } // Admin, MerchantOwner, Rider, Customer
    }
}
