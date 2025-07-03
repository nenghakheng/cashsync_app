using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace CashSyncApi.Migrations
{
    /// <inheritdoc />
    public partial class AddAuthMethodToUserTable : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<string>(
                name: "AuthMethod",
                table: "Users",
                type: "text",
                nullable: true);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "AuthMethod",
                table: "Users");
        }
    }
}
