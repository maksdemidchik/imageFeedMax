//
//  ImagesListPresenterSpy.swift
//  imageFeedTests
//
//  Created by Maxim on 06.04.2025.
//

import Foundation
import imageFeed

final class ImagesListPresenterSpy: ImagesListPresenterProtocol {
    var view:  imageFeed.ImagesListViewControllerProtocol?
    
    var photos: [imageFeed.Photo] = []
    
    var viewDidLoadCalled = false
    var updateInfoForTableViewAnimateCalled = false
    var imageListCellDidTapLikeCalled = false
    var countPhotosCalled = false
    var calculateCellHeight = false
    var returnPhotosIndexPathsCalled = false
    var checkingIfNeedToLoadNewPhotos = false
    func imageListCellDidTapLike(_ cell: imageFeed.ImagesListCell, indexPath: IndexPath) {
        imageListCellDidTapLikeCalled = true
    }
    
    func updateInfoForTableViewAnimate() -> Array<Int> {
        updateInfoForTableViewAnimateCalled = true
        return [0,0]
    }
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    func checkingIfNeedToLoadNewPhotos(indexPath: IndexPath) {
        checkingIfNeedToLoadNewPhotos = true
    }
    
    func countPhotos() -> Int {
        countPhotosCalled = true
        return photos.count
    }
    
    func returnPhotosIndexPaths(indexPath: IndexPath) -> imageFeed.Photo? {
        returnPhotosIndexPathsCalled = true
        if photos.count > indexPath.row {
            return photos[indexPath.row]
        }
        return nil
    }
    
    
}
