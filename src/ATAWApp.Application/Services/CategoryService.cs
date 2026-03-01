using ATAW.Application.DTOs;
using ATAW.Infrastructure.Data;
using Microsoft.EntityFrameworkCore;
using System.Threading.Tasks;

namespace ATAW.Application.Services
{
    public class CategoryService
    {
        private readonly AppDbContext _context;

        public CategoryService(AppDbContext context)
        {
            _context = context;
        }

        public async Task CreateAsync(CreateCategoryDto dto)
        {
            await _context.Database.ExecuteSqlRawAsync(
                "CALL sp_create_category({0},{1})",
                dto.VerticalId, dto.Name);
        }
    }
}
