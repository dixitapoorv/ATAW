using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ATAW.Application.DTOs
{
    public class CreateOrderDto
    {
        public Guid CustomerId { get; set; }
        public Guid MerchantId { get; set; }
        public Guid VerticalId { get; set; }
        public decimal TotalAmount { get; set; }
        public double Lat { get; set; }
        public double Lng { get; set; }
    }
}
