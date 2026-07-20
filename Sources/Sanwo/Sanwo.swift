#if canImport(UIKit)
import UIKit
#endif

/// The main entry point for the Sanwo payment SDK.
///
/// Create a `Sanwo` instance with a provider and public key, register event handlers,
/// then call it directly to present the payment UI.
///
/// ```swift
/// let sanwo = Sanwo(provider: .paystack, publicKey: "pk_test_...")
///
/// sanwo.on(.success) { event in
///     print("Payment succeeded: \(event.data ?? [:])")
/// }
///
/// sanwo(
///     from: viewController,
///     options: CheckoutOptions(
///         amount: 500000,
///         currency: "NGN",
///         customer: CheckoutCustomer(email: "user@example.com")
///     )
/// ) { result in
///     switch result {
///     case .successful(let data):
///         print("Reference: \(data.reference)")
///     case .cancelled:
///         print("Cancelled")
///     case .failed(_, _, let error):
///         print("Failed: \(error)")
///     }
/// }
/// ```
public final class Sanwo {
    // MARK: - Properties

    /// The payment provider being used.
    public let provider: SanwoProvider

    /// The provider's public/API key.
    public let publicKey: String

    /// Registered event handlers.
    internal private(set) var eventHandlers: [SanwoEventType: SanwoEventHandler] = [:]

    // MARK: - Initialization

    /// Creates a new Sanwo instance.
    ///
    /// - Parameters:
    ///   - provider: The payment provider to use (e.g. `.paystack`, `.flutterwave`).
    ///   - publicKey: The provider's public/API key.
    public init(provider: SanwoProvider, publicKey: String) {
        self.provider = provider
        self.publicKey = publicKey
    }

    // MARK: - Event registration

    /// Registers an event handler for a specific event type.
    ///
    /// - Parameters:
    ///   - eventType: The type of event to listen for.
    ///   - handler: A closure called when the event occurs.
    /// - Returns: This `Sanwo` instance for chaining.
    @discardableResult
    public func on(
        _ eventType: SanwoEventType,
        handler: @escaping SanwoEventHandler
    ) -> Sanwo {
        eventHandlers[eventType] = handler
        return self
    }

    /// Removes the event handler for a specific event type.
    ///
    /// - Parameter eventType: The event type to stop listening for.
    /// - Returns: This `Sanwo` instance for chaining.
    @discardableResult
    public func off(_ eventType: SanwoEventType) -> Sanwo {
        eventHandlers.removeValue(forKey: eventType)
        return self
    }

    /// Removes all registered event handlers.
    ///
    /// - Returns: This `Sanwo` instance for chaining.
    @discardableResult
    public func removeAllHandlers() -> Sanwo {
        eventHandlers.removeAll()
        return self
    }

    // MARK: - Checkout

    #if canImport(UIKit)
    /// Presents the checkout UI from the given view controller.
    ///
    /// This method allows `Sanwo` instances to be called like functions:
    /// ```swift
    /// sanwo(from: viewController, options: options) { result in ... }
    /// ```
    ///
    /// - Parameters:
    ///   - viewController: The view controller to present the checkout from.
    ///   - options: Checkout configuration options.
    ///   - completion: Called with the checkout result when the session ends.
    public func callAsFunction(
        from viewController: UIViewController,
        options: CheckoutOptions,
        completion: @escaping (CheckoutResult) -> Void
    ) {
        let checkoutVC = SanwoCheckoutViewController(
            provider: provider,
            publicKey: publicKey,
            options: options,
            eventHandlers: eventHandlers,
            completion: completion
        )

        viewController.present(checkoutVC, animated: true)
    }
    #endif
}
