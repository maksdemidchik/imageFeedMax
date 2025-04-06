//
//  ProfileViewControllerSpy.swift
//  imageFeedTests
//
//  Created by Maxim on 05.04.2025.
//


import UIKit
import imageFeed

final class ProfileViewControllerSpy:ProfileViewControllerProtocol {
    var presenter: imageFeed.ProfilePresenterProtocol?
    var loginNameLabel = UILabel()
    var nameLabel = UILabel()
    var descriptionLabel = UILabel()
    var updateAvatarCalled = false
    var setUserInfoCalled = false
    func updateAvatar(url: URL) {
        updateAvatarCalled = true
    }
    
    func setUserInfo(profile: imageFeed.Profile?) {
        setUserInfoCalled = true
        if let profile = profile  {
            loginNameLabel.text = profile.loginName
            nameLabel.text = profile.name
            descriptionLabel.text = profile.bio
        }
    }
    
    
}
