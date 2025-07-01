using CashSyncApi.Models;
using Microsoft.EntityFrameworkCore;

namespace CashSyncApi.Data;

public class UserRepository
{
    private readonly ApplicationDbContext _context;

    public UserRepository(ApplicationDbContext context)
    {
        _context = context;
    }

    public async Task<UserModel?> GetUserByIdAsync(int id)
    {
        return await _context.Users.FindAsync(id);
    }


    public async Task<List<UserModel>?> GatAllUsersAsync()
    {
        return await _context.Users.ToListAsync();
    }
}