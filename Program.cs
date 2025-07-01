using CashSyncApi;
using CashSyncApi.Data;
using Microsoft.EntityFrameworkCore;
using Microsoft.OpenApi.Models;
using TMSCore.Middlewares;

var builder = WebApplication.CreateBuilder(args);

// Add Repository
builder.Services.AddScoped<UserRepository>();

// Add JsonApi filther middleware
builder.Services.AddControllers(options =>
{
    options.Filters.Add<JsonApiFilter>();
});

// Cors
builder.Services.AddCors(options =>
{
    options.AddPolicy("AllowAllOrigins",
        builder => builder.AllowAnyOrigin()
                          .AllowAnyMethod()
                          .AllowAnyHeader());
});

// Add services to the container.
builder.Services.AddControllers();
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen(c =>
{
    c.SwaggerDoc("v1", new OpenApiInfo
    {
        Title = "CashSync API",
        Version = "v1",
        Description = "A financial management API for CashSync application"
    });
});

// Database
builder.Services.AddDbContext<ApplicationDbContext>(options =>
    options.UseSqlServer(builder.Configuration.GetConnectionString("DefaultConnection")));

var app = builder.Build();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI(c =>
    {
        c.SwaggerEndpoint("/swagger/v1/swagger.json", "CashSync API v1");
        c.RoutePrefix = string.Empty; // To serve the Swagger UI at the application's root
    });
}

app.UseHttpsRedirection();
app.UseAuthorization();
app.MapControllers();
app.Run();