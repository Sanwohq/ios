# Contributing to Sanwo iOS SDK

Thank you for your interest in contributing to the Sanwo iOS SDK! This guide will help you get started.

## Getting Started

1. Fork the repository
2. Clone your fork:
   ```bash
   git clone https://github.com/YOUR_USERNAME/ios.git
   cd ios
   ```
3. Open the project in Xcode or build from the command line:
   ```bash
   swift build
   ```

## Development

### Requirements

- Xcode 15.0 or later
- Swift 5.9 or later
- iOS 15.0+ deployment target

### Building

```bash
swift build
```

### Running Tests

```bash
swift test
```

### Project Structure

```
Sources/Sanwo/
├── Sanwo.swift                        # Main class
├── CheckoutOptions.swift              # Options struct
├── CheckoutResult.swift               # Result enum
├── CheckoutCustomer.swift             # Customer struct
├── SanwoProvider.swift                # Provider definition
├── SanwoProviders.swift               # Built-in providers
├── SanwoEvent.swift                   # Event types & handler
├── Engine.swift                       # Template rendering & bridge
├── SanwoCheckoutViewController.swift  # UIKit WebView controller
├── SanwoCheckoutModifier.swift        # SwiftUI view modifier
└── Templates/
    ├── PaystackTemplate.swift
    └── FlutterwaveTemplate.swift
```

## Adding a New Provider

1. Create a new template file in `Sources/Sanwo/Templates/`:
   ```swift
   // Sources/Sanwo/Templates/MyProviderTemplate.swift
   enum MyProviderTemplate {
       static let html = """
       <!DOCTYPE html>
       <html>
       <body onload="initPayment()">
         <script src="https://provider-sdk-url.js"></script>
         <script>
           {{sanwoBridge}}
           var params = {{params}};
           function initPayment() {
             // Initialize the provider with params
             // Call sanwoCallback('success', {...}) on success
             // Call sanwoCallback('cancelled', {}) on cancel
             // Call sanwoCallback('error', { message: '...' }) on error
           }
         </script>
       </body>
       </html>
       """
   }
   ```

2. Add the provider in `Sources/Sanwo/SanwoProviders.swift`:
   ```swift
   extension SanwoProvider {
       public static let myProvider = SanwoProvider(
           id: "myprovider",
           name: "My Provider",
           template: MyProviderTemplate.html,
           amountInMinorUnit: true
       )
   }
   ```

3. Add tests for the new provider.

## Pull Requests

1. Create a feature branch from `main`
2. Make your changes
3. Ensure all tests pass: `swift test`
4. Ensure the project builds cleanly: `swift build`
5. Submit a pull request against `main`

### PR Guidelines

- Keep PRs focused on a single change
- Write descriptive commit messages
- Add tests for new functionality
- Update documentation if needed

## Code Style

- Follow Swift API Design Guidelines
- Use descriptive names
- Document public APIs with doc comments
- Keep functions focused and concise

## Reporting Issues

If you find a bug or have a feature request, please open an issue on GitHub with:
- A clear description of the issue
- Steps to reproduce (for bugs)
- Expected vs actual behavior
- Your environment (Xcode version, iOS version, device)

## License

By contributing, you agree that your contributions will be licensed under the Apache License 2.0.
