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
    public class VerticalService
    {
        private readonly AppDbContext _context;

        public VerticalService(AppDbContext context)
        {
            _context = context;
        }

        public async Task CreateAsync(CreateVerticalDto dto)
        {
            await _context.Database.ExecuteSqlRawAsync(
                "INSERT INTO service_vertical_master(name,code) VALUES({0},{1})",
                dto.Name, dto.Code);
        }
    }
}
