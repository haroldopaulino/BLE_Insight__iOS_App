# BLE Insight for iOS

**Native iOS Bluetooth Low Energy scanner built with Swift, SwiftUI, CoreBluetooth, and the Observation framework for real-time BLE device discovery, signal analysis, advertisement inspection, and clean mobile architecture.**

BLE Insight is a professional-grade iOS application for discovering and analyzing nearby Bluetooth Low Energy devices. The app scans BLE advertisements in real time and displays useful device information in a polished SwiftUI interface, including device name, RSSI, signal quality, connectable status, advertisement count, service UUIDs, manufacturer data size, and last-seen time.

This project demonstrates strong iOS engineering skills while also connecting directly to embedded, IoT, hardware, and firmware workflows where BLE visibility and device diagnostics are important.

---

## Why This Project Matters

BLE is widely used in wearables, IoT devices, medical devices, fitness products, smart locks, sensors, industrial hardware, and consumer electronics. A BLE scanner is a practical engineering tool because it helps developers validate whether embedded devices are advertising correctly and whether mobile apps can detect them reliably.

This project demonstrates:

- Native iOS development with Swift
- SwiftUI interface implementation
- CoreBluetooth integration
- BLE advertisement scanning
- Real-time device discovery
- RSSI and signal-quality analysis
- Connectable-device detection
- Service UUID inspection
- Manufacturer data inspection
- Last-seen tracking
- Reactive UI updates
- Observation framework usage
- Clean App / Domain / Data / Presentation separation
- Mobile tooling for embedded and IoT debugging

For employers, this repository shows the ability to build mobile software that interacts with real wireless hardware, which is valuable for iOS, BLE, IoT, embedded, firmware, and connected-device engineering roles.

---

## Project Overview

BLE Insight scans nearby Bluetooth Low Energy advertisements and presents discovered devices in a modern dark UI.

Each discovered device card shows:

- Device name
- RSSI
- Signal quality
- Connectable status
- Advertisement count
- Service UUIDs
- Manufacturer data size
- Last-seen time

The app is designed to be used on a real iPhone or iPad with Bluetooth enabled. BLE scanning does not work in the iOS Simulator because the simulator cannot scan real nearby Bluetooth advertisements.

---

## Main Features

### Real-Time BLE Scanning

The app uses CoreBluetooth to scan nearby BLE advertisements and update the UI as devices are discovered or seen again.

This is useful for:

- Testing embedded BLE peripherals
- Debugging advertising behavior
- Checking whether a device is discoverable
- Inspecting signal strength during movement or range testing
- Validating service UUID exposure
- Comparing nearby BLE devices

### Device Signal Analysis

Each device includes RSSI data and a user-friendly signal-quality interpretation. This helps turn raw BLE signal strength into information that is easier to read during field testing.

### Advertisement Count Tracking

The app tracks how many times a device has been observed. This helps identify whether a device is actively advertising and how consistently it appears during scans.

### Connectable Status

BLE Insight shows whether a device is connectable, which is important when testing peripherals that should accept connections from a mobile app.

### Service UUID Display

The app displays advertised service UUIDs when available. This is especially useful when validating custom embedded firmware services or checking whether a peripheral is advertising the expected BLE profile.

### Manufacturer Data Visibility

The app reports manufacturer data size, giving quick visibility into whether manufacturer-specific advertisement payloads are present.

### Last-Seen Tracking

Each device card includes the last-seen time, helping users determine whether a peripheral is still nearby and actively advertising.

### Modern SwiftUI Interface

The app uses a clean dark UI with card-based BLE device presentation. The interface is designed to be readable during real-world scanning and debugging sessions.

---

## Technical Stack

| Layer | Technology |
|---|---|
| Platform | iOS |
| Language | Swift |
| UI | SwiftUI |
| Bluetooth | CoreBluetooth |
| State updates | Observation framework |
| Architecture | App / Domain / Data / Presentation |
| Required IDE | Xcode 16 or newer |
| Required OS | iOS 18 or newer |
| Device requirement | Real iPhone or iPad with Bluetooth enabled |
| License | GPL-3.0 |

---

## Architecture

The project uses a small, clean separation of concerns:

```text
BLEInsight/
├── App
├── Domain
├── Data
├── Presentation
├── Assets.xcassets
├── Preview Content
└── Info.plist
```

### App

Contains the SwiftUI app entry point and application startup configuration.

### Domain

Contains the core BLE-related models, including device information and Bluetooth power-state representation.

### Data

Contains the CoreBluetooth scanning service responsible for interacting with iOS Bluetooth APIs.

### Presentation

Contains SwiftUI screens, device cards, app theme, and the scanner ViewModel.

This structure keeps Bluetooth implementation details separate from UI rendering and domain models, making the project easier to maintain, test, and extend.

---

## BLE Data Displayed

BLE Insight presents the following information for each discovered device:

| Field | Purpose |
|---|---|
| Name | Human-readable device name when advertised |
| RSSI | Raw signal strength value |
| Signal quality | User-friendly signal interpretation |
| Connectable | Whether the peripheral appears connectable |
| Advertisement count | Number of times the device has been observed |
| Service UUIDs | Advertised BLE services |
| Manufacturer data size | Size of manufacturer-specific advertisement data |
| Last seen | Most recent time the advertisement was observed |

---

## Permissions

The app includes Bluetooth usage descriptions in `Info.plist`.

iOS presents the Bluetooth permission prompt automatically when CoreBluetooth is initialized.

Important iOS behavior:

- Apps cannot silently turn Bluetooth on.
- If Bluetooth is off, the user must enable it from Control Center or Settings.
- BLE scanning requires a real iPhone or iPad.
- The iOS Simulator cannot scan real BLE advertisements.

---

## Skills Demonstrated

This repository demonstrates several iOS, wireless, and connected-device engineering skills:

- Swift development
- SwiftUI app development
- CoreBluetooth scanning
- BLE advertisement handling
- Bluetooth permission handling
- Real-time UI state updates
- Observation framework usage
- RSSI-based signal interpretation
- Device-discovery data modeling
- Separation of concerns
- Domain/data/presentation architecture
- Mobile debugging tools for embedded devices
- Hardware-adjacent mobile engineering
- Clean user interface design

---

## Embedded and Firmware Relevance

This project is especially useful for embedded and firmware workflows because BLE scanner apps are commonly used to validate wireless behavior from hardware prototypes.

A firmware engineer can use this type of app to verify:

- Whether a BLE peripheral is advertising
- Whether advertising intervals appear active
- Whether the expected service UUIDs are present
- Whether manufacturer data is included
- Whether RSSI changes with distance or enclosure changes
- Whether a device appears connectable
- Whether the device disappears after sleep, reset, or power changes

That makes this app a strong bridge between mobile development and embedded systems engineering.

---

## How to Run

1. Clone the repository.
2. Open `BLEInsight.xcodeproj` in Xcode 16 or newer.
3. Select a real iPhone or iPad running iOS 18 or newer.
4. Make sure Bluetooth is enabled on the device.
5. Build and run the app.
6. Accept the Bluetooth permission prompt when iOS displays it.
7. View nearby BLE advertisements in the scanner UI.

BLE scanning requires physical hardware. The iOS Simulator cannot scan real BLE devices.

---

## Owner

by Harold Paulino

---

## License

This project is licensed under the GPL-3.0 license.
