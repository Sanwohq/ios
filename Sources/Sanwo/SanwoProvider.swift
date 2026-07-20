import Foundation

/// Defines a payment provider that Sanwo can use to process payments.
///
/// Each provider supplies an HTML template containing `{{sanwoBridge}}` and `{{params}}`
/// placeholders that the engine replaces at runtime.
public struct SanwoProvider: Sendable {
    /// Unique identifier for this provider (e.g. "paystack", "flutterwave").
    public let id: String

    /// Human-readable name for display purposes.
    public let name: String

    /// The HTML template string containing `{{sanwoBridge}}` and `{{params}}` placeholders.
    public let template: String

    /// Whether the provider expects amounts in minor units (e.g. kobo, cents).
    /// If `false`, the engine will convert from minor units before passing to the template.
    public let amountInMinorUnit: Bool

    /// Creates a new provider definition.
    ///
    /// - Parameters:
    ///   - id: Unique identifier for the provider.
    ///   - name: Human-readable display name.
    ///   - template: HTML template with `{{sanwoBridge}}` and `{{params}}` placeholders.
    ///   - amountInMinorUnit: Whether the provider expects amounts in minor units. Defaults to `true`.
    public init(
        id: String,
        name: String,
        template: String,
        amountInMinorUnit: Bool = true
    ) {
        self.id = id
        self.name = name
        self.template = template
        self.amountInMinorUnit = amountInMinorUnit
    }
}
