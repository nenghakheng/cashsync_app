using Google.Apis.Auth;

namespace CashSyncApi.Services;

public class GoogleAuthService
{
    private readonly IConfiguration _configuration;

    public GoogleAuthService(IConfiguration configuration)
    {
        _configuration = configuration;
    }

    public async Task<GoogleJsonWebSignature.Payload?> VerifyGoogleToken(string idToken)
    {
        try
        {
            var settings = new GoogleJsonWebSignature.ValidationSettings
            {
                Audience = new[] { _configuration["Authentication:Google:ClientId"] }
            };

            var payload = await GoogleJsonWebSignature.ValidateAsync(idToken, settings);
            return payload;
        }
        catch (InvalidJwtException)
        {
            return null;
        }
    }
}