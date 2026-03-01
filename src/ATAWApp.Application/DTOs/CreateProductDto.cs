using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ATAW.Application.DTOs
{
    public class CreateProductDto
    {
        public Guid VerticalId { get; set; }
        public Guid CategoryId { get; set; }
        public Guid SubCategoryId { get; set; }
        public required string Name { get; set; }
        public required string Description { get; set; }
    }
}
