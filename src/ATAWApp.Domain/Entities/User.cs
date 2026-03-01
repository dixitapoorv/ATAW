using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ATAW.Domain.Entities
{
    public class User
    {
        public Guid Id { get; set; }
        public required string FullName { get; set; }
        public required string Phone { get; set; }
        public required string PasswordHash { get; set; }
        public required string Role { get; set; }
    }
}
