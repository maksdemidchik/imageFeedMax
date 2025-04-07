//
//  WebViewControllerSpy.swift
//  imageFeedTests
//
//  Created by Maxim on 05.04.2025.
//

import Foundation
import imageFeed

final class WebViewControllerSpy: WebViewViewControllerProtocol {
    var presenter: imageFeed.WebViewPresenterProtocol?
    var loadRequest = false
    func load(request: URLRequest) {
        loadRequest = true
    }
    
    func setProgressValue(_ newValue: Float) {
        
    }
    
    func setProgressHidden(_ isHidden: Bool) {
        
    }
    
    
}
