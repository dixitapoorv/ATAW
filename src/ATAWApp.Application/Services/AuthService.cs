using ATAW.Application.DTOs;
using ATAW.Domain.Entities;
using ATAW.Infrastructure.Data;
using ATAWApp.Application.DTOs;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.IdentityModel.Tokens;
using System;
using System.Collections.Generic;
using System.IdentityModel.Tokens.Jwt;
using System.Linq;
using System.Security.Claims;
using System.Text;
using System.Threading.Tasks;

namespace ATAW.Application.Services
{
    public class AuthService
    {
        private readonly AppDbContext _context;
        private readonly IConfiguration _config;

        public AuthService(AppDbContext context, IConfiguration config)
        {
            _context = context;
            _config = config;
        }

        public async Task RegisterAsync(RegisterUserDto dto)
        {
            var hashed = BCrypt.Net.BCrypt.HashPassword(dto.Password);

            await _context.Database.ExecuteSqlRawAsync(
                "CALL sp_register_user({0},{1},{2},{3},{4})",
                Guid.NewGuid(),
                dto.FullName,
                dto.Phone,
                hashed,
                dto.Role);
        }

        public async Task<AuthResponseDto> LoginAsync(LoginDto dto)
        {
            var user = await _context.Database
                .SqlQuery<UserDto>(
                    $"SELECT * FROM fn_get_user_by_phone({dto.Phone})")
                .FirstOrDefaultAsync();

            if (user == null)
                return null;

            if (!BCrypt.Net.BCrypt.Verify(dto.Password, user.Password_Hash))
                return null;

            var userEntity = new User
            {
                Id = user.Id,
                FullName = user.Full_Name,
                PasswordHash = user.Password_Hash,
                Phone = user.Phone,
                Role = user.Role
            };

            var token = GenerateJwtToken(userEntity);
            return new AuthResponseDto
            {
                Token = token,
                Role = user.Role
            };
        }

        private string GenerateJwtToken(User user)
        {
            var jwtSettings = _config.GetSection("Jwt");

            // Ensure the "Key" value is not null or empty
            var keyString = jwtSettings["Key"];
            var expiresInMinutesString = jwtSettings["ExpiresInMinutes"];
            if (string.IsNullOrEmpty(keyString))
            {
                throw new InvalidOperationException("JWT Key is not configured properly.");
            }

            if (string.IsNullOrEmpty(expiresInMinutesString) || !int.TryParse(expiresInMinutesString, out _))
            {
                throw new InvalidOperationException("JWT ExpiresInMinutes is not configured properly.");
            }

            var claims = new[]
            {
                new Claim(ClaimTypes.NameIdentifier, user.Id.ToString()),
                new Claim(ClaimTypes.Role, user.Role),
                new Claim(ClaimTypes.Name, user.FullName)
            };

            var key = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(keyString));

            var creds = new SigningCredentials(key, SecurityAlgorithms.HmacSha256);

            var token = new JwtSecurityToken(
                issuer: jwtSettings["Issuer"],
                audience: jwtSettings["Audience"],
                claims: claims,
                expires: DateTime.UtcNow.AddMinutes(
                    int.Parse(expiresInMinutesString)),
                signingCredentials: creds);

            return new JwtSecurityTokenHandler().WriteToken(token);
        }
    }
}
