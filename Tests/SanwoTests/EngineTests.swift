import XCTest
@testable import Sanwo

final class EngineTests: XCTestCase {

    // MARK: - Bridge tests

    func testBridgeContainsMessageHandler() {
        let bridge = Engine.getBridge()
        XCTAssertTrue(bridge.contains("window.webkit.messageHandlers.sanwo.postMessage"))
        XCTAssertTrue(bridge.contains("sanwoCallback"))
    }

    func testBridgeIsValidJavaScript() {
        let bridge = Engine.getBridge()
        // Should define a function named sanwoCallback
        XCTAssertTrue(bridge.contains("function sanwoCallback(event, data)"))
        // Should stringify the message
        XCTAssertTrue(bridge.contains("JSON.stringify"))
    }

    // MARK: - Template rendering tests

    func testRenderTemplateReplacesPlaceholders() {
        let template = "<html>{{sanwoBridge}}<script>var p = {{params}};</script></html>"
        let params: [String: Any] = ["key": "value", "amount": 100]

        let rendered = Engine.renderTemplate(
            template,
            params: params,
            bridge: "/* bridge */"
        )

        XCTAssertFalse(rendered.contains("{{sanwoBridge}}"))
        XCTAssertFalse(rendered.contains("{{params}}"))
        XCTAssertTrue(rendered.contains("/* bridge */"))
        XCTAssertTrue(rendered.contains("\"key\":\"value\""))
        XCTAssertTrue(rendered.contains("\"amount\":100"))
    }

    func testRenderTemplateWithEmptyParams() {
        let template = "{{params}}"
        let rendered = Engine.renderTemplate(template, params: [:], bridge: "")
        XCTAssertEqual(rendered, "{}")
    }

    // MARK: - Amount conversion tests

    func testFromMinorUnitStandardCurrency() {
        // NGN uses 2 decimal places
        let result = Engine.fromMinorUnit(500000, currency: "NGN")
        XCTAssertEqual(result, 5000.0, accuracy: 0.001)
    }

    func testFromMinorUnitUSD() {
        let result = Engine.fromMinorUnit(1099, currency: "USD")
        XCTAssertEqual(result, 10.99, accuracy: 0.001)
    }

    func testFromMinorUnitZeroDecimalCurrency() {
        // JPY uses 0 decimal places
        let result = Engine.fromMinorUnit(1000, currency: "JPY")
        XCTAssertEqual(result, 1000.0, accuracy: 0.001)
    }

    func testFromMinorUnitKRW() {
        let result = Engine.fromMinorUnit(50000, currency: "KRW")
        XCTAssertEqual(result, 50000.0, accuracy: 0.001)
    }

    func testFromMinorUnitThreeDecimalCurrency() {
        // KWD uses 3 decimal places
        let result = Engine.fromMinorUnit(5000, currency: "KWD")
        XCTAssertEqual(result, 5.0, accuracy: 0.001)
    }

    func testFromMinorUnitBHD() {
        let result = Engine.fromMinorUnit(1500, currency: "BHD")
        XCTAssertEqual(result, 1.5, accuracy: 0.001)
    }

    func testFromMinorUnitCaseInsensitive() {
        let result = Engine.fromMinorUnit(500000, currency: "ngn")
        XCTAssertEqual(result, 5000.0, accuracy: 0.001)
    }

    // MARK: - Params builder tests

    func testBuildTemplateParamsIncludesRequiredFields() {
        let options = CheckoutOptions(
            amount: 500000,
            currency: "NGN",
            customer: CheckoutCustomer(email: "test@example.com")
        )

        let params = Engine.buildTemplateParams(
            options: options,
            publicKey: "pk_test_123",
            provider: .paystack
        )

        XCTAssertEqual(params["publicKey"] as? String, "pk_test_123")
        XCTAssertEqual(params["email"] as? String, "test@example.com")
        XCTAssertEqual(params["amount"] as? Int, 500000) // Paystack uses minor units
        XCTAssertEqual(params["currency"] as? String, "NGN")
    }

    func testBuildTemplateParamsConvertsAmountForFlutterwave() throws {
        let options = CheckoutOptions(
            amount: 500000,
            currency: "NGN",
            customer: CheckoutCustomer(email: "test@example.com")
        )

        let params = Engine.buildTemplateParams(
            options: options,
            publicKey: "FLWPUBK_TEST_123",
            provider: .flutterwave
        )

        // Flutterwave does NOT use minor units, so 500000 kobo -> 5000.0 naira
        let amount = try XCTUnwrap(params["amount"] as? Double)
        XCTAssertEqual(amount, 5000.0, accuracy: 0.001)
    }

    func testBuildTemplateParamsIncludesOptionalFields() {
        let options = CheckoutOptions(
            amount: 100000,
            currency: "NGN",
            customer: CheckoutCustomer(
                email: "test@example.com",
                firstName: "John",
                lastName: "Doe",
                phone: "+2341234567890"
            ),
            reference: "ref_123",
            channels: ["card", "bank"],
            method: "checkout"
        )

        let params = Engine.buildTemplateParams(
            options: options,
            publicKey: "pk_test_123",
            provider: .paystack
        )

        XCTAssertEqual(params["firstName"] as? String, "John")
        XCTAssertEqual(params["lastName"] as? String, "Doe")
        XCTAssertEqual(params["phone"] as? String, "+2341234567890")
        XCTAssertEqual(params["reference"] as? String, "ref_123")
        XCTAssertEqual(params["channels"] as? [String], ["card", "bank"])
        XCTAssertEqual(params["method"] as? String, "checkout")
    }

    func testBuildTemplateParamsOmitsNilFields() {
        let options = CheckoutOptions(
            amount: 100000,
            currency: "NGN",
            customer: CheckoutCustomer(email: "test@example.com")
        )

        let params = Engine.buildTemplateParams(
            options: options,
            publicKey: "pk_test_123",
            provider: .paystack
        )

        XCTAssertNil(params["firstName"])
        XCTAssertNil(params["lastName"])
        XCTAssertNil(params["phone"])
        XCTAssertNil(params["reference"])
        XCTAssertNil(params["channels"])
        XCTAssertNil(params["metadata"])
        XCTAssertNil(params["paymentOptions"])
        XCTAssertNil(params["subaccounts"])
        XCTAssertNil(params["method"])
    }

    // MARK: - Provider tests

    func testPaystackProviderUsesMinorUnit() {
        XCTAssertTrue(SanwoProvider.paystack.amountInMinorUnit)
        XCTAssertEqual(SanwoProvider.paystack.id, "paystack")
        XCTAssertEqual(SanwoProvider.paystack.name, "Paystack")
    }

    func testFlutterwaveProviderDoesNotUseMinorUnit() {
        XCTAssertFalse(SanwoProvider.flutterwave.amountInMinorUnit)
        XCTAssertEqual(SanwoProvider.flutterwave.id, "flutterwave")
        XCTAssertEqual(SanwoProvider.flutterwave.name, "Flutterwave")
    }

    func testPaystackTemplateContainsPlaceholders() {
        XCTAssertTrue(SanwoProvider.paystack.template.contains("{{sanwoBridge}}"))
        XCTAssertTrue(SanwoProvider.paystack.template.contains("{{params}}"))
        XCTAssertTrue(SanwoProvider.paystack.template.contains("PaystackPop"))
    }

    func testFlutterwaveTemplateContainsPlaceholders() {
        XCTAssertTrue(SanwoProvider.flutterwave.template.contains("{{sanwoBridge}}"))
        XCTAssertTrue(SanwoProvider.flutterwave.template.contains("{{params}}"))
        XCTAssertTrue(SanwoProvider.flutterwave.template.contains("FlutterwaveCheckout"))
    }

    // MARK: - Sanwo instance tests

    func testSanwoEventRegistration() {
        let sanwo = Sanwo(provider: .paystack, publicKey: "pk_test_123")

        sanwo.on(.success) { _ in }
        XCTAssertNotNil(sanwo.eventHandlers[.success])

        sanwo.off(.success)
        XCTAssertNil(sanwo.eventHandlers[.success])
    }

    func testSanwoRemoveAllHandlers() {
        let sanwo = Sanwo(provider: .paystack, publicKey: "pk_test_123")

        sanwo.on(.success) { _ in }
        sanwo.on(.cancelled) { _ in }
        sanwo.on(.loaded) { _ in }

        XCTAssertEqual(sanwo.eventHandlers.count, 3)

        sanwo.removeAllHandlers()
        XCTAssertTrue(sanwo.eventHandlers.isEmpty)
    }

    func testSanwoOnReturnsChainable() {
        let sanwo = Sanwo(provider: .paystack, publicKey: "pk_test_123")

        let returned = sanwo
            .on(.success) { _ in }
            .on(.cancelled) { _ in }

        XCTAssertTrue(returned === sanwo)
        XCTAssertEqual(returned.eventHandlers.count, 2)
    }

    // MARK: - CheckoutResult tests

    func testSuccessDataInit() {
        let data = CheckoutResult.SuccessData(
            provider: "paystack",
            reference: "ref_123",
            transactionId: "txn_456",
            raw: ["status": "success"]
        )

        XCTAssertEqual(data.provider, "paystack")
        XCTAssertEqual(data.reference, "ref_123")
        XCTAssertEqual(data.transactionId, "txn_456")
        XCTAssertEqual(data.raw["status"] as? String, "success")
    }

    // MARK: - SanwoEvent tests

    func testSanwoEventTypeRawValues() {
        XCTAssertEqual(SanwoEventType.started.rawValue, "started")
        XCTAssertEqual(SanwoEventType.opened.rawValue, "opened")
        XCTAssertEqual(SanwoEventType.loaded.rawValue, "loaded")
        XCTAssertEqual(SanwoEventType.success.rawValue, "success")
        XCTAssertEqual(SanwoEventType.cancelled.rawValue, "cancelled")
        XCTAssertEqual(SanwoEventType.failed.rawValue, "failed")
        XCTAssertEqual(SanwoEventType.closed.rawValue, "closed")
    }

    func testSanwoEventDataInit() {
        let eventData = SanwoEventData(
            type: .success,
            provider: "paystack",
            data: ["reference": "ref_123"]
        )

        XCTAssertEqual(eventData.type, .success)
        XCTAssertEqual(eventData.provider, "paystack")
        XCTAssertEqual(eventData.data?["reference"] as? String, "ref_123")
        XCTAssertNotNil(eventData.timestamp)
    }
}
