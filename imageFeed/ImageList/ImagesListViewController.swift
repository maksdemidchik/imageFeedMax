//
//  ViewController.swift
//  imageFeed
//
//  Created by Maxim on 25.01.2025.
//

import UIKit

final class ImagesListViewController: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    private var photos: [Photo] = []
    private let imgService=ImageListService.shared
    private var beerToken = OAuth2TokenStorage.shared.beerToken
    private let dataCurrent = Date()
    private let alert = AlertPresenter.shared
    private let showSingleImageSegueIdentifier = "ShowSingleImage"
    private var imageListServiceObserver: NSObjectProtocol?
    private let dateFormatterTwo = ISO8601DateFormatter()
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMMM yyyy"
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageListObserver()
        imgService.fetchPhotosNextPage{ _ in}
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showSingleImageSegueIdentifier {
            guard
                let viewController = segue.destination as?
                    SingleImageViewController,
                    let indexPath = sender as? IndexPath
            else {
                assertionFailure("Invalid segue destination")
                return
            }
            let photoUrl = photos[indexPath.row].largeImageURL
            viewController.photoUrl = photoUrl
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}

extension ImagesListViewController{
    private func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        guard let url = URL(string: photos[indexPath.row].thumbImageURL) else {return}
        cell.imageCell.kf.setImage(with: url,placeholder: UIImage(named: "placeholder"))
        cell.imageCell.kf.indicatorType = .activity
        cell.imageCell.layer.cornerRadius = 15
        cell.imageCell.layer.masksToBounds = true
        if let date = photos[indexPath.row].createdAt, let finalDate = dateFormatterTwo.date(from: date) {
            cell.dataLabel.text=dateFormatter.string(from: finalDate)
        }
        else{
            cell.dataLabel.text = "" 
        }
        let isLiked = photos[indexPath.row].isLiked
        let image = isLiked ? UIImage(named:  "like_button_on") : UIImage(named:  "like_button_off")
        cell.likeButton.setImage(image, for: .normal)
    }
    private func imageListObserver(){
        imageListServiceObserver = NotificationCenter.default.addObserver(forName: ImageListService.didChangeNotification, object: nil, queue: .main){ [weak self] _ in
            guard let self = self else{ return }
            self.updateTableViewAnimated()
        }
    }
    private func updateTableViewAnimated() {
        guard let tableView = tableView else { return }
        let oldCount = photos.count
        let newCount = imgService.photos.count
        photos = imgService.photos
        if oldCount != newCount {
            tableView.performBatchUpdates {
                let indexPaths = (oldCount..<newCount).map { i in
                    IndexPath(row: i, section: 0)
                }
                tableView.insertRows(at: indexPaths, with: .automatic)
            } completion: { _ in }
        }
    }
      
}
extension ImagesListViewController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        performSegue(withIdentifier: showSingleImageSegueIdentifier, sender: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let imageCell = photos[indexPath.row]
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let scale = (tableView.bounds.width - imageInsets.left - imageInsets.right) / imageCell.size.width
        let cellHeight = imageCell.size.height * scale + imageInsets.top + imageInsets.bottom
        return cellHeight
    }
}
extension ImagesListViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        guard let imageListCell = cell as? ImagesListCell else {
            return UITableViewCell()
        }
        imageListCell.delegate = self
        configCell(for: imageListCell,with: indexPath)
        return imageListCell
    }
    func tableView(
      _ tableView: UITableView,
      willDisplay cell: UITableViewCell,
      forRowAt indexPath: IndexPath
    ) {
        if (photos.count-1) == indexPath.row {
            imgService.fetchPhotosNextPage{ _ in
            }
        }
    }

}
extension ImagesListViewController: ImagesListCellDelegate {
    func imageListCellDidTapLike(_ cell: ImagesListCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
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
                self.alert.showAlert(self, title: "Что-то пошло не так", message: "Не удалось изменить лайк", ButtonTitle: "Ок"){ }
            }
        }
    }
}
