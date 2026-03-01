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
    public class SubCategoryService
    {
        private readonly AppDbContext _context;

        public SubCategoryService(AppDbContext context)
        {
            _context = context;
        }

        public async Task CreateAsync(CreateSubCategoryDto dto)
        {
            await _context.Database.ExecuteSqlRawAsync(
                "CALL sp_create_subcategory({0},{1})",
                dto.CategoryId, dto.Name);
        }
    }
}
