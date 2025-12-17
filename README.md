# Sandwich Shop

A simple Flutter app that demonstrates a small ordering flow for a sandwich shop. The app includes a sandwich counter, cart, checkout, user profile, settings, and order history backed by a local database. It is intended for educational/demo purposes and includes unit and integration tests.

**Status:** Prototype / Course project

**Platforms:** Android, iOS, Web, macOS, Windows, Linux (Flutter-supported targets)

---

**Table of contents**

- **Description**
- **Features**
- **Getting started**
- **Running the app**
- **Testing**
- **Project structure**
- **Contributing**

---

## Description

`Sandwich Shop` is a lightweight Flutter application intended to illustrate a simple e-commerce-like flow: selecting sandwiches, adding them to a cart, checking out (which persists orders locally), and viewing order history. It uses `Provider` for simple state management and `sqflite` (or `sqflite_common_ffi` in tests) for local persistence.

## Features

- Choose sandwich types and sizes
- Adjust quantity and add items to cart
- View cart and perform a (simulated) checkout
- Persist orders locally and view order history
- Basic profile and settings screens (font size preference)
- Right-side (end) drawer with navigation
- Unit and integration tests included in the repository

## Getting started

Prerequisites:

- Flutter SDK (stable channel) installed and configured
- A platform target (Android/iOS/macOS/Windows) or web to run the app

Clone the repository and fetch dependencies:

```powershell
git clone <repo-url>
cd sandwich_shop
flutter pub get
```

If you're running tests that use the `sqflite` plugin on a desktop/test environment, the integration tests include `sqflite_common_ffi` initialization so tests can run without a platform channel-backed database.

## Running the app

Run on a connected device or emulator:

```powershell
flutter run
```

To target web:

```powershell
flutter run -d chrome
```

## Testing

Unit and widget tests are in the `test/` directory. Run them with:

```powershell
flutter test
```

Integration tests are located in `intergration_test/` (note: the project keeps the intentionally-named folder `intergration_test` to match previous assignments). Run the single integration test file with:

```powershell
flutter test integration_test\app_test.dart
```

If you see plugin errors for `shared_preferences` in tests, the integration test file sets up `SharedPreferences.setMockInitialValues({})` and also initializes `sqflite_common_ffi` for database access in test environments.

## Project structure (high level)

- `lib/` – main app code
	- `main.dart` – app entrypoint
	- `models/` – data models (`sandwich.dart`, `cart.dart`, `saved_order.dart`)
	- `views/` – screens (order screen, cart, checkout, order history, profile, settings)
	- `widgets/` – reusable widgets (buttons, app bars)
- `test/` – unit and widget tests
- `intergration_test/` – end-to-end integration tests (kept as `intergration_test` per project history)


## License

This repository is provided for educational purposes. Check the project root for any licensing files or contact the maintainer.

