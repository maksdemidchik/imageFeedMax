//
//  profilePresenter.swift
//  imageFeed
//
//  Created by Maxim on 05.04.2025.
//

import UIKit

public protocol ProfilePresenterProtocol: AnyObject{
    var view: ProfileViewControllerProtocol? { get set }
    func viewDidLoad()
    func updateAvatar()
    func reset()
}

final class ProfilePresenter:ProfilePresenterProtocol {
    private let profileService = ProfileService.sharedProfile
    private let profileLogoutService = ProfileLogoutService.shared
    func viewDidLoad() {
        updateAvatar()
        updateUserInfo()
    }
    func updateUserInfo() {
        if let profile = profileService.profile {
            view?.setUserInfo(profile: profile)
        }
    }
    func updateAvatar() {
        if let profileImageUrl = ProfileImageService.shared.avatarURL,let url = URL(string: profileImageUrl){
            view?.updateAvatar(url: url)
            print(1)
        }
    }
    func reset() {
        profileLogoutService.logout()
        guard let window = UIApplication.shared.windows.first else { fatalError("Invalid Configuration") }
        let vc = SplashViewController()
        window.rootViewController = vc
        window.makeKeyAndVisible()
    }
    
    var view: ProfileViewControllerProtocol?
    
}
