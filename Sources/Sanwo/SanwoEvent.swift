import Foundation

/// Types of events emitted during a checkout lifecycle.
public enum SanwoEventType: String, Sendable {
    /// The checkout session has started.
    case started
    /// The checkout UI has been presented.
    case opened
    /// The checkout UI has finished loading.
    case loaded
    /// Payment completed successfully.
    case success
    /// The user cancelled the checkout.
    case cancelled
    /// The checkout failed due to an error.
    case failed
    /// The checkout UI has been closed.
    case closed
}

/// Data associated with a Sanwo event.
public struct SanwoEventData: @unchecked Sendable {
    /// The type of event that occurred.
    public let type: SanwoEventType

    /// The provider that emitted this event.
    public let provider: String

    /// When this event occurred.
    public let timestamp: Date

    /// Additional data associated with the event, if any.
    public let data: [String: Any]?

    /// Creates a new event data instance.
    public init(
        type: SanwoEventType,
        provider: String,
        timestamp: Date = Date(),
        data: [String: Any]? = nil
    ) {
        self.type = type
        self.provider = provider
        self.timestamp = timestamp
        self.data = data
    }
}

/// A type-erased event handler.
public typealias SanwoEventHandler = @Sendable (SanwoEventData) -> Void
