using Dapper;
using LOGINventoryHardware.Models;

namespace LOGINventoryHardware.Data;

public sealed class LoginventoryRepository
{
    private readonly SqlConnectionFactory _connectionFactory;

    public LoginventoryRepository(
        SqlConnectionFactory connectionFactory)
    {
        _connectionFactory = connectionFactory;
    }

    public async Task<AssetInfo?> GetAssetAsync(
        string inventoryNumber,
        CancellationToken cancellationToken = default)
    {
        const string sql = """
            SELECT TOP (1)
                a.Id AS AssetId,
                a.Name,
                ha.InventoryNumber,
                ha.SerialNumber,
                ha.CustomType,
                d.DnsHostName
            FROM dbo.Asset AS a
            INNER JOIN dbo.HardwareAsset AS ha
                ON ha.Id = a.Id
            INNER JOIN dbo.Device AS d
                ON d.Id = a.Id
            WHERE ha.InventoryNumber = @InventoryNumber
              AND a.Archived IS NULL;
            """;

        await using var connection =
            _connectionFactory.CreateConnection();

        var command = new CommandDefinition(
            sql,
            new { InventoryNumber = inventoryNumber },
            cancellationToken: cancellationToken);

        return await connection
            .QuerySingleOrDefaultAsync<AssetInfo>(command);
    }

    public async Task<IReadOnlyList<MonitorInfo>> GetMonitorsAsync(
        int assetId,
        CancellationToken cancellationToken = default)
    {
        const string sql = """
            SELECT
                mi.Ordinal,
                m.Name,
                m.Model,
                m.Vendor,
                m.Size,
                mi.SerialNumber,
                mi.ManufactureWeek,
                mi.ConnectionType,
                mi.Timestamp AS LastInventory
            FROM dbo.MonitorInfo AS mi
            INNER JOIN dbo.Monitor AS m
                ON m.Id = mi.ItemId
            WHERE mi.AssetId = @AssetId
              AND mi.Archived = 0
            ORDER BY mi.Ordinal;
            """;

        await using var connection =
            _connectionFactory.CreateConnection();

        var command = new CommandDefinition(
            sql,
            new { AssetId = assetId },
            cancellationToken: cancellationToken);

        var result =
            await connection.QueryAsync<MonitorInfo>(command);

        return result.ToList();
    }

    public async Task<IReadOnlyList<DockingStationInfo>>
        GetDockingStationsAsync(
            int assetId,
            CancellationToken cancellationToken = default)
    {
        const string sql = """
            SELECT
                ds.Name,
                ds.Manufacturer,
                dsi.SerialNumber,
                dsi.FirmwareVersion,
                dsi.Timestamp AS LastInventory,
                N'DockingStationInfo' AS Source
            FROM dbo.DockingStationInfo AS dsi
            INNER JOIN dbo.DockingStation AS ds
                ON ds.Id = dsi.ItemId
            WHERE dsi.AssetId = @AssetId
              AND dsi.Archived = 0

            UNION

            SELECT
                ud.Name,
                CAST(NULL AS nvarchar(100)) AS Manufacturer,
                CAST(NULL AS nvarchar(100)) AS SerialNumber,
                CAST(NULL AS nvarchar(100)) AS FirmwareVersion,
                MAX(udi.Timestamp) AS LastInventory,
                N'UsbDeviceInfo' AS Source
            FROM dbo.UsbDeviceInfo AS udi
            INNER JOIN dbo.UsbDevice AS ud
                ON ud.Id = udi.ItemId
            WHERE udi.AssetId = @AssetId
              AND udi.Archived = 0
              AND
              (
                   ud.Name LIKE N'%Dock%'
                OR ud.Name LIKE N'%Port Replicator%'
                OR ud.Name LIKE N'%Thunderbolt%'
              )
            GROUP BY ud.Name
            ORDER BY Name;
            """;

        await using var connection =
            _connectionFactory.CreateConnection();

        var command = new CommandDefinition(
            sql,
            new { AssetId = assetId },
            cancellationToken: cancellationToken);

        var result =
            await connection.QueryAsync<DockingStationInfo>(command);

        return result.ToList();
    }

    public async Task<IReadOnlyList<UsbDeviceInfo>> GetUsbDevicesAsync(
        int assetId,
        CancellationToken cancellationToken = default)
    {
        const string sql = """
            SELECT
                udi.Ordinal,
                ud.Name,
                udi.Service,
                udi.Timestamp AS LastInventory
            FROM dbo.UsbDeviceInfo AS udi
            INNER JOIN dbo.UsbDevice AS ud
                ON ud.Id = udi.ItemId
            WHERE udi.AssetId = @AssetId
              AND udi.Archived = 0
            ORDER BY
                ud.Name,
                udi.Ordinal;
            """;

        await using var connection =
            _connectionFactory.CreateConnection();

        var command = new CommandDefinition(
            sql,
            new { AssetId = assetId },
            cancellationToken: cancellationToken);

        var result =
            await connection.QueryAsync<UsbDeviceInfo>(command);

        return result.ToList();
    }
}