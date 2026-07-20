#if canImport(UIKit) && canImport(SwiftUI)
import SwiftUI
import UIKit

/// A SwiftUI view modifier that presents a Sanwo checkout sheet.
@available(iOS 15.0, *)
struct SanwoCheckoutModifier: ViewModifier {
    @Binding var isPresented: Bool
    let sanwo: Sanwo
    let options: CheckoutOptions
    let onResult: (CheckoutResult) -> Void

    func body(content: Content) -> some View {
        content.fullScreenCover(isPresented: $isPresented) {
            SanwoCheckoutRepresentable(
                sanwo: sanwo,
                options: options,
                isPresented: $isPresented,
                onResult: onResult
            )
            .ignoresSafeArea()
        }
    }
}

/// A UIViewControllerRepresentable wrapper for `SanwoCheckoutViewController`.
@available(iOS 15.0, *)
struct SanwoCheckoutRepresentable: UIViewControllerRepresentable {
    let sanwo: Sanwo
    let options: CheckoutOptions
    @Binding var isPresented: Bool
    let onResult: (CheckoutResult) -> Void

    func makeUIViewController(context: Context) -> SanwoCheckoutViewController {
        SanwoCheckoutViewController(
            provider: sanwo.provider,
            publicKey: sanwo.publicKey,
            options: options,
            eventHandlers: sanwo.eventHandlers
        ) { result in
            onResult(result)
            isPresented = false
        }
    }

    func updateUIViewController(
        _ uiViewController: SanwoCheckoutViewController,
        context: Context
    ) {
        // No updates needed after initial presentation
    }
}

// MARK: - View extension

@available(iOS 15.0, *)
public extension View {
    /// Presents a Sanwo checkout as a full-screen cover.
    ///
    /// - Parameters:
    ///   - isPresented: A binding that controls whether the checkout is shown.
    ///   - sanwo: The configured `Sanwo` instance.
    ///   - options: Checkout configuration options.
    ///   - onResult: Called with the checkout result when the session ends.
    /// - Returns: A view that presents the checkout when `isPresented` is `true`.
    ///
    /// ```swift
    /// Button("Pay") { showCheckout = true }
    ///     .sanwoCheckout(
    ///         isPresented: $showCheckout,
    ///         sanwo: sanwo,
    ///         options: CheckoutOptions(
    ///             amount: 500000,
    ///             currency: "NGN",
    ///             customer: CheckoutCustomer(email: "user@example.com")
    ///         )
    ///     ) { result in
    ///         // handle result
    ///     }
    /// ```
    func sanwoCheckout(
        isPresented: Binding<Bool>,
        sanwo: Sanwo,
        options: CheckoutOptions,
        onResult: @escaping (CheckoutResult) -> Void
    ) -> some View {
        modifier(SanwoCheckoutModifier(
            isPresented: isPresented,
            sanwo: sanwo,
            options: options,
            onResult: onResult
        ))
    }
}
#endif
