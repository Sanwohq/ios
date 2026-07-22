import Foundation

/// The engine handles template rendering, bridge injection, and amount conversion.
public enum Engine {
    // MARK: - Bridge

    /// Returns the JavaScript bridge function for iOS WKWebView communication.
    ///
    /// The bridge sends messages via `window.webkit.messageHandlers.sanwo.postMessage()`.
    public static func getBridge() -> String {
        return """
        function sanwoCallback(event, data) {
          window.webkit.messageHandlers.sanwo.postMessage(JSON.stringify({ type: 'sanwo', event: event, data: data }));
        }
        """
    }

    // MARK: - Template rendering

    /// Renders a provider template by replacing placeholders with the bridge and params.
    ///
    /// - Parameters:
    ///   - template: The HTML template string containing `{{sanwoBridge}}` and `{{params}}`.
    ///   - params: A dictionary of parameters to serialize as JSON for the `{{params}}` placeholder.
    ///   - bridge: The JavaScript bridge code to inject.
    /// - Returns: The fully rendered HTML string ready for loading in a web view.
    public static func renderTemplate(
        _ template: String,
        params: [String: Any],
        bridge: String
    ) -> String {
        let jsonData = try? JSONSerialization.data(
            withJSONObject: params,
            options: [.sortedKeys]
        )
        let jsonString = jsonData.flatMap { String(data: $0, encoding: .utf8) } ?? "{}"

        return template
            .replacingOccurrences(of: "{{sanwoBridge}}", with: bridge)
            .replacingOccurrences(of: "{{params}}", with: jsonString)
    }

    // MARK: - Params builder

    /// Builds the template parameters dictionary from checkout options.
    ///
    /// - Parameters:
    ///   - options: The checkout options.
    ///   - publicKey: The provider's public/API key.
    ///   - provider: The payment provider.
    /// - Returns: A dictionary of parameters ready for template injection.
    public static func buildTemplateParams(
        options: CheckoutOptions,
        publicKey: String,
        provider: SanwoProvider
    ) -> [String: Any] {
        let amount: Any
        if provider.amountInMinorUnit {
            amount = options.amount
        } else {
            amount = fromMinorUnit(options.amount, currency: options.currency)
        }

        var params: [String: Any] = [
            "publicKey": publicKey,
            "email": options.customer.email,
            "amount": amount,
            "currency": options.currency,
            "reference": options.reference ?? generateReference()
        ]
        if let firstName = options.customer.firstName {
            params["firstName"] = firstName
        }
        if let lastName = options.customer.lastName {
            params["lastName"] = lastName
        }
        if let phone = options.customer.phone {
            params["phone"] = phone
        }
        if let channels = options.channels {
            params["channels"] = channels
        }
        if let metadata = options.metadata {
            params["metadata"] = metadata
        }
        if let paymentOptions = options.paymentOptions {
            params["paymentOptions"] = paymentOptions
        }
        if let subaccounts = options.subaccounts {
            params["subaccounts"] = subaccounts
        }
        if let method = options.method {
            params["method"] = method
        }

        return params
    }

    // MARK: - Reference generation

    private static func generateReference() -> String {
        let chars = "abcdefghijklmnopqrstuvwxyz0123456789"
        let random = String((0..<12).map { _ in chars.randomElement()! })
        return "sanwo_\(random)"
    }

    // MARK: - Amount conversion

    /// Currencies that use zero decimal places.
    private static let zeroDecimalCurrencies: Set<String> = [
        "JPY", "KRW", "VND", "CLP", "PYG", "ISK", "UGX", "RWF"
    ]

    /// Currencies that use three decimal places.
    private static let threeDecimalCurrencies: Set<String> = [
        "BHD", "KWD", "OMR", "TND", "JOD"
    ]

    /// Converts an amount from minor units to major units based on the currency.
    ///
    /// - Parameters:
    ///   - amount: The amount in minor units.
    ///   - currency: The ISO 4217 currency code.
    /// - Returns: The amount in major units as a `Double`.
    ///
    /// Examples:
    /// - `fromMinorUnit(500000, currency: "NGN")` returns `5000.0` (2-decimal)
    /// - `fromMinorUnit(1000, currency: "JPY")` returns `1000.0` (0-decimal)
    /// - `fromMinorUnit(5000, currency: "KWD")` returns `5.0` (3-decimal)
    public static func fromMinorUnit(_ amount: Int, currency: String) -> Double {
        let uppercased = currency.uppercased()

        if zeroDecimalCurrencies.contains(uppercased) {
            return Double(amount)
        } else if threeDecimalCurrencies.contains(uppercased) {
            return Double(amount) / 1000.0
        } else {
            return Double(amount) / 100.0
        }
    }
}
