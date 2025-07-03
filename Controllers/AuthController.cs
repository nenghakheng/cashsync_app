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
        private readonly AuthService _authService;

        public AuthController(
            GoogleAuthService googleAuthService,
            JwtService jwtService,
            UserService userService, AuthService authService)
        {
            _googleAuthService = googleAuthService;
            _jwtService = jwtService;
            _userService = userService;
            _authService = authService;
        }

        [HttpPost("login")]
        public async Task<IActionResult> Login([FromBody] UserModel userModel)
        {
            if (userModel == null || string.IsNullOrEmpty(userModel.Email) || string.IsNullOrEmpty(userModel.Password))
            {
                return BadRequest(new { message = "Email and password are required" });
            }

            // Authenticate the user
            var user = await _authService.LoginAsync(userModel.Email, userModel.Password);

            if (user == null)
            {
                return Unauthorized(new { message = "Invalid email or password" });
            }

            // Generate a JWT token for the user
            var token = _jwtService.GenerateJwtToken(user);

            // Return the token and user information to the client
            return Ok(new { token, user });
        }

        [HttpPost("signup")]
        public async Task<IActionResult> SignUp([FromBody] UserModel userModel)
        {
            if (userModel == null || string.IsNullOrEmpty(userModel.Email) || string.IsNullOrEmpty(userModel.Password))
            {
                return BadRequest(new { message = "Email and password are required" });
            }

            // Register the user
            var existingUser = await _userService.GetUserByEmailAsync(userModel.Email);
            if (existingUser != null)
            {
                return Conflict(new { message = "User already exists" });
            }

            var newUser = await _authService.SignUpAsync(userModel);

            if (newUser == null)
            {
                return BadRequest(new { message = "Failed to create user" });
            }

            return Ok(new { message = "User created successfully", user = newUser });
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
                    Email = payload.Email,
                    AuthMethod = "google",
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