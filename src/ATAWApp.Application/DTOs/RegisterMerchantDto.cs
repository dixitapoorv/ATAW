using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ATAW.Application.DTOs
{
    public class RegisterMerchantDto
    {
        public Guid OwnerId { get; set; }
        public Guid VerticalId { get; set; }
        public required string Name { get; set; }
        public required string Phone { get; set; }
        public required string GstNumber { get; set; }
    }
}
