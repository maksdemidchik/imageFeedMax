//
//  ViewController.swift
//  imageFeed
//
//  Created by Maxim on 25.01.2025.
//

import UIKit

class ImagesListViewController: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    
    private let photosName: [String] = Array(0..<20).map{ "\($0)" }
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight=200
        // Do any additional setup after loading the view.
    }

}

extension ImagesListViewController{
    func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        guard let imageCell=UIImage(named: photosName[indexPath.row]) else{
            return
        }
        cell.imageCell.image=imageCell
        cell.imageCell.layer.cornerRadius=15
        cell.imageCell.layer.masksToBounds=true
        cell.dataLabel.text=dateFormatter.string(from: Date())
        cell.likeButton.setImage(indexPath.row%2==0 ? UIImage(named:  "like_button_on") : UIImage(named:  "like_button_off"), for: .normal)
    }
}
extension ImagesListViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {}
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let imageCell = UIImage(named: photosName[indexPath.row]) else {
            return 0
        }
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let scale = (tableView.bounds.width - imageInsets.left - imageInsets.right) / imageCell.size.width
        let cellHeight = imageCell.size.height * scale + imageInsets.top + imageInsets.bottom
        return cellHeight
    }
}
extension ImagesListViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photosName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
              
              guard let imageListCell = cell as? ImagesListCell else {
                  return UITableViewCell()
              }
              
        configCell(for: imageListCell,with: indexPath)
              return imageListCell
    }
    
    
}

