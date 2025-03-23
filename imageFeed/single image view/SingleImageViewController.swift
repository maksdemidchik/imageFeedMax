//
//  singleImageViewController.swift
//  imageFeed
//
//  Created by Maxim on 30.01.2025.
//

import UIKit
import Kingfisher

final class SingleImageViewController: UIViewController {
    private let alert = AlertPresenter.shared
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var singleImage: UIImageView!
    var photoUrl: String?
    var image: UIImage?{
        didSet {
            guard isViewLoaded else { return }
            imgSetAndSize()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 1.25
        guard let stringURL = photoUrl,let url = URL(string: stringURL) else { return }
        loadAndSetImage(fullImageURL: url)
        imgSetAndSize()
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        dismiss(animated: true,completion: nil)
    }
    
    @IBAction func shareButtonAction(_ sender: Any) {
        guard let image else { return }
        let share = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        present(share,animated: true,completion: nil)
    }
    
    private func rescaleAndCenterImageInScrollView(image: UIImage) {
        let minZoomScale = scrollView.minimumZoomScale
        let maxZoomScale = scrollView.maximumZoomScale
        view.layoutIfNeeded()
        let visibleRectSize = scrollView.bounds.size
        let imageSize = image.size
        let hScale = visibleRectSize.width / imageSize.width
        let vScale = visibleRectSize.height / imageSize.height
        let scale = min(maxZoomScale, max(minZoomScale, min(hScale, vScale)))
        scrollView.setZoomScale(scale, animated: false)
        scrollView.layoutIfNeeded()
        let newContentSize = scrollView.contentSize
        let x = (newContentSize.width - visibleRectSize.width) / 2
        let y = (newContentSize.height - visibleRectSize.height) / 2
        scrollView.setContentOffset(CGPoint(x: x, y: y), animated: false)
        
    }

    private func imgSetAndSize(){
        guard let image else { return }
        singleImage.image = image
        singleImage.frame.size = image.size
        rescaleAndCenterImageInScrollView(image: image)
    }
    private func loadAndSetImage(fullImageURL:URL) {
        UIBlockingProgressHUD.show()
        singleImage.kf.setImage(with: fullImageURL) { [weak self] result in
            UIBlockingProgressHUD.dismiss()
            guard let self = self else { return }
            switch result {
            case .success(let imageResult):
                self.imgSetAndSize()
            case .failure:
                self.showError()
            }
        }
    }
    
    private func showError(){
        alert.showAlertTwoButton(self, title: "Что-то пошло не так", message: "Попробовать ещё раз?", ButtonTitle: "Повторить", ButtonTitle2: "Не надо"){ [weak self] in
            guard let self = self else { return }
            guard let stringURL = photoUrl,let url = URL(string: stringURL) else { return }
            self.loadAndSetImage(fullImageURL: url)
        }
    }
  
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return singleImage
    }
}
