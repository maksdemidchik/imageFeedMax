//
//  AuthViewController1.swift
//  imageFeed
//
//  Created by Maxim on 15.02.2025.
//

import UIKit

protocol AuthViewControllerDelegate: AnyObject {
    
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String)
    
}

final class AuthViewController: UIViewController {
    
    @IBOutlet private weak var authButton: UIButton!
    
    private let webViewSegueIndentifier = "ShowWebView"
    private let oauth2Service = OAuth2Service.shared
    
    weak var delegate: AuthViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        authButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)
        configureBackButton()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == webViewSegueIndentifier {
            guard let webViewController = segue.destination as? WebViewViewController else{
                assertionFailure("Failed to prepare for \(webViewSegueIndentifier)")
                return
            }
            webViewController.delegate = self
        }
        else{
            super.prepare(for: segue, sender: sender)
        }
    }
    
    private func configureBackButton() {
        navigationController?.navigationBar.backIndicatorImage = UIImage(named: "nav_back_button_white")
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "nav_back_button_white")
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = UIColor(named: "YP-BlackColor")
    }

}

extension AuthViewController: WebViewViewControllerDelegate {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        oauth2Service.fetchOAuthToken(code: code) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                self.delegate?.authViewController(self, didAuthenticateWithCode: code)
            case .failure:
                // TODO  Sprint11
                break
            }
        }
    }

    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        vc.dismiss(animated: true)
    }
}

