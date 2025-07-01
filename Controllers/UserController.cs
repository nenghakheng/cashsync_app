using CashSyncApi.Data;
using CashSyncApi.Models;
using Microsoft.AspNetCore.Mvc;

namespace CashSyncApi.Controllers;

[Route("api/users")]
[ApiController]
public class UserController : ControllerBase
{
    private readonly UserRepository _userRepository;

    public UserController(UserRepository userRepository)
    {
        _userRepository = userRepository;
    }

    [HttpGet]
    public async Task<ActionResult<List<UserModel>?>> GetAllUsers()
    {
        List<UserModel>? users = await _userRepository.GatAllUsersAsync();

        return users;
    }

    [HttpGet("{id:int}")]
    public async Task<ActionResult<UserModel?>> GetUserById(int id)
    {
        UserModel? user = await _userRepository.GetUserByIdAsync(id);

        if (user == null)
        {
            return NotFound();
        }

        return user;
    }
}