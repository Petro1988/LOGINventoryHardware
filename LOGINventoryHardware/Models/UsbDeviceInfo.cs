namespace LOGINventoryHardware.Models;

public sealed class UsbDeviceInfo
{
    public int Ordinal { get; init; }

    public string Name { get; init; } = string.Empty;

    public string? Service { get; init; }

    public DateTime? LastInventory { get; init; }
}