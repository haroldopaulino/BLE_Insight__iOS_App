# BLE Insight iOS Scanner

**Native iOS Bluetooth Low Energy scanner built with Swift, SwiftUI, CoreBluetooth, and the Observation framework for real-time BLE discovery, RSSI/signal-quality analysis, advertisement inspection, connectable status, service UUID visibility, manufacturer data awareness, advertisement counts, and last-seen tracking.**

BLE Insight is a professional iOS BLE scanner designed for mobile developers, embedded engineers, firmware engineers, IoT teams, QA testers, and connected-device product teams. The app discovers nearby Bluetooth Low Energy peripherals and presents useful signal, advertisement, and discovery information in a clean SwiftUI interface.

This project demonstrates practical iOS engineering with CoreBluetooth while also showing strong hardware-adjacent product thinking for BLE-enabled devices.

<img width="1536" height="1024" alt="ble_insight_ios" src="https://github.com/user-attachments/assets/ed4fe279-55ab-4163-b9b5-f20a950fde43" />

---

## Why This Project Matters

Bluetooth Low Energy is widely used in wearables, IoT sensors, medical devices, smart locks, fitness devices, industrial peripherals, smart home products, asset trackers, and embedded prototypes. A BLE scanner is one of the most useful tools during firmware bring-up and connected-device debugging because it confirms whether a device is advertising correctly and whether the mobile platform can detect it reliably.

BLE Insight demonstrates:

- Native iOS development with Swift
- SwiftUI user interface implementation
- CoreBluetooth scanner integration
- Real-time BLE advertisement discovery
- RSSI and signal-quality analysis
- Connectable-device detection
- Service UUID inspection
- Manufacturer data visibility
- Advertisement count tracking
- Last-seen tracking
- Bluetooth permission handling
- Observation framework usage
- Clean App / Domain / Data / Presentation separation
- Mobile tooling for embedded and IoT validation

---

## Project Overview

BLE Insight scans nearby Bluetooth Low Energy advertisements and displays discovered devices in a modern dark SwiftUI interface.

Each discovered device card can show:

- Device name
- RSSI
- Signal quality
- Connectable status
- Advertisement count
- Service UUIDs
- Manufacturer data size
- Last-seen time

The app is designed to run on a real iPhone or iPad with Bluetooth enabled. BLE scanning cannot be validated in the iOS Simulator because the simulator cannot scan real nearby Bluetooth advertisements.

---

## Main Features

### Real-Time BLE Scanning

BLE Insight uses CoreBluetooth to discover nearby BLE peripherals and update the UI as devices appear or are seen again.

This is useful for:

- Testing embedded BLE peripherals
- Debugging advertising behavior
- Validating service UUID exposure
- Checking whether a device is discoverable
- Inspecting RSSI changes during range testing
- Comparing multiple nearby BLE devices
- Confirming whether firmware sleep/reset behavior affects advertising

### RSSI and Signal Quality

The app displays RSSI and signal-quality information so raw Bluetooth signal strength is easier to understand during testing.

RSSI visibility is useful when evaluating:

- Device distance
- Enclosure impact
- Antenna placement
- Wearable/body-blocking behavior
- Firmware advertising consistency
- Physical deployment environment

### Advertisement Count Tracking

BLE Insight tracks how often a device has been observed. This helps engineers determine whether a peripheral is actively advertising and whether it appears consistently during a scan session.

### Connectable Status

The app shows whether a peripheral appears connectable, which is important when validating devices that are expected to support mobile connections.

### Service UUID Visibility

The app displays advertised service UUIDs when available. This helps confirm whether embedded firmware is exposing the expected BLE services.

### Manufacturer Data Awareness

The app reports manufacturer data size when manufacturer-specific payloads are present. This is useful for proprietary peripherals, sensors, beacons, and embedded products that rely on compact advertisement payloads.

### Last-Seen Tracking

Each device includes a last-seen timestamp so engineers can tell whether a device is still nearby and actively advertising.

### Clean SwiftUI Interface

The app uses a card-based SwiftUI layout and dark UI styling designed for readability during engineering/debugging sessions.

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
| IDE | Xcode |
| Device requirement | Real iPhone or iPad with Bluetooth enabled |
| Language breakdown | Swift 100% |
| License | GPL-3.0 |

---

## Repository Structure

```text
BLE_Insight__iOS_App/
├── BLEInsight.xcodeproj/
├── BLEInsight/
│   ├── App/
│   ├── Domain/
│   ├── Data/
│   ├── Presentation/
│   ├── Assets.xcassets/
│   ├── Preview Content/
│   └── Info.plist
├── README.md
└── LICENSE
```

The current repository page lists `BLEInsight.xcodeproj`, the `BLEInsight` source folder, `README.md`, and the GPL-3.0 license. The GitHub language breakdown shows Swift as 100% of the repository.

---

## Architecture

BLE Insight separates app startup, domain models, Bluetooth implementation, and presentation code into dedicated areas.

```text
App
 └── SwiftUI app entry point and startup configuration

Domain
 └── BLE device models and Bluetooth power-state models

Data
 └── CoreBluetooth scanning service and platform Bluetooth implementation

Presentation
 └── SwiftUI scanner screens, device cards, theme, and scanner ViewModel
```

This structure keeps Bluetooth platform code away from UI rendering and makes the app easier to maintain, test, and extend.

---

## Data Flow

```text
CoreBluetooth scan result
      ↓
BLE scanning service
      ↓
Domain device model
      ↓
Scanner ViewModel
      ↓
SwiftUI device list and cards
      ↓
User-visible BLE diagnostics
```

This is a clean mobile architecture pattern: platform APIs are handled in the data layer, BLE state is modeled in the domain layer, and SwiftUI renders the presentation layer.

---

## BLE Data Displayed

| Field | Purpose |
|---|---|
| Device name | Identifies advertised peripherals when a local name is available |
| RSSI | Shows raw signal strength |
| Signal quality | Converts RSSI into easier-to-read quality information |
| Connectable | Shows whether the device appears available for connection |
| Advertisement count | Tracks how often the device was seen |
| Service UUIDs | Confirms advertised BLE services |
| Manufacturer data size | Indicates manufacturer-specific payload presence |
| Last seen | Shows the most recent advertisement observation time |

---

## iOS Bluetooth Behavior

BLE Insight follows normal iOS Bluetooth behavior:

- iOS presents the Bluetooth permission prompt when CoreBluetooth is used.
- Apps cannot silently enable Bluetooth.
- If Bluetooth is off, the user must enable it manually from Control Center or Settings.
- BLE scanning must be tested on a physical iPhone or iPad.
- The iOS Simulator cannot scan real BLE advertisements.

---

## Embedded, Firmware, and IoT Relevance

BLE Insight is especially useful for embedded and firmware workflows because BLE scanner apps are commonly used during device bring-up.

A firmware engineer can use this app to verify:

- Whether a BLE peripheral is advertising
- Whether iOS can discover the peripheral
- Whether service UUIDs are present
- Whether manufacturer data is included
- Whether RSSI changes with distance or enclosure design
- Whether advertising remains active after sleep, reset, or power transitions
- Whether the device appears connectable
- Whether scan behavior differs between firmware versions

This makes BLE Insight a strong bridge between iOS development and embedded BLE product validation.

---

## Skills Demonstrated

This repository demonstrates several iOS, wireless, and connected-device engineering skills:

- Swift development
- SwiftUI UI development
- CoreBluetooth scanning
- BLE advertisement handling
- Bluetooth permission handling
- Real-time UI state updates
- Observation framework usage
- RSSI-based signal interpretation
- BLE domain modeling
- App/domain/data/presentation separation
- Hardware-adjacent mobile debugging
- Clean UI design for engineering tools
- Product thinking for BLE/IoT workflows

---

## How to Run

1. Clone the repository.
2. Open `BLEInsight.xcodeproj` in Xcode.
3. Select a real iPhone or iPad.
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
