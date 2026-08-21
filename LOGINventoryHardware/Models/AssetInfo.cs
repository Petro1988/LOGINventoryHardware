namespace LOGINventoryHardware.Models;

public sealed class AssetInfo
{
    public int AssetId { get; init; }

    public string Name { get; init; } = string.Empty;

    public string InventoryNumber { get; init; } = string.Empty;

    public string? SerialNumber { get; init; }

    public string? CustomType { get; init; }

    public string? DnsHostName { get; init; }
}