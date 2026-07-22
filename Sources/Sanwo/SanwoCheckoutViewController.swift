#if canImport(UIKit)
import UIKit
import WebKit

/// A view controller that presents a payment checkout in a WKWebView.
///
/// This controller loads the provider's HTML template, injects the iOS bridge, and
/// listens for messages from the JavaScript bridge to dispatch events and results.
public final class SanwoCheckoutViewController: UIViewController {
    // MARK: - Properties

    private let provider: SanwoProvider
    private let publicKey: String
    private let options: CheckoutOptions
    private let eventHandlers: [SanwoEventType: SanwoEventHandler]
    private let completion: (CheckoutResult) -> Void

    private var webView: WKWebView!
    private var hasCompleted = false

    // MARK: - Initialization

    /// Creates a new checkout view controller.
    ///
    /// - Parameters:
    ///   - provider: The payment provider to use.
    ///   - publicKey: The provider's public/API key.
    ///   - options: Checkout configuration options.
    ///   - eventHandlers: A dictionary of event handlers keyed by event type.
    ///   - completion: Called with the checkout result when the session ends.
    public init(
        provider: SanwoProvider,
        publicKey: String,
        options: CheckoutOptions,
        eventHandlers: [SanwoEventType: SanwoEventHandler],
        completion: @escaping (CheckoutResult) -> Void
    ) {
        self.provider = provider
        self.publicKey = publicKey
        self.options = options
        self.eventHandlers = eventHandlers
        self.completion = completion
        super.init(nibName: nil, bundle: nil)
        self.modalPresentationStyle = .fullScreen
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }

    // MARK: - Lifecycle

    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupWebView()
        loadCheckout()
    }

    // MARK: - Setup

    private func setupWebView() {
        let configuration = WKWebViewConfiguration()
        let contentController = WKUserContentController()
        contentController.add(self, name: "sanwo")
        configuration.userContentController = contentController

        // Allow inline media playback
        configuration.allowsInlineMediaPlayback = true

        webView = WKWebView(frame: .zero, configuration: configuration)
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.isOpaque = false
        webView.backgroundColor = .white
        webView.scrollView.bounces = false
        webView.navigationDelegate = self

        view.addSubview(webView)

        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.topAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func loadCheckout() {
        let params = Engine.buildTemplateParams(
            options: options,
            publicKey: publicKey,
            provider: provider
        )
        let bridge = Engine.getBridge()
        let html = Engine.renderTemplate(provider.template, params: params, bridge: bridge)

        emitEvent(.started)
        webView.loadHTMLString(html, baseURL: URL(string: "https://checkout.sanwohq.com"))
    }

    // MARK: - Event handling

    private func emitEvent(_ type: SanwoEventType, data: [String: Any]? = nil) {
        let eventData = SanwoEventData(
            type: type,
            provider: provider.id,
            data: data
        )
        eventHandlers[type]?(eventData)
    }

    private func completeCheckout(with result: CheckoutResult) {
        guard !hasCompleted else { return }
        hasCompleted = true
        completion(result)
        dismiss(animated: true)
    }

    // MARK: - Message parsing

    private func handleMessage(_ body: Any) {
        guard
            let bodyString = body as? String,
            let bodyData = bodyString.data(using: .utf8),
            let json = try? JSONSerialization.jsonObject(with: bodyData) as? [String: Any],
            let type = json["type"] as? String,
            type == "sanwo",
            let event = json["event"] as? String
        else {
            return
        }

        let data = json["data"] as? [String: Any] ?? [:]

        switch event {
        case "loaded":
            emitEvent(.loaded, data: data)
            options.onLoad?()

        case "success":
            let reference = data["reference"] as? String ?? ""
            let transactionId = data["transaction_id"] as? String
            let successData = CheckoutResult.SuccessData(
                provider: provider.id,
                reference: reference,
                transactionId: transactionId,
                raw: data
            )
            emitEvent(.success, data: data)
            completeCheckout(with: .successful(successData))

        case "cancelled":
            let reference = data["reference"] as? String
            emitEvent(.cancelled, data: data)
            completeCheckout(with: .cancelled(
                provider: provider.id,
                reference: reference
            ))

        case "closed":
            let reference = data["reference"] as? String
            emitEvent(.closed, data: data)
            // Closed without explicit success/cancel means the user dismissed
            completeCheckout(with: .cancelled(
                provider: provider.id,
                reference: reference
            ))

        case "error":
            let message = data["message"] as? String ?? "Unknown error"
            emitEvent(.failed, data: data)
            options.onError?(SanwoError(message: message))
            completeCheckout(with: .failed(
                provider: provider.id,
                reference: data["reference"] as? String,
                error: message
            ))

        default:
            break
        }
    }

    // MARK: - Cleanup

    deinit {
        webView?.configuration.userContentController.removeScriptMessageHandler(forName: "sanwo")
    }
}

// MARK: - WKScriptMessageHandler

extension SanwoCheckoutViewController: WKScriptMessageHandler {
    public func userContentController(
        _ userContentController: WKUserContentController,
        didReceive message: WKScriptMessage
    ) {
        guard message.name == "sanwo" else { return }
        handleMessage(message.body)
    }
}

// MARK: - WKNavigationDelegate

extension SanwoCheckoutViewController: WKNavigationDelegate {
    public func webView(
        _ webView: WKWebView,
        didFinish navigation: WKNavigation!
    ) {
        emitEvent(.opened)
    }

    public func webView(
        _ webView: WKWebView,
        didFail navigation: WKNavigation!,
        withError error: Error
    ) {
        let message = error.localizedDescription
        emitEvent(.failed, data: ["message": message])
        options.onError?(SanwoError(message: message))
        completeCheckout(with: .failed(
            provider: provider.id,
            reference: nil,
            error: message
        ))
    }

    public func webView(
        _ webView: WKWebView,
        didFailProvisionalNavigation navigation: WKNavigation!,
        withError error: Error
    ) {
        let message = error.localizedDescription
        emitEvent(.failed, data: ["message": message])
        options.onError?(SanwoError(message: message))
        completeCheckout(with: .failed(
            provider: provider.id,
            reference: nil,
            error: message
        ))
    }

    public func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
    ) {
        // Allow all navigation within the checkout
        decisionHandler(.allow)
    }
}
#endif
