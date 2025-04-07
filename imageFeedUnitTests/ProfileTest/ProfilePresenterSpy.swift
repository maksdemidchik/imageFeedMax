//
//  ProfilePresenterSpy.swift
//  imageFeedTests
//
//  Created by Maxim on 05.04.2025.
//

import Foundation

import imageFeed

final class ProfilePresenterSpy: ProfilePresenterProtocol {
    var view: imageFeed.ProfileViewControllerProtocol?
    var viewDidLoadCalled = false
    var updateAvatarCalled = false
    var resetCalled = false
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    func updateAvatar() {
        updateAvatarCalled = true
    }
    
    func reset() {
        resetCalled = true
    }
    
}
