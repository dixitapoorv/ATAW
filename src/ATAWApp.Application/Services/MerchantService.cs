using ATAW.Application.DTOs;
using ATAW.Infrastructure.Data;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ATAW.Application.Services
{
    public class MerchantService
    {
        private readonly AppDbContext _context;

        public MerchantService(AppDbContext context)
        {
            _context = context;
        }

        public async Task RegisterAsync(RegisterMerchantDto dto)
        {
            await _context.Database.ExecuteSqlRawAsync(
                "CALL sp_register_merchant({0},{1},{2},{3},{4})",
                dto.OwnerId,
                dto.VerticalId,
                dto.Name,
                dto.Phone,
                dto.GstNumber);
        }

        public async Task ApproveAsync(Guid merchantId, bool approve)
        {
            await _context.Database.ExecuteSqlRawAsync(
                "CALL sp_approve_merchant({0},{1})",
                merchantId,
                approve);
        }
    }
}
