import Sanwo

/// Pre-configured Flutterwave payment provider.
///
/// Flutterwave expects amounts in major units (naira, not kobo), so the engine
/// converts from minor units automatically.
public let flutterwaveProvider = SanwoProvider(
    id: "flutterwave",
    name: "flutterwave",
    displayName: "Flutterwave",
    template: flutterwaveTemplate,
    amountInMinorUnit: false,
    supportedCurrencies: ["NGN", "GHS", "KES", "ZAR", "USD", "EUR", "GBP", "TZS", "UGX", "RWF", "XAF", "XOF"],
    supportedCountries: ["NG", "GH", "KE", "ZA", "US", "GB", "TZ", "UG", "RW", "CM", "CI"]
)

private let flutterwaveTemplate = """
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Sanwo Checkout</title>
</head>
<body onload="initPayment()" style="background-color:#fff;height:100vh">
  <script src="https://checkout.flutterwave.com/v3.js"></script>
  <script>
    {{sanwoBridge}}
    var params = {{params}};
    function initPayment() {
      try {
        var config = {
          public_key: params.publicKey,
          tx_ref: params.reference,
          amount: params.amount,
          currency: params.currency,
          customer: { email: params.email },
          callback: function(response) {
            sanwoCallback('success', {
              reference: response.tx_ref,
              transaction_id: String(response.transaction_id),
              flw_ref: response.flw_ref,
              message: response.status,
              raw: response
            });
          },
          onclose: function() { sanwoCallback('cancelled', {}); }
        };
        if (params.firstName || params.lastName) {
          config.customer.name = [params.firstName, params.lastName].filter(Boolean).join(' ');
        }
        if (params.phone) config.customer.phone_number = params.phone;
        if (params.paymentOptions) config.payment_options = params.paymentOptions;
        if (params.metadata) config.meta = params.metadata;
        if (params.subaccounts) config.subaccounts = params.subaccounts;
        sanwoCallback('loaded', {});
        FlutterwaveCheckout(config);
      } catch(e) {
        sanwoCallback('error', { message: e.message });
      }
    }
  </script>
</body>
</html>
"""
