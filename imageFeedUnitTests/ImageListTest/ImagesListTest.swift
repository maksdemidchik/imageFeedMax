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
    func testCheckingIfNeedToLoadNewPhotos(){
        _ = vc.view
        presenter.checkingIfNeedToLoadNewPhotos(indexPath: indexPath)
        XCTAssertTrue(presenter.checkingIfNeedToLoadNewPhotos)
    }
    func testCountPhotos(){
        _ = vc.view
        let countPhotos = presenter.countPhotos()
        XCTAssertTrue(presenter.countPhotosCalled)
        XCTAssertEqual(countPhotos, 0)
    }
    func testReturnPhotosIndexPaths(){
        _ = vc.view
        _ = presenter.returnPhotosIndexPaths(indexPath: indexPath)
        XCTAssertTrue(presenter.returnPhotosIndexPathsCalled)
    }
}
