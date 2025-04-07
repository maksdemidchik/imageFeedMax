//
//  ImagesListTest.swift
//  imageFeedTests
//
//  Created by Maxim on 06.04.2025.
//

@testable import imageFeed
import XCTest

final class ImagesListTest: XCTestCase {
    let indexPath = IndexPath(row: 1, section: 0)
    let vc = ImagesListViewController()
    let presenter = ImagesListPresenterSpy()
    
    func testViewControllerCallsViewDidLoad()  {
        vc.presenter = presenter
        presenter.view = vc
        _ = vc.view
        XCTAssertTrue(presenter.viewDidLoadCalled)
    }
    func testUpdateInfoForTableViewAnimateCalled(){
        vc.presenter = presenter
        presenter.view = vc
        _ = vc.view
        let _ = presenter.updateInfoForTableViewAnimate()
        XCTAssertTrue(presenter.updateInfoForTableViewAnimateCalled)
    }
    func testcheckingIfNeedToLoadNewPhotos(){
        _ = vc.view
        presenter.checkingIfNeedToLoadNewPhotos(indexPath: indexPath)
        XCTAssertTrue(presenter.checkingIfNeedToLoadNewPhotos)
    }
    func testcountPhotos(){
        _ = vc.view
        let countPhotos = presenter.countPhotos()
        XCTAssertTrue(presenter.countPhotosCalled)
        XCTAssertEqual(countPhotos, 0)
    }
    func testreturnPhotosIndexPaths(){
        _ = vc.view
        _ = presenter.returnPhotosIndexPaths(indexPath: indexPath)
        XCTAssertTrue(presenter.returnPhotosIndexPathsCalled)
    }
}
