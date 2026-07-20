import Foundation

/// The outcome of a checkout session.
public enum CheckoutResult {
    /// Payment completed successfully.
    case successful(SuccessData)

    /// The user cancelled the checkout before completing payment.
    case cancelled(provider: String, reference: String?)

    /// The checkout failed due to an error.
    case failed(provider: String, reference: String?, error: String)

    /// Data returned on a successful payment.
    public struct SuccessData {
        /// The provider that processed the payment (e.g. "paystack", "flutterwave").
        public let provider: String

        /// The transaction reference.
        public let reference: String

        /// The provider's internal transaction ID, if available.
        public let transactionId: String?

        /// The complete raw response from the provider.
        public let raw: [String: Any]

        /// Creates a new `SuccessData`.
        public init(
            provider: String,
            reference: String,
            transactionId: String? = nil,
            raw: [String: Any] = [:]
        ) {
            self.provider = provider
            self.reference = reference
            self.transactionId = transactionId
            self.raw = raw
        }
    }
}
