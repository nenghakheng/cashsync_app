namespace TMSCore.Models.Base;

public interface IAuditableEntity
{
    DateTime? CreatedAt { get; set; }
    DateTime? UpdatedAt { get; set; }
}