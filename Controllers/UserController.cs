using CashSyncApi.Models;
using CashSyncApi.Services;
using Microsoft.AspNetCore.Mvc;

namespace CashSyncApi.Controllers;

[Route("api/users")]
[ApiController]
public class UserController : ControllerBase
{
    private readonly UserService _userService;

    public UserController(UserService userService)
    {
        _userService = userService;
    }

    [HttpGet]
    public async Task<ActionResult<List<UserModel>?>> GetAllUsers()
    {
        List<UserModel>? users = await _userService.GatAllUsersAsync();

        return users;
    }

    [HttpGet("{id:int}")]
    public async Task<ActionResult<UserModel?>> GetUserById(int id)
    {
        UserModel? user = await _userService.GetUserByIdAsync(id);

        if (user == null)
        {
            return NotFound();
        }

        return user;
    }
}