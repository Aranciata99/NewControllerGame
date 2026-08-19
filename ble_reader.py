import asyncio
import sys
from bleak import BleakClient, BleakScanner

# Die TX-Charakteristik, über die der XIAO sendet
UART_TX_CHAR_UUID = "6E400003-B5A3-F393-E0A9-E50E24DCCA9E"

async def main():
    print("STATUS: Scanne nach XIAO...", flush=True)
    devices = await BleakScanner.discover(timeout=5.0)
    
    xiao_device = None
    for d in devices:
        # Sucht nach einem Gerät, das "XIAO" im Namen hat
        if d.name and "Mein_Akku_nRF52" in d.name: 
            xiao_device = d
            break
            
    if not xiao_device:
        print("STATUS: Kein XIAO in der Nähe gefunden.", flush=True)
        return

    print(f"STATUS: Gefunden: {xiao_device.name}. Verbinde...", flush=True)
    
    async with BleakClient(xiao_device.address) as client:
        print("STATUS: Verbunden! Warte auf Daten...", flush=True)
        
        # Wird immer ausgelöst, wenn der XIAO ein Signal schickt
        def callback(sender, data):
            # Wir drucken "DATA:" davor, damit dein Java-Programm das Signal erkennt
            print(f"DATA:{data.decode('utf-8').strip()}", flush=True)

        await client.start_notify(UART_TX_CHAR_UUID, callback)
        
        # Verbindung unendlich lange offen halten
        while True:
            await asyncio.sleep(1)

# Skript starten
try:
    asyncio.run(main())
except KeyboardInterrupt:
    print("STATUS: Beendet.", flush=True)