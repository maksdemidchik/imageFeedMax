//
//  ImagesListCell.swift
//  imageFeed
//
//  Created by Maxim on 25.01.2025.
//

import UIKit

final class ImagesListCell: UITableViewCell {
    
    @IBOutlet weak var imageCell: UIImageView!
    
    @IBOutlet weak var likeButton: UIButton!

    @IBOutlet weak var dataLabel: UILabel!
    
    static let reuseIdentifier = "ImagesListCell"
    
}
