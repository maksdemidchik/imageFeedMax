//
//  OAuth2TokenStorage.swift
//  imageFeed
//
//  Created by Maxim on 16.02.2025.
//

import Foundation

final class OAuth2TokenStorage{
    
    private enum Keys: String {
        case beerToken
    }
    
    var beerToken: String?{
        get{
            UserDefaults.standard.string(forKey: Keys.beerToken.rawValue)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Keys.beerToken.rawValue)
        }
    }
    
    
}
