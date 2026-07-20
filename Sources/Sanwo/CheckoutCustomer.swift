import Foundation

/// Customer information for a checkout session.
public struct CheckoutCustomer: Sendable {
    /// Customer's email address (required by most providers).
    public let email: String

    /// Customer's first name.
    public let firstName: String?

    /// Customer's last name.
    public let lastName: String?

    /// Customer's phone number.
    public let phone: String?

    /// Creates a new customer.
    ///
    /// - Parameters:
    ///   - email: Customer's email address.
    ///   - firstName: Customer's first name. Defaults to `nil`.
    ///   - lastName: Customer's last name. Defaults to `nil`.
    ///   - phone: Customer's phone number. Defaults to `nil`.
    public init(
        email: String,
        firstName: String? = nil,
        lastName: String? = nil,
        phone: String? = nil
    ) {
        self.email = email
        self.firstName = firstName
        self.lastName = lastName
        self.phone = phone
    }
}
