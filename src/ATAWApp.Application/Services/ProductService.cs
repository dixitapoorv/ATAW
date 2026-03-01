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
    public class ProductService
    {
        private readonly AppDbContext _context;

        public ProductService(AppDbContext context)
        {
            _context = context;
        }

        public async Task CreateAsync(CreateProductDto dto)
        {
            await _context.Database.ExecuteSqlRawAsync(
                "CALL sp_create_product({0},{1},{2},{3},{4})",
                dto.VerticalId,
                dto.CategoryId,
                dto.SubCategoryId,
                dto.Name,
                dto.Description);
        }
    }
}
