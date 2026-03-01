using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ATAW.Application.DTOs
{
    public class RegisterRiderDto
    {
        public required string FullName { get; set; }
        public required string Phone { get; set; }
        public required string DrivingLicense { get; set; }
    }
}
