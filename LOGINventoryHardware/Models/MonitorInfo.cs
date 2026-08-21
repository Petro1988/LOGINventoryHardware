namespace LOGINventoryHardware.Models;

public sealed class MonitorInfo
{
    public int Ordinal { get; init; }

    public string Name { get; init; } = string.Empty;

    public string? Model { get; init; }

    public string? Vendor { get; init; }

    public decimal? Size { get; init; }

    public string? SerialNumber { get; init; }

    public string? ManufactureWeek { get; init; }

    public int? ConnectionType { get; init; }

    public DateTime? LastInventory { get; init; }

    public string SizeDisplay =>
        Size.HasValue
            ? $"{Size.Value:0.#} Zoll"
            : "Nicht angegeben";

    public string ConnectionDisplay =>
        ConnectionType switch
        {
            null => "Nicht angegeben",
            int.MinValue => "Intern",
            5 => "HDMI",
            _ => $"Typ {ConnectionType}"
        };
}