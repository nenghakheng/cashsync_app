using TMSCore.Models.Base;

namespace CashSyncApi.Models;

public class UserModel : AuditableEntity
{
    public int Id { get; set; }
    public string? Name { get; set; }
    public string? Email { get; set; }
    public string? Password { get; set; }
    public string? AuthMethod { get; set; } // e.g., "Google", "Credentials"
}

