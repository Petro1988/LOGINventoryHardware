using Microsoft.Data.SqlClient;

namespace LOGINventoryHardware.Data;

public sealed class SqlConnectionFactory
{
    private readonly string _connectionString;

    public SqlConnectionFactory(IConfiguration configuration)
    {
        _connectionString =
            configuration.GetConnectionString("LOGINventory")
            ?? throw new InvalidOperationException(
                "Der Connection String 'LOGINventory' fehlt.");
    }

    public SqlConnection CreateConnection()
    {
        return new SqlConnection(_connectionString);
    }
}