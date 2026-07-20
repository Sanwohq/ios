import Foundation

/// Defines a payment provider that Sanwo can use to process payments.
///
/// Each provider supplies an HTML template containing `{{sanwoBridge}}` and `{{params}}`
/// placeholders that the engine replaces at runtime.
public struct SanwoProvider: Sendable {
    /// Unique identifier for this provider (e.g. "paystack", "flutterwave").
    public let id: String

    /// Short name for this provider (e.g. "paystack", "flutterwave").
    public let name: String

    /// Human-readable display name (e.g. "Paystack", "Flutterwave").
    public let displayName: String

    /// The HTML template string containing `{{sanwoBridge}}` and `{{params}}` placeholders.
    public let template: String

    /// Whether the provider expects amounts in minor units (e.g. kobo, cents).
    /// If `false`, the engine will convert from minor units before passing to the template.
    public let amountInMinorUnit: Bool

    /// ISO 4217 currency codes supported by this provider (e.g. `["NGN", "USD"]`).
    public let supportedCurrencies: [String]

    /// ISO 3166-1 alpha-2 country codes supported by this provider (e.g. `["NG", "US"]`).
    public let supportedCountries: [String]

    /// Creates a new provider definition.
    ///
    /// - Parameters:
    ///   - id: Unique identifier for the provider.
    ///   - name: Short name for the provider.
    ///   - displayName: Human-readable display name.
    ///   - template: HTML template with `{{sanwoBridge}}` and `{{params}}` placeholders.
    ///   - amountInMinorUnit: Whether the provider expects amounts in minor units. Defaults to `true`.
    ///   - supportedCurrencies: ISO 4217 currency codes supported by this provider. Defaults to an empty array.
    ///   - supportedCountries: ISO 3166-1 alpha-2 country codes supported by this provider. Defaults to an empty array.
    public init(
        id: String,
        name: String,
        displayName: String,
        template: String,
        amountInMinorUnit: Bool = true,
        supportedCurrencies: [String] = [],
        supportedCountries: [String] = []
    ) {
        self.id = id
        self.name = name
        self.displayName = displayName
        self.template = template
        self.amountInMinorUnit = amountInMinorUnit
        self.supportedCurrencies = supportedCurrencies
        self.supportedCountries = supportedCountries
    }
}
