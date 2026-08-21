namespace LOGINventoryHardware.Models;

public sealed class DockingStationInfo
{
    public string Name { get; init; } = string.Empty;

    public string? Manufacturer { get; init; }

    public string? SerialNumber { get; init; }

    public string? FirmwareVersion { get; init; }

    public DateTime? LastInventory { get; init; }

    public string Source { get; init; } = string.Empty;
}
