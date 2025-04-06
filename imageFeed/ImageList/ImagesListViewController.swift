//
//  ViewController.swift
//  imageFeed
//
//  Created by Maxim on 25.01.2025.
//

import UIKit

public protocol ImagesListViewControllerProtocol: AnyObject {
    var presenter : ImagesListPresenterProtocol? { get set }
    func showAlert()
}

final class ImagesListViewController: UIViewController & ImagesListViewControllerProtocol {
    
    @IBOutlet  weak var tableView: UITableView!
    private let dataCurrent = Date()
    let alert = AlertPresenter.shared
    private let showSingleImageSegueIdentifier = "ShowSingleImage"
    private var imageListServiceObserver: NSObjectProtocol?
    private let dateFormatterTwo = ISO8601DateFormatter()
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMMM yyyy"
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter
    }()
    var presenter: ImagesListPresenterProtocol?
    override func viewDidLoad() {
        super.viewDidLoad()
        imageListObserver()
        presenter?.viewDidLoad()
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
            guard let photos = presenter?.returnPhotosIndexPaths(indexPath: indexPath) else { return }
            let photoUrl = photos.largeImageURL
            viewController.photoUrl = photoUrl
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}

extension ImagesListViewController{
    private func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        guard let photos = presenter?.returnPhotosIndexPaths(indexPath: indexPath) else { return }
        guard let url = URL(string: photos.thumbImageURL) else {return}
        cell.imageCell.kf.setImage(with: url,placeholder: UIImage(named: "placeholder"))
        cell.imageCell.kf.indicatorType = .activity
        cell.imageCell.layer.cornerRadius = 15
        cell.imageCell.layer.masksToBounds = true
        if let date = photos.createdAt, let finalDate = dateFormatterTwo.date(from: date) {
            cell.dataLabel.text=dateFormatter.string(from: finalDate)
        }
        else{
            cell.dataLabel.text = "" 
        }
        let isLiked = photos.isLiked
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
        guard let x = presenter?.updateInfoForTableViewAnimate() else { return }
        let oldCount = x[0]
        let newCount = x[1]
        if oldCount != newCount {
            tableView.performBatchUpdates {
                let indexPaths = (oldCount..<newCount).map { i in
                    IndexPath(row: i, section: 0)
                }
                tableView.insertRows(at: indexPaths, with: .automatic)
            } completion: { _ in }
        }
    }
    func showAlert(){
        alert.showAlert(self, title: "Что-то пошло не так", message: "Не удалось изменить лайк", ButtonTitle: "Ок"){ }
    }
      
}
extension ImagesListViewController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        performSegue(withIdentifier: showSingleImageSegueIdentifier, sender: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let imageCell = presenter?.returnPhotosIndexPaths(indexPath: indexPath) else {return 0}
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        guard let view else { return 0 }
        let scale = (tableView.bounds.width - imageInsets.left - imageInsets.right) / imageCell.size.width
        let cellHeight = imageCell.size.height * scale + imageInsets.top + imageInsets.bottom
        return cellHeight
    }
}
extension ImagesListViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let count = presenter?.countPhotos() else { return 0 }
        return count
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
        presenter?.checkingIfNeedToLoadNewPhotos(indexPath: indexPath)
    }

}
extension ImagesListViewController: ImagesListCellDelegate {
    func imageListCellDidTapLike(_ cell: ImagesListCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        presenter?.imageListCellDidTapLike(cell, indexPath: indexPath)
    }
}
