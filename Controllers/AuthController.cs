using CashSyncApi.Models;
using CashSyncApi.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace CashSyncApi.Controllers
{
    [ApiController]
    [Route("api/auth")]
    public class AuthController : ControllerBase
    {
        private readonly GoogleAuthService _googleAuthService;
        private readonly JwtService _jwtService;
        private readonly UserService _userService;

        public AuthController(
            GoogleAuthService googleAuthService,
            JwtService jwtService,
            UserService userService)
        {
            _googleAuthService = googleAuthService;
            _jwtService = jwtService;
            _userService = userService;
        }

        [HttpPost("google")]
        public async Task<IActionResult> GoogleLogin([FromBody] GoogleLoginRequest request)
        {
            // Verify the Google ID token
            var payload = await _googleAuthService.VerifyGoogleToken(request.IdToken ?? string.Empty);

            if (payload == null)
            {
                return Unauthorized(new { message = "Invalid Google token" });
            }

            // Find or create the user
            var user = await _userService.GetUserByEmailAsync(payload.Email);

            if (user == null)
            {
                user = new UserModel
                {
                    Name = payload.Name,
                    Email = payload.Email
                };

                user = await _userService.AddUserAsync(user);
            }

            // Generate a JWT token for the user
            var token = _jwtService.GenerateJwtToken(user);

            // Return the token to the client
            return Ok(new { token, user });
        }

        [HttpGet("me")]
        [Authorize]
        public async Task<IActionResult> GetCurrentUser()
        {
            // Get user ID from claims
            var userId = User.FindFirst(System.Security.Claims.ClaimTypes.NameIdentifier)?.Value;

            if (string.IsNullOrEmpty(userId) || !int.TryParse(userId, out var id))
            {
                return Unauthorized();
            }

            var user = await _userService.GetUserByIdAsync(id);

            if (user == null)
            {
                return NotFound();
            }

            return Ok(user);
        }
    }

    public class GoogleLoginRequest
    {
        public string? IdToken { get; set; }
    }
}