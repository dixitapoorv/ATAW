using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ATAWApp.Application.DTOs
{
    public class UserDto
    {
        public Guid Id { get; set; }
        public string Full_Name { get; set; }
        public string Phone { get; set; }
        public string Password_Hash { get; set; }
        public string Role { get; set; }
    }
}
