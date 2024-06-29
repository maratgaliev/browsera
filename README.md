# browsera

browsera is a macOS menu bar application that allows users to quickly view and change their default web browser. It provides a simple interface to select from installed browsers and set one as the system default.

## Features

- Displays a list of installed web browsers in the menu bar
- Allows setting any listed browser as the system default with a single click
- Uses monochrome icons for a clean, consistent look
- Includes an About dialog with developer information

## How It Works

browsera is built using Swift and AppKit, with a SwiftUI wrapper for the app structure. Here's a high-level overview of its components and functionality:

1. **App Structure**: The app uses the `@NSApplicationDelegateAdaptor` property wrapper to bridge SwiftUI with the traditional AppKit-based menu bar app structure.

2. **Menu Bar Integration**: The app creates a status item in the menu bar using `NSStatusBar`, displaying a monochrome browser icon.

3. **Browser Detection**: On launch and each time the menu is opened, the app checks for installed browsers using a predefined list of bundle identifiers.

4. **Menu Creation**: For each detected browser, a menu item is created with the browser's name and a monochrome version of its icon.

5. **Default Browser Setting**: When a browser is selected from the menu, the app uses the `LSSetDefaultHandlerForURLScheme` function to set it as the default for HTTP and HTTPS protocols.

6. **Monochrome Icons**: The app converts all browser icons to monochrome using Core Image filters for a consistent appearance.

7. **About Dialog**: An "About" menu item opens a dialog with the developer's information and a clickable website link.

## Key Components

- `AppDelegate`: Manages the app's lifecycle, creates the menu, and handles user interactions.
- `convertToMonochrome(_:)`: A function that converts color images to monochrome using Core Image filters.
- `setBrowserAsDefault(_:)`: Sets the selected browser as the system default.
- `showAbout()`: Displays the About dialog with developer information.

## Installation

1. Clone the repository
2. Open the project in Xcode
3. Build and run the application

Note: Ensure that your app's target settings include the "Application is agent (UIElement)" key set to "YES" in the Info.plist to make it a true menu bar app without a dock icon.

## Requirements

- macOS 11.0 or later
- Xcode 12.0 or later

## Author

Marat Galiev
https://maratgaliev.com