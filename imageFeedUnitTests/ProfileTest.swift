//
//  ProfileTest.swift
//  imageFeedTests
//
//  Created by Maxim on 05.04.2025.
//

@testable import imageFeed
import XCTest
final class ProfilePresenterTest: XCTestCase {
    var vc = ProfileViewController()
    var presenter = ProfilePresenterSpy()
    func testViewControllerCallsViewDidLoad()  {
        vc.presenter = presenter
        presenter.view = vc
        _ = vc.view
        XCTAssertTrue(presenter.viewDidLoadCalled)
    }
    func testViewControllerCallsReset()  {
        vc.presenter = presenter
        presenter.view = vc
        _ = vc.view
        presenter.reset()
        XCTAssertTrue(presenter.resetCalled)
    }
    func testViewControllerCallsUpdateAvatar()  {
        vc.presenter = presenter
        presenter.view = vc
        _ = vc.view
        presenter.updateAvatar()
        XCTAssertTrue(presenter.updateAvatarCalled)
    }
}

final class ProfileViewControllerTest: XCTestCase {
    let vc = ProfileViewControllerSpy()
    let presenter = ProfilePresenter()
    func testViewControllerCallsUpdateAvatar()  {
        vc.presenter = presenter
        presenter.view = vc
        guard let url = URL(string: "https://api.unsplash.com/users") else {XCTFail(); return}
        vc.updateAvatar(url: url)
        XCTAssertTrue(vc.updateAvatarCalled)
    }
    func testForUserSetInfo()  {
        vc.presenter = presenter
        presenter.view = vc
        let loginNameText = "loginNameTextTest"
        let nameText = "nameTest"
        let bioText = "biotTest"
        let profile = Profile(username: "", name: nameText, loginName: loginNameText, bio: bioText)
        vc.setUserInfo(profile: profile)
        XCTAssertTrue(vc.setUserInfoCalled)
        XCTAssertEqual(vc.nameLabel.text, nameText)
        XCTAssertEqual(vc.loginNameLabel.text, loginNameText)
        XCTAssertEqual(vc.descriptionLabel.text, bioText)
    }
}
