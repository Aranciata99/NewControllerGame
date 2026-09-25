import asyncio
import sys
from bleak import BleakClient, BleakScanner

# Die TX-Charakteristik, über die der XIAO sendet
UART_TX_CHAR_UUID = "6E400003-B5A3-F393-E0A9-E50E24DCCA9E"

# Namen der Geräte, mit denen du verbinden möchtest
TARGET_DEVICES = ["Mein_Akku_nRF52_1", "Mein_Akku_nRF52_2"]

async def connect_and_listen(device):
    """Baut die Verbindung zu einem einzelnen Gerät auf und hält sie."""
    print(f"STATUS: Verbinde mit {device.name} ({device.address})...", flush=True)
    
    try:
        async with BleakClient(device.address) as client:
            print(f"STATUS: Verbunden mit {device.name}! Warte auf Daten...", flush=True)
            
            def callback(sender, data):
                # Wir nutzen exakt das alte Format (DATA:), 
                # da der Akku selbst die 1 oder 2 sendet und Java das aufteilt
                decoded_data = data.decode('utf-8').strip()
                print(f"DATA:{decoded_data}", flush=True)

            await client.start_notify(UART_TX_CHAR_UUID, callback)
            
            # Verbindung unendlich lange offen halten
            while True:
                await asyncio.sleep(1)
                
    except Exception as e:
        print(f"STATUS: Verbindung zu {device.name} getrennt/fehlgeschlagen: {e}", flush=True)

async def main():
    print("STATUS: Scanne nach XIAO Geräten (5 Sekunden Suchzeit)...", flush=True)
    devices = await BleakScanner.discover(timeout=5.0)
    
    print("STATUS: --- ALLE GEFUNDENEN GERÄTE ---", flush=True)
    target_devices_found = []
    for d in devices:
        # Gibt jedes gefundene Gerät mit Namen aus, um den exakten String zu sehen
        if d.name:
            print(f"STATUS: Gefunden -> '{d.name}'", flush=True)
            if d.name in TARGET_DEVICES: 
                target_devices_found.append(d)
    print("STATUS: ------------------------------", flush=True)
            
    if not target_devices_found:
        print("STATUS: Keine Ziel-Akkus in der Nähe gefunden.", flush=True)
        return

    print(f"STATUS: {len(target_devices_found)} Ziel-Gerät(e) gefunden. Starte Verbindungen...", flush=True)
    
    tasks = [connect_and_listen(dev) for dev in target_devices_found]
    await asyncio.gather(*tasks)

# Skript starten
try:
    asyncio.run(main())
except KeyboardInterrupt:
    print("STATUS: Beendet.", flush=True)