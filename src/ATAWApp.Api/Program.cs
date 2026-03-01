using ATAW.Application.Services;
using ATAW.Infrastructure.Data;
using ATAWApp.Api.Hubs;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.AspNetCore.Builder;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Microsoft.IdentityModel.Tokens;
using Microsoft.OpenApi;
using System.Text;

var builder = WebApplication.CreateBuilder(args);

#region Configuration

var configuration = builder.Configuration;
var jwtSettings = configuration.GetSection("Jwt");

#endregion

#region Database Configuration (PostgreSQL)

builder.Services.AddDbContext<AppDbContext>(options =>
    options.UseNpgsql(
        configuration.GetConnectionString("Default"),
        o => o.UseNetTopologySuite() 
    ));

#endregion

#region Dependency Injection (Services)

builder.Services.AddScoped<AuthService>();
builder.Services.AddScoped<VerticalService>();
builder.Services.AddScoped<CategoryService>();
builder.Services.AddScoped<SubCategoryService>();
builder.Services.AddScoped<ProductService>();
builder.Services.AddScoped<MerchantService>();
builder.Services.AddScoped<RiderService>();
builder.Services.AddScoped<OrderService>();

#endregion

#region JWT Authentication Configuration

builder.Services.AddAuthentication(options =>
{
    options.DefaultAuthenticateScheme = JwtBearerDefaults.AuthenticationScheme;
    options.DefaultChallengeScheme = JwtBearerDefaults.AuthenticationScheme;
})
.AddJwtBearer(options =>
{
    options.RequireHttpsMetadata = false; // Set true in production with HTTPS
    options.SaveToken = true;

    options.TokenValidationParameters = new TokenValidationParameters
    {
        ValidateIssuer = true,
        ValidateAudience = true,
        ValidateLifetime = true,
        ValidateIssuerSigningKey = true,
        ValidIssuer = jwtSettings["Issuer"],
        ValidAudience = jwtSettings["Audience"],
        IssuerSigningKey = new SymmetricSecurityKey(
            Encoding.UTF8.GetBytes(jwtSettings["Key"]))
    };
});

builder.Services.AddAuthorization();

#endregion

#region DB Context
builder.Services.AddDbContext<AppDbContext>(options =>
    options.UseNpgsql(
        builder.Configuration.GetConnectionString("Default"),
        o => o.UseNetTopologySuite()
    ));

#endregion

#region CORS Configuration

builder.Services.AddCors(options =>
{
    options.AddPolicy("AllowAll",
        policy =>
        {
            policy.AllowAnyOrigin()
                  .AllowAnyMethod()
                  .AllowAnyHeader();
        });
});

#endregion

#region Controllers

builder.Services.AddControllers();

#endregion

#region SignalR

builder.Services.AddSignalR();

#endregion

#region Swagger + JWT Support

builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen(options =>
{
    options.SwaggerDoc("v1", new OpenApiInfo
    {
        Title = "SuperApp API",
        Version = "v1"
    });

    // Enable JWT in Swagger
    options.AddSecurityDefinition("Bearer", new OpenApiSecurityScheme
    {
        Description = "Enter JWT Token: Bearer {your token}",
        Name = "Authorization",
        In = ParameterLocation.Header,
        Type = SecuritySchemeType.ApiKey,
        Scheme = "Bearer"
    });

    options.AddSecurityDefinition("Bearer", new OpenApiSecurityScheme
    {
        Description = "Enter JWT Token: Bearer {your token}",
        Name = "Authorization",
        In = ParameterLocation.Header,
        Type = SecuritySchemeType.ApiKey,
        Scheme = "Bearer"
    });
});

#endregion

var app = builder.Build();

#region Middleware Pipeline

if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseHttpsRedirection();

app.UseCors("AllowAll");

app.UseAuthentication();   // Must come before Authorization
app.UseAuthorization();

app.MapControllers();

app.MapHub<RiderHub>("/riderHub");

#endregion

app.Run();