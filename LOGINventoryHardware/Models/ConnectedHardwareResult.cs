namespace LOGINventoryHardware.Models;

public sealed class ConnectedHardwareResult
{
    public AssetInfo Asset { get; init; } = null!;

    public IReadOnlyList<MonitorInfo> Monitors { get; init; } =
        Array.Empty<MonitorInfo>();

    public IReadOnlyList<DockingStationInfo> DockingStations { get; init; } =
        Array.Empty<DockingStationInfo>();

    public IReadOnlyList<UsbDeviceInfo> UsbDevices { get; init; } =
        Array.Empty<UsbDeviceInfo>();
}