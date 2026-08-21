using LOGINventoryHardware.Data;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddControllers();

builder.Services.AddSingleton<SqlConnectionFactory>();
builder.Services.AddScoped<LoginventoryRepository>();

var app = builder.Build();

app.UseRouting();
app.UseAuthorization();

app.MapControllers();

app.MapGet("/", () => Results.Ok(new
{
    application = "LOGINventoryHardware",
    status = "API läuft",
    example = "/api/hardware?invnr=ASSET-3"
}));
//https://localhost:7024/api/hardware?invnr=ASSET-3

app.Run();