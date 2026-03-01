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
    public class RiderService
    {
        private readonly AppDbContext _context;

        public RiderService(AppDbContext context)
        {
            _context = context;
        }

        public async Task RegisterAsync(RegisterRiderDto dto)
        {
            await _context.Database.ExecuteSqlRawAsync(
                "CALL sp_register_rider({0},{1},{2},{3})",
                Guid.NewGuid(),
                dto.FullName,
                dto.Phone,
                dto.DrivingLicense);
        }

        public async Task UpdateAvailability(Guid id, bool available)
        {
            await _context.Database.ExecuteSqlRawAsync(
                "CALL sp_update_rider_availability({0},{1})",
                id, available);
        }

        public async Task UpdateLocation(Guid id, double lat, double lng)
        {
            await _context.Database.ExecuteSqlRawAsync(
                "CALL sp_update_rider_location({0},{1},{2})",
                id, lat, lng);
        }
    }
}
