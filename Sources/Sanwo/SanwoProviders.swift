import Foundation

/// Built-in payment providers supported by Sanwo out of the box.
extension SanwoProvider {
    /// Paystack payment provider.
    ///
    /// Paystack expects amounts in minor units (kobo for NGN, pesewas for GHS).
    public static let paystack = SanwoProvider(
        id: "paystack",
        name: "Paystack",
        template: PaystackTemplate.html,
        amountInMinorUnit: true
    )

    /// Flutterwave payment provider.
    ///
    /// Flutterwave expects amounts in major units (naira, not kobo), so the engine
    /// converts from minor units automatically.
    public static let flutterwave = SanwoProvider(
        id: "flutterwave",
        name: "Flutterwave",
        template: FlutterwaveTemplate.html,
        amountInMinorUnit: false
    )
}
