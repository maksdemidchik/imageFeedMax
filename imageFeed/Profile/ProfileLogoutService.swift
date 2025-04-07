//
//  ProfileLogoutService.swift
//  imageFeed
//
//  Created by Maxim on 21.03.2025.
//

import Foundation
import WebKit

final class ProfileLogoutService {
    private var profileImageService = ProfileImageService.shared
    private var imgService = ImageListService.shared
    private let storage = OAuth2TokenStorage.shared
    static let shared = ProfileLogoutService()
    private init() {}
    
    func logout() {
        cleanCookies()
        profileImageService.cleanAvatarUrl()
        imgService.cleanPhoto()
        storage.clean()
    }
    
    private func cleanCookies() {
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
            }
        }
    }
    
}
