# Sanwo iOS SDK

## Build & Test

```bash
swift build      # Build the package
swift test       # Run all tests
```

## Architecture

Sanwo is a universal payment SDK. The iOS SDK uses WKWebView to load provider HTML templates.

### How it works

1. Provider packages define HTML templates with `{{sanwoBridge}}` and `{{params}}` placeholders
2. The `Engine` replaces `{{sanwoBridge}}` with a JS function that calls `window.webkit.messageHandlers.sanwo.postMessage()`
3. The `Engine` replaces `{{params}}` with serialized JSON checkout parameters
4. `SanwoCheckoutViewController` loads the HTML in a WKWebView and listens for messages via `WKScriptMessageHandler`
5. Messages follow the format: `{ type: "sanwo", event: "success"|"cancelled"|"closed"|"error"|"loaded", data: {...} }`

### Key files

- `Sources/Sanwo/Sanwo.swift` - Main entry point, event registration, checkout presentation
- `Sources/Sanwo/Engine.swift` - Template rendering, bridge generation, amount conversion
- `Sources/Sanwo/SanwoCheckoutViewController.swift` - UIKit controller with WKWebView
- `Sources/Sanwo/SanwoCheckoutModifier.swift` - SwiftUI view modifier
- `Sources/Sanwo/SanwoProvider.swift` - Provider struct definition (public, used by provider packages)
- `Sources/SanwoPaystack/SanwoPaystack.swift` - Paystack provider definition and HTML template
- `Sources/SanwoFlutterwave/SanwoFlutterwave.swift` - Flutterwave provider definition and HTML template

### Code conventions

- Swift 5.9+, iOS 15+ minimum
- UIKit code is guarded with `#if canImport(UIKit)`
- SwiftUI code is guarded with `#if canImport(SwiftUI)`
- All public APIs have doc comments
- Amount values are in minor units (kobo/cents); the engine handles conversion per provider
