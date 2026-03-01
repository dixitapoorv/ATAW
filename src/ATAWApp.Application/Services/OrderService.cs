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
    public class OrderService
    {
        private readonly AppDbContext _context;

        public OrderService(AppDbContext context)
        {
            _context = context;
        }

        public async Task<Guid> CreateAsync(CreateOrderDto dto)
        {
            var orderId = Guid.NewGuid();

            await _context.Database.ExecuteSqlRawAsync(
                "CALL sp_create_order({0},{1},{2},{3},{4})",
                orderId,
                dto.CustomerId,
                dto.MerchantId,
                dto.VerticalId,
                dto.TotalAmount);

            var riderId = await _context.Database
                .SqlQuery<Guid?>(
                    $"SELECT fn_assign_nearest_rider({dto.Lat},{dto.Lng})")
                .FirstOrDefaultAsync();

            if (riderId.HasValue)
            {
                await _context.Database.ExecuteSqlRawAsync(
                    "UPDATE orders SET rider_id={0} WHERE id={1}",
                    riderId.Value, orderId);
            }

            return orderId;
        }
    }
}
