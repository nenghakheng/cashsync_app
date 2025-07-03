using CashSyncApi.Models;
using Microsoft.EntityFrameworkCore;

namespace CashSyncApi.Services;

public class AuthService
{
    private readonly ApplicationDbContext _context;

    public AuthService(ApplicationDbContext context)
    {
        _context = context;
    }

    public async Task<UserModel?> LoginAsync(string email, string password)
    {
        var user = await _context.Users.FirstOrDefaultAsync(u => u.Email == email);

        if (user != null && BCrypt.Net.BCrypt.Verify(password, user.Password))
        {
            return user;
        }
        return null;
    }

    public async Task<UserModel?> SignUpAsync(UserModel user)
    {
        var existingUser = await _context.Users.FirstOrDefaultAsync(u => u.Email == user.Email);
        if (existingUser != null)
        {
            return null; // User already exists
        }

        // Hash Password
        user.Password = BCrypt.Net.BCrypt.HashPassword(user.Password);
        user.AuthMethod = "credentials";

        _context.Users.Add(user);
        await _context.SaveChangesAsync();
        return user;
    }
}