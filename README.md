# BLE Insight for iOS

BLE Insight is a native iOS Bluetooth Low Energy scanner built with Swift, SwiftUI, CoreBluetooth, and the Observation framework.

## Owner

by Harold Paulino

## What it does

BLE Insight scans for nearby Bluetooth Low Energy advertisements and displays the discovered devices in a modern dark UI. Each device card shows the name, RSSI, signal quality, connectable status, advertisement count, service UUIDs, manufacturer data size, and last-seen time.

## Architecture

The project uses a small, clean separation of concerns:

- `App`: SwiftUI app entry point
- `Domain`: BLE device and Bluetooth power state models
- `Data`: CoreBluetooth scanning service
- `Presentation`: SwiftUI screens, cards, theme, and scanner ViewModel

## Requirements

- Xcode 16 or newer
- iOS 18 or newer
- A real iPhone or iPad with Bluetooth enabled

BLE scanning requires a physical device. The iOS Simulator does not scan real BLE advertisements.

## Permissions

The app includes Bluetooth usage descriptions in `Info.plist`. iOS presents the Bluetooth permission prompt automatically when CoreBluetooth is initialized.

## Notes

iOS apps cannot turn Bluetooth on silently. If Bluetooth is off, iOS requires the user to enable it from Control Center or Settings.
