//
//  ImageListPresenter.swift
//  imageFeed
//
//  Created by Maxim on 05.04.2025.
//

import UIKit
public protocol ImagesListPresenterProtocol : AnyObject {
    var view: ImagesListViewControllerProtocol? { get set }
    func imageListCellDidTapLike(_ cell: ImagesListCell,indexPath:IndexPath)
    func updateInfoForTableViewAnimate() -> Array<Int>
    func viewDidLoad()
    func checkingIfNeedToLoadNewPhotos(indexPath: IndexPath)
    func countPhotos() -> Int
    func returnPhotosIndexPaths(indexPath:IndexPath) -> Photo?
}
final class ImageListPresenter: ImagesListPresenterProtocol {
    var photos: [Photo] = []
    weak var view: ImagesListViewControllerProtocol?
    private let imgService=ImageListService.shared
    func updateInfoForTableViewAnimate() -> Array<Int> {
        let oldCount = photos.count
        let newCount = imgService.photos.count
        photos = imgService.photos
        return [oldCount,newCount]
    }
    func viewDidLoad() {
        imgService.fetchPhotosNextPage(){ _ in }
    }
    func countPhotos() -> Int {
        return photos.count
    }
    func returnPhotosIndexPaths(indexPath:IndexPath) -> Photo? {
        return photos[indexPath.row]
    }
    func imageListCellDidTapLike(_ cell: ImagesListCell, indexPath: IndexPath) {
        let photo = photos[indexPath.row]
        UIBlockingProgressHUD.show()
        imgService.changeLike(photoId: photo.id, isLike: !photo.isLiked) {[weak self] result in
            guard let self = self else {
                UIBlockingProgressHUD.dismiss()
                return
            }
            switch result {
            case .success:
                self.photos = self.imgService.photos
                cell.setIsLiked(self.photos[indexPath.row].isLiked)
                UIBlockingProgressHUD.dismiss()
            case .failure:
                UIBlockingProgressHUD.dismiss()
                self.view?.showAlert()
            }
        }

    }
    
    func checkingIfNeedToLoadNewPhotos(indexPath: IndexPath) {
        if (photos.count-1) == indexPath.row {
            imgService.fetchPhotosNextPage{ _ in
            }
        }
    }
}
