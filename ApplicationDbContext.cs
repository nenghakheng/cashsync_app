using CashSyncApi.Models;
using Microsoft.EntityFrameworkCore;

namespace CashSyncApi;
public class ApplicationDbContext : DbContext
{
    public DbSet<UserModel> Users { get; set; }

    public ApplicationDbContext(DbContextOptions dbContextOptions)
        : base(dbContextOptions)
    {

    }
}