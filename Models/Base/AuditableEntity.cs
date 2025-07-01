using System.ComponentModel.DataAnnotations.Schema;

namespace TMSCore.Models.Base;

public abstract class AuditableEntity : IAuditableEntity
{
    public DateTime? CreatedAt { get; set; }
    public DateTime? UpdatedAt { get; set; }
}