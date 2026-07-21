# Sanwo iOS SDK

A universal payment SDK for iOS. Integrate multiple payment providers (Paystack, Flutterwave, and more) with a single, consistent API.

## Installation

### Swift Package Manager

Add Sanwo to your project using SPM:

1. In Xcode, go to **File > Add Package Dependencies...**
2. Enter the repository URL:
   ```
   https://github.com/Sanwohq/ios
   ```
3. Select your version rule and click **Add Package**
4. Choose which libraries to add:
   - **Sanwo** (core SDK, always required)
   - **SanwoPaystack** (Paystack provider)
   - **SanwoFlutterwave** (Flutterwave provider)
   - **SanwoRazorpay** (Razorpay provider)
   - **SanwoMonnify** (Monnify provider)
   - **SanwoInterswitch** (Interswitch provider)

Or add it to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/Sanwohq/ios.git", from: "0.1.0")
]
```

Then add the products to your target's dependencies:

```swift
.target(
    name: "MyApp",
    dependencies: [
        .product(name: "Sanwo", package: "ios"),
        .product(name: "SanwoPaystack", package: "ios"),
    ]
)
```

## Quick Start

### UIKit

```swift
import Sanwo
import SanwoPaystack

class CheckoutViewController: UIViewController {
    let sanwo = Sanwo(
        provider: paystackProvider,
        publicKey: "pk_test_your_key_here"
    )

    func startPayment() {
        // Listen for events (optional)
        sanwo.on(.loaded) { event in
            print("Checkout loaded for \(event.provider)")
        }

        // Start checkout
        sanwo(
            from: self,
            options: CheckoutOptions(
                amount: 500000,  // 5,000.00 in minor units
                currency: "NGN",
                customer: CheckoutCustomer(email: "user@example.com")
            )
        ) { result in
            switch result {
            case .successful(let data):
                print("Payment successful!")
                print("Reference: \(data.reference)")
                print("Transaction ID: \(data.transactionId ?? "N/A")")

            case .cancelled(let provider, _):
                print("Payment cancelled by user (\(provider))")

            case .failed(_, _, let error):
                print("Payment failed: \(error)")
            }
        }
    }
}
```

### SwiftUI

```swift
import SwiftUI
import Sanwo
import SanwoPaystack

struct ContentView: View {
    @State private var showCheckout = false

    let sanwo = Sanwo(
        provider: paystackProvider,
        publicKey: "pk_test_your_key_here"
    )

    var body: some View {
        Button("Pay NGN 5,000") {
            showCheckout = true
        }
        .sanwoCheckout(
            isPresented: $showCheckout,
            sanwo: sanwo,
            options: CheckoutOptions(
                amount: 500000,
                currency: "NGN",
                customer: CheckoutCustomer(email: "user@example.com")
            )
        ) { result in
            switch result {
            case .successful(let data):
                print("Reference: \(data.reference)")
            case .cancelled:
                print("Cancelled")
            case .failed(_, _, let error):
                print("Failed: \(error)")
            }
        }
    }
}
```

## Providers

### Paystack

```swift
import Sanwo
import SanwoPaystack

let sanwo = Sanwo(
    provider: paystackProvider,
    publicKey: "pk_test_..."
)
```

### Flutterwave

```swift
import Sanwo
import SanwoFlutterwave

let sanwo = Sanwo(
    provider: flutterwaveProvider,
    publicKey: "FLWPUBK_TEST-..."
)
```

### Razorpay

```swift
import Sanwo
import SanwoRazorpay

let sanwo = Sanwo(
    provider: razorpayProvider,
    publicKey: "rzp_test_..."
)
```

### Monnify

```swift
import Sanwo
import SanwoMonnify

let sanwo = Sanwo(
    provider: monnifyProvider,
    publicKey: "MK_TEST_..."
)
```

### Interswitch

```swift
import Sanwo
import SanwoInterswitch

let sanwo = Sanwo(
    provider: interswitchProvider,
    publicKey: "your_merchant_code"
)
```

## Checkout Options

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `amount` | `Int` | Yes | Amount in minor units (e.g. kobo, cents) |
| `currency` | `String` | Yes | ISO 4217 currency code (e.g. "NGN", "USD") |
| `customer` | `CheckoutCustomer` | Yes | Customer information |
| `reference` | `String?` | No | Unique transaction reference |
| `channels` | `[String]?` | No | Payment channels (e.g. `["card", "bank"]`) |
| `metadata` | `[String: Any]?` | No | Additional metadata |
| `paymentOptions` | `String?` | No | Provider-specific payment options |
| `method` | `String?` | No | Paystack checkout method |
| `onLoad` | `(() -> Void)?` | No | Called when checkout UI loads |
| `onError` | `((SanwoError) -> Void)?` | No | Called on initialization error |

### Customer

```swift
let customer = CheckoutCustomer(
    email: "user@example.com",
    firstName: "John",       // optional
    lastName: "Doe",         // optional
    phone: "+2341234567890"  // optional
)
```

## Events

Register event handlers to track the checkout lifecycle:

```swift
sanwo
    .on(.started) { event in print("Checkout started") }
    .on(.opened) { event in print("Checkout UI opened") }
    .on(.loaded) { event in print("Checkout loaded") }
    .on(.success) { event in print("Payment successful") }
    .on(.cancelled) { event in print("Payment cancelled") }
    .on(.failed) { event in print("Payment failed") }
    .on(.closed) { event in print("Checkout closed") }
```

Remove handlers:

```swift
sanwo.off(.success)       // Remove specific handler
sanwo.removeAllHandlers() // Remove all handlers
```

## Checkout Result

The completion handler receives a `CheckoutResult`:

```swift
switch result {
case .successful(let data):
    // data.provider    - "paystack", "flutterwave", etc.
    // data.reference   - Transaction reference
    // data.transactionId - Provider transaction ID (optional)
    // data.raw         - Complete raw response dictionary

case .cancelled(let provider, let reference):
    // User dismissed the checkout

case .failed(let provider, let reference, let error):
    // Payment failed with error message
}
```

## Custom Providers

You can add support for any payment provider by creating a `SanwoProvider`:

```swift
let customProvider = SanwoProvider(
    id: "myprovider",
    name: "myprovider",
    displayName: "My Provider",
    template: """
    <!DOCTYPE html>
    <html>
    <body onload="initPayment()">
      <script src="https://provider-sdk.js"></script>
      <script>
        {{sanwoBridge}}
        var params = {{params}};
        function initPayment() {
          // Use params to configure the provider
          // Call sanwoCallback('success', { reference: '...' }) on success
          // Call sanwoCallback('cancelled', {}) on cancel
          // Call sanwoCallback('error', { message: '...' }) on error
        }
      </script>
    </body>
    </html>
    """,
    amountInMinorUnit: false  // Set to false if provider expects major units
)

let sanwo = Sanwo(provider: customProvider, publicKey: "key_...")
```

## Amounts

All amounts are specified in **minor units** (e.g. kobo for NGN, cents for USD):

| Display Amount | Minor Units | Currency |
|---------------|-------------|----------|
| NGN 5,000.00 | 500000 | NGN |
| USD 10.99 | 1099 | USD |
| JPY 1,000 | 1000 | JPY (0 decimals) |
| KWD 5.000 | 5000 | KWD (3 decimals) |

The SDK automatically converts minor units to major units for providers that require it (e.g. Flutterwave).

## Requirements

- iOS 15.0+
- Swift 5.9+
- Xcode 15.0+

## License

Apache 2.0. See [LICENSE](LICENSE) for details.
