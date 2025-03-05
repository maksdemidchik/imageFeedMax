//
//  WebViewViewController.swift
//  imageFeed
//
//  Created by Maxim on 15.02.2025.
//

import UIKit
@preconcurrency import WebKit

enum WebViewConstants {
    static let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
}

protocol WebViewViewControllerDelegate: AnyObject {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String)
    func webViewViewControllerDidCancel(_ vc: WebViewViewController)
}


final class WebViewViewController: UIViewController {
    
    @IBOutlet private weak var webView: WKWebView!
    @IBOutlet private weak var progressView: UIProgressView!
    
    private var backButton: UIButton = {
        let button = UIButton()
        return button
    }()
    
    weak var delegate: WebViewViewControllerDelegate?
    
    private var estimatedProgressObservation: NSKeyValueObservation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.navigationDelegate = self
        estimatedProgressObservation=webView.observe( \.estimatedProgress,options: []){ [weak self] _, _ in
                guard let self = self else { return }
                self.updateProgress()
        }
        loadAuthView()
        let backButton = UIButton.systemButton(with: UIImage(named: "nav_back_button_white") ?? UIImage(), target: self, action: #selector(self.backButtonAction))
        buttonSettings(button: backButton)
        self.backButton = backButton
        progressView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor,constant: 8).isActive=true
        webView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor,constant: 8).isActive=true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateProgress()
    }
    
    private func updateProgress() {
        progressView.progress = Float(webView.estimatedProgress)
        progressView.isHidden = fabs(webView.estimatedProgress - 1.0) <= 0.0001
    }
    
    
    
    private func loadAuthView() {
        guard var urlComponents = URLComponents(string: WebViewConstants.unsplashAuthorizeURLString) else {
            return
        }

        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: Constants.accessKey),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "scope", value: Constants.accessScope)
        ]

        guard let url = urlComponents.url else {
            print("ошибка URLComponents")
            return
        }

        let request = URLRequest(url: url)
        webView.load(request)
    }
    private func buttonSettings(button: UIButton){
        button.tintColor = .ypBlack
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)
        button.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor,constant: 9).isActive=true
        button.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 9).isActive = true
        button.widthAnchor.constraint(equalToConstant: 24).isActive = true
        button.heightAnchor.constraint(equalToConstant: 24).isActive = true
    }
    
    @objc private func backButtonAction() {
        dismiss(animated: true)
    }

}

extension WebViewViewController: WKNavigationDelegate {
    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
    ) {
        if let code = code(from: navigationAction)
        {
            delegate?.webViewViewController(self, didAuthenticateWithCode: code)
            decisionHandler(.cancel)
            
        } else {
            decisionHandler(.allow)
        }
    }
    
    
    private func code(from navigationAction: WKNavigationAction) -> String? {
        if
            let url = navigationAction.request.url,
            let urlComponents = URLComponents(string: url.absoluteString),
            urlComponents.path == "/oauth/authorize/native",
            let items = urlComponents.queryItems,
            let codeItem = items.first(where: { $0.name == "code" })
        {
            return codeItem.value
        } else {
            return nil
        }
    }
}
