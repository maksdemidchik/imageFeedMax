//
//  WebViewViewController.swift
//  imageFeed
//
//  Created by Maxim on 15.02.2025.
//

import UIKit
@preconcurrency import WebKit

protocol WebViewViewControllerDelegate: AnyObject {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String)
    func webViewViewControllerDidCancel(_ vc: WebViewViewController)
}
public protocol WebViewViewControllerProtocol:AnyObject {
    var presenter: WebViewPresenterProtocol? { get  set }
    func load(request: URLRequest)
    func setProgressValue(_ newValue: Float)
    func setProgressHidden(_ isHidden: Bool)
}

final class WebViewViewController: UIViewController & WebViewViewControllerProtocol {
    
    @IBOutlet private weak var webView: WKWebView!
    
    @IBOutlet private weak var progressView: UIProgressView!
    
    private var backButton: UIButton = {
        let button = UIButton()
        return button
    }()
    private var estimatedProgressObservation: NSKeyValueObservation?
    
    weak var delegate: WebViewViewControllerDelegate?
    
    var presenter: WebViewPresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.accessibilityIdentifier = "UnsplashWebView"
        webView.navigationDelegate = self
        estimatedProgressObservation=webView.observe( \.estimatedProgress,options: []){ [weak self] _, _ in
                guard let self = self else { return }
                self.presenter?.didUpdateProgressValue(webView.estimatedProgress)
        }
        presenter?.viewDidLoad()
        let backButton = UIButton.systemButton(with: UIImage(named: "nav_back_button_white") ?? UIImage(), target: self, action: #selector(self.backButtonAction))
        buttonSettings(button: backButton)
        self.backButton = backButton
        progressView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor,constant: 8).isActive=true
        webView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor,constant: 8).isActive=true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presenter?.didUpdateProgressValue(webView.estimatedProgress)
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
    
    func load(request: URLRequest) {
        webView.load(request)
    }
    func setProgressValue(_ newValue: Float){
        progressView.progress = newValue
    }
    
    func setProgressHidden(_ isHidden: Bool){
        progressView.isHidden = isHidden
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
        if let url = navigationAction.request.url
        {
            return presenter?.code(from: url)
        } else {
            return nil
        }
    }
}
