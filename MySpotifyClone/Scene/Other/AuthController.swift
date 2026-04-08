//
//  OuthController.swift
//  MySpotifyClone
//
//  Created by Abid Kerimli on 24.02.26.
//

import UIKit
import WebKit

class AuthController: BaseController, WKNavigationDelegate {
    
    
    private lazy var  webView: WKWebView = {
        let config = WKWebViewConfiguration()
        let prefs = WKWebpagePreferences()
        prefs.allowsContentJavaScript = true
        config.defaultWebpagePreferences = prefs
        let webView = WKWebView(frame: .zero, configuration: config)
        webView.navigationDelegate = self
        return webView
    }()
    
    private var viewModel: AuthViewModel
    init(viewModel:AuthViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadLoginPage()
    }
    
    private func loadLoginPage() {
        guard let url = viewModel.signURL else {
            return
        }
        webView.load(URLRequest(url: url))
    }
    
    override func configureViewModel() {
        viewModel.succes = { [weak self] in
            guard let window = self?.view.window else { return }
            let navController = UINavigationController()
            let coordinator = AppCoordinator(navigationController: navController)
            coordinator.start()
            window.rootViewController = navController
        }
        
        viewModel.failure = { error in
            print("\(error)")
        }
    }
    
    override func configureUI() {
        title = "Sign in"
        view.backgroundColor = .systemBackground
        view.addSubview(webView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        webView.frame = view.bounds
    }
    
    
    func webView(_ webView: WKWebView,
                 decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        guard let url = navigationAction.request.url else {
            decisionHandler(.allow)
            return
        }
        
        // Spotify callback URL
        if url.scheme == "spotify-ios-quick-start" {
            let components = URLComponents(string: url.absoluteString)
            if let code = components?.queryItems?
                .first(where: { $0.name == "code" })?.value {
                webView.isHidden = true
                viewModel.signIn(code: code)
            }
            decisionHandler(.cancel)
            return
        }
        decisionHandler(.allow)
    }
}
