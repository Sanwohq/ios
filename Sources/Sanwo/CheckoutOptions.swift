import Foundation

/// Configuration options for a checkout session.
public struct CheckoutOptions: @unchecked Sendable {
    /// Payment amount in minor units (e.g. kobo, cents).
    ///
    /// For example, NGN 5,000.00 should be passed as `500000`.
    public let amount: Int

    /// ISO 4217 currency code (e.g. "NGN", "USD", "GHS").
    public let currency: String

    /// Customer information for this checkout.
    public let customer: CheckoutCustomer

    /// A unique reference for this transaction. If `nil`, the provider will generate one.
    public let reference: String?

    /// Payment channels to restrict to (provider-specific, e.g. `["card", "bank"]`).
    public let channels: [String]?

    /// Additional metadata to attach to the transaction.
    public let metadata: [String: Any]?

    /// Provider-specific payment options (e.g. Flutterwave's `payment_options`).
    public let paymentOptions: String?

    /// Flutterwave sub-accounts for split payments.
    public let subaccounts: [[String: Any]]?

    /// Paystack checkout method. Defaults to `"checkout"`.
    public let method: String?

    /// Called when the checkout UI has finished loading.
    public let onLoad: (@Sendable () -> Void)?

    /// Called when an error occurs during checkout initialization.
    public let onError: (@Sendable (SanwoError) -> Void)?

    /// Provider-specific extra parameters merged into the top-level template params.
    ///
    /// Use this for fields like Monnify's `contractCode`, `isTestMode`, `paymentMethods`,
    /// or Interswitch's `payItemId`, `siteRedirectUrl`.
    public let extra: [String: Any]?

    /// Creates new checkout options.
    ///
    /// - Parameters:
    ///   - amount: Payment amount in minor units.
    ///   - currency: ISO 4217 currency code.
    ///   - customer: Customer information.
    ///   - reference: Unique transaction reference. Defaults to `nil`.
    ///   - channels: Allowed payment channels. Defaults to `nil`.
    ///   - metadata: Additional metadata. Defaults to `nil`.
    ///   - paymentOptions: Provider-specific payment options. Defaults to `nil`.
    ///   - subaccounts: Sub-accounts for split payments. Defaults to `nil`.
    ///   - method: Paystack checkout method. Defaults to `nil`.
    ///   - onLoad: Callback when checkout loads. Defaults to `nil`.
    ///   - onError: Callback for errors. Defaults to `nil`.
    public init(
        amount: Int,
        currency: String,
        customer: CheckoutCustomer,
        reference: String? = nil,
        channels: [String]? = nil,
        metadata: [String: Any]? = nil,
        paymentOptions: String? = nil,
        subaccounts: [[String: Any]]? = nil,
        method: String? = nil,
        extra: [String: Any]? = nil,
        onLoad: (@Sendable () -> Void)? = nil,
        onError: (@Sendable (SanwoError) -> Void)? = nil
    ) {
        self.amount = amount
        self.currency = currency
        self.customer = customer
        self.reference = reference
        self.channels = channels
        self.metadata = metadata
        self.paymentOptions = paymentOptions
        self.subaccounts = subaccounts
        self.method = method
        self.extra = extra
        self.onLoad = onLoad
        self.onError = onError
    }
}

/// Represents an error that occurred during a Sanwo checkout.
public struct SanwoError: Error, Sendable {
    /// A human-readable error message.
    public let message: String

    /// Creates a new `SanwoError`.
    ///
    /// - Parameter message: A human-readable error message.
    public init(message: String) {
        self.message = message
    }
}
