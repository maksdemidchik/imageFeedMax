//
//  AlertPresenter.swift
//  imageFeed
//
//  Created by Maxim on 02.03.2025.
//

import UIKit

class AlertPresenter{
    static let shared = AlertPresenter()
    
    private init() {}
    
    func showAlert(_ vc: UIViewController,title: String, message: String,ButtonTitle: String, onCompletion: @escaping(() -> Void)) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: ButtonTitle, style: .default) { _ in
            onCompletion()
        }
        alert.addAction(action)
        vc.present(alert, animated: true)
    }
    func showAlertTwoButton(_ vc: UIViewController,title: String, message: String,buttonTitle: String,buttonTitleTwo: String, onCompletion: @escaping(() -> Void)) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: buttonTitle, style: .default) { _ in
            onCompletion()
        }
        let secondAction = UIAlertAction(title: buttonTitleTwo, style: .default) { _ in
        }
        alert.view.accessibilityIdentifier = "alert"
        action.accessibilityIdentifier = "Yes"
        alert.addAction(action)
        alert.addAction(secondAction)
        vc.present(alert, animated: true)
    }
}
