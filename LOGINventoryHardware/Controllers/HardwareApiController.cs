using LOGINventoryHardware.Data;
using LOGINventoryHardware.Models;
using Microsoft.AspNetCore.Mvc;

namespace LOGINventoryHardware.Controllers;

[ApiController]
[Route("api/hardware")]
public sealed class HardwareApiController : ControllerBase
{
    private readonly LoginventoryRepository _repository;
    private readonly ILogger<HardwareApiController> _logger;

    public HardwareApiController(
        LoginventoryRepository repository,
        ILogger<HardwareApiController> logger)
    {
        _repository = repository;
        _logger = logger;
    }

    [HttpGet]
    public async Task<ActionResult<ConnectedHardwareResult>> GetAsync(
        [FromQuery(Name = "invnr")] string? inventoryNumber,
        CancellationToken cancellationToken)
    {
        if (string.IsNullOrWhiteSpace(inventoryNumber))
        {
            return BadRequest(new
            {
                message = "Die Inventarnummer fehlt."
            });
        }

        inventoryNumber = inventoryNumber.Trim();

        try
        {
            var asset = await _repository.GetAssetAsync(
                inventoryNumber,
                cancellationToken);

            if (asset is null)
            {
                return NotFound(new
                {
                    message =
                        $"Das Asset '{inventoryNumber}' wurde nicht gefunden."
                });
            }

            var monitors = await _repository.GetMonitorsAsync(
                asset.AssetId,
                cancellationToken);

            var dockingStations =
                await _repository.GetDockingStationsAsync(
                    asset.AssetId,
                    cancellationToken);

            var usbDevices = await _repository.GetUsbDevicesAsync(
                asset.AssetId,
                cancellationToken);

            return Ok(new ConnectedHardwareResult
            {
                Asset = asset,
                Monitors = monitors,
                DockingStations = dockingStations,
                UsbDevices = usbDevices
            });
        }
        catch (Exception exception)
        {
            _logger.LogError(
                exception,
                "Fehler beim Laden der Hardware für {InventoryNumber}.",
                inventoryNumber);

            return Problem(
                title: "Datenbankfehler",
                detail:
                    "Die LOGINventory-Daten konnten nicht geladen werden.",
                statusCode:
                    StatusCodes.Status500InternalServerError);
        }
    }
}