import XCTest
@testable import Sanwo
import SanwoPaystack
import SanwoFlutterwave
import SanwoStripe
import SanwoPaypal
import SanwoRazorpay
import SanwoMonnify
import SanwoInterswitch

final class ProviderTests: XCTestCase {

    // MARK: - Paystack

    func testPaystackProviderMetadata() {
        XCTAssertEqual(paystackProvider.id, "paystack")
        XCTAssertEqual(paystackProvider.name, "paystack")
        XCTAssertEqual(paystackProvider.displayName, "Paystack")
        XCTAssertTrue(paystackProvider.amountInMinorUnit)
    }

    func testPaystackTemplatePlaceholders() {
        XCTAssertTrue(paystackProvider.template.contains("{{sanwoBridge}}"))
        XCTAssertTrue(paystackProvider.template.contains("{{params}}"))
    }

    func testPaystackTemplateCallbacks() {
        XCTAssertTrue(paystackProvider.template.contains("sanwoCallback"))
    }

    func testPaystackSupportedCurrenciesNonEmpty() {
        XCTAssertFalse(paystackProvider.supportedCurrencies.isEmpty)
    }

    func testPaystackSupportedCountriesNonEmpty() {
        XCTAssertFalse(paystackProvider.supportedCountries.isEmpty)
    }

    // MARK: - Flutterwave

    func testFlutterwaveProviderMetadata() {
        XCTAssertEqual(flutterwaveProvider.id, "flutterwave")
        XCTAssertEqual(flutterwaveProvider.name, "flutterwave")
        XCTAssertEqual(flutterwaveProvider.displayName, "Flutterwave")
        XCTAssertFalse(flutterwaveProvider.amountInMinorUnit)
    }

    func testFlutterwaveTemplatePlaceholders() {
        XCTAssertTrue(flutterwaveProvider.template.contains("{{sanwoBridge}}"))
        XCTAssertTrue(flutterwaveProvider.template.contains("{{params}}"))
    }

    func testFlutterwaveTemplateCallbacks() {
        XCTAssertTrue(flutterwaveProvider.template.contains("sanwoCallback"))
    }

    func testFlutterwaveSupportedCurrenciesNonEmpty() {
        XCTAssertFalse(flutterwaveProvider.supportedCurrencies.isEmpty)
    }

    func testFlutterwaveSupportedCountriesNonEmpty() {
        XCTAssertFalse(flutterwaveProvider.supportedCountries.isEmpty)
    }

    // MARK: - Stripe

    func testStripeProviderMetadata() {
        XCTAssertEqual(stripeProvider.id, "stripe")
        XCTAssertEqual(stripeProvider.name, "stripe")
        XCTAssertEqual(stripeProvider.displayName, "Stripe")
        XCTAssertTrue(stripeProvider.amountInMinorUnit)
    }

    func testStripeTemplatePlaceholders() {
        XCTAssertTrue(stripeProvider.template.contains("{{sanwoBridge}}"))
        XCTAssertTrue(stripeProvider.template.contains("{{params}}"))
    }

    func testStripeTemplateCallbacks() {
        XCTAssertTrue(stripeProvider.template.contains("sanwoCallback"))
    }

    func testStripeSupportedCurrenciesNonEmpty() {
        XCTAssertFalse(stripeProvider.supportedCurrencies.isEmpty)
    }

    func testStripeSupportedCountriesNonEmpty() {
        XCTAssertFalse(stripeProvider.supportedCountries.isEmpty)
    }

    // MARK: - PayPal

    func testPaypalProviderMetadata() {
        XCTAssertEqual(paypalProvider.id, "paypal")
        XCTAssertEqual(paypalProvider.name, "paypal")
        XCTAssertEqual(paypalProvider.displayName, "PayPal")
        XCTAssertFalse(paypalProvider.amountInMinorUnit)
    }

    func testPaypalTemplatePlaceholders() {
        XCTAssertTrue(paypalProvider.template.contains("{{sanwoBridge}}"))
        XCTAssertTrue(paypalProvider.template.contains("{{params}}"))
    }

    func testPaypalTemplateCallbacks() {
        XCTAssertTrue(paypalProvider.template.contains("sanwoCallback"))
    }

    func testPaypalSupportedCurrenciesNonEmpty() {
        XCTAssertFalse(paypalProvider.supportedCurrencies.isEmpty)
    }

    func testPaypalSupportedCountriesNonEmpty() {
        XCTAssertFalse(paypalProvider.supportedCountries.isEmpty)
    }

    // MARK: - Razorpay

    func testRazorpayProviderMetadata() {
        XCTAssertEqual(razorpayProvider.id, "razorpay")
        XCTAssertEqual(razorpayProvider.name, "razorpay")
        XCTAssertEqual(razorpayProvider.displayName, "Razorpay")
        XCTAssertTrue(razorpayProvider.amountInMinorUnit)
    }

    func testRazorpayTemplatePlaceholders() {
        XCTAssertTrue(razorpayProvider.template.contains("{{sanwoBridge}}"))
        XCTAssertTrue(razorpayProvider.template.contains("{{params}}"))
    }

    func testRazorpayTemplateCallbacks() {
        XCTAssertTrue(razorpayProvider.template.contains("sanwoCallback"))
    }

    func testRazorpaySupportedCurrenciesNonEmpty() {
        XCTAssertFalse(razorpayProvider.supportedCurrencies.isEmpty)
    }

    func testRazorpaySupportedCountriesNonEmpty() {
        XCTAssertFalse(razorpayProvider.supportedCountries.isEmpty)
    }

    // MARK: - Monnify

    func testMonnifyProviderMetadata() {
        XCTAssertEqual(monnifyProvider.id, "monnify")
        XCTAssertEqual(monnifyProvider.name, "monnify")
        XCTAssertEqual(monnifyProvider.displayName, "Monnify")
        XCTAssertFalse(monnifyProvider.amountInMinorUnit)
    }

    func testMonnifyTemplatePlaceholders() {
        XCTAssertTrue(monnifyProvider.template.contains("{{sanwoBridge}}"))
        XCTAssertTrue(monnifyProvider.template.contains("{{params}}"))
    }

    func testMonnifyTemplateCallbacks() {
        XCTAssertTrue(monnifyProvider.template.contains("sanwoCallback"))
    }

    func testMonnifySupportedCurrenciesNonEmpty() {
        XCTAssertFalse(monnifyProvider.supportedCurrencies.isEmpty)
    }

    func testMonnifySupportedCountriesNonEmpty() {
        XCTAssertFalse(monnifyProvider.supportedCountries.isEmpty)
    }

    // MARK: - Interswitch

    func testInterswitchProviderMetadata() {
        XCTAssertEqual(interswitchProvider.id, "interswitch")
        XCTAssertEqual(interswitchProvider.name, "interswitch")
        XCTAssertEqual(interswitchProvider.displayName, "Interswitch")
        XCTAssertTrue(interswitchProvider.amountInMinorUnit)
    }

    func testInterswitchTemplatePlaceholders() {
        XCTAssertTrue(interswitchProvider.template.contains("{{sanwoBridge}}"))
        XCTAssertTrue(interswitchProvider.template.contains("{{params}}"))
    }

    func testInterswitchTemplateCallbacks() {
        XCTAssertTrue(interswitchProvider.template.contains("sanwoCallback"))
    }

    func testInterswitchSupportedCurrenciesNonEmpty() {
        XCTAssertFalse(interswitchProvider.supportedCurrencies.isEmpty)
    }

    func testInterswitchSupportedCountriesNonEmpty() {
        XCTAssertFalse(interswitchProvider.supportedCountries.isEmpty)
    }

    // MARK: - Amount conversion per provider

    func testPaystackAmountConversion() {
        // Paystack uses minor units, so amount should pass through unchanged
        let options = CheckoutOptions(
            amount: 500000,
            currency: "NGN",
            customer: CheckoutCustomer(email: "test@example.com")
        )
        let params = Engine.buildTemplateParams(
            options: options,
            publicKey: "pk_test",
            provider: paystackProvider
        )
        XCTAssertEqual(params["amount"] as? Int, 500000)
    }

    func testFlutterwaveAmountConversion() {
        // Flutterwave does NOT use minor units, so 500000 kobo -> 5000.0 naira
        let options = CheckoutOptions(
            amount: 500000,
            currency: "NGN",
            customer: CheckoutCustomer(email: "test@example.com")
        )
        let params = Engine.buildTemplateParams(
            options: options,
            publicKey: "FLWPUBK_TEST",
            provider: flutterwaveProvider
        )
        let amount = params["amount"] as? Double
        XCTAssertNotNil(amount)
        XCTAssertEqual(amount!, 5000.0, accuracy: 0.001)
    }

    func testStripeAmountConversion() {
        // Stripe uses minor units (cents)
        let options = CheckoutOptions(
            amount: 1099,
            currency: "USD",
            customer: CheckoutCustomer(email: "test@example.com")
        )
        let params = Engine.buildTemplateParams(
            options: options,
            publicKey: "pk_test",
            provider: stripeProvider
        )
        XCTAssertEqual(params["amount"] as? Int, 1099)
    }

    func testPaypalAmountConversion() {
        // PayPal does NOT use minor units, so 1099 cents -> 10.99 dollars
        let options = CheckoutOptions(
            amount: 1099,
            currency: "USD",
            customer: CheckoutCustomer(email: "test@example.com")
        )
        let params = Engine.buildTemplateParams(
            options: options,
            publicKey: "client_id",
            provider: paypalProvider
        )
        let amount = params["amount"] as? Double
        XCTAssertNotNil(amount)
        XCTAssertEqual(amount!, 10.99, accuracy: 0.001)
    }

    func testRazorpayAmountConversion() {
        // Razorpay uses minor units (paise)
        let options = CheckoutOptions(
            amount: 50000,
            currency: "INR",
            customer: CheckoutCustomer(email: "test@example.com")
        )
        let params = Engine.buildTemplateParams(
            options: options,
            publicKey: "rzp_test",
            provider: razorpayProvider
        )
        XCTAssertEqual(params["amount"] as? Int, 50000)
    }

    func testMonnifyAmountConversion() {
        // Monnify does NOT use minor units, so 500000 kobo -> 5000.0 naira
        let options = CheckoutOptions(
            amount: 500000,
            currency: "NGN",
            customer: CheckoutCustomer(email: "test@example.com")
        )
        let params = Engine.buildTemplateParams(
            options: options,
            publicKey: "MK_TEST",
            provider: monnifyProvider
        )
        let amount = params["amount"] as? Double
        XCTAssertNotNil(amount)
        XCTAssertEqual(amount!, 5000.0, accuracy: 0.001)
    }

    func testInterswitchAmountConversion() {
        // Interswitch uses minor units (kobo)
        let options = CheckoutOptions(
            amount: 500000,
            currency: "NGN",
            customer: CheckoutCustomer(email: "test@example.com")
        )
        let params = Engine.buildTemplateParams(
            options: options,
            publicKey: "merchant_code",
            provider: interswitchProvider
        )
        XCTAssertEqual(params["amount"] as? Int, 500000)
    }
}
