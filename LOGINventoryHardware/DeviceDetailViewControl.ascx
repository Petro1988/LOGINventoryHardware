// This file is part of LOGINventory
<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="DeviceDetailViewControl.ascx.cs" Inherits="Ventory.Web.Client.Controls.DeviceDetailViewControl" %>
<%@ Register TagPrefix="L" TagName="PropertyEditor" Src="~/Controls/PropertyEditor.ascx" %>
<%@ Register TagPrefix="L" TagName="HardwareAssetDetails" Src="~/Controls/HardwareAssetDetailsControl.ascx" %>
<%@ Register TagPrefix="L" TagName="LifecycleHistory" Src="~/Controls/LifecycleHistoryControl.ascx" %>
<%-- ReSharper disable AspUnusedRegisterDirectiveHighlighting --%>
<%@ Register Assembly="DevExpress.Web.Bootstrap.v21.2, Version=21.2.15.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web.Bootstrap" TagPrefix="dx" %>
<%@ Register Assembly="DevExpress.Printing.v21.2.Core, Version=21.2.15.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.XtraPrinting" TagPrefix="dx" %>
<%@ Register TagPrefix="dx" Namespace="DevExpress.Web" Assembly="DevExpress.Web.v21.2, Version=21.2.15.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" %>
<%@ Register Assembly="DevExpress.Data.v21.2, Version=21.2.15.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Data" TagPrefix="dx" %>
<%@ Import Namespace="Login.Ventory.Web.Client.Localization" %>

<contenttemplate>
    <div id="message" runat="server"></div>

    <div class="device-detail-menu d-flex flex-wrap align-items-center gap-2 mb-3">
        <asp:LinkButton ID="btnOverview" runat="server" CssClass="btn btn-outline-secondary btn-sm detail-nav-btn d-inline-flex align-items-center gap-2" CommandArgument="Overview" OnCommand="SectionButton_Command" UseSubmitBehavior="false">
            <span class="btn-icon icon custom-tab-icon-overview"></span>
            <span class="device-detail-menu__label"><%= WebResource.txt_Overview %></span>
        </asp:LinkButton>

        <asp:LinkButton ID="btnProperties" runat="server" CssClass="btn btn-outline-secondary btn-sm detail-nav-btn d-inline-flex align-items-center gap-2" CommandArgument="Properties" OnCommand="SectionButton_Command" UseSubmitBehavior="false">
            <span class="btn-icon icon custom-tab-icon-properties"></span>
            <span class="device-detail-menu__label"><%= WebResource.txt_Properties %></span>
        </asp:LinkButton>

        <asp:LinkButton ID="btnCustom" runat="server" CssClass="btn btn-outline-secondary btn-sm detail-nav-btn d-inline-flex align-items-center gap-2" CommandArgument="Custom" OnCommand="SectionButton_Command" UseSubmitBehavior="false">
            <span class="btn-icon icon custom-tab-icon-custom"></span>
            <span class="device-detail-menu__label"><%= WebResource.txt_CustomProperties %></span>
        </asp:LinkButton>

        <div class="dropdown">
            <asp:LinkButton ID="btnLifecycle" runat="server" CssClass="btn btn-outline-secondary btn-sm detail-nav-btn d-inline-flex align-items-center gap-2 dropdown-toggle" UseSubmitBehavior="false" OnClientClick="return false;" data-bs-toggle="dropdown" aria-expanded="false">
                <span class="btn-icon icon-invert-dark custom-tab-icon-lifecycle"></span>
                <span class="device-detail-menu__label"><%= WebResource.txt_Lifecycle %></span>
                <span class="dropdown-caret"></span>
            </asp:LinkButton>
            <ul class="dropdown-menu">
                <li><asp:LinkButton ID="btnLifecycleHistory" runat="server" CssClass="dropdown-item d-flex align-items-center gap-2" CommandArgument="Lifecycle|History" OnCommand="SectionButton_Command" UseSubmitBehavior="false"><span class="btn-icon icon custom-tab-icon-lifecycle"></span><span><%= WebResource.txt_Entries %></span></asp:LinkButton></li>
                <li><asp:LinkButton ID="btnLifecycleNew" runat="server" CssClass="dropdown-item d-flex align-items-center gap-2" CommandArgument="Lifecycle|LifeCycle" OnCommand="SectionButton_Command" UseSubmitBehavior="false"><span class="btn-icon icon custom-icon-lifecycle"></span><span><%= WebResource.txt_NewLifecycleEntry %></span></asp:LinkButton></li>
                <li><asp:LinkButton ID="btnLifecycleHandout" runat="server" CssClass="dropdown-item d-flex align-items-center gap-2" CommandArgument="Lifecycle|HandOut" OnCommand="SectionButton_Command" UseSubmitBehavior="false"><span class="btn-icon icon custom-icon-handout"></span><span><%= WebResource.txt_NewHandOut %></span></asp:LinkButton></li>
                <li><asp:LinkButton ID="btnLifecycleReturn" runat="server" CssClass="dropdown-item d-flex align-items-center gap-2" CommandArgument="Lifecycle|Return" OnCommand="SectionButton_Command" UseSubmitBehavior="false"><span class="btn-icon icon custom-icon-return"></span><span><%= WebResource.txt_NewReturn %></span></asp:LinkButton></li>
            </ul>
        </div>

        <asp:LinkButton ID="btnSoftware" runat="server" CssClass="btn btn-outline-secondary btn-sm detail-nav-btn d-inline-flex align-items-center gap-2" CommandArgument="Software" OnCommand="SectionButton_Command" UseSubmitBehavior="false">
            <span class="btn-icon icon custom-tab-icon-software"></span>
            <span class="device-detail-menu__label"><%= WebResource.txt_Software %></span>
        </asp:LinkButton>

        <button type="button" id="btnConnectedHardware" class="btn btn-outline-secondary btn-sm detail-nav-btn d-inline-flex align-items-center gap-2" onclick="showConnectedHardware(); return false;">
            <span class="btn-icon icon custom-tab-icon-properties"></span>
            <span class="device-detail-menu__label">Angeschlossene Hardware</span>
        </button>

        <asp:LinkButton ID="btnMacAddressTable" runat="server" CssClass="btn btn-outline-secondary btn-sm detail-nav-btn d-inline-flex align-items-center gap-2" CommandArgument="MacAddressTable" OnCommand="SectionButton_Command" UseSubmitBehavior="false" Visible="false">
            <span class="btn-icon icon custom-tab-icon-properties"></span>
            <span class="device-detail-menu__label"><%= WebResource.txt_MacAddressTable %></span>
        </asp:LinkButton>
    </div>

    <div class="device-detail-content">
        <asp:Panel ID="panelOverview" runat="server" CssClass="device-detail-section">
            <div class="row">
                <div class="col-lg-6">
                    <h5>Hardware</h5>
                    <div class="mb-1 pt-2 pb-2">
                        <div class="row"><div class="col-xl-3 col-lg-4 col-5 fw-bold"><%= WebResource.txt_CPU %>:</div><div class="col-xl-9 col-lg-8 col-7"><%= CpuName %></div></div>
                        <div class="row"><div class="col-xl-3 col-lg-4 col-5 fw-bold"><%= WebResource.txt_ChassisType %>:</div><div class="col-xl-9 col-lg-8 col-7"><%= ChassisType %></div></div>
                        <div class="row"><div class="col-xl-3 col-lg-4 col-5 fw-bold"><%= WebResource.txt_MemorySize %>:</div><div class="col-xl-9 col-lg-8 col-7"><%= MemorySizeGB %> GB</div></div>
                    </div>
                </div>
                <div class="col-lg-6">
                    <h5><%= WebResource.txt_OperatingSystem %></h5>
                    <div class="mb-1 pt-2 pb-2">
                        <div class="row"><div class="col-xl-3 col-lg-4 col-5 fw-bold"><%= WebResource.txt_Name %>:</div><div class="col-xl-9 col-lg-8 col-7"><%= OsName %></div></div>
                        <div class="row"><div class="col-xl-3 col-lg-4 col-5 fw-bold"><%= WebResource.txt_DisplayVersion %>:</div><div class="col-xl-9 col-lg-8 col-7"><%= OsVersion %></div></div>
                        <div class="row"><div class="col-xl-3 col-lg-4 col-5 fw-bold"><%= WebResource.txt_Platform %>:</div><div class="col-xl-9 col-lg-8 col-7"><%= OsPlatform %></div></div>
                        <div class="row"><div class="col-xl-3 col-lg-4 col-5 fw-bold"><%= WebResource.txt_InstallDate %>:</div><div class="col-xl-9 col-lg-8 col-7"><%= OsInstallDate %></div></div>
                        <div class="row"><div class="col-xl-3 col-lg-4 col-5 fw-bold"><%= WebResource.txt_Domain %>:</div><div class="col-xl-9 col-lg-8 col-7"><%= OsDomain %></div></div>
                    </div>
                </div>
            </div>
        </asp:Panel>

        <asp:Panel ID="panelProperties" runat="server" CssClass="device-detail-section"><div class="row"><L:HardwareAssetDetails ID="hardwareAssetDetails" runat="server" /></div></asp:Panel>
        <asp:Panel ID="panelCustom" runat="server" CssClass="device-detail-section"><L:PropertyEditor runat="server" ID="propertyEditor"></L:PropertyEditor></asp:Panel>
        <asp:Panel ID="panelLifecycle" runat="server" CssClass="device-detail-section"><L:LifecycleHistory runat="server" ID="lifecycleHistory"></L:LifecycleHistory></asp:Panel>

        <asp:Panel ID="panelSoftware" runat="server" CssClass="device-detail-section">
            <div class="row">
                <dx:BootstrapGridView ID="gridViewSoftware" runat="server" Visible="false">
                    <SettingsPager NumericButtonCount="4" PageSize="500"><PageSizeItemSettings Visible="true" Items="100, 500, 1000" /></SettingsPager>
                    <Settings ShowGroupPanel="True" ShowFooter="True" ShowFilterRow="true" ShowFilterRowMenu="true" />
                </dx:BootstrapGridView>
            </div>
        </asp:Panel>

        <div id="panelConnectedHardware" class="device-detail-section" style="display:none;">
            <div class="d-flex flex-wrap justify-content-between align-items-center gap-2 mb-3">
                <h5 class="mb-0">Angeschlossene Hardware</h5>
                <button type="button" class="btn btn-sm btn-outline-secondary" onclick="loadConnectedHardware(true); return false;">Aktualisieren</button>
            </div>
            <div id="connectedHardwareLoading" class="text-muted py-3" style="display:none;">Hardwaredaten werden geladen...</div>
            <div id="connectedHardwareError" class="alert alert-warning" role="alert" style="display:none;"></div>
            <div id="connectedHardwareContent"></div>
        </div>

        <asp:Panel ID="panelMacAddressTable" runat="server" CssClass="device-detail-section">
            <div class="row">
                <dx:BootstrapGridView ID="gridViewMacAddressTable" runat="server" Visible="false">
                    <SettingsPager NumericButtonCount="4" PageSize="500"><PageSizeItemSettings Visible="true" Items="100, 500, 1000" /></SettingsPager>
                    <Settings ShowGroupPanel="True" ShowFooter="True" ShowFilterRow="true" ShowFilterRowMenu="true" />
                </dx:BootstrapGridView>
            </div>
        </asp:Panel>
    </div>

    <script type="text/javascript">
        var connectedHardwareLoaded = false;

        function getConnectedHardwareInventoryNumber() {
            return new URLSearchParams(window.location.search).get("invnr");
        }

        function findLoginventoryPanel(panelName) {
            return document.querySelector('[id$="' + panelName + '"]');
        }

        function deactivateLoginventoryButtons() {
            document.querySelectorAll(".detail-nav-btn").forEach(function (button) {
                button.classList.remove("active");
            });
        }

        function hideLoginventoryDetailPanels() {
            ["panelOverview", "panelProperties", "panelCustom", "panelLifecycle", "panelSoftware", "panelMacAddressTable"]
                .forEach(function (panelName) {
                    var currentPanel = findLoginventoryPanel(panelName);
                    if (currentPanel) currentPanel.style.display = "none";
                });
        }

        function hideConnectedHardwarePanel() {
            var hardwarePanel = document.getElementById("panelConnectedHardware");
            var hardwareButton = document.getElementById("btnConnectedHardware");
            if (hardwarePanel) hardwarePanel.style.display = "none";
            if (hardwareButton) hardwareButton.classList.remove("active");
        }

        function showConnectedHardware() {
            deactivateLoginventoryButtons();
            hideLoginventoryDetailPanels();

            var hardwarePanel = document.getElementById("panelConnectedHardware");
            var hardwareButton = document.getElementById("btnConnectedHardware");
            if (!hardwarePanel) return;

            hardwarePanel.style.display = "block";
            if (hardwareButton) hardwareButton.classList.add("active");
            loadConnectedHardware(true);
        }

        async function loadConnectedHardware(forceReload) {
            if (connectedHardwareLoaded && !forceReload) return;

            var invnr = getConnectedHardwareInventoryNumber();
            var loading = document.getElementById("connectedHardwareLoading");
            var error = document.getElementById("connectedHardwareError");
            var content = document.getElementById("connectedHardwareContent");
            if (!loading || !error || !content) return;

            if (!invnr) {
                error.textContent = "In der URL wurde keine Inventarnummer gefunden.";
                error.style.display = "block";
                return;
            }

            loading.style.display = "block";
            error.style.display = "none";
            content.innerHTML = "";

            try {
                var response = await fetch("/LOGINventoryHardware/api/hardware?invnr=" + encodeURIComponent(invnr), {
                    headers: { "Accept": "application/json" },
                    credentials: "same-origin",
                    cache: "no-store"
                });

                if (!response.ok) {
                    throw new Error("Die Hardwaredaten konnten nicht geladen werden. HTTP-Status: " + response.status);
                }

                renderConnectedHardware(await response.json());
                connectedHardwareLoaded = true;
            }
            catch (exception) {
                console.error(exception);
                error.textContent = exception.message || "Die Hardwaredaten konnten nicht geladen werden.";
                error.style.display = "block";
            }
            finally {
                loading.style.display = "none";
            }
        }

        function valueText(value) {
            return value === null || value === undefined || value === "" ? "\u2013" : String(value);
        }

        function formatHardwareDate(value) {
            if (!value) return "\u2013";
            var date = new Date(value);
            return isNaN(date.getTime())
                ? String(value)
                : date.toLocaleString("de-DE", { day:"2-digit", month:"2-digit", year:"numeric", hour:"2-digit", minute:"2-digit" });
        }

        function isAudioDevice(device) {
            if (!device) return false;
            var name = String(device.name || "").toLowerCase();
            var service = String(device.service || "").toLowerCase();
            return service === "usbaudio" || service === "usbaudio2" ||
                ["usb audio", "microphone", "mikrofon", "headset", "headphone", "kopfh\u00f6rer", "lautsprecher", "speaker"]
                    .some(function (term) { return name.indexOf(term) >= 0; });
        }

        function isImportantDevice(device) {
            if (!device || !device.name || isAudioDevice(device)) return false;

            var name = String(device.name).toLowerCase();
            var service = String(device.service || "").toLowerCase();

            var isPrinter =
                service === "usbprint" ||
                name.indexOf("printer") >= 0 ||
                name.indexOf("drucker") >= 0;

            var isDockingStation =
                name.indexOf("dock") >= 0 ||
                name.indexOf("docking station") >= 0 ||
                name.indexOf("port replicator") >= 0 ||
                name.indexOf("thunderbolt") >= 0;

            return isPrinter || isDockingStation;
        }

        function getDeviceType(device) {
            var name = String(device.name || "").toLowerCase();
            var service = String(device.service || "").toLowerCase();

            if (
                service === "usbprint" ||
                name.indexOf("printer") >= 0 ||
                name.indexOf("drucker") >= 0
            ) {
                return "Drucker";
            }

            if (
                name.indexOf("dock") >= 0 ||
                name.indexOf("docking station") >= 0 ||
                name.indexOf("port replicator") >= 0 ||
                name.indexOf("thunderbolt") >= 0
            ) {
                return "Dockingstation";
            }

            return "Ger\\u00e4t";
        }

        function removeDuplicateDevices(devices) {
            var unique = {};
            devices.forEach(function (device) {
                if (!device || !device.name || isAudioDevice(device)) return;
                var key = String(device.name).toLowerCase().trim().replace(/\s+/g, " ").replace(/\s+(usb\s+)?audio(\s+\d+)?$/g, "");
                var existing = unique[key];
                if (!existing ||
                    (device.service === "usbvideo" && existing.service !== "usbvideo") ||
                    (device.service === "usbprint" && existing.service !== "usbprint")) {
                    unique[key] = device;
                }
            });
            return Object.keys(unique).map(function (key) { return unique[key]; });
        }

        function createHardwareCard(titleText, count) {
            var card = document.createElement("div");
            card.className = "card mb-3";
            var header = document.createElement("div");
            header.className = "card-header d-flex justify-content-between align-items-center";
            var title = document.createElement("strong");
            title.textContent = titleText;
            var badge = document.createElement("span");
            badge.className = "badge bg-secondary";
            badge.textContent = String(count);
            header.appendChild(title);
            header.appendChild(badge);
            card.appendChild(header);
            return card;
        }

        function createEmptyMessage(card, message) {
            var element = document.createElement("div");
            element.className = "card-body text-muted";
            element.textContent = message;
            card.appendChild(element);
            return card;
        }

        function createHardwareTable(items, columns) {
            var wrapper = document.createElement("div");
            wrapper.className = "table-responsive";
            var table = document.createElement("table");
            table.className = "table table-sm table-striped table-hover align-middle mb-0";
            var thead = document.createElement("thead");
            var headerRow = document.createElement("tr");

            columns.forEach(function (column) {
                var th = document.createElement("th");
                th.textContent = column.title;
                headerRow.appendChild(th);
            });

            thead.appendChild(headerRow);
            table.appendChild(thead);
            var tbody = document.createElement("tbody");

            items.forEach(function (item) {
                var row = document.createElement("tr");
                columns.forEach(function (column) {
                    var cell = document.createElement("td");
                    cell.textContent = valueText(column.value(item));
                    row.appendChild(cell);
                });
                tbody.appendChild(row);
            });

            table.appendChild(tbody);
            wrapper.appendChild(table);
            return wrapper;
        }

        function createMonitorSection(monitors) {
            var card = createHardwareCard("Monitore", monitors.length);
            if (!monitors.length) return createEmptyMessage(card, "Keine aktuellen Monitore gefunden.");

            card.appendChild(createHardwareTable(monitors, [
                { title:"Name", value:function(x){ return x.name; } },
                { title:"Modell", value:function(x){ return x.model; } },
                { title:"Hersteller", value:function(x){ return x.vendor; } },
                { title:"Gr\u00f6\u00dfe", value:function(x){ return x.sizeDisplay || (x.size == null ? "\u2013" : String(x.size).replace(".", ",") + " Zoll"); } },
                { title:"Seriennummer", value:function(x){ return x.serialNumber; } },
                { title:"Herstellung", value:function(x){ return x.manufactureWeek; } },
                { title:"Verbindung", value:function(x){ return x.connectionDisplay || (x.connectionType === -2147483648 ? "Intern" : x.connectionType === 5 ? "HDMI" : "Typ " + x.connectionType); } },
                { title:"Letzte Inventarisierung", value:function(x){ return formatHardwareDate(x.lastInventory); } }
            ]));

            return card;
        }

        function createDeviceSection(devices) {
            var card = createHardwareCard("Ger\u00e4te", devices.length);
            if (!devices.length) return createEmptyMessage(card, "Keine weiteren angeschlossenen Ger\u00e4te gefunden.");

            card.appendChild(createHardwareTable(devices, [
                { title:"Typ", value:getDeviceType },
                { title:"Name", value:function(x){ return x.name; } },
                { title:"Hersteller", value:function(x){ return x.manufacturer; } },
                { title:"Seriennummer", value:function(x){ return x.serialNumber; } },
                { title:"Dienst", value:function(x){ return x.service; } },
                { title:"Letzte Inventarisierung", value:function(x){ return formatHardwareDate(x.lastInventory); } }
            ]));

            return card;
        }

        function createUsbDeviceSection(usbDevices) {
            var details = document.createElement("details");
            details.className = "card mb-3";
            var summary = document.createElement("summary");
            summary.className = "card-header d-flex justify-content-between align-items-center";
            summary.style.cursor = "pointer";
            var title = document.createElement("strong");
            title.textContent = "USB-Ger\u00e4te anzeigen";
            var badge = document.createElement("span");
            badge.className = "badge bg-secondary";
            badge.textContent = String(usbDevices.length);
            summary.appendChild(title);
            summary.appendChild(badge);
            details.appendChild(summary);

            if (!usbDevices.length) return createEmptyMessage(details, "Keine aktuellen USB-Ger\u00e4te gefunden.");

            details.appendChild(createHardwareTable(usbDevices, [
                { title:"Name", value:function(x){ return x.name; } },
                { title:"Dienst", value:function(x){ return x.service; } },
                { title:"Letzte Inventarisierung", value:function(x){ return formatHardwareDate(x.lastInventory); } }
            ]));

            return details;
        }

        function renderConnectedHardware(result) {
            var content = document.getElementById("connectedHardwareContent");
            if (!content) return;
            content.innerHTML = "";

            var monitors = result && Array.isArray(result.monitors) ? result.monitors : [];
            var baseDevices = result && Array.isArray(result.dockingStations) ? result.dockingStations : [];
            var usbDevices = result && Array.isArray(result.usbDevices) ? result.usbDevices : [];
            var promoted = usbDevices.filter(isImportantDevice).map(function (item) {
                return { name:item.name, manufacturer:null, serialNumber:null, service:item.service, lastInventory:item.lastInventory };
            });

            content.appendChild(createMonitorSection(monitors));
            content.appendChild(createDeviceSection(removeDuplicateDevices(baseDevices.concat(promoted))));
            content.appendChild(createUsbDeviceSection(usbDevices.filter(function (item) { return !isImportantDevice(item); })));
        }

        document.addEventListener("click", function (event) {
            if (!event.target || typeof event.target.closest !== "function") return;
            var navigationButton = event.target.closest(".detail-nav-btn");
            if (!navigationButton || navigationButton.id === "btnConnectedHardware") return;
            hideConnectedHardwarePanel();
        });
    </script>
</contenttemplate>
