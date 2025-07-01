using CashSyncApi.Models;
using Microsoft.EntityFrameworkCore;

namespace CashSyncApi.Services;

public class UserService
{
    private readonly ApplicationDbContext _context;

    public UserService(ApplicationDbContext context)
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

    public async Task<UserModel?> GetUserByEmailAsync(string email)
    {
        return await _context.Users.FirstOrDefaultAsync(u => u.Email == email);
    }

    public async Task<UserModel> AddUserAsync(UserModel user)
    {
        _context.Users.Add(user);
        await _context.SaveChangesAsync();
        return user;
    }
}