//
//  OAuth2TokenStorage.swift
//  imageFeed
//
//  Created by Maxim on 16.02.2025.
//

import Foundation
import SwiftKeychainWrapper

final class OAuth2TokenStorage{
    
    private enum Keys: String {
        case beerToken
    }
    
    var beerToken: String?{
        get{
            let token: String? = KeychainWrapper.standard.string(forKey: Keys.beerToken.rawValue)
            return token
        }
        set {
            let token = newValue
            guard let token else {
                return
            }
            let isSuccess = KeychainWrapper.standard.set(token, forKey: Keys.beerToken.rawValue)
            guard isSuccess else {
                return
            }
         
        }
    }
    
    
}
